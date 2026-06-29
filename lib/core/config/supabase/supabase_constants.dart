class SupabaseConstants {
  // Table names
  static const String usersTable = 'users';
  static const String driversTable = 'drivers';
  static const String passengersTable = 'passengers';
  static const String routesTable = 'routes';
  static const String tripsTable = 'trips';
  static const String notificationsTable = 'notifications';
  static const String favoritesTable = 'favorites';
  static const String savedPlacesTable = 'saved_places';

  // User roles
  static const String rolePassenger = 'passenger';
  static const String roleDriver = 'driver';

  // Driver status
  static const String statusActive = 'active';
  static const String statusInactive = 'inactive';
  static const String statusOnRoute = 'on_route';
  static const String statusOffline = 'offline';
}
