import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/constants/app_colors.dart';
import '../mock/mock_places.dart';
import '../models/place_suggestion.dart';
import '../services/places_repository.dart';

// ─── Public callback types ────────────────────────────────────────────────────

typedef OnDestinationSelected = void Function(PlaceSuggestion destination);
typedef OnRouteCleared = void Function();
typedef OnExpandedChanged = void Function(bool expanded);

// ─── Main widget ──────────────────────────────────────────────────────────────

/// Destination-only search sheet.
///
/// Collapsed state: shows a "Where to?" pill the passenger taps.
/// Expanded state: shows a single destination field + suggestions.
/// After selecting a destination, the sheet auto-collapses to reveal the map.
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
  final OnExpandedChanged? onExpandedChanged;
  final String currentLocationLabel;
  final PlacesRepository placesRepository;

  @override
  State<RouteSearchSheet> createState() => _RouteSearchSheetState();
}

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
    with SingleTickerProviderStateMixin {
  late final AnimationController _expandCtrl;
  late final Animation<double> _expandAnim;

  final TextEditingController _destCtrl = TextEditingController();
  final FocusNode _destFocus = FocusNode();

  bool _isExpanded = false;
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
      duration: const Duration(milliseconds: 280),
    );
    _expandAnim = CurvedAnimation(
      parent: _expandCtrl,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _loadInitialData();
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    _destCtrl.dispose();
    _destFocus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final saved = await widget.placesRepository.savedPlaces();
    final recents = await widget.placesRepository.recentDestinations();
    if (mounted) {
      setState(() {
        _saved = saved;
        _recents = recents;
      });
    }
  }

  // ── Expand / collapse ─────────────────────────────────────────────────────

  void _expand() {
    if (_isExpanded) return;
    setState(() => _isExpanded = true);
    _expandCtrl.forward();
    widget.onExpandedChanged?.call(true);
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) _destFocus.requestFocus();
    });
  }

  void _collapse() {
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
    _destCtrl.clear();
    _selectedDestination = null;
    _suggestions = [];
    _collapse();
    widget.onRouteCleared();
  }

  // ── Autocomplete ──────────────────────────────────────────────────────────

  void _onDestChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => _fetchSuggestions(v),
    );
  }

  Future<void> _fetchSuggestions(String input) async {
    if (input.trim().isEmpty) {
      if (mounted) {
        setState(() {
          _suggestions = [];
          _loadingSuggestions = false;
        });
      }
      return;
    }
    if (mounted) setState(() => _loadingSuggestions = true);
    final results = await widget.placesRepository.autocomplete(input);
    if (mounted) {
      setState(() {
        _suggestions = results;
        _loadingSuggestions = false;
      });
    }
  }

  // ── Selection — always collapses after pick ───────────────────────────────

  void _selectSuggestion(PlaceSuggestion place) {
    HapticFeedback.selectionClick();
    _destCtrl.text = place.primaryText;
    _selectedDestination = place;
    _destFocus.unfocus();
    setState(() => _suggestions = []);
    widget.onDestinationSelected(place);
    _collapse();
  }

  void _selectSaved(SavedPlace place) {
    HapticFeedback.selectionClick();
    final suggestion = PlaceSuggestion(
      placeId: place.placeId,
      primaryText: place.label,
      secondaryText: place.address,
      icon: place.icon,
      iconColor: place.iconColor,
    );
    _destCtrl.text = place.label;
    _selectedDestination = suggestion;
    _destFocus.unfocus();
    setState(() => _suggestions = []);
    widget.onDestinationSelected(suggestion);
    _collapse();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expandAnim,
      builder: (context, _) {
        return Container(
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
              children: [
                _isExpanded ? _buildExpandedHeader() : _buildCollapsed(),
                if (_isExpanded) _buildPanel(),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Collapsed pill ────────────────────────────────────────────────────────

  Widget _buildCollapsed() {
    return GestureDetector(
      onTap: _expand,
      child: Padding(
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
                  Text(
                    _selectedDestination != null
                        ? _selectedDestination!.primaryText
                        : 'Where to?',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color:
                          _selectedDestination != null
                              ? AppColors.primary
                              : AppColors.ink,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _selectedDestination != null
                        ? 'Tap to change destination'
                        : 'Search destination',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            // Show clear button if a destination is selected
            if (_selectedDestination != null)
              GestureDetector(
                onTap: _clearAll,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Symbols.close_rounded,
                    size: 16,
                    color: AppColors.gray600,
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Search',
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
      ),
    );
  }

  // ── Expanded header — destination field only ──────────────────────────────

  Widget _buildExpandedHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: Row(
        children: [
          // Search icon
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
          // Single destination field
          Expanded(
            child: _buildField(
              controller: _destCtrl,
              focus: _destFocus,
              hint: 'Where do you want to go?',
              onChanged: _onDestChanged,
            ),
          ),
          const SizedBox(width: 8),
          // Collapse/close button
          GestureDetector(
            onTap: _collapse,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.gray200),
              ),
              child: const Icon(
                Symbols.keyboard_arrow_up_rounded,
                size: 20,
                color: AppColors.gray600,
              ),
            ),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: place.iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(place.icon, size: 16, color: place.iconColor),
            ),
            const SizedBox(height: 6),
            Text(
              place.label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(
              place.address,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: AppColors.muted,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: (suggestion.iconColor ?? AppColors.softInk).withValues(
                  alpha: 0.10,
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                suggestion.icon,
                size: 17,
                color: suggestion.iconColor ?? AppColors.softInk,
              ),
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
                  ),
                  if (suggestion.secondaryText.isNotEmpty)
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
            const Icon(
              Symbols.north_east_rounded,
              size: 14,
              color: AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}
