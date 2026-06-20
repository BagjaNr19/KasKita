import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import 'widgets/admin_dashboard.dart';
import '../../data/models/app_user.dart';
import '../auth/auth_provider.dart';
import '../../shared/widgets/custom_bottom_nav.dart';
import 'widgets/bendahara_dashboard.dart';
import 'widgets/warga_dashboard.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _navIndex = 0;

  void _onNavTap(int index, UserRole role) {
    setState(() => _navIndex = index);
    
    // Default routes based on index. We'll map them according to the role's navbar.
    // Admin: 0=Home, 1=Warga, 2=Kas, 3=Laporan, 4=Profil
    // Bendahara: 0=Home, 1=Transaksi, 2=Penagihan, 3=Laporan, 4=Profil
    // Warga: 0=Home, 1=Kas, 2=Iuran, 3=Laporan, 4=Profil
    
    if (index == 0) return; // Already on Home
    
    switch (role) {
      case UserRole.admin:
        if (index == 1) context.go(AppRoutes.residents);
        if (index == 2) context.go(AppRoutes.cash);
        if (index == 3) context.go(AppRoutes.reports);
        if (index == 4) context.go(AppRoutes.profile);
        break;
      case UserRole.bendahara:
        if (index == 1) context.go(AppRoutes.transactions);
        if (index == 2) context.go(AppRoutes.billing);
        if (index == 3) context.go(AppRoutes.reports);
        if (index == 4) context.go(AppRoutes.profile);
        break;
      case UserRole.warga:
        if (index == 1) context.go(AppRoutes.cash);
        if (index == 2) context.go(AppRoutes.dues);
        if (index == 3) context.go(AppRoutes.reports);
        if (index == 4) context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    Widget dashboardContent;
    switch (user.role) {
      case UserRole.admin:
        dashboardContent = const AdminDashboard();
        break;
      case UserRole.bendahara:
        dashboardContent = const BendaharaDashboard();
        break;
      case UserRole.warga:
        dashboardContent = const WargaDashboard();
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: dashboardContent,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => _onNavTap(i, user.role),
        role: user.role,
      ),
    );
  }
}
