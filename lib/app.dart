// ignore_for_file: deprecated_member_use
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  THEME
// ─────────────────────────────────────────────────────────────────────────────

class TsuperApp extends StatelessWidget {
  const TsuperApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.darkNavy,
        surface: Colors.white,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      fontFamily: 'Poppins',
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TSUPER',
      theme: base.copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: AppColors.ink),
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins', fontWeight: FontWeight.w700,
            fontSize: 17, color: AppColors.ink,
          ),
        ),
        textTheme: base.textTheme.copyWith(
          headlineLarge: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 28, letterSpacing: -0.3),
          headlineMedium: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 24, letterSpacing: -0.2),
          headlineSmall: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 20),
          titleLarge: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 18),
          titleMedium: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
          titleSmall: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13),
          bodyLarge: const TextStyle(fontFamily: 'Poppins', fontSize: 15, height: 1.55),
          bodyMedium: const TextStyle(fontFamily: 'Poppins', fontSize: 14, height: 1.5),
          bodySmall: const TextStyle(fontFamily: 'Poppins', fontSize: 12, height: 1.45, color: AppColors.softInk),
          labelLarge: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13, letterSpacing: 0.1),
          labelMedium: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 0.2),
          labelSmall: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 11, letterSpacing: 0.3),
        ).apply(bodyColor: AppColors.ink, displayColor: AppColors.ink, fontFamily: 'Poppins'),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: TsuperTransitionsBuilder(),
            TargetPlatform.iOS: TsuperTransitionsBuilder(),
            TargetPlatform.linux: TsuperTransitionsBuilder(),
            TargetPlatform.macOS: TsuperTransitionsBuilder(),
            TargetPlatform.windows: TsuperTransitionsBuilder(),
            TargetPlatform.fuchsia: TsuperTransitionsBuilder(),
          },
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          height: 64,
          indicatorColor: AppColors.primary.withOpacity(0.12),
          labelTextStyle: const WidgetStatePropertyAll(TextStyle(
            fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 11,
          )),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary, foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 15),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(52),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            side: const BorderSide(color: AppColors.primary, width: 1.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true, fillColor: AppColors.gray100,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          labelStyle: const TextStyle(color: AppColors.softInk, fontFamily: 'Poppins'),
          hintStyle: const TextStyle(color: AppColors.muted, fontFamily: 'Poppins'),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.gray100,
          selectedColor: AppColors.primary.withOpacity(0.12),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          labelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        cardTheme: const CardTheme(color: Colors.white, surfaceTintColor: Colors.white, elevation: 0, margin: EdgeInsets.zero),
        dividerTheme: const DividerThemeData(color: AppColors.gray200, thickness: 1, space: 1),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.darkNavy,
          contentTextStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.splash,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ROUTES
// ─────────────────────────────────────────────────────────────────────────────

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const roleSelection = '/role-selection';
  static const passenger = '/passenger';
  static const driver = '/driver';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const settings = '/settings';
  static const about = '/about';
  static const helpCenter = '/help-center';
  static const privacy = '/privacy';
  static const terms = '/terms';

  static final routes = <String, WidgetBuilder>{
    splash: (_) => const SplashScreen(),
    onboarding: (_) => const OnboardingScreen(),
    roleSelection: (_) => const RoleSelectionScreen(),
    passenger: (_) => const PassengerShell(),
    driver: (_) => const DriverShell(),
    login: (_) => const AuthScreen(mode: AuthMode.login),
    register: (_) => const AuthScreen(mode: AuthMode.register),
    forgotPassword: (_) => const AuthScreen(mode: AuthMode.forgot),
    settings: (_) => const SettingsScreen(),
    about: (_) => const InfoScreen(title: 'About', body: 'TSUPER APP is a premium commuter experience for passengers and drivers. Phase 1 is UI only.'),
    helpCenter: (_) => const InfoScreen(title: 'Help Center', body: 'Help content placeholder for the TSUPER APP support area.'),
    privacy: (_) => const InfoScreen(title: 'Privacy Policy', body: 'Privacy policy placeholder for the Phase 1 mock build.'),
    terms: (_) => const InfoScreen(title: 'Terms & Conditions', body: 'Terms placeholder for the Phase 1 mock build.'),
  };
}

enum AuthMode { login, register, forgot }

// ─────────────────────────────────────────────────────────────────────────────
//  PAGE TRANSITION
// ─────────────────────────────────────────────────────────────────────────────

class TsuperTransitionsBuilder extends PageTransitionsBuilder {
  const TsuperTransitionsBuilder();

  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context,
      Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    final fade = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    final offset = Tween<Offset>(begin: const Offset(0, 0.035), end: Offset.zero).animate(fade);
    return FadeTransition(opacity: fade, child: SlideTransition(position: offset, child: child));
  }
}

// Aliases used in test / existing named references
typedef TsuperFadeSlideTransitionsBuilder = TsuperTransitionsBuilder;

// ─────────────────────────────────────────────────────────────────────────────
//  COLORS
// ─────────────────────────────────────────────────────────────────────────────

class AppColors {
  static const primary   = Color(0xFF243B7A);
  static const darkNavy  = Color(0xFF1D2F63);
  static const secondary = darkNavy;
  static const surface   = Color(0xFFF8F9FC);
  static const white     = Color(0xFFFFFFFF);
  static const gray100   = Color(0xFFF2F4F7);
  static const gray200   = Color(0xFFE5E7EB);
  static const gray300   = Color(0xFFD1D5DB);
  static const gray400   = Color(0xFF9CA3AF);
  static const gray600   = Color(0xFF374151);
  static const ink       = Color(0xFF111827);
  static const softInk   = Color(0xFF6B7280);
  static const muted     = Color(0xFF9CA3AF);
  static const success   = Color(0xFF3E7B5E);
  static const warning   = Color(0xFFF59E0B);
  static const danger    = Color(0xFFB14B5C);
  // Aliases
  static const background = surface;
  static const accent = gray600;
  static const offWhite = Color(0xFFFCFDFF);
}

// ─────────────────────────────────────────────────────────────────────────────
//  APP DATA
// ─────────────────────────────────────────────────────────────────────────────

class AppData {
  static const onboardingSlides = [
    OnboardingSlide(title: 'Track jeepneys with clarity', subtitle: 'A polished commuter flow designed around route awareness, occupancy insight, and quick decisions.', icon: Symbols.route_rounded),
    OnboardingSlide(title: 'Built for passengers and drivers', subtitle: 'One premium UI system, two focused experiences, both ready for backend integration in Phase 2.', icon: Symbols.groups_rounded),
    OnboardingSlide(title: 'Mock data, real product feel', subtitle: 'Every screen is complete, navigable, and styled to feel like a production app from day one.', icon: Symbols.auto_awesome_rounded),
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
    QuickActionData('Plan Route', Symbols.route_rounded, AppColors.primary, 'Fastest jeepney path'),
    QuickActionData('Track Jeepney', Symbols.directions_bus_rounded, AppColors.gray600, 'See mock nearby units'),
    QuickActionData('Saved Places', Symbols.bookmark_rounded, AppColors.warning, 'Home, work, school'),
    QuickActionData('Help Desk', Symbols.support_agent_rounded, AppColors.success, 'Ride assistance'),
  ];

  static const nearbyJeepneys = [
    JeepneyData('JEEP-104', 'Baclaran – Quiapo', '18', 'Arriving in 4 min', '4 min', AppColors.primary),
    JeepneyData('JEEP-217', 'Makati Loop', '12', 'Moderate load', '7 min', AppColors.gray600),
    JeepneyData('JEEP-311', 'Cubao – Fairview', '21', 'Nearly full', '10 min', AppColors.warning),
  ];

  static const recentTrips = [
    TripData('Campus Run', 'Today • 7:25 AM', '₱18', 'Completed', AppColors.success),
    TripData('Market Stop', 'Yesterday • 4:15 PM', '₱14', 'Completed', AppColors.primary),
  ];

  static const recommendedRoutes = [
    RouteData('Via EDSA Express', 'Quezon City', 'Makati CBD', '₱38', '34 min', 1, 'Light crowd', AppColors.primary),
    RouteData('Via Ortigas Connector', 'Pasig', 'Ortigas Center', '₱24', '18 min', 0, 'Moderate crowd', AppColors.gray600),
    RouteData('Night Return', 'BGC', 'Pasay', '₱32', '28 min', 1, 'Low crowd', AppColors.warning),
  ];

  static const passengerNotifications = [
    NotificationData('Route Advisory', 'Quiapo corridor has a short delay. Consider the alternative route shown in your planner.', '8 min ago', NotificationKind.route, AppColors.primary),
    NotificationData('Promo unlocked', 'Save 10% on your next commute with the morning pass mock promo.', '1 hour ago', NotificationKind.promo, AppColors.warning),
    NotificationData('System update', 'Passenger occupancy visuals were refreshed for Phase 1 preview.', 'Today', NotificationKind.system, AppColors.success),
  ];

