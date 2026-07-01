import 'package:material_symbols_icons/symbols.dart';
import '../core/constants/app_colors.dart';
import '../models/models.dart';

class AppData {
  static const onboardingSlides = [
    OnboardingSlide(
      title: 'Track Nearby Jeepneys',
      subtitle:
          'See real-time locations of jeepneys on your route. Know exactly when your ride arrives.',
      imageAsset: 'assets/images/onboarding/tracking.png',
    ),
    OnboardingSlide(
      title: 'Smart Route Planning',
      subtitle:
          'Find the fastest routes with estimated travel times, fares, and transfer points.',
      imageAsset: 'assets/images/onboarding/routes.png',
    ),
    OnboardingSlide(
      title: 'Travel with Confidence',
      subtitle:
          'Check occupancy levels, save favorite destinations, and enjoy better daily commutes.',
      imageAsset: 'assets/images/onboarding/confidence.png',
    ),
  ];

  static const passengerNav = [
    NavItem('Home', Symbols.home_rounded),
    NavItem('Map', Symbols.map_rounded),
    NavItem('Routes', Symbols.route_rounded),
    NavItem('Alerts', Symbols.notifications_rounded),
    NavItem('Profile', Symbols.person_rounded),
  ];

  static const driverNav = [
    NavItem('Dashboard', Symbols.space_dashboard_rounded),
    NavItem('Map', Symbols.map_rounded),
    NavItem('Trips', Symbols.directions_bus_rounded),
    NavItem('Alerts', Symbols.notifications_rounded),
    NavItem('Profile', Symbols.person_rounded),
  ];

  static const passengerQuickActions = [
    QuickActionData(
      'Plan Route',
      Symbols.route_rounded,
      AppColors.primary,
      'Fastest jeepney path',
    ),
    QuickActionData(
      'Saved Places',
      Symbols.place_rounded,
      AppColors.secondary,
      'Quick access to favorites',
    ),
    QuickActionData(
      'Recent Trips',
      Symbols.history_rounded,
      AppColors.accent,
      'View travel history',
    ),
    QuickActionData(
      'Alerts',
      Symbols.notifications_rounded,
      AppColors.warning,
      'Route updates',
    ),
  ];

  static const driverQuickActions = [
    QuickActionData(
      'Start Trip',
      Symbols.play_arrow_rounded,
      AppColors.onDuty,
      'Begin your route',
    ),
    QuickActionData(
      'End Trip',
      Symbols.stop_rounded,
      AppColors.danger,
      'Complete journey',
    ),
    QuickActionData(
      'Break',
      Symbols.coffee_rounded,
      AppColors.secondary,
      'Take a rest',
    ),
    QuickActionData(
      'Report Issue',
      Symbols.error_rounded,
      AppColors.warning,
      'Road conditions',
    ),
  ];

  static const notifications = [
    NotificationData(
      'Route 2 Delayed',
      'Heavy traffic on EDSA. Expect 15-min delay.',
      '5 min ago',
      NotificationKind.alert,
      AppColors.warning,
    ),
    NotificationData(
      'New Route Available',
      'QCU to SM Fairview via Commonwealth.',
      '1 hour ago',
      NotificationKind.route,
      AppColors.primary,
    ),
    NotificationData(
      'Fare Update',
      'Minimum fare increased to ₱13.00.',
      '2 hours ago',
      NotificationKind.announcement,
      AppColors.secondary,
    ),
  ];

  static const trips = [
    TripData(
      'QCU - Cubao',
      'Today, 8:30 AM',
      '₱156.00',
      'Completed',
      AppColors.primary,
    ),
    TripData(
      'Cubao - QCU',
      'Today, 10:15 AM',
      '₱104.00',
      'Completed',
      AppColors.secondary,
    ),
    TripData(
      'QCU - SM Fairview',
      'Yesterday, 3:45 PM',
      '₱195.00',
      'Completed',
      AppColors.accent,
    ),
  ];

  static const routes = [
    RouteData(
      'QCU - Cubao',
      'Quezon City University',
      'Cubao',
      '₱13.00',
      '45 min',
      0,
      'Moderate',
      AppColors.primary,
    ),
    RouteData(
      'QCU - SM Fairview',
      'Quezon City University',
      'SM Fairview',
      '₱11.00',
      '30 min',
      0,
      'Light',
      AppColors.secondary,
    ),
    RouteData(
      'Cubao - QCU',
      'Cubao',
      'Quezon City University',
      '₱13.00',
      '45 min',
      0,
      'Moderate',
      AppColors.accent,
    ),
    RouteData(
      'SM Fairview - QCU',
      'SM Fairview',
      'Quezon City University',
      '₱11.00',
      '30 min',
      0,
      'Light',
      AppColors.primary,
    ),
  ];

  // Additional data for passenger screens
  static const passengerSavedPlaces = [
    SavedPlaceData(
      'Home',
      '123 Main St',
      Symbols.home_rounded,
      AppColors.primary,
    ),
    SavedPlaceData(
      'Work',
      '456 Office Ave',
      Symbols.work_rounded,
      AppColors.secondary,
    ),
    SavedPlaceData(
      'School',
      '789 Campus Rd',
      Symbols.school_rounded,
      AppColors.accent,
    ),
  ];

  static const nearbyJeepneys = [
    JeepneyData(
      'J-123',
      'QCU - Cubao',
      '12/20',
      'On Route',
      '5 min',
      AppColors.primary,
    ),
    JeepneyData(
      'J-456',
      'QCU - SM Fairview',
      '8/20',
      'On Route',
      '8 min',
      AppColors.secondary,
    ),
  ];

  static const recommendedRoutes = routes;

  static const recentTrips = trips;

  static const passengerNotifications = notifications;

  // Additional data for driver screens
  static const driverTrips = trips;

  static const driverStats = [
    StatData('Total Trips', '45', '+12%', Symbols.directions_bus_rounded),
    StatData('Earnings', '₱5,850', '+8%', Symbols.payments_rounded),
    StatData('Rating', '4.8', '+0.2', Symbols.star_rounded),
  ];

  static const driverRoute = 'QCU - Cubao';

  static const driverNotifications = notifications;
}
