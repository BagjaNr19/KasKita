import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/app_user.dart';
import '../../data/dummy/dummy_chart_data.dart';
import '../../data/dummy/dummy_transactions.dart';
import '../../data/dummy/dummy_dues.dart';
import '../../features/auth/auth_provider.dart';
import '../../shared/widgets/balance_card.dart';
import '../../shared/widgets/finance_chart.dart';
import '../../shared/widgets/quick_action_card.dart';
import '../../shared/widgets/recent_transaction_card.dart';
import '../../shared/widgets/custom_bottom_nav.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _navIndex = 0;

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        context.push(AppRoutes.transactions);
        break;
      case 2:
        context.push(AppRoutes.dues);
        break;
      case 3:
        context.push(AppRoutes.reports);
        break;
      case 4:
        context.push(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.currentUser!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(user),
                const SizedBox(height: 20),
                BalanceCard(
                  balance: DummyChartData.currentBalance,
                  totalIncome: DummyChartData.totalIncomeThisMonth,
                  totalExpense: DummyChartData.totalExpenseThisMonth,
                ),
                const SizedBox(height: 20),
                if (user.role == UserRole.warga) _buildMyDueStatus(),
                if (user.role == UserRole.bendahara ||
                    user.role == UserRole.admin)
                  _buildUnpaidSummary(),
                const SizedBox(height: 20),
                FinanceChart(
                  title: 'Pemasukan vs Pengeluaran',
                  data: DummyChartData.monthlyData,
                ),
                const SizedBox(height: 20),
                if (user.role.canAddTransaction) _buildQuickActions(),
                if (user.role.canAddTransaction) const SizedBox(height: 20),
                _buildRecentTransactions(user),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildHeader(AppUser user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _greeting(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              '${user.role.label} • ${user.rtRw}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              user.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyDueStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Iuran Bulan Ini',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Text(
                  'Sudah Lunas ✅',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.format(50000),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnpaidSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              label: 'Belum Bayar',
              value: '${DummyDues.unpaidCount} warga',
              color: AppColors.error,
              icon: Icons.warning_rounded,
            ),
          ),
          Container(width: 1, height: 48, color: AppColors.border),
          Expanded(
            child: _buildSummaryItem(
              label: 'Menunggu',
              value: '${DummyDues.pendingCount} warga',
              color: AppColors.warning,
              icon: Icons.pending_rounded,
            ),
          ),
          Container(width: 1, height: 48, color: AppColors.border),
          Expanded(
            child: _buildSummaryItem(
              label: 'Lunas',
              value: '${DummyDues.paidCount} warga',
              color: AppColors.success,
              icon: Icons.check_circle_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aksi Cepat',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        QuickActionCard(
          icon: Icons.add_circle_rounded,
          label: 'Tambah Transaksi',
          color: AppColors.primary,
          onTap: () => context.push(AppRoutes.addTransaction),
        ),
        const SizedBox(height: 10),
        QuickActionCard(
          icon: Icons.people_alt_rounded,
          label: 'Kelola Iuran Warga',
          color: AppColors.secondary,
          onTap: () => context.push(AppRoutes.dues),
        ),
        const SizedBox(height: 10),
        QuickActionCard(
          icon: Icons.bar_chart_rounded,
          label: 'Lihat Laporan',
          color: AppColors.info,
          onTap: () => context.push(AppRoutes.reports),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(AppUser user) {
    final recent = DummyTransactions.all.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transaksi Terbaru',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.transactions),
              child: const Text(
                'Lihat semua',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...recent.map(
          (t) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: RecentTransactionCard(
              transaction: t,
              onTap: () => context.push(
                '/transactions/${t.id}',
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi 🌤️';
    if (hour < 15) return 'Selamat Siang ☀️';
    if (hour < 18) return 'Selamat Sore 🌤️';
    return 'Selamat Malam 🌙';
  }
}
