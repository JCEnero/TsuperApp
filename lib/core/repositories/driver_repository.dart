import '../config/supabase/supabase_client.dart';
import '../config/supabase/supabase_constants.dart';
import '../models/driver_model.dart';

class DriverRepository {
  // Get driver by user ID
  Future<DriverModel?> getDriverByUserId(String userId) async {
    try {
      final response =
          await SupabaseManager.client
              .from(SupabaseConstants.driversTable)
              .select()
              .eq('user_id', userId)
              .single();

      return DriverModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Get driver by ID
  Future<DriverModel?> getDriverById(String driverId) async {
    try {
      final response =
          await SupabaseManager.client
              .from(SupabaseConstants.driversTable)
              .select()
              .eq('id', driverId)
              .single();

      return DriverModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Create driver
  Future<DriverModel> createDriver(DriverModel driver) async {
    final response =
        await SupabaseManager.client
            .from(SupabaseConstants.driversTable)
            .insert(driver.toJson())
            .select()
            .single();

    return DriverModel.fromJson(response);
  }

  // Update driver
  Future<DriverModel> updateDriver(DriverModel driver) async {
    final response =
        await SupabaseManager.client
            .from(SupabaseConstants.driversTable)
            .update(driver.toJson())
            .eq('id', driver.id)
            .select()
            .single();

    return DriverModel.fromJson(response);
  }

  // Update driver location
  Future<void> updateDriverLocation({
    required String driverId,
    required double latitude,
    required double longitude,
  }) async {
    await SupabaseManager.client
        .from(SupabaseConstants.driversTable)
        .update({'current_latitude': latitude, 'current_longitude': longitude})
        .eq('id', driverId);
  }

  // Update driver status
  Future<void> updateDriverStatus({
    required String driverId,
    required String status,
  }) async {
    await SupabaseManager.client
        .from(SupabaseConstants.driversTable)
        .update({'status': status})
        .eq('id', driverId);
  }

  // Update driver occupancy
  Future<void> updateDriverOccupancy({
    required String driverId,
    required int occupancy,
  }) async {
    await SupabaseManager.client
        .from(SupabaseConstants.driversTable)
        .update({'occupancy': occupancy})
        .eq('id', driverId);
  }

  // Get all active drivers
  Future<List<DriverModel>> getActiveDrivers() async {
    final response = await SupabaseManager.client
        .from(SupabaseConstants.driversTable)
        .select()
        .eq('status', SupabaseConstants.statusActive);

    return response.map((json) => DriverModel.fromJson(json)).toList();
  }

  // Get drivers by route
  Future<List<DriverModel>> getDriversByRoute(String route) async {
    final response = await SupabaseManager.client
        .from(SupabaseConstants.driversTable)
        .select()
        .eq('assigned_route', route);

    return response.map((json) => DriverModel.fromJson(json)).toList();
  }
}
