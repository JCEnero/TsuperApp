import '../config/supabase/supabase_client.dart';
import '../config/supabase/supabase_constants.dart';
import '../models/route_model.dart';

class RouteRepository {
  // Get all routes
  Future<List<RouteModel>> getAllRoutes() async {
    final response = await SupabaseManager.client
        .from(SupabaseConstants.routesTable)
        .select()
        .order('created_at', ascending: false);

    return response.map((json) => RouteModel.fromJson(json)).toList();
  }

  // Get route by ID
  Future<RouteModel?> getRouteById(String routeId) async {
    try {
      final response =
          await SupabaseManager.client
              .from(SupabaseConstants.routesTable)
              .select()
              .eq('id', routeId)
              .single();

      return RouteModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Create route
  Future<RouteModel> createRoute(RouteModel route) async {
    final response =
        await SupabaseManager.client
            .from(SupabaseConstants.routesTable)
            .insert(route.toJson())
            .select()
            .single();

    return RouteModel.fromJson(response);
  }

  // Update route
  Future<RouteModel> updateRoute(RouteModel route) async {
    final response =
        await SupabaseManager.client
            .from(SupabaseConstants.routesTable)
            .update(route.toJson())
            .eq('id', route.id)
            .select()
            .single();

    return RouteModel.fromJson(response);
  }

  // Delete route
  Future<void> deleteRoute(String routeId) async {
    await SupabaseManager.client
        .from(SupabaseConstants.routesTable)
        .delete()
        .eq('id', routeId);
  }

  // Search routes by origin
  Future<List<RouteModel>> searchRoutesByOrigin(String origin) async {
    final response = await SupabaseManager.client
        .from(SupabaseConstants.routesTable)
        .select()
        .ilike('origin', '%$origin%');

    return response.map((json) => RouteModel.fromJson(json)).toList();
  }

  // Search routes by destination
  Future<List<RouteModel>> searchRoutesByDestination(String destination) async {
    final response = await SupabaseManager.client
        .from(SupabaseConstants.routesTable)
        .select()
        .ilike('destination', '%$destination%');

    return response.map((json) => RouteModel.fromJson(json)).toList();
  }
}
