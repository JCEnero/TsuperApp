// ignore_for_file: deprecated_member_use
import 'package:material_symbols_icons/symbols.dart';
import 'package:latlong2/latlong.dart';
import '../core/constants/app_colors.dart';
import '../models/models.dart';

class AppData {
  static const onboardingSlides = [
    OnboardingSlide(
      title: 'Track jeepneys with clarity',
      subtitle:
          'A polished commuter flow designed around route awareness, occupancy insight, and quick decisions.',
      icon: Symbols.route_rounded,
    ),
    OnboardingSlide(
      title: 'Built for passengers and drivers',
      subtitle:
          'One premium UI system, two focused experiences, both ready for backend integration in Phase 2.',
      icon: Symbols.groups_rounded,
    ),
    OnboardingSlide(
      title: 'Mock data, real product feel',
      subtitle:
          'Every screen is complete, navigable, and styled to feel like a production app from day one.',
      icon: Symbols.auto_awesome_rounded,
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
      'Track Jeepney',
      Symbols.directions_bus_rounded,
      AppColors.primary,
      'See mock nearby units',
    ),
    QuickActionData(
      'Saved Places',
      Symbols.bookmark_rounded,
      AppColors.primary,
      'Home, work, school',
    ),
    QuickActionData(
      'Help Desk',
      Symbols.support_agent_rounded,
      AppColors.primary,
      'Ride assistance',
    ),
  ];

  static const nearbyJeepneys = [
    JeepneyData(
      'JEEP-104',
      'Baclaran – Quiapo',
      '18',
      'Arriving in 4 min',
      '4 min',
      AppColors.primary,
    ),
    JeepneyData(
      'JEEP-217',
      'Makati Loop',
      '12',
      'Moderate load',
      '7 min',
      AppColors.blueBright,
    ),
    JeepneyData(
      'JEEP-311',
      'Cubao – Fairview',
      '21',
      'Nearly full',
      '10 min',
      AppColors.blueBright,
    ),
  ];

  static const recentTrips = [
    TripData(
      'Campus Run',
      'Today • 7:25 AM',
      '₱18',
      'Completed',
      AppColors.onDuty,
    ),
    TripData(
      'Market Stop',
      'Yesterday • 4:15 PM',
      '₱14',
      'Completed',
      AppColors.onDuty,
    ),
  ];

  static const recommendedRoutes = [
    RouteData(
      'Via EDSA Express',
      'Quezon City',
      'Makati CBD',
      '₱38',
      '34 min',
      1,
      'Light crowd',
      AppColors.primary,
    ),
    RouteData(
      'Via Ortigas Connector',
      'Pasig',
      'Ortigas Center',
      '₱24',
      '18 min',
      0,
      'Moderate crowd',
      AppColors.blueBright,
    ),
    RouteData(
      'Night Return',
      'BGC',
      'Pasay',
      '₱32',
      '28 min',
      1,
      'Low crowd',
      AppColors.blueBright,
    ),
  ];

  static const passengerNotifications = [
    NotificationData(
      'Route Advisory',
      'Quiapo corridor has a short delay. Consider the alternative route shown in your planner.',
      '8 min ago',
      NotificationKind.route,
      AppColors.primary,
    ),
    NotificationData(
      'Promo unlocked',
      'Save 10% on your next commute with the morning pass mock promo.',
      '1 hour ago',
      NotificationKind.promo,
      AppColors.blueBright,
    ),
    NotificationData(
      'System update',
      'Passenger occupancy visuals were refreshed for Phase 1 preview.',
      'Today',
      NotificationKind.system,
      AppColors.onDuty,
    ),
  ];

  static const passengerSavedPlaces = [
    SavedPlaceData(
      'Home',
      'Mandaluyong',
      Symbols.home_rounded,
      AppColors.primary,
    ),
    SavedPlaceData(
      'Office',
      'Makati CBD',
      Symbols.work_rounded,
      AppColors.blueBright,
    ),
    SavedPlaceData(
      'Campus',
      'Taft Avenue',
      Symbols.school_rounded,
      AppColors.blueBright,
    ),
  ];

  static const passengerStats = [
    StatData('Trips this month', '18', '+24%', Symbols.trending_up_rounded),
    StatData('Money saved', '₱214', '+12%', Symbols.savings_rounded),
    StatData('Favorite routes', '7', '2 new', Symbols.route_rounded),
  ];

  static const driverVehicle = 'Jeepney 02 • ZXG-421';
  static const driverRoute = 'Cubao – Fairview Line';

  static const driverStats = [
    StatData('Trips today', '24', '+8%', Symbols.directions_bus_rounded),
    StatData('Gross earnings', '₱2,140', '+16%', Symbols.payments_rounded),
    StatData('Avg occupancy', '81%', '+5%', Symbols.groups_rounded),
  ];

  static const driverQuickActions = [
    QuickActionData(
      'Start Shift',
      Symbols.play_circle_rounded,
      AppColors.primary,
      'Begin the day route',
    ),
    QuickActionData(
      'Passenger Log',
      Symbols.note_alt_rounded,
      AppColors.primary,
      'Mock trip record',
    ),
    QuickActionData(
      'Report Issue',
      Symbols.warning_rounded,
      AppColors.primary,
      'Safety and route notes',
    ),
    QuickActionData(
      'Earnings',
      Symbols.finance_rounded,
      AppColors.primary,
      'Daily summary',
    ),
  ];

  static const driverTrips = [
    TripData(
      'Morning Loop',
      '6:00 AM – 8:15 AM',
      '₱640',
      'High demand',
      AppColors.primary,
    ),
    TripData(
      'Midday Run',
      '10:00 AM – 12:30 PM',
      '₱510',
      'Steady load',
      AppColors.primary,
    ),
    TripData(
      'Afternoon Peak',
      '3:00 PM – 6:00 PM',
      '₱990',
      'Full occupancy',
      AppColors.warning,
    ),
  ];

  static const driverNotifications = [
    NotificationData(
      'Passenger alert',
      'Demand is rising on the afternoon corridor. Consider a short extra run.',
      '12 min ago',
      NotificationKind.alert,
      AppColors.blueBright,
    ),
    NotificationData(
      'System update',
      'Weekly trip charts are now available in the dashboard preview.',
      '1 hour ago',
      NotificationKind.system,
      AppColors.onDuty,
    ),
    NotificationData(
      'Announcement',
      'Vehicle maintenance reminder is scheduled for Friday evening.',
      'Today',
      NotificationKind.announcement,
      AppColors.primary,
    ),
  ];

  static const driverProfileItems = [
    ProfileMenuItemData('Vehicle Details', Symbols.directions_bus_rounded),
    ProfileMenuItemData('Assigned Route', Symbols.route_rounded),
    ProfileMenuItemData('Settings', Symbols.settings_rounded),
    ProfileMenuItemData('Help', Symbols.help_rounded),
    ProfileMenuItemData('Logout', Symbols.logout_rounded),
  ];

  static const commonInfoSections = [
    InfoSection('Preview scope', [
      'This Phase 1 build uses only local mock data.',
      'No GPS, permissions, backend integrations, or network calls are active.',
      'Future backend features can be wired in without changing the navigation shell.',
    ]),
  ];

