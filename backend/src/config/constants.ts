// Table names - mirrors SupabaseConstants in Flutter app
export const Tables = {
  USERS: 'users',
  DRIVERS: 'drivers',
  PASSENGERS: 'passengers',
  ROUTES: 'routes',
  TRIPS: 'trips',
  NOTIFICATIONS: 'notifications',
  FAVORITES: 'favorites',
  SAVED_PLACES: 'saved_places',
} as const;

// User roles
export const Roles = {
  PASSENGER: 'passenger',
  DRIVER: 'driver',
} as const;

// Driver statuses
export const DriverStatus = {
  ACTIVE: 'active',
  INACTIVE: 'inactive',
  ON_ROUTE: 'on_route',
  OFFLINE: 'offline',
} as const;

// Trip statuses
export const TripStatus = {
  PENDING: 'pending',
  IN_PROGRESS: 'in_progress',
  COMPLETED: 'completed',
  CANCELLED: 'cancelled',
} as const;