  static const passengerSavedPlaces = [
    SavedPlaceData('Home', 'Mandaluyong', Symbols.home_rounded, AppColors.primary),
    SavedPlaceData('Office', 'Makati CBD', Symbols.work_rounded, AppColors.gray600),
    SavedPlaceData('Campus', 'Taft Avenue', Symbols.school_rounded, AppColors.warning),
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
    QuickActionData('Start Shift', Symbols.play_circle_rounded, AppColors.success, 'Begin the day route'),
    QuickActionData('Passenger Log', Symbols.note_alt_rounded, AppColors.primary, 'Mock trip record'),
    QuickActionData('Report Issue', Symbols.warning_rounded, AppColors.warning, 'Safety and route notes'),
    QuickActionData('Earnings', Symbols.finance_rounded, AppColors.gray600, 'Daily summary'),
  ];

  static const driverTrips = [
    TripData('Morning Loop', '6:00 AM – 8:15 AM', '₱640', 'High demand', AppColors.success),
    TripData('Midday Run', '10:00 AM – 12:30 PM', '₱510', 'Steady load', AppColors.primary),
    TripData('Afternoon Peak', '3:00 PM – 6:00 PM', '₱990', 'Full occupancy', AppColors.warning),
  ];

  static const driverNotifications = [
    NotificationData('Passenger alert', 'Demand is rising on the afternoon corridor. Consider a short extra run.', '12 min ago', NotificationKind.alert, AppColors.warning),
    NotificationData('System update', 'Weekly trip charts are now available in the dashboard preview.', '1 hour ago', NotificationKind.system, AppColors.success),
    NotificationData('Announcement', 'Vehicle maintenance reminder is scheduled for Friday evening.', 'Today', NotificationKind.announcement, AppColors.primary),
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
      id: 'qcu-sm-fairview', title: 'QCU → SM Fairview',
      fromLabel: 'QCU', toLabel: 'SM Fairview', routeName: 'Commonwealth Loop',
      estimatedTravelTime: '16 min', estimatedFare: '₱18',
      center: LatLng(14.7048, 121.0495), zoom: 13.4,
      path: [LatLng(14.6592, 121.0313), LatLng(14.6730, 121.0372), LatLng(14.6878, 121.0442), LatLng(14.7019, 121.0496), LatLng(14.7179, 121.0552), LatLng(14.7328, 121.0579)],
      markers: [
        MetroManilaMapMarkerSpec(id: 'qcu', label: 'QCU', point: LatLng(14.6592, 121.0313), kind: MetroManilaMapMarkerKind.currentLocation),
        MetroManilaMapMarkerSpec(id: 'jeepney-1', label: 'Jeepney 14', point: LatLng(14.6878, 121.0442), kind: MetroManilaMapMarkerKind.jeepney),
        MetroManilaMapMarkerSpec(id: 'stop-1', label: 'Bus Stop', point: LatLng(14.7019, 121.0496), kind: MetroManilaMapMarkerKind.busStop),
        MetroManilaMapMarkerSpec(id: 'terminal-1', label: 'SM Fairview', point: LatLng(14.7328, 121.0579), kind: MetroManilaMapMarkerKind.destination),
      ],
    ),
    MetroManilaRoute(
      id: 'qcu-sm-north', title: 'QCU → SM North EDSA',
      fromLabel: 'QCU', toLabel: 'SM North EDSA', routeName: 'North Avenue Link',
      estimatedTravelTime: '14 min', estimatedFare: '₱16',
      center: LatLng(14.6546, 121.0310), zoom: 13.7,
      path: [LatLng(14.6592, 121.0313), LatLng(14.6568, 121.0326), LatLng(14.6539, 121.0319), LatLng(14.6512, 121.0308), LatLng(14.6489, 121.0298), LatLng(14.6467, 121.0292)],
      markers: [
        MetroManilaMapMarkerSpec(id: 'qcu', label: 'QCU', point: LatLng(14.6592, 121.0313), kind: MetroManilaMapMarkerKind.currentLocation),
        MetroManilaMapMarkerSpec(id: 'jeepney-2', label: 'Jeepney 08', point: LatLng(14.6539, 121.0319), kind: MetroManilaMapMarkerKind.jeepney),
        MetroManilaMapMarkerSpec(id: 'terminal-2', label: 'SM North', point: LatLng(14.6467, 121.0292), kind: MetroManilaMapMarkerKind.destination),
      ],
    ),
    MetroManilaRoute(
      id: 'qcu-cubao', title: 'QCU → Cubao',
      fromLabel: 'QCU', toLabel: 'Cubao', routeName: 'Cubao Shuttle',
      estimatedTravelTime: '19 min', estimatedFare: '₱22',
      center: LatLng(14.6402, 121.0421), zoom: 13.5,
      path: [LatLng(14.6592, 121.0313), LatLng(14.6518, 121.0361), LatLng(14.6451, 121.0417), LatLng(14.6388, 121.0459), LatLng(14.6324, 121.0487), LatLng(14.6255, 121.0510)],
      markers: [
        MetroManilaMapMarkerSpec(id: 'qcu', label: 'QCU', point: LatLng(14.6592, 121.0313), kind: MetroManilaMapMarkerKind.currentLocation),
        MetroManilaMapMarkerSpec(id: 'jeepney-3', label: 'Jeepney 21', point: LatLng(14.6451, 121.0417), kind: MetroManilaMapMarkerKind.jeepney),
        MetroManilaMapMarkerSpec(id: 'terminal-3', label: 'Cubao', point: LatLng(14.6255, 121.0510), kind: MetroManilaMapMarkerKind.destination),
      ],
    ),
    MetroManilaRoute(
      id: 'qcu-novaliches', title: 'QCU → Novaliches',
      fromLabel: 'QCU', toLabel: 'Novaliches', routeName: 'Novaliches Connector',
      estimatedTravelTime: '18 min', estimatedFare: '₱20',
      center: LatLng(14.6956, 121.0387), zoom: 13.4,
      path: [LatLng(14.6592, 121.0313), LatLng(14.6702, 121.0331), LatLng(14.6826, 121.0352), LatLng(14.6941, 121.0378), LatLng(14.7069, 121.0409), LatLng(14.7195, 121.0438)],
      markers: [
        MetroManilaMapMarkerSpec(id: 'qcu', label: 'QCU', point: LatLng(14.6592, 121.0313), kind: MetroManilaMapMarkerKind.currentLocation),
        MetroManilaMapMarkerSpec(id: 'terminal-4', label: 'Novaliches', point: LatLng(14.7195, 121.0438), kind: MetroManilaMapMarkerKind.destination),
        MetroManilaMapMarkerSpec(id: 'stop-4', label: 'Terminal Stop', point: LatLng(14.6941, 121.0378), kind: MetroManilaMapMarkerKind.terminal),
      ],
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────────────────────────────────────

class MetroManilaRoute {
  const MetroManilaRoute({required this.id, required this.title, required this.fromLabel, required this.toLabel, required this.routeName, required this.estimatedTravelTime, required this.estimatedFare, required this.center, required this.zoom, required this.path, required this.markers});
  final String id, title, fromLabel, toLabel, routeName, estimatedTravelTime, estimatedFare;
  final LatLng center;
  final double zoom;
  final List<LatLng> path;
  final List<MetroManilaMapMarkerSpec> markers;
}

class MetroManilaMapMarkerSpec {
  const MetroManilaMapMarkerSpec({required this.id, required this.label, required this.point, required this.kind});
  final String id, label;
  final LatLng point;
  final MetroManilaMapMarkerKind kind;
}

enum MetroManilaMapMarkerKind { currentLocation, destination, jeepney, terminal, busStop }

class OnboardingSlide { const OnboardingSlide({required this.title, required this.subtitle, required this.icon}); final String title, subtitle; final IconData icon; }
class NavItem { const NavItem(this.label, this.icon); final String label; final IconData icon; }
class QuickActionData { const QuickActionData(this.label, this.icon, this.color, this.subtitle); final String label, subtitle; final IconData icon; final Color color; }
class JeepneyData { const JeepneyData(this.unit, this.route, this.occupancy, this.status, this.eta, this.color); final String unit, route, occupancy, status, eta; final Color color; }
class TripData { const TripData(this.title, this.subtitle, this.amount, this.status, this.color); final String title, subtitle, amount, status; final Color color; }
class RouteData { const RouteData(this.title, this.origin, this.destination, this.fare, this.duration, this.transfers, this.traffic, this.color); final String title, origin, destination, fare, duration, traffic; final int transfers; final Color color; }
class NotificationData { const NotificationData(this.title, this.message, this.time, this.kind, this.color); final String title, message, time; final NotificationKind kind; final Color color; }
class SavedPlaceData { const SavedPlaceData(this.label, this.subtitle, this.icon, this.color); final String label, subtitle; final IconData icon; final Color color; }
class StatData { const StatData(this.label, this.value, this.change, this.icon); final String label, value, change; final IconData icon; }
class ProfileMenuItemData { const ProfileMenuItemData(this.label, this.icon); final String label; final IconData icon; }
class InfoSection { const InfoSection(this.title, this.items); final String title; final List<String> items; }

enum NotificationKind { announcement, route, alert, promo, system }
enum MapMode { passenger, driver }

// ─────────────────────────────────────────────────────────────────────────────
//  SPLASH SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
  late final Animation<double> _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  late final Animation<double> _scale = Tween<double>(begin: 0.82, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 84, height: 84,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(26)),
                  child: const Icon(Symbols.directions_bus_rounded, size: 42, color: Colors.white),
                ),
                const SizedBox(height: 22),
                const Text('TSUPER', style: TextStyle(fontFamily: 'Poppins', fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 2.5)),
                const SizedBox(height: 6),
                Text('Move smarter across Metro Manila', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.white.withOpacity(0.65))),
                const SizedBox(height: 56),
                SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.45)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ONBOARDING SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _i = 0;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _next() {
    if (_i < AppData.onboardingSlides.length - 1) {
      _ctrl.nextPage(duration: const Duration(milliseconds: 340), curve: Curves.easeOutCubic);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _i == AppData.onboardingSlides.length - 1;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _WordMark(),
                  TextButton(onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.roleSelection), child: const Text('Skip')),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                itemCount: AppData.onboardingSlides.length,
                onPageChanged: (i) => setState(() => _i = i),
                itemBuilder: (_, i) => _OnboardPage(slide: AppData.onboardingSlides[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(AppData.onboardingSlides.length, (j) {
                      final active = j == _i;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: active ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.gray200,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  _PrimaryBtn(text: isLast ? 'Get Started' : 'Continue', icon: isLast ? Symbols.check_rounded : Symbols.arrow_forward_rounded, onPressed: _next),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({required this.slide});
  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(24)),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 90, height: 90, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(26)),
                      child: Icon(slide.icon, size: 46, color: AppColors.primary)),
                    const SizedBox(height: 10),
                    Text('Illustration Placeholder', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.muted.withOpacity(0.6))),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(slide.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          Text(slide.subtitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.softInk, height: 1.6)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ROLE SELECTION
// ─────────────────────────────────────────────────────────────────────────────

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});
  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  int? _sel;

  Future<void> _pick(int i, String route) async {
    setState(() => _sel = i);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _WordMark(),
                  const SizedBox(height: 32),
                  Text('Who are you?', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('Select your role to enter your personalized experience.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.softInk)),
                  const SizedBox(height: 28),
                  _RoleCard(title: 'Passenger', subtitle: 'Search routes, track nearby jeepneys, and manage your commute.', icon: Symbols.person_rounded, badge: 'Commuter', selected: _sel == 0, onTap: () => _pick(0, AppRoutes.passenger)),
                  const SizedBox(height: 14),
                  _RoleCard(title: 'Driver', subtitle: 'Track trips, manage occupancy, and review shift earnings.', icon: Symbols.directions_bus_rounded, badge: 'Operator', selected: _sel == 1, onTap: () => _pick(1, AppRoutes.driver)),
                  const SizedBox(height: 32),
                  const _Divider(label: 'Already have an account?'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _PrimaryBtn(text: 'Log In', icon: Symbols.login_rounded, onPressed: () => Navigator.pushNamed(context, AppRoutes.login))),
                      const SizedBox(width: 12),
                      Expanded(child: _OutlineBtn(text: 'Register', icon: Symbols.person_add_rounded, onPressed: () => Navigator.pushNamed(context, AppRoutes.register))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(child: TextButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword), child: const Text('Forgot password?'))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.title, required this.subtitle, required this.icon, required this.badge, required this.selected, required this.onTap});
  final String title, subtitle, badge;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primary : AppColors.gray200, width: selected ? 0 : 1.5),
          boxShadow: [
            if (selected)
              BoxShadow(color: AppColors.primary.withOpacity(0.25), blurRadius: 24, offset: const Offset(0, 8))
            else
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white.withOpacity(0.18) : AppColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 22, color: selected ? Colors.white : AppColors.primary),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white.withOpacity(0.18) : AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(badge, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppColors.primary, letterSpacing: 0.4)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(title, style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w800, color: selected ? Colors.white : AppColors.ink)),
              const SizedBox(height: 6),
              Text(subtitle, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, height: 1.5, color: selected ? Colors.white.withOpacity(0.8) : AppColors.softInk)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(selected ? 'Selected ✓' : 'Select', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppColors.primary)),
                  const SizedBox(width: 4),
                  Icon(Symbols.arrow_forward_rounded, size: 14, color: selected ? Colors.white : AppColors.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SHELLS
// ─────────────────────────────────────────────────────────────────────────────

class PassengerShell extends StatefulWidget {
  const PassengerShell({super.key});
  @override
  State<PassengerShell> createState() => _PassengerShellState();
}

class _PassengerShellState extends State<PassengerShell> {
  int _i = 0;
  static const _pages = [PassengerHomeScreen(), PassengerMapScreen(), PassengerRoutesScreen(), PassengerNotificationsScreen(), PassengerProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(index: _i, children: _pages),
      bottomNavigationBar: _NavBar(selectedIndex: _i, onSelected: (v) => setState(() => _i = v), items: AppData.passengerNav),
    );
  }
}

