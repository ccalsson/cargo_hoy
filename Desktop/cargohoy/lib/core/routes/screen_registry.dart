class ScreenRegistry {
  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';
  static const String roleSelection = '/role-selection';
  static const String twoFactorSetup = '/2fa-setup';
  static const String twoFactorVerify = '/2fa-verify';
  static const String biometrySetup = '/biometry-setup';
  static const String locationPermission = '/location-permission';

  // Main Routes
  static const String home = '/home';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String chat = '/chat';

  // Load Management Routes
  static const String loadList = '/loads';
  static const String loadDetail = '/load-detail';
  static const String loadCreate = '/load-create';
  static const String documentUpload = '/document-upload';

  // Map & Location Routes
  static const String mapView = '/map';
  static const String predictiveRoute = '/predictive-route';

  // Analytics Routes
  static const String analytics = '/analytics';
  static const String fuelControl = '/fuel-control';
  static const String financialReport = '/financial-report';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      roleSelection: (context) => const RoleSelectionScreen(),
      twoFactorSetup: (context) => const TwoFactorSetupScreen(),
      twoFactorVerify: (context) => const TwoFactorVerifyScreen(),
      biometrySetup: (context) => const BiometrySetupScreen(),
      locationPermission: (context) => const LocationPermissionScreen(),
      // ... resto de las rutas
    };
  }
} 