import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/constants/app_colors.dart';
import '../mock/mock_places.dart';
import '../models/place_suggestion.dart';
import '../services/places_repository.dart';

// ─── State machine ────────────────────────────────────────────────────────────

enum _SearchFocus { none, origin, destination }

// ─── Public callback types ────────────────────────────────────────────────────

typedef OnDestinationSelected = void Function(PlaceSuggestion destination);
typedef OnRouteCleared = void Function();
typedef OnExpandedChanged = void Function(bool expanded);

// ─── Main widget ──────────────────────────────────────────────────────────────

/// Premium floating search card that handles:
///   • Collapsed "Where to?" tap target
///   • Expanded dual-field (origin + destination) with swap
///   • Live autocomplete suggestions
///   • Recents & favorites in idle state
///   • Smooth open / close animations
///
/// Swap [MockPlacesRepository] for [GooglePlacesRepository] with no
/// widget changes — just pass a different [placesRepository].
class RouteSearchSheet extends StatefulWidget {
  const RouteSearchSheet({
    super.key,
    required this.onDestinationSelected,
    required this.onRouteCleared,
    this.onExpandedChanged,
    this.currentLocationLabel = 'Your location',
    PlacesRepository? placesRepository,
  }) : placesRepository = placesRepository ?? const _DefaultRepo();

  final OnDestinationSelected onDestinationSelected;
  final OnRouteCleared onRouteCleared;

  /// Called whenever the sheet expands or collapses so the parent can
  /// hide/show the filter chips and legend accordingly.
  final OnExpandedChanged? onExpandedChanged;
  final String currentLocationLabel;

  /// Injected repository — replace with GooglePlacesRepository in production.
  final PlacesRepository placesRepository;

  @override
  State<RouteSearchSheet> createState() => _RouteSearchSheetState();
}

// Thin shim so const default works (PlacesRepository is abstract)
class _DefaultRepo implements PlacesRepository {
  const _DefaultRepo();
  @override
  Future<List<PlaceSuggestion>> autocomplete(String input) =>
      MockPlacesRepository().autocomplete(input);
  @override
  Future<List<SavedPlace>> savedPlaces() =>
      MockPlacesRepository().savedPlaces();
  @override
  Future<List<PlaceSuggestion>> recentDestinations() =>
      MockPlacesRepository().recentDestinations();
}