class DriverShell extends StatefulWidget {
  const DriverShell({super.key});
  @override
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  int _i = 0;
  static const _pages = [DriverDashboardScreen(), DriverMapScreen(), DriverTripsScreen(), DriverNotificationsScreen(), DriverProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(index: _i, children: _pages),
      bottomNavigationBar: _NavBar(selectedIndex: _i, onSelected: (v) => setState(() => _i = v), items: AppData.driverNav),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({required this.selectedIndex, required this.onSelected, required this.items});
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<NavItem> items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.gray200),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 24, offset: const Offset(0, 8))],
          ),
          child: Row(
            children: List.generate(items.length, (i) {
              final active = i == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelected(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        width: active ? 44 : 36,
                        height: active ? 32 : 28,
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Icon(items[i].icon, size: 19, color: active ? Colors.white : AppColors.muted),
                      ),
                      const SizedBox(height: 3),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: active ? AppColors.primary : AppColors.muted),
                        child: Text(items[i].label),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PASSENGER HOME
// ─────────────────────────────────────────────────────────────────────────────

class PassengerHomeScreen extends StatelessWidget {
  const PassengerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HomeHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            sliver: SliverList(delegate: SliverChildListDelegate([
              _SearchBar(placeholder: 'Where to?'),
              const SizedBox(height: 14),
              SizedBox(height: 36, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: AppData.passengerSavedPlaces.length, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (_, i) => _QuickChip(data: AppData.passengerSavedPlaces[i]))),
              const SizedBox(height: 22),
              _SectionHeader(title: 'Nearby Jeepneys', action: 'See all', onTap: () {}),
              const SizedBox(height: 10),
            ])),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 158, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 20), scrollDirection: Axis.horizontal, itemCount: AppData.nearbyJeepneys.length, separatorBuilder: (_, __) => const SizedBox(width: 12), itemBuilder: (_, i) => _JeepCard(data: AppData.nearbyJeepneys[i])))),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList(delegate: SliverChildListDelegate([
              _SectionHeader(title: 'Quick Actions', action: 'More', onTap: () => Navigator.pushNamed(context, AppRoutes.settings)),
              const SizedBox(height: 12),
              GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: AppData.passengerQuickActions.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.5), itemBuilder: (_, i) => _QACard(data: AppData.passengerQuickActions[i])),
              const SizedBox(height: 22),
              _SectionHeader(title: 'Suggested Routes', action: 'All', onTap: () {}),
              const SizedBox(height: 10),
              ...AppData.recommendedRoutes.map((r) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _RouteCard(data: r))),
              const SizedBox(height: 22),
              _SectionHeader(title: 'Recent Trips', action: 'History', onTap: () {}),
              const SizedBox(height: 10),
              ...AppData.recentTrips.map((t) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _TripTile(data: t))),
              const SizedBox(height: 10),
              _PromoBanner(),
            ])),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 14, left: 20, right: 20, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Good morning 👋', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.softInk)),
              const SizedBox(height: 2),
              const Text('Ferdinand Barral', style: TextStyle(fontFamily: 'Poppins', fontSize: 21, fontWeight: FontWeight.w800, color: AppColors.ink)),
            ]),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(14)),
              child: const Center(child: Text('FB', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15))),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PASSENGER MAP
// ─────────────────────────────────────────────────────────────────────────────

class PassengerMapScreen extends StatelessWidget {
  const PassengerMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
              child: Row(
                children: [
                  const Expanded(child: Text('Explore Routes', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink))),
                  _IconBtn(icon: Symbols.tune_rounded, onTap: () {}),
                ],
              ),
            ),
            const Expanded(child: Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 0), child: MetroManilaMapExplorer(initialRouteId: 'qcu-sm-fairview'))),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PASSENGER ROUTES
// ─────────────────────────────────────────────────────────────────────────────

class PassengerRoutesScreen extends StatefulWidget {
  const PassengerRoutesScreen({super.key});
  @override
  State<PassengerRoutesScreen> createState() => _PassengerRoutesScreenState();
}

