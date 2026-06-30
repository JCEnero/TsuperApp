import '../config/supabase/supabase_client.dart';
import '../config/supabase/supabase_constants.dart';
import '../models/passenger_model.dart';

class PassengerRepository {
  // Get passenger by user ID
  Future<PassengerModel?> getPassengerByUserId(String userId) async {
    try {
      final response =
          await SupabaseManager.client
              .from(SupabaseConstants.passengersTable)
              .select()
              .eq('user_id', userId)
              .single();

      return PassengerModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Get passenger by ID
  Future<PassengerModel?> getPassengerById(String passengerId) async {
    try {
      final response =
          await SupabaseManager.client
              .from(SupabaseConstants.passengersTable)
              .select()
              .eq('id', passengerId)
              .single();

      return PassengerModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Create passenger
  Future<PassengerModel> createPassenger(PassengerModel passenger) async {
    final response =
        await SupabaseManager.client
            .from(SupabaseConstants.passengersTable)
            .insert(passenger.toJson())
            .select()
            .single();

    return PassengerModel.fromJson(response);
  }

  // Update passenger
  Future<PassengerModel> updatePassenger(PassengerModel passenger) async {
    final response =
        await SupabaseManager.client
            .from(SupabaseConstants.passengersTable)
            .update(passenger.toJson())
            .eq('id', passenger.id)
            .select()
            .single();

    return PassengerModel.fromJson(response);
  }

  // Add favorite place
  Future<void> addFavoritePlace({
    required String passengerId,
    required String placeId,
  }) async {
    final passenger = await getPassengerById(passengerId);
    if (passenger != null) {
      final favorites = [...?passenger.favoritePlaces, placeId];
      await SupabaseManager.client
          .from(SupabaseConstants.passengersTable)
          .update({'favorite_places': favorites})
          .eq('id', passengerId);
    }
  }

  // Remove favorite place
  Future<void> removeFavoritePlace({
    required String passengerId,
    required String placeId,
  }) async {
    final passenger = await getPassengerById(passengerId);
    if (passenger != null) {
      final favorites =
          passenger.favoritePlaces?.where((p) => p != placeId).toList();
      await SupabaseManager.client
          .from(SupabaseConstants.passengersTable)
          .update({'favorite_places': favorites})
          .eq('id', passengerId);
    }
  }

  // Add recent route
  Future<void> addRecentRoute({
    required String passengerId,
    required String routeId,
  }) async {
    final passenger = await getPassengerById(passengerId);
    if (passenger != null) {
      final recentRoutes = [...?passenger.recentRoutes, routeId];
      await SupabaseManager.client
          .from(SupabaseConstants.passengersTable)
          .update({'recent_routes': recentRoutes})
          .eq('id', passengerId);
    }
  }
}
