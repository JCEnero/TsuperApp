import '../config/supabase/supabase_client.dart';
import '../config/supabase/supabase_constants.dart';
import '../models/trip_model.dart';

class TripRepository {
  // Get trips for user
  Future<List<TripModel>> getUserTrips(String userId) async {
    final response = await SupabaseManager.client
        .from(SupabaseConstants.tripsTable)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response.map((json) => TripModel.fromJson(json)).toList();
  }

  // Get trips for driver
  Future<List<TripModel>> getDriverTrips(String driverId) async {
    final response = await SupabaseManager.client
        .from(SupabaseConstants.tripsTable)
        .select()
        .eq('driver_id', driverId)
        .order('created_at', ascending: false);

    return response.map((json) => TripModel.fromJson(json)).toList();
  }

  // Get trip by ID
  Future<TripModel?> getTripById(String tripId) async {
    try {
      final response =
          await SupabaseManager.client
              .from(SupabaseConstants.tripsTable)
              .select()
              .eq('id', tripId)
              .single();

      return TripModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Create trip
  Future<TripModel> createTrip(TripModel trip) async {
    final response =
        await SupabaseManager.client
            .from(SupabaseConstants.tripsTable)
            .insert(trip.toJson())
            .select()
            .single();

    return TripModel.fromJson(response);
  }

  // Update trip
  Future<TripModel> updateTrip(TripModel trip) async {
    final response =
        await SupabaseManager.client
            .from(SupabaseConstants.tripsTable)
            .update(trip.toJson())
            .eq('id', trip.id)
            .select()
            .single();

    return TripModel.fromJson(response);
  }

  // Start trip
  Future<void> startTrip(String tripId) async {
    await SupabaseManager.client
        .from(SupabaseConstants.tripsTable)
        .update({
          'status': 'in_progress',
          'start_time': DateTime.now().toIso8601String(),
        })
        .eq('id', tripId);
  }

  // Complete trip
  Future<void> completeTrip(String tripId) async {
    await SupabaseManager.client
        .from(SupabaseConstants.tripsTable)
        .update({
          'status': 'completed',
          'end_time': DateTime.now().toIso8601String(),
        })
        .eq('id', tripId);
  }

  // Cancel trip
  Future<void> cancelTrip(String tripId) async {
    await SupabaseManager.client
        .from(SupabaseConstants.tripsTable)
        .update({'status': 'cancelled'})
        .eq('id', tripId);
  }
}