class _PassengerRoutesScreenState extends State<PassengerRoutesScreen> {
  int _filter = 0;
  static const _filters = ['Fastest', 'Cheapest', 'Least Crowded'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Route Planner'), actions: [_IconBtn(icon: Symbols.history_rounded, onTap: () {})]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _OdCard(),
          const SizedBox(height: 14),
          SizedBox(height: 36, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: _filters.length, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (_, i) => _FChip(label: _filters[i], selected: i == _filter, onTap: () => setState(() => _filter = i)))),
          const SizedBox(height: 20),
          _SectionHeader(title: 'Suggested Routes', action: 'Filter', onTap: () {}),
          const SizedBox(height: 10),
          ...AppData.recommendedRoutes.map((r) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _RouteCard(data: r, showAction: true))),
          const SizedBox(height: 16),
          Row(children: [
            const Expanded(child: _PrimaryBtn(text: 'Start Trip', icon: Symbols.play_arrow_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _OutlineBtn(text: 'Save Route', icon: Symbols.bookmark_rounded, onPressed: () {})),
          ]),
          const SizedBox(height: 20),
          _SectionHeader(title: 'Recent Searches', action: 'Clear', onTap: () {}),
          const SizedBox(height: 8),
          _Card(child: Column(children: const [_RecentRow(label: 'Makati CBD'), Divider(height: 1), _RecentRow(label: 'Quezon Memorial Circle'), Divider(height: 1), _RecentRow(label: 'Quiapo Market')])),
          const SizedBox(height: 16),
          _SectionHeader(title: 'Saved Places', action: 'Edit', onTap: () {}),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: AppData.passengerSavedPlaces.map((p) => _SavedChip(data: p)).toList()),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PASSENGER NOTIFICATIONS
// ─────────────────────────────────────────────────────────────────────────────

class PassengerNotificationsScreen extends StatelessWidget {
  const PassengerNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Notifications'), actions: [TextButton(onPressed: () {}, child: const Text('Mark read'))]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const _GroupLabel(text: 'Today'),
          const SizedBox(height: 8),
          ...AppData.passengerNotifications.take(2).map((n) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _NotifTile(item: n, unread: true))),
          const SizedBox(height: 12),
          const _GroupLabel(text: 'Earlier'),
          const SizedBox(height: 8),
          ...AppData.passengerNotifications.skip(2).map((n) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _NotifTile(item: n, unread: false))),
          const SizedBox(height: 20),
          _SectionHeader(title: 'Browse categories', action: '', onTap: () {}),
          const SizedBox(height: 10),
          _CatRow(title: 'Route Updates', icon: Symbols.route_rounded),
          const SizedBox(height: 8),
          _CatRow(title: 'System Alerts', icon: Symbols.warning_rounded),
          const SizedBox(height: 8),
          _CatRow(title: 'Promotions', icon: Symbols.local_offer_rounded),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PASSENGER PROFILE
// ─────────────────────────────────────────────────────────────────────────────

class PassengerProfileScreen extends StatelessWidget {
  const PassengerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: _HeroBanner(name: 'Ferdinand Barral', role: 'Passenger', initials: 'FB', stats: const [('18', 'Trips'), ('₱214', 'Saved'), ('7', 'Faves')], onSettings: () => Navigator.pushNamed(context, AppRoutes.settings))),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          sliver: SliverList(delegate: SliverChildListDelegate([
            _Card(child: Column(children: [
              _MenuRow(label: 'Saved Places', icon: Symbols.bookmark_rounded, onTap: () {}),
              const Divider(height: 1),
              _MenuRow(label: 'Trip History', icon: Symbols.receipt_long_rounded, onTap: () {}),
              const Divider(height: 1),
              _MenuRow(label: 'Settings', icon: Symbols.settings_rounded, onTap: () => Navigator.pushNamed(context, AppRoutes.settings)),
              const Divider(height: 1),
              _MenuRow(label: 'Help Center', icon: Symbols.help_rounded, onTap: () => Navigator.pushNamed(context, AppRoutes.helpCenter)),
              const Divider(height: 1),
              _MenuRow(label: 'About TSUPER', icon: Symbols.info_rounded, onTap: () => Navigator.pushNamed(context, AppRoutes.about)),
            ])),
            const SizedBox(height: 14),
            _Card(child: _MenuRow(label: 'Log out', icon: Symbols.logout_rounded, iconColor: AppColors.danger, textColor: AppColors.danger, onTap: () => Navigator.pushNamed(context, AppRoutes.roleSelection))),
            const SizedBox(height: 28),
            Center(child: Text('TSUPER APP · Phase 1 Preview', style: Theme.of(context).textTheme.bodySmall)),
          ])),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  DRIVER DASHBOARD
// ─────────────────────────────────────────────────────────────────────────────

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: _DriverHeader()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          sliver: SliverList(delegate: SliverChildListDelegate([
            _NavyEarningsCard(),
            const SizedBox(height: 12),
            _StatsRow(),
            const SizedBox(height: 18),
            _VehicleCard(),
            const SizedBox(height: 10),
            _RouteCard2(),
            const SizedBox(height: 18),
            _OccCard(),
            const SizedBox(height: 18),
            _SectionHeader(title: 'Quick Actions', action: 'More', onTap: () {}),
            const SizedBox(height: 10),
            GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: AppData.driverQuickActions.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.5), itemBuilder: (_, i) => _QACard(data: AppData.driverQuickActions[i])),
            const SizedBox(height: 18),
            _SectionHeader(title: "Today's Trips", action: 'History', onTap: () {}),
            const SizedBox(height: 10),
            ...AppData.driverTrips.map((t) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _TripTile(data: t))),
            const SizedBox(height: 18),
            _ChartCard(),
            const SizedBox(height: 14),
            Row(children: const [
              Expanded(child: _PrimaryBtn(text: 'Start Trip', icon: Symbols.play_arrow_rounded)),
              SizedBox(width: 12),
              Expanded(child: _DangerBtn(text: 'End Trip', icon: Symbols.stop_rounded)),
            ]),
          ])),
        ),
      ]),
    );
  }
}

class _DriverHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 14, left: 20, right: 20, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Good day, Driver 👋', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.softInk)),
              const SizedBox(height: 2),
              const Text('Ramon dela Cruz', style: TextStyle(fontFamily: 'Poppins', fontSize: 21, fontWeight: FontWeight.w800, color: AppColors.ink)),
            ]),
          ),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(999)), child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 7, height: 7, decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle)), const SizedBox(width: 5), const Text('On Duty', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success))])),
          const SizedBox(width: 8),
          _IconBtn(icon: Symbols.settings_rounded, onTap: () => Navigator.pushNamed(context, AppRoutes.settings)),
        ],
      ),
    );
  }
}

class _NavyEarningsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text("Today's Earnings", style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.white.withOpacity(0.7))),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(999)), child: const Text('Shift active', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white))),
        ]),
        const SizedBox(height: 6),
        const Text('₱2,140', style: TextStyle(fontFamily: 'Poppins', fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, children: [
          _Pill(label: '24 trips', icon: Symbols.directions_bus_rounded),
          _Pill(label: '81% occupancy', icon: Symbols.people_rounded),
        ]),
      ]),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: Colors.white),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
      ]),
    );
  }
}

class _StatsRow extends StatelessWidget {
  static const _colors = [AppColors.primary, AppColors.success, AppColors.warning];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(AppData.driverStats.length, (i) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: i == 0 ? 0 : 5, right: i == AppData.driverStats.length - 1 ? 0 : 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.gray200),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.025), blurRadius: 8, offset: const Offset(0, 3))],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: 3, color: _colors[i]),
              Padding(
                padding: const EdgeInsets.all(11),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(color: _colors[i], shape: BoxShape.circle),
                    child: Icon(AppData.driverStats[i].icon, size: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(AppData.driverStats[i].value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
                  Text(AppData.driverStats[i].label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 9.5, color: AppColors.softInk, height: 1.3)),
                  const SizedBox(height: 3),
                  Text(AppData.driverStats[i].change, style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w700, color: _colors[i])),
                ]),
              ),
            ]),
          ),
        ),
      )),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(child: Row(children: [
      Container(
        width: 52, height: 52,
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
        child: const Icon(Symbols.directions_bus_rounded, color: Colors.white, size: 27),
      ),
      const SizedBox(width: 14),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Vehicle 28B', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
        SizedBox(height: 2),
        Text('Toyota Jeepney · ZXG-421', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.softInk)),
      ])),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(999)),
        child: const Text('Active', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    ]));
  }
}

class _RouteCard2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(child: Row(children: [
      Container(
        width: 40, height: 40,
        decoration: const BoxDecoration(color: AppColors.darkNavy, shape: BoxShape.circle),
        child: const Icon(Symbols.route_rounded, size: 19, color: Colors.white),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Assigned Route', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.softInk, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(AppData.driverRoute, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
      ])),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(999)),
        child: const Text('Route 2', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    ]));
  }
}