class _RouteSearchSheetState extends State<RouteSearchSheet>
    with TickerProviderStateMixin {
  // ── Animation controllers ────────────────────────────────────────────────
  late final AnimationController _expandCtrl;
  late final Animation<double> _expandAnim;
  late final AnimationController _swapCtrl;

  // ── Text controllers & focus ─────────────────────────────────────────────
  final TextEditingController _originCtrl = TextEditingController();
  final TextEditingController _destCtrl = TextEditingController();
  final FocusNode _originFocus = FocusNode();
  final FocusNode _destFocus = FocusNode();

  // ── State ────────────────────────────────────────────────────────────────
  bool _isExpanded = false;
  _SearchFocus _focus = _SearchFocus.none;
  List<PlaceSuggestion> _suggestions = [];
  List<SavedPlace> _saved = [];
  List<PlaceSuggestion> _recents = [];
  bool _loadingSuggestions = false;
  PlaceSuggestion? _selectedDestination;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _expandCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _expandAnim = CurvedAnimation(
      parent: _expandCtrl,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _swapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _originFocus.addListener(_onFocusChanged);
    _destFocus.addListener(_onFocusChanged);

    _loadInitialData();
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    _swapCtrl.dispose();
    _originCtrl.dispose();
    _destCtrl.dispose();
    _originFocus.removeListener(_onFocusChanged);
    _destFocus.removeListener(_onFocusChanged);
    _originFocus.dispose();
    _destFocus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ── Lifecycle helpers ────────────────────────────────────────────────────

  Future<void> _loadInitialData() async {
    final saved = await widget.placesRepository.savedPlaces();
    final recents = await widget.placesRepository.recentDestinations();
    if (mounted)
      setState(() {
        _saved = saved;
        _recents = recents;
      });
  }

  void _onFocusChanged() {
    if (_originFocus.hasFocus) {
      setState(() => _focus = _SearchFocus.origin);
      _fetchSuggestions(_originCtrl.text);
    } else if (_destFocus.hasFocus) {
      setState(() => _focus = _SearchFocus.destination);
      _fetchSuggestions(_destCtrl.text);
    } else {
      setState(() {
        _focus = _SearchFocus.none;
        _suggestions = [];
      });
    }
  }

  void _expand() {
    if (_isExpanded) return;
    setState(() => _isExpanded = true);
    _expandCtrl.forward();
    widget.onExpandedChanged?.call(true);
    // Auto-focus destination field after animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _destFocus.requestFocus();
    });
  }

  void _collapse() {
    _originFocus.unfocus();
    _destFocus.unfocus();
    _expandCtrl.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isExpanded = false;
          _suggestions = [];
        });
        widget.onExpandedChanged?.call(false);
      }
    });
  }

  void _clearAll() {
    _originCtrl.clear();
    _destCtrl.clear();
    _selectedDestination = null;
    _suggestions = [];
    _collapse();
    widget.onRouteCleared();
  }

  // ── Swap animation + values ───────────────────────────────────────────────

  void _swap() {
    HapticFeedback.lightImpact();
    final origText = _originCtrl.text;
    _originCtrl.text = _destCtrl.text;
    _destCtrl.text = origText;
    _swapCtrl.forward(from: 0);
  }

  // ── Autocomplete ─────────────────────────────────────────────────────────

  void _onOriginChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => _fetchSuggestions(v),
    );
  }

  void _onDestChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => _fetchSuggestions(v),
    );
  }

  Future<void> _fetchSuggestions(String input) async {
    if (input.trim().isEmpty) {
      if (mounted)
        setState(() {
          _suggestions = [];
          _loadingSuggestions = false;
        });
      return;
    }
    if (mounted) setState(() => _loadingSuggestions = true);
    final results = await widget.placesRepository.autocomplete(input);
    if (mounted)
      setState(() {
        _suggestions = results;
        _loadingSuggestions = false;
      });
  }

  void _selectSuggestion(PlaceSuggestion place) {
    HapticFeedback.selectionClick();
    if (_focus == _SearchFocus.origin) {
      _originCtrl.text = place.primaryText;
      _originFocus.unfocus();
      Future.delayed(const Duration(milliseconds: 80), () {
        if (mounted) _destFocus.requestFocus();
      });
    } else {
      _destCtrl.text = place.primaryText;
      _selectedDestination = place;
      _destFocus.unfocus();
      setState(() => _suggestions = []);
      widget.onDestinationSelected(place);
      // Collapse sheet so the map is visible after selecting destination
      _collapse();
    }
  }

  void _selectSaved(SavedPlace place) {
    HapticFeedback.selectionClick();
    _destCtrl.text = place.label;
    _selectedDestination = PlaceSuggestion(
      placeId: place.placeId,
      primaryText: place.label,
      secondaryText: place.address,
      icon: place.icon,
      iconColor: place.iconColor,
    );
    _destFocus.unfocus();
    setState(() => _suggestions = []);
    widget.onDestinationSelected(_selectedDestination!);
    // Collapse sheet so the map is visible
    _collapse();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expandAnim,
      builder: (context, _) {
        return GestureDetector(
          onTap: _isExpanded ? null : _expand,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(
                    alpha: 0.10 + _expandAnim.value * 0.08,
                  ),
                  blurRadius: 20 + _expandAnim.value * 10,
                  spreadRadius: _expandAnim.value * 2,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [_buildSearchCard(), if (_isExpanded) _buildPanel()],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Search card (always visible) ──────────────────────────────────────────

  Widget _buildSearchCard() {
    if (!_isExpanded) return _buildCollapsed();
    return _buildExpanded();
  }

  Widget _buildCollapsed() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.darkNavy],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Symbols.search_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Where to?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  widget.currentLocationLabel,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Plan trip',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpanded() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Route dots column
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.onDuty,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onDuty.withValues(alpha: 0.4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              Container(width: 2, height: 22, color: AppColors.gray300),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Input fields column
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildField(
                  controller: _originCtrl,
                  focus: _originFocus,
                  hint: widget.currentLocationLabel,
                  onChanged: _onOriginChanged,
                  isActive: _focus == _SearchFocus.origin,
                ),
                const SizedBox(height: 6),
                _buildField(
                  controller: _destCtrl,
                  focus: _destFocus,
                  hint: 'Choose destination',
                  onChanged: _onDestChanged,
                  isActive: _focus == _SearchFocus.destination,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Swap + close column
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotationTransition(
                turns: _swapCtrl,
                child: GestureDetector(
                  onTap: _swap,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: AppColors.gray200),
                    ),
                    child: const Icon(
                      Symbols.swap_vert_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _clearAll,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: AppColors.gray200),
                  ),
                  child: const Icon(
                    Symbols.close_rounded,
                    size: 16,
                    color: AppColors.gray600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required FocusNode focus,
    required String hint,
    required ValueChanged<String> onChanged,
    required bool isActive,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color:
            isActive
                ? AppColors.primary.withValues(alpha: 0.05)
                : AppColors.gray100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              isActive
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focus,
        onChanged: onChanged,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: AppColors.muted,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          suffixIcon:
              controller.text.isNotEmpty
                  ? GestureDetector(
                    onTap: () {
                      controller.clear();
                      onChanged('');
                    },
                    child: const Icon(
                      Symbols.close_rounded,
                      size: 15,
                      color: AppColors.muted,
                    ),
                  )
                  : null,
        ),
      ),
    );
  }

  // ── Dropdown panel ────────────────────────────────────────────────────────

  Widget _buildPanel() {
    final showSuggestions = _suggestions.isNotEmpty || _loadingSuggestions;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 1, color: AppColors.gray200),
        if (showSuggestions)
          _buildSuggestionsSection()
        else ...[
          if (_saved.isNotEmpty) _buildSavedSection(),
          if (_recents.isNotEmpty) _buildRecentsSection(),
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSuggestionsSection() {
    if (_loadingSuggestions) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children:
          _suggestions
              .map(
                (s) => _SuggestionTile(
                  suggestion: s,
                  onTap: () => _selectSuggestion(s),
                ),
              )
              .toList(),
    );
  }

  Widget _buildSavedSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(label: 'Saved Places'),
          const SizedBox(height: 10),
          Row(
            children:
                _saved
                    .map(
                      (p) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _SavedChip(
                            place: p,
                            onTap: () => _selectSaved(p),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(label: 'Recent'),
          const SizedBox(height: 4),
          ..._recents.map(
            (r) => _SuggestionTile(
              suggestion: r,
              onTap: () => _selectSuggestion(r),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.muted,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _SavedChip extends StatelessWidget {
  const _SavedChip({required this.place, required this.onTap});
  final SavedPlace place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: place.iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(place.icon, size: 15, color: place.iconColor),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.label,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    place.address,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: AppColors.muted,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.suggestion, required this.onTap});
  final PlaceSuggestion suggestion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = suggestion.iconColor ?? AppColors.softInk;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withValues(alpha: 0.06),
        highlightColor: AppColors.gray100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(suggestion.icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.primaryText,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      suggestion.secondaryText,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (suggestion.distanceLabel != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    suggestion.distanceLabel!,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 4),
              const Icon(
                Symbols.arrow_forward_ios_rounded,
                size: 12,
                color: AppColors.gray300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
