import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'features/auth/auth_provider.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/residents/residents_screen.dart';
import 'features/cash/cash_screen.dart';
import 'features/billing/billing_screen.dart';
import 'features/transactions/transactions_screen.dart';
import 'features/transactions/transaction_detail_screen.dart';
import 'features/transactions/add_transaction_screen.dart';
import 'features/dues/dues_screen.dart';
import 'features/reports/reports_screen.dart';
import 'features/profile/profile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isLoggedIn = authState.currentUser != null;
      final isOnSplash = state.matchedLocation == AppRoutes.splash;
      final isOnOnboarding = state.matchedLocation == AppRoutes.onboarding;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      if (isLoggedIn && (isOnSplash || isOnOnboarding || isOnLogin)) {
        return AppRoutes.dashboard;
      }

      if (isOnSplash || isOnOnboarding || isOnLogin) return null;
      if (!isLoggedIn) return AppRoutes.login;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.residents,
        builder: (context, state) => const ResidentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.cash,
        builder: (context, state) => const CashScreen(),
      ),
      GoRoute(
        path: AppRoutes.billing,
        builder: (context, state) => const BillingScreen(),
      ),
      GoRoute(
        path: AppRoutes.transactions,
        builder: (context, state) => const TransactionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.addTransaction,
        builder: (context, state) => const AddTransactionScreen(),
      ),
      GoRoute(
        path: AppRoutes.transactionDetail,
        builder: (context, state) {
          final transactionId = state.pathParameters['id'] ?? '';
          return TransactionDetailScreen(transactionId: transactionId);
        },
      ),
      GoRoute(
        path: AppRoutes.dues,
        builder: (context, state) => const DuesScreen(),
      ),
      GoRoute(
        path: AppRoutes.reports,
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});

class KaskitaApp extends ConsumerWidget {
  const KaskitaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Kaskita',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