class _OccCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 36, height: 36,
          decoration: const BoxDecoration(color: AppColors.warning, shape: BoxShape.circle),
          child: const Icon(Symbols.people_rounded, size: 17, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Text('Occupancy', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: AppColors.warning, borderRadius: BorderRadius.circular(999)),
          child: const Text('76% · 13/17', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
      ]),
      const SizedBox(height: 14),
      ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: const LinearProgressIndicator(
          value: 0.76, minHeight: 10,
          backgroundColor: AppColors.gray200,
          valueColor: AlwaysStoppedAnimation(AppColors.warning),
        ),
      ),
      const SizedBox(height: 8),
      Row(children: const [
        Icon(Symbols.info_rounded, size: 13, color: AppColors.softInk),
        SizedBox(width: 5),
        Text('4 seats remaining for next stop.', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.softInk)),
      ]),
    ]));
  }
}

class _ChartCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const bars = [0.35, 0.56, 0.72, 0.61, 0.81, 0.92, 0.68];
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Text('Weekly Trips', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
        const Spacer(),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(999)), child: const Text('This week', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.softInk))),
      ]),
      const SizedBox(height: 16),
      SizedBox(height: 110, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(7, (i) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Expanded(child: Align(alignment: Alignment.bottomCenter, child: Container(width: double.infinity, height: 88 * bars[i], decoration: BoxDecoration(color: i == 5 ? AppColors.primary : AppColors.primary.withOpacity(0.2 + bars[i] * 0.5), borderRadius: const BorderRadius.vertical(top: Radius.circular(5)))))),
        const SizedBox(height: 4),
        Text(days[i], style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.softInk, fontWeight: FontWeight.w600)),
      ])))))),
    ]));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  MAP EXPLORER  (logic unchanged)
// ─────────────────────────────────────────────────────────────────────────────

class MetroManilaMapExplorer extends StatefulWidget {
  const MetroManilaMapExplorer({super.key, required this.initialRouteId, this.showDriverActions = false});
  final String initialRouteId;
  final bool showDriverActions;

  @override
  State<MetroManilaMapExplorer> createState() => _MetroManilaMapExplorerState();
}

class _MetroManilaMapExplorerState extends State<MetroManilaMapExplorer> with TickerProviderStateMixin {
  static final LatLngBounds _bounds = LatLngBounds(const LatLng(14.36, 120.84), const LatLng(14.81, 121.18));

  late final AnimatedMapController _mc = AnimatedMapController(vsync: this, duration: const Duration(milliseconds: 520), curve: Curves.easeInOutCubic, cancelPreviousAnimations: true);
  late MetroManilaRoute _route;
  String? _markerId;

  @override
  void initState() {
    super.initState();
    _route = AppData.metroManilaRoutes.firstWhere((r) => r.id == widget.initialRouteId, orElse: () => AppData.metroManilaRoutes.first);
    _markerId = _route.markers.first.id;
  }

  @override
  void dispose() { _mc.dispose(); super.dispose(); }

  MetroManilaMapMarkerSpec? get _marker => _route.markers.where((m) => m.id == _markerId).firstOrNull;

  Future<void> _selectRoute(MetroManilaRoute r) async {
    if (r.id == _route.id) return;
    setState(() { _route = r; _markerId = r.markers.first.id; });
    await _mc.animatedFitCamera(cameraFit: CameraFit.coordinates(coordinates: r.path, padding: const EdgeInsets.all(72)), customId: r.id, duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
  }

  Future<void> _focusMarker(MetroManilaMapMarkerSpec m) async {
    setState(() => _markerId = m.id);
    await _mc.animateTo(dest: m.point, zoom: (_route.zoom + 0.35).clamp(11.0, 16.5), customId: m.id, duration: const Duration(milliseconds: 420), curve: Curves.easeOutCubic);
  }

  void _zoomIn()  => _mc.animatedZoomIn(customId: 'z', duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
  void _zoomOut() => _mc.animatedZoomOut(customId: 'z', duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
  Future<void> _fit() => _mc.animatedFitCamera(cameraFit: CameraFit.coordinates(coordinates: _route.path, padding: const EdgeInsets.all(72)), customId: 'f', duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);

  @override
  Widget build(BuildContext context) {
    final sel = _marker;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _SearchBar(placeholder: 'Search QCU, SM Fairview, Cubao…'),
      const SizedBox(height: 10),
      SizedBox(height: 40, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: AppData.metroManilaRoutes.length, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (_, i) {
        final r = AppData.metroManilaRoutes[i];
        return _MapChip(label: r.toLabel, selected: r.id == _route.id, onTap: () => _selectRoute(r));
      })),
      const SizedBox(height: 10),
      Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(18), child: Stack(children: [
        FlutterMap(
          mapController: _mc.mapController,
          options: MapOptions(
            initialCenter: _route.center, initialZoom: _route.zoom, minZoom: 11, maxZoom: 16.5,
            cameraConstraint: CameraConstraint.contain(bounds: _bounds),
            interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
            onTap: (_, __) => setState(() => _markerId = _route.markers.first.id),
          ),
          children: [
            TileLayer(urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd'], userAgentPackageName: 'tsuper_app', maxNativeZoom: 19),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              transitionBuilder: (c, a) => FadeTransition(opacity: a, child: c),
              child: PolylineLayer(key: ValueKey('p-${_route.id}'), polylines: [Polyline(points: _route.path, color: AppColors.primary, strokeWidth: 5, strokeCap: StrokeCap.round)]),
            ),
            AnimatedMarkerLayer(markers: _route.markers.map((m) => AnimatedMarker(
              point: m.point, width: 80, height: 80,
              duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic,
              builder: (ctx, anim) => GestureDetector(
                onTap: () => _focusMarker(m),
                child: Opacity(opacity: anim.value, child: Transform.translate(offset: Offset(0, (1 - anim.value) * 10), child: _MapBadge(marker: m, selected: _markerId == m.id))),
              ),
            )).toList()),
          ],
        ),
        Positioned(left: 12, top: 12, child: _MapTag(title: 'Metro Manila', sub: 'Mock map')),
        Positioned(top: 12, right: 12, child: _ZoomPanel(onIn: _zoomIn, onOut: _zoomOut, onFit: _fit)),
        Positioned(left: 12, right: 12, bottom: 12, child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          transitionBuilder: (c, a) => FadeTransition(opacity: a, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(a), child: c)),
          child: _MapSheet(key: ValueKey('${_route.id}-${sel?.id}'), route: _route, marker: sel),
        )),
      ]))),
      if (widget.showDriverActions) ...[const SizedBox(height: 8), const Text('Driver focus mode', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.softInk, fontWeight: FontWeight.w600))],
    ]);
  }
}

class _MapChip extends StatelessWidget {
  const _MapChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: selected ? AppColors.primary : AppColors.gray200),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Symbols.route_rounded, size: 14, color: selected ? Colors.white : AppColors.gray600),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppColors.ink)),
      ]),
    ));
  }
}

class _ZoomPanel extends StatelessWidget {
  const _ZoomPanel({required this.onIn, required this.onOut, required this.onFit});
  final VoidCallback onIn, onOut, onFit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.gray200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))]),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _MapBtn(icon: Symbols.add_rounded, onTap: onIn),
        const SizedBox(height: 3),
        _MapBtn(icon: Symbols.remove_rounded, onTap: onOut),
        const SizedBox(height: 3),
        _MapBtn(icon: Symbols.center_focus_strong_rounded, onTap: onFit),
      ]),
    );
  }
}

class _MapBtn extends StatelessWidget {
  const _MapBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(8), child: Container(width: 30, height: 30, decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 15, color: AppColors.primary)));
  }
}

class _MapTag extends StatelessWidget {
  const _MapTag({required this.title, required this.sub});
  final String title, sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.gray200)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink)),
        Text(sub, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.softInk)),
      ]),
    );
  }
}

class _MapSheet extends StatelessWidget {
  const _MapSheet({super.key, required this.route, required this.marker});
  final MetroManilaRoute route;
  final MetroManilaMapMarkerSpec? marker;

  @override
  Widget build(BuildContext context) {
    final txt = marker == null ? 'Tap a marker to inspect stops.' : '${marker!.label} · ${_markerDescription(marker!.kind)}';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gray200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 5))]),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(route.title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(999)), child: Text(route.routeName, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          _InfoTag(label: route.fromLabel),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Icon(Symbols.arrow_forward_rounded, size: 12, color: AppColors.muted)),
          _InfoTag(label: route.toLabel),
          const Spacer(),
          _InfoTag(label: route.estimatedTravelTime),
          const SizedBox(width: 5),
          _InfoTag(label: route.estimatedFare, highlight: true),
        ]),
        const SizedBox(height: 6),
        Text(txt, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.softInk, height: 1.4)),
      ]),
    );
  }
}

class _InfoTag extends StatelessWidget {
  const _InfoTag({required this.label, this.highlight = false});
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: highlight ? AppColors.primary.withOpacity(0.08) : AppColors.gray100, borderRadius: BorderRadius.circular(5)),
      child: Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: highlight ? AppColors.primary : AppColors.ink)),
    );
  }
}

