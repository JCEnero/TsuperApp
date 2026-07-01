import '../models/place_suggestion.dart';

/// Abstract contract for place search and lookup.
///
/// Current implementation: [MockPlacesRepository]
/// Future implementation:  GooglePlacesRepository (Google Places API)
///
/// To migrate:
///   1. Create `GooglePlacesRepository implements PlacesRepository`.
///   2. Inject it in `PassengerMapScreen` instead of `MockPlacesRepository`.
///   3. No widget code changes required.
abstract class PlacesRepository {
  /// Returns autocomplete suggestions for [input].
  /// Empty list when [input] is blank.
  Future<List<PlaceSuggestion>> autocomplete(String input);

  /// Returns the user's saved/favorite places.
  Future<List<SavedPlace>> savedPlaces();

  /// Returns recently used destinations (most-recent first).
  Future<List<PlaceSuggestion>> recentDestinations();
}
