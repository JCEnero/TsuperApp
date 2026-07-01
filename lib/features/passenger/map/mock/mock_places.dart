import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/place_suggestion.dart';
import '../services/places_repository.dart';

/// Mock implementation of [PlacesRepository] using hard-coded QC landmarks.
/// Replace with GooglePlacesRepository when the Places API key is available.
class MockPlacesRepository implements PlacesRepository {
  // ── Master place catalog ────────────────────────────────────────────────
  static const List<PlaceSuggestion> _catalog = [
    PlaceSuggestion(
      placeId: 'qcu',
      primaryText: 'Quezon City University',
      secondaryText: 'Batangas St, Novaliches, Quezon City',
      icon: Symbols.school_rounded,
      iconColor: AppColors.primary,
      distanceLabel: '0.3 km',
    ),
    PlaceSuggestion(
      placeId: 'cubao',
      primaryText: 'Cubao (Araneta Center)',
      secondaryText: 'EDSA, Cubao, Quezon City',
      icon: Symbols.shopping_bag_rounded,
      iconColor: AppColors.primary,
      distanceLabel: '4.2 km',
    ),
    PlaceSuggestion(
      placeId: 'sm-fairview',
      primaryText: 'SM City Fairview',
      secondaryText: 'Quirino Highway, Fairview, Quezon City',
      icon: Symbols.shopping_cart_rounded,
      iconColor: AppColors.primary,
      distanceLabel: '3.8 km',
    ),
    PlaceSuggestion(
      placeId: 'trinoma',
      primaryText: 'TriNoma Mall',
      secondaryText: 'EDSA, North Triangle, Quezon City',
      icon: Symbols.storefront_rounded,
      iconColor: AppColors.primary,
      distanceLabel: '7.1 km',
    ),
    PlaceSuggestion(
      placeId: 'up-diliman',
      primaryText: 'UP Diliman',
      secondaryText: 'Katipunan Ave, Diliman, Quezon City',
      icon: Symbols.account_balance_rounded,
      iconColor: AppColors.primary,
      distanceLabel: '5.6 km',
    ),
    PlaceSuggestion(
      placeId: 'commonwealth',
      primaryText: 'Commonwealth Ave',
      secondaryText: 'Commonwealth, Quezon City',
      icon: Symbols.signpost_rounded,
      iconColor: AppColors.softInk,
      distanceLabel: '1.9 km',
    ),
    PlaceSuggestion(
      placeId: 'munoz-market',
      primaryText: 'Muñoz Market',
      secondaryText: 'EDSA, Muñoz, Quezon City',
      icon: Symbols.store_rounded,
      iconColor: AppColors.softInk,
      distanceLabel: '6.3 km',
    ),
    PlaceSuggestion(
      placeId: 'novaliches',
      primaryText: 'Novaliches Proper',
      secondaryText: 'Novaliches, Quezon City',
      icon: Symbols.location_city_rounded,
      iconColor: AppColors.softInk,
      distanceLabel: '2.1 km',
    ),
    PlaceSuggestion(
      placeId: 'holy-spirit',
      primaryText: 'Holy Spirit Drive',
      secondaryText: 'Holy Spirit, Quezon City',
      icon: Symbols.signpost_rounded,
      iconColor: AppColors.softInk,
      distanceLabel: '4.0 km',
    ),
    PlaceSuggestion(
      placeId: 'batasan',
      primaryText: 'Batasan Hills',
      secondaryText: 'Batasan, Quezon City',
      icon: Symbols.location_city_rounded,
      iconColor: AppColors.softInk,
      distanceLabel: '5.5 km',
    ),
  ];

  // ── Saved (favorite) places ─────────────────────────────────────────────
  static const List<SavedPlace> _saved = [
    SavedPlace(
      placeId: 'home',
      label: 'Home',
      address: '123 Batangas St, Novaliches',
      icon: Symbols.home_rounded,
      iconColor: AppColors.primary,
    ),
    SavedPlace(
      placeId: 'work',
      label: 'Work',
      address: 'QCU – Main Building, Novaliches',
      icon: Symbols.work_rounded,
      iconColor: AppColors.onDuty,
    ),
    SavedPlace(
      placeId: 'school',
      label: 'School',
      address: 'Commonwealth Ave, Quezon City',
      icon: Symbols.school_rounded,
      iconColor: AppColors.warning,
    ),
  ];

  // ── Recent destinations ─────────────────────────────────────────────────
  static const List<PlaceSuggestion> _recents = [
    PlaceSuggestion(
      placeId: 'cubao',
      primaryText: 'Cubao (Araneta Center)',
      secondaryText: 'Yesterday, 5:30 PM',
      icon: Symbols.history_rounded,
      iconColor: AppColors.softInk,
    ),
    PlaceSuggestion(
      placeId: 'sm-fairview',
      primaryText: 'SM City Fairview',
      secondaryText: 'Today, 8:00 AM',
      icon: Symbols.history_rounded,
      iconColor: AppColors.softInk,
    ),
    PlaceSuggestion(
      placeId: 'trinoma',
      primaryText: 'TriNoma Mall',
      secondaryText: 'Monday, 2:15 PM',
      icon: Symbols.history_rounded,
      iconColor: AppColors.softInk,
    ),
  ];

  @override
  Future<List<PlaceSuggestion>> autocomplete(String input) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 180));
    if (input.trim().isEmpty) return [];
    final q = input.trim().toLowerCase();
    return _catalog
        .where(
          (p) =>
              p.primaryText.toLowerCase().contains(q) ||
              p.secondaryText.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Future<List<SavedPlace>> savedPlaces() async => List.unmodifiable(_saved);

  @override
  Future<List<PlaceSuggestion>> recentDestinations() async =>
      List.unmodifiable(_recents);
}