class _MapBadge extends StatelessWidget {
  const _MapBadge({required this.marker, required this.selected});
  final MetroManilaMapMarkerSpec marker;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final col  = _markerColor(marker.kind, selected);
    final icon = _markerIcon(marker.kind);
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: selected ? AppColors.primary : AppColors.gray200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(selected ? 0.1 : 0.04), blurRadius: 8, offset: const Offset(0, 3))]),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 28, height: 28, decoration: BoxDecoration(color: col, borderRadius: BorderRadius.circular(9)), child: Icon(icon, size: 15, color: Colors.white)),
        const SizedBox(height: 3),
        Text(marker.label, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Poppins', fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.ink)),
      ]),
    );
  }
}

Color _markerColor(MetroManilaMapMarkerKind k, bool sel) {
  if (sel) return AppColors.primary;
  return switch (k) {
    MetroManilaMapMarkerKind.currentLocation => AppColors.gray600,
    MetroManilaMapMarkerKind.destination     => AppColors.primary,
    MetroManilaMapMarkerKind.jeepney         => AppColors.gray600,
    MetroManilaMapMarkerKind.terminal        => AppColors.muted,
    MetroManilaMapMarkerKind.busStop         => AppColors.muted,
  };
}

IconData _markerIcon(MetroManilaMapMarkerKind k) => switch (k) {
  MetroManilaMapMarkerKind.currentLocation => Symbols.my_location_rounded,
  MetroManilaMapMarkerKind.destination     => Symbols.flag_rounded,
  MetroManilaMapMarkerKind.jeepney         => Symbols.directions_bus_rounded,
  MetroManilaMapMarkerKind.terminal        => Symbols.place_rounded,
  MetroManilaMapMarkerKind.busStop         => Symbols.stop_circle_rounded,
};

String _markerDescription(MetroManilaMapMarkerKind k) => switch (k) {
  MetroManilaMapMarkerKind.currentLocation => 'Current location',
  MetroManilaMapMarkerKind.destination     => 'Destination',
  MetroManilaMapMarkerKind.jeepney         => 'Mock jeepney',
  MetroManilaMapMarkerKind.terminal        => 'Terminal stop',
  MetroManilaMapMarkerKind.busStop         => 'Bus stop',
};

// ─────────────────────────────────────────────────────────────────────────────
//  DRIVER MAP
// ─────────────────────────────────────────────────────────────────────────────

class DriverMapScreen extends StatelessWidget {
  const DriverMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(children: [
            _Card(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), child: Row(children: [
              Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              const Text('On Duty · Route 2 active', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
              const Spacer(),
              _IconBtn(icon: Symbols.info_rounded, onTap: () => Navigator.pushNamed(context, AppRoutes.settings)),
            ])),
            const SizedBox(height: 10),
            const Expanded(child: MetroManilaMapExplorer(initialRouteId: 'qcu-cubao', showDriverActions: true)),
            const SizedBox(height: 10),
            Row(children: const [
              Expanded(child: _PrimaryBtn(text: 'Start Trip', icon: Symbols.play_arrow_rounded)),
              SizedBox(width: 10),
              Expanded(child: _DangerBtn(text: 'End Trip', icon: Symbols.stop_rounded)),
            ]),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  DRIVER TRIPS
// ─────────────────────────────────────────────────────────────────────────────

class DriverTripsScreen extends StatelessWidget {
  const DriverTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Trips & Earnings'), actions: [_IconBtn(icon: Symbols.download_rounded, onTap: () {})]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Total Earnings', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.white.withOpacity(0.7))),
              const SizedBox(height: 4),
              const Text('₱3,450', style: TextStyle(fontFamily: 'Poppins', fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
              const SizedBox(height: 12),
              Wrap(spacing: 8, children: const [_Pill(label: 'Today ₱2,140', icon: Symbols.today_rounded), _Pill(label: 'This week', icon: Symbols.date_range_rounded)]),
            ]),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _SmallStat(label: 'Trips', value: '42', icon: Symbols.directions_bus_rounded, accent: AppColors.primary)),
            const SizedBox(width: 10),
            Expanded(child: _SmallStat(label: 'Avg Occupancy', value: '76%', icon: Symbols.people_rounded, accent: AppColors.success)),
            const SizedBox(width: 10),
            Expanded(child: _SmallStat(label: 'Completion', value: '98%', icon: Symbols.check_circle_rounded, accent: AppColors.gray600)),
          ]),
          const SizedBox(height: 18),
          _ChartCard(),
          const SizedBox(height: 18),
          _SectionHeader(title: "Today's Trips", action: 'Export', onTap: () {}),
          const SizedBox(height: 10),
          ...AppData.driverTrips.map((t) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _TripTile(data: t))),
          const SizedBox(height: 18),
          _SectionHeader(title: 'History', action: 'All', onTap: () {}),
          const SizedBox(height: 10),
          _Card(child: Column(children: const [
            _HistRow(route: 'Route 1', time: 'Mon 8:00 AM', amt: '₱180'),
            Divider(height: 1),
            _HistRow(route: 'Route 2', time: 'Tue 1:20 PM', amt: '₱220'),
            Divider(height: 1),
            _HistRow(route: 'Route 3', time: 'Wed 5:10 PM', amt: '₱195'),
          ])),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  const _SmallStat({required this.label, required this.value, required this.icon, this.accent = AppColors.primary});
  final String label, value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.025), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(height: 3, color: accent),
        Padding(
          padding: const EdgeInsets.all(11),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              child: Icon(icon, size: 13, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.softInk)),
          ]),
        ),
      ]),
    );
  }
}

class _HistRow extends StatelessWidget {
  const _HistRow({required this.route, required this.time, required this.amt});
  final String route, time, amt;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 36, height: 36,
        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
        child: const Icon(Symbols.history_rounded, size: 16, color: Colors.white),
      ),
      title: Text(route, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
      subtitle: Text(time, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.softInk)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
        child: Text(amt, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  DRIVER NOTIFICATIONS
// ─────────────────────────────────────────────────────────────────────────────

class DriverNotificationsScreen extends StatelessWidget {
  const DriverNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Notifications'), actions: [TextButton(onPressed: () {}, child: const Text('Mark read'))]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const _GroupLabel(text: 'Today'),
          const SizedBox(height: 8),
          ...AppData.driverNotifications.take(2).map((n) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _NotifTile(item: n, unread: true))),
          const SizedBox(height: 12),
          const _GroupLabel(text: 'Earlier'),
          const SizedBox(height: 8),
          ...AppData.driverNotifications.skip(2).map((n) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _NotifTile(item: n, unread: false))),
          const SizedBox(height: 20),
          _CatRow(title: 'Announcements', icon: Symbols.campaign_rounded),
          const SizedBox(height: 8),
          _CatRow(title: 'Passenger Alerts', icon: Symbols.person_search_rounded),
          const SizedBox(height: 8),
          _CatRow(title: 'System Updates', icon: Symbols.system_update_alt_rounded),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  DRIVER PROFILE
// ─────────────────────────────────────────────────────────────────────────────

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: _HeroBanner(name: 'Ramon dela Cruz', role: 'Driver · Route 2', initials: 'RD', stats: const [('ZXG-421', 'Plate'), ('24', 'Trips'), ('81%', 'Occ.')], onSettings: () => Navigator.pushNamed(context, AppRoutes.settings))),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          sliver: SliverList(delegate: SliverChildListDelegate([
            _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(padding: EdgeInsets.only(bottom: 12), child: Text('Driver Information', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 0.5))),
              const _DetailRow(label: 'License No.', value: 'N01-204-889'),
              const Divider(height: 16),
              const _DetailRow(label: 'Vehicle', value: 'Toyota Jeepney 28B'),
              const Divider(height: 16),
              const _DetailRow(label: 'Assigned Route', value: 'Cubao – Fairview Line'),
            ])),
            const SizedBox(height: 14),
            _Card(child: Column(children: [
              _MenuRow(label: 'Vehicle Details', icon: Symbols.directions_bus_rounded, onTap: () {}),
              const Divider(height: 1),
              _MenuRow(label: 'Assigned Route', icon: Symbols.route_rounded, onTap: () {}),
              const Divider(height: 1),
              _MenuRow(label: 'Settings', icon: Symbols.settings_rounded, onTap: () => Navigator.pushNamed(context, AppRoutes.settings)),
              const Divider(height: 1),
              _MenuRow(label: 'Help', icon: Symbols.help_rounded, onTap: () => Navigator.pushNamed(context, AppRoutes.helpCenter)),
            ])),
            const SizedBox(height: 14),
            _Card(child: _MenuRow(label: 'Log out', icon: Symbols.logout_rounded, iconColor: AppColors.danger, textColor: AppColors.danger, onTap: () => Navigator.pushNamed(context, AppRoutes.roleSelection))),
          ])),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  AUTH SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key, required this.mode});
  final AuthMode mode;

  String get _title => switch (mode) { AuthMode.login => 'Welcome back', AuthMode.register => 'Create account', AuthMode.forgot => 'Reset password' };
  String get _sub   => switch (mode) { AuthMode.login => 'Sign in to your TSUPER account.', AuthMode.register => 'Start your premium commute experience.', AuthMode.forgot => 'Enter your email to receive a reset link.' };

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.only(bottom: insets),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Center(child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  if (Navigator.of(context).canPop()) ...[
                    GestureDetector(onTap: () => Navigator.maybePop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(12)), child: const Icon(Symbols.arrow_back_rounded, size: 20, color: AppColors.ink))),
                    const SizedBox(width: 12),
                  ],
                  const _WordMark(),
                ]),
                const SizedBox(height: 32),
                Text(_title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(_sub, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.softInk)),
                const SizedBox(height: 28),
                if (mode == AuthMode.register) ...[_FField(label: 'Full name', icon: Symbols.person_rounded), const SizedBox(height: 12)],
                _FField(label: 'Email or mobile number', icon: Symbols.email_rounded),
                const SizedBox(height: 12),
                if (mode != AuthMode.forgot) ...[_FField(label: 'Password', icon: Symbols.lock_rounded, obscure: true), const SizedBox(height: 4)],
                if (mode == AuthMode.register) ...[const SizedBox(height: 8), _FField(label: 'Confirm password', icon: Symbols.lock_rounded, obscure: true), const SizedBox(height: 4)],
                if (mode == AuthMode.login) Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword), child: const Text('Forgot password?'))),
                if (mode == AuthMode.forgot) ...[const SizedBox(height: 8), Text('A reset link will be sent to your registered email address.', style: Theme.of(context).textTheme.bodySmall)],
                const SizedBox(height: 20),
                _PrimaryBtn(
                  text: switch (mode) { AuthMode.login => 'Log In', AuthMode.register => 'Create Account', AuthMode.forgot => 'Send Reset Link' },
                  icon: Symbols.arrow_forward_rounded,
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.roleSelection),
                ),
                const SizedBox(height: 16),
                if (mode == AuthMode.login) Center(child: GestureDetector(onTap: () => Navigator.pushNamed(context, AppRoutes.register), child: RichText(text: const TextSpan(style: TextStyle(fontFamily: 'Poppins', fontSize: 14), children: [TextSpan(text: "Don't have an account? ", style: TextStyle(color: AppColors.softInk)), TextSpan(text: 'Register', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))])))),
                if (mode == AuthMode.register) Center(child: GestureDetector(onTap: () => Navigator.pushNamed(context, AppRoutes.login), child: RichText(text: const TextSpan(style: TextStyle(fontFamily: 'Poppins', fontSize: 14), children: [TextSpan(text: 'Already have an account? ', style: TextStyle(color: AppColors.softInk)), TextSpan(text: 'Log in', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))])))),
                if (mode == AuthMode.forgot) Center(child: TextButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.login), child: const Text('Back to login'))),
              ]),
            )),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SETTINGS
