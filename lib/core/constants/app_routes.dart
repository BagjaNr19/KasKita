class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  
  // Admin/RT routes
  static const String residents = '/residents';
  
  // Bendahara routes
  static const String billing = '/billing';
  static const String transactions = '/transactions';
  static const String addTransaction = '/transactions/add';
  static const String transactionDetail = '/transactions/:id';
  
  // Warga routes
  static const String dues = '/dues';
  
  // Shared routes
  static const String cash = '/cash';
  static const String reports = '/reports';
  static const String profile = '/profile';
}