  static const metroManilaRoutes = [
    MetroManilaRoute(
      id: 'qcu-sm-fairview',
      title: 'QCU → SM Fairview',
      fromLabel: 'QCU',
      toLabel: 'SM Fairview',
      routeName: 'Commonwealth Loop',
      estimatedTravelTime: '16 min',
      estimatedFare: '₱18',
      center: LatLng(14.7048, 121.0495),
      zoom: 13.4,
      path: [
        LatLng(14.6592, 121.0313),
        LatLng(14.6730, 121.0372),
        LatLng(14.6878, 121.0442),
        LatLng(14.7019, 121.0496),
        LatLng(14.7179, 121.0552),
        LatLng(14.7328, 121.0579),
      ],
      markers: [
        MetroManilaMapMarkerSpec(
          id: 'qcu',
          label: 'QCU',
          point: LatLng(14.6592, 121.0313),
          kind: MetroManilaMapMarkerKind.currentLocation,
        ),
        MetroManilaMapMarkerSpec(
          id: 'jeepney-1',
          label: 'Jeepney 14',
          point: LatLng(14.6878, 121.0442),
          kind: MetroManilaMapMarkerKind.jeepney,
        ),
        MetroManilaMapMarkerSpec(
          id: 'stop-1',
          label: 'Bus Stop',
          point: LatLng(14.7019, 121.0496),
          kind: MetroManilaMapMarkerKind.busStop,
        ),
        MetroManilaMapMarkerSpec(
          id: 'terminal-1',
          label: 'SM Fairview',
          point: LatLng(14.7328, 121.0579),
          kind: MetroManilaMapMarkerKind.destination,
        ),
      ],
    ),
    MetroManilaRoute(
      id: 'qcu-sm-north',
      title: 'QCU → SM North EDSA',
      fromLabel: 'QCU',
      toLabel: 'SM North EDSA',
      routeName: 'North Avenue Link',
      estimatedTravelTime: '14 min',
      estimatedFare: '₱16',
      center: LatLng(14.6546, 121.0310),
      zoom: 13.7,
      path: [
        LatLng(14.6592, 121.0313),
        LatLng(14.6568, 121.0326),
        LatLng(14.6539, 121.0319),
        LatLng(14.6512, 121.0308),
        LatLng(14.6489, 121.0298),
        LatLng(14.6467, 121.0292),
      ],
      markers: [
        MetroManilaMapMarkerSpec(
          id: 'qcu',
          label: 'QCU',
          point: LatLng(14.6592, 121.0313),
          kind: MetroManilaMapMarkerKind.currentLocation,
        ),
        MetroManilaMapMarkerSpec(
          id: 'jeepney-2',
          label: 'Jeepney 08',
          point: LatLng(14.6539, 121.0319),
          kind: MetroManilaMapMarkerKind.jeepney,
        ),
        MetroManilaMapMarkerSpec(
          id: 'terminal-2',
          label: 'SM North',
          point: LatLng(14.6467, 121.0292),
          kind: MetroManilaMapMarkerKind.destination,
        ),
      ],
    ),
    MetroManilaRoute(
      id: 'qcu-cubao',
      title: 'QCU → Cubao',
      fromLabel: 'QCU',
      toLabel: 'Cubao',
      routeName: 'Cubao Shuttle',
      estimatedTravelTime: '19 min',
      estimatedFare: '₱22',
      center: LatLng(14.6402, 121.0421),
      zoom: 13.5,
      path: [
        LatLng(14.6592, 121.0313),
        LatLng(14.6518, 121.0361),
        LatLng(14.6451, 121.0417),
        LatLng(14.6388, 121.0459),
        LatLng(14.6324, 121.0487),
        LatLng(14.6255, 121.0510),
      ],
      markers: [
        MetroManilaMapMarkerSpec(
          id: 'qcu',
          label: 'QCU',
          point: LatLng(14.6592, 121.0313),
          kind: MetroManilaMapMarkerKind.currentLocation,
        ),
        MetroManilaMapMarkerSpec(
          id: 'jeepney-3',
          label: 'Jeepney 21',
          point: LatLng(14.6451, 121.0417),
          kind: MetroManilaMapMarkerKind.jeepney,
        ),
        MetroManilaMapMarkerSpec(
          id: 'terminal-3',
          label: 'Cubao',
          point: LatLng(14.6255, 121.0510),
          kind: MetroManilaMapMarkerKind.destination,
        ),
      ],
    ),
    MetroManilaRoute(
      id: 'qcu-novaliches',
      title: 'QCU → Novaliches',
      fromLabel: 'QCU',
      toLabel: 'Novaliches',
      routeName: 'Novaliches Connector',
      estimatedTravelTime: '18 min',
      estimatedFare: '₱20',
      center: LatLng(14.6956, 121.0387),
      zoom: 13.4,
      path: [
        LatLng(14.6592, 121.0313),
        LatLng(14.6702, 121.0331),
        LatLng(14.6826, 121.0352),
        LatLng(14.6941, 121.0378),
        LatLng(14.7069, 121.0409),
        LatLng(14.7195, 121.0438),
      ],
      markers: [
        MetroManilaMapMarkerSpec(
          id: 'qcu',
          label: 'QCU',
          point: LatLng(14.6592, 121.0313),
          kind: MetroManilaMapMarkerKind.currentLocation,
        ),
        MetroManilaMapMarkerSpec(
          id: 'terminal-4',
          label: 'Novaliches',
          point: LatLng(14.7195, 121.0438),
          kind: MetroManilaMapMarkerKind.destination,
        ),
        MetroManilaMapMarkerSpec(
          id: 'stop-4',
          label: 'Terminal Stop',
          point: LatLng(14.6941, 121.0378),
          kind: MetroManilaMapMarkerKind.terminal,
        ),
      ],
    ),
  ];
}