// ─────────────────────────────────────────────────────────────────────────────

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: Navigator.of(context).canPop() ? IconButton(icon: const Icon(Symbols.arrow_back_rounded), onPressed: () => Navigator.maybePop(context)) : null,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _SettingsGroup(label: 'Account', children: [
            _MenuRow(label: 'Account', icon: Symbols.person_rounded, onTap: () {}),
            const Divider(height: 1),
            _MenuRow(label: 'Notifications', icon: Symbols.notifications_rounded, onTap: () {}),
            const Divider(height: 1),
            _MenuRow(label: 'Appearance', icon: Symbols.palette_rounded, onTap: () {}),
          ]),
          const SizedBox(height: 16),
          _SettingsGroup(label: 'Preferences', children: [
            _TogRow(label: 'Dark Mode Ready', val: false),
            const Divider(height: 1),
            _TogRow(label: 'Compact Layout', val: false),
            const Divider(height: 1),
            _TogRow(label: 'High Contrast', val: false),
          ]),
          const SizedBox(height: 16),
          _SettingsGroup(label: 'Support', children: [
            _MenuRow(label: 'About', icon: Symbols.info_rounded, onTap: () => Navigator.pushNamed(context, AppRoutes.about)),
            const Divider(height: 1),
            _MenuRow(label: 'Help Center', icon: Symbols.help_rounded, onTap: () => Navigator.pushNamed(context, AppRoutes.helpCenter)),
            const Divider(height: 1),
            _MenuRow(label: 'Privacy Policy', icon: Symbols.privacy_tip_rounded, onTap: () => Navigator.pushNamed(context, AppRoutes.privacy)),
            const Divider(height: 1),
            _MenuRow(label: 'Terms & Conditions', icon: Symbols.gavel_rounded, onTap: () => Navigator.pushNamed(context, AppRoutes.terms)),
          ]),
          const SizedBox(height: 28),
          Center(child: Text('TSUPER APP · v1.0.0 (Phase 1)', style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.label, required this.children});
  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Text(label.toUpperCase(), style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 0.8))),
      _Card(child: Column(children: children)),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  INFO SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key, required this.title, required this.body});
  final String title, body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(title),
        leading: Navigator.of(context).canPop() ? IconButton(icon: const Icon(Symbols.arrow_back_rounded), onPressed: () => Navigator.maybePop(context)) : null,
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 46, height: 46,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Symbols.info_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(body, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.softInk, height: 1.65)),
        ])),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SHARED COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.025), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }
}

class _WordMark extends StatelessWidget {
  const _WordMark();
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 34, height: 34, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)), child: const Icon(Symbols.directions_bus_rounded, color: Colors.white, size: 18)),
      const SizedBox(width: 10),
      const Text('TSUPER', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink, letterSpacing: 0.8)),
    ]);
  }
}

class _PrimaryBtn extends StatelessWidget {
  const _PrimaryBtn({required this.text, required this.icon, this.onPressed});
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return _TapScale(onTap: onPressed ?? () {}, child: FilledButton.icon(
      onPressed: onPressed ?? () {},
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary, foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52), padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14),
      ),
    ));
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.text, required this.icon, this.onPressed});
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => _PrimaryBtn(text: text, icon: icon, onPressed: onPressed);
}

class _OutlineBtn extends StatelessWidget {
  const _OutlineBtn({required this.text, required this.icon, this.onPressed});
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return _TapScale(onTap: onPressed ?? () {}, child: OutlinedButton.icon(
      onPressed: onPressed ?? () {},
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size.fromHeight(52), padding: const EdgeInsets.symmetric(horizontal: 20),
        side: const BorderSide(color: AppColors.primary, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14),
      ),
    ));
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.text, required this.onPressed});
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => _OutlineBtn(text: text, icon: Symbols.arrow_forward_rounded, onPressed: onPressed);
}

class _DangerBtn extends StatelessWidget {
  const _DangerBtn({required this.text, required this.icon});
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return _TapScale(onTap: () {}, child: FilledButton.icon(onPressed: () {}, icon: Icon(icon, size: 18), label: Text(text), style: FilledButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(52), padding: const EdgeInsets.symmetric(horizontal: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14))));
  }
}

class DangerButton extends StatelessWidget {
  const DangerButton({super.key, required this.text, required this.icon});
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) => _DangerBtn(text: text, icon: icon);
}

class _TapScale extends StatefulWidget {
  const _TapScale({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;
  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale> {
  bool _d = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _d = true),
      onTapUp: (_) { setState(() => _d = false); widget.onTap(); },
      onTapCancel: () => setState(() => _d = false),
      child: AnimatedScale(scale: _d ? 0.97 : 1, duration: const Duration(milliseconds: 110), curve: Curves.easeOutCubic, child: widget.child),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action, required this.onTap});
  final String title, action;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink))),
      if (action.isNotEmpty) GestureDetector(onTap: onTap, child: Text(action, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary))),
    ]);
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left: 2), child: Text(text.toUpperCase(), style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted, letterSpacing: 0.8)));
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.placeholder});
  final String placeholder;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(children: [
        Container(
          width: 34, height: 34,
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          child: const Icon(Symbols.search_rounded, size: 17, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(placeholder, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.muted))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Symbols.tune_rounded, size: 14, color: AppColors.primary),
            SizedBox(width: 4),
            Text('Filter', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ]),
        ),
      ]),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: AppColors.gray200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Icon(icon, size: 18, color: AppColors.ink),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Expanded(child: Divider()),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.muted, fontWeight: FontWeight.w500))),
      const Expanded(child: Divider()),
    ]);
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.name, required this.role, required this.initials, required this.stats, required this.onSettings});
  final String name, role, initials;
  final List<(String, String)> stats;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(20, top + 20, 20, 28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(role, style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.65))),
            const SizedBox(height: 4),
            Text(name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
          ])),
          GestureDetector(onTap: onSettings, child: Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.25))),
            child: Center(child: Text(initials, style: const TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
          )),
        ]),
        const SizedBox(height: 22),
        Row(children: stats.asMap().entries.map((e) {
          final i = e.key;
          final s = e.value;
          return Expanded(child: Row(children: [
            if (i > 0) Container(width: 1, height: 30, color: Colors.white.withOpacity(0.2)),
            if (i > 0) const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.$1, style: const TextStyle(fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
              Text(s.$2, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.white.withOpacity(0.65))),
            ]),
          ]));
        }).toList()),
      ]),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.label, required this.icon, required this.onTap, this.iconColor, this.textColor});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final col = iconColor ?? AppColors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: textColor != null ? col.withOpacity(0.12) : col,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 17, color: textColor != null ? col : Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: textColor ?? AppColors.ink))),
          Icon(Symbols.chevron_right_rounded, size: 16, color: AppColors.muted),
        ]),
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.item, required this.unread});
  final NotificationData item;
  final bool unread;

  IconData _icon(NotificationKind k) => switch (k) {
    NotificationKind.announcement => Symbols.campaign_rounded,
    NotificationKind.route        => Symbols.route_rounded,
    NotificationKind.alert        => Symbols.warning_rounded,
    NotificationKind.promo        => Symbols.local_offer_rounded,
    NotificationKind.system       => Symbols.system_update_alt_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: unread ? item.color.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: unread ? item.color.withOpacity(0.25) : AppColors.gray200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.025), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (unread) Container(width: 4, color: item.color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
                    child: Icon(_icon(item.kind), size: 19, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(item.title, style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: unread ? FontWeight.w700 : FontWeight.w600, color: AppColors.ink))),
                      const SizedBox(width: 6),
                      Text(item.time, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.muted)),
                    ]),
                    const SizedBox(height: 5),
                    Text(item.message, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.softInk, height: 1.45)),
                  ])),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatRow extends StatelessWidget {
  const _CatRow({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      onTap: () {},
      child: _Card(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11), child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          child: Icon(icon, size: 17, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink))),
        const Icon(Symbols.chevron_right_rounded, size: 15, color: AppColors.muted),
      ])),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.data, this.showAction = false});
  final RouteData data;
  final bool showAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: data.color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: data.color, shape: BoxShape.circle),
              child: const Icon(Symbols.route_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(data.title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
              const SizedBox(height: 2),
              Row(children: [
                Text(data.origin, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.softInk)),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Icon(Symbols.arrow_forward_rounded, size: 10, color: AppColors.muted)),
                Expanded(child: Text(data.destination, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.softInk), overflow: TextOverflow.ellipsis)),
              ]),
            ])),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
              child: Text(data.fare, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ]),
          const SizedBox(height: 10),
          Wrap(spacing: 6, runSpacing: 5, children: [
            _Tag(label: data.duration, icon: Symbols.schedule_rounded, color: AppColors.primary),
            _Tag(label: '${data.transfers} transfer', icon: Symbols.sync_alt_rounded, color: AppColors.gray600),
            _Tag(label: data.traffic, icon: Symbols.traffic_rounded, color: _trafficColor(data.traffic)),
          ]),
        ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _trafficColor(String t) {
  if (t.contains('Light') || t.contains('Low')) return AppColors.success;
  if (t.contains('Heavy') || t.contains('Full')) return AppColors.danger;
  return AppColors.warning;
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.icon, this.color = AppColors.primary});
  final String label;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 10.5, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }
}

class _TripTile extends StatelessWidget {
  const _TripTile({required this.data});
  final TripData data;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.025), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: data.color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(color: data.color, shape: BoxShape.circle),
                    child: const Icon(Symbols.directions_bus_rounded, size: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(data.title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    const SizedBox(height: 2),
                    Text(data.subtitle, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.softInk)),
                  ])),
                  const SizedBox(width: 10),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(data.amount, style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: data.color, borderRadius: BorderRadius.circular(999)),
                      child: Text(data.status, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ]),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JeepCard extends StatelessWidget {
  const _JeepCard({required this.data});
  final JeepneyData data;
  @override
  Widget build(BuildContext context) {
    final occ = (int.tryParse(data.occupancy) ?? 0) / 22.0;
    return Container(
      width: 204,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [BoxShadow(color: data.color.withOpacity(0.08), blurRadius: 14, offset: const Offset(0, 5))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: data.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Row(children: [
            const Icon(Symbols.directions_bus_rounded, color: Colors.white, size: 15),
            const SizedBox(width: 6),
            Text(data.unit, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.22), borderRadius: BorderRadius.circular(999)),
              child: Text(data.eta, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 11, 14, 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data.route, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 3),
            Text(data.status, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.softInk)),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Symbols.people_rounded, size: 12, color: AppColors.muted),
              const SizedBox(width: 4),
              Text('${data.occupancy} passengers', style: const TextStyle(fontFamily: 'Poppins', fontSize: 10.5, color: AppColors.softInk, fontWeight: FontWeight.w500)),
            ]),
            const SizedBox(height: 7),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: occ.clamp(0.0, 1.0), minHeight: 5,
                backgroundColor: AppColors.gray200,
                valueColor: AlwaysStoppedAnimation(data.color),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _QACard extends StatelessWidget {
  const _QACard({required this.data});
  final QuickActionData data;
  @override
  Widget build(BuildContext context) {
    return _TapScale(onTap: () {}, child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [BoxShadow(color: data.color.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 3, color: data.color),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: data.color, borderRadius: BorderRadius.circular(13)),
                  child: Icon(data.icon, color: Colors.white, size: 22),
                ),
                const Spacer(),
                Text(data.label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink, height: 1.2)),
                const SizedBox(height: 3),
                Text(data.subtitle, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10.5, color: AppColors.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),
          ),
        ],
      ),
    ));
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({required this.data});
  final SavedPlaceData data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999), border: Border.all(color: AppColors.gray200)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(data.icon, size: 14, color: data.color), const SizedBox(width: 5),
        Text(data.label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink)),
      ]),
    );
  }
}

class _SavedChip extends StatelessWidget {
  const _SavedChip({required this.data});
  final SavedPlaceData data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999), border: Border.all(color: AppColors.gray200)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(data.icon, size: 15, color: data.color), const SizedBox(width: 5),
        Text(data.label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
      ]),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(13)),
          child: const Icon(Symbols.local_offer_rounded, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 14),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Ride Smarter', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
          SizedBox(height: 3),
          Text('Save places, unlock better routes.', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.white70, height: 1.4)),
        ])),
        const Icon(Symbols.arrow_forward_rounded, color: Colors.white70, size: 18),
      ]),
    );
  }
}

class _OdCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(child: Column(children: [
      _OdRow(label: 'From', value: 'Brgy. Bagong Pag-asa, QC', icon: Symbols.trip_origin_rounded, color: AppColors.primary),
      Padding(padding: const EdgeInsets.only(left: 28, top: 8, bottom: 8), child: Divider(height: 1, color: AppColors.gray200)),
      _OdRow(label: 'To', value: 'Cubao Gateway', icon: Symbols.location_on_rounded, color: AppColors.danger),
    ]));
  }
}

class _OdRow extends StatelessWidget {
  const _OdRow({required this.label, required this.value, required this.icon, required this.color});
  final String label, value;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 20, color: color),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.muted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
      ])),
    ]);
  }
}

class _FChip extends StatelessWidget {
  const _FChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(color: selected ? AppColors.primary : Colors.white, borderRadius: BorderRadius.circular(999), border: Border.all(color: selected ? AppColors.primary : AppColors.gray200)),
      child: Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppColors.ink)),
    ));
  }
}

class _RecentRow extends StatelessWidget {
  const _RecentRow({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(9)), child: const Icon(Symbols.history_rounded, size: 15, color: AppColors.primary)),
      title: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
      trailing: const Icon(Symbols.north_east_rounded, size: 14, color: AppColors.muted),
      onTap: () {},
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.softInk))),
      Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
    ]);
  }
}

class _TogRow extends StatefulWidget {
  const _TogRow({required this.label, required this.val});
  final String label;
  final bool val;
  @override
  State<_TogRow> createState() => _TogRowState();
}

class _TogRowState extends State<_TogRow> {
  late bool _v = widget.val;
  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(widget.label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
      value: _v, onChanged: (v) => setState(() => _v = v), activeColor: AppColors.primary,
    );
  }
}

class _FField extends StatelessWidget {
  const _FField({required this.label, required this.icon, this.obscure = false});
  final String label;
  final IconData icon;
  final bool obscure;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 19, color: AppColors.muted),
        filled: true, fillColor: AppColors.gray100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        labelStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.softInk, fontSize: 14),
      ),
    );
  }
}

// Backward-compat AppScaffold
class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.title, required this.subtitle, required this.body, this.actions = const []});
  final String title, subtitle;
  final Widget body;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.surface, appBar: AppBar(title: Text(title), actions: actions), body: body);
  }
}

// Unused legacy classes kept for reference; map/marker helpers used above
class MapGridPainter extends CustomPainter {
  const MapGridPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final lp = Paint()..color = AppColors.primary.withOpacity(0.05)..strokeWidth = 1;
    for (var x = 0.0; x <= size.width; x += 28) { canvas.drawLine(Offset(x, 0), Offset(x, size.height), lp); }
    for (var y = 0.0; y <= size.height; y += 28) { canvas.drawLine(Offset(0, y), Offset(size.width, y), lp); }
  }
  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
