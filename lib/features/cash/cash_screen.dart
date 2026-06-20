import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../data/models/app_user.dart';
import '../../data/models/transaction_model.dart';
import '../../data/dummy/dummy_transactions.dart';
import '../auth/auth_provider.dart';
import '../../shared/widgets/recent_transaction_card.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/custom_bottom_nav.dart';

enum _Filter { all, income, expense, thisMonth }

class CashScreen extends ConsumerStatefulWidget {
  const CashScreen({super.key});

  @override
  ConsumerState<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends ConsumerState<CashScreen> {
  _Filter _filter = _Filter.all;

  List<TransactionModel> get _filtered {
    final now = DateTime.now();
    switch (_filter) {
      case _Filter.all:
        return DummyTransactions.all;
      case _Filter.income:
        return DummyTransactions.all
            .where((t) => t.type == TransactionType.income)
            .toList();
      case _Filter.expense:
        return DummyTransactions.all
            .where((t) => t.type == TransactionType.expense)
            .toList();
      case _Filter.thisMonth:
        return DummyTransactions.all
            .where((t) => t.date.month == now.month && t.date.year == now.year)
            .toList();
    }
  }

  void _onNavTap(int index, UserRole role) {
    if (role == UserRole.admin) {
      if (index == 0) context.go(AppRoutes.dashboard);
      if (index == 1) context.go(AppRoutes.residents);
      if (index == 2) return;
      if (index == 3) context.go(AppRoutes.reports);
      if (index == 4) context.go(AppRoutes.profile);
    } else if (role == UserRole.warga) {
      if (index == 0) context.go(AppRoutes.dashboard);
      if (index == 1) return;
      if (index == 2) context.go(AppRoutes.dues);
      if (index == 3) context.go(AppRoutes.reports);
      if (index == 4) context.go(AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).currentUser;
    if (user == null) return const Scaffold();

    final transactions = _filtered;
    // Admin uses index 2 for Kas, Warga uses index 1
    final navIndex = user.role == UserRole.admin ? 2 : 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Data Kas'),
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: transactions.isEmpty
                ? const EmptyState(
                    icon: Icons.account_balance_wallet_rounded,
                    title: 'Tidak ada data kas',
                    subtitle: 'Belum ada riwayat transaksi.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: transactions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final t = transactions[index];
                      return RecentTransactionCard(
                        transaction: t,
                        onTap: () => context.push('/transactions/${t.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: navIndex,
        onTap: (i) => _onNavTap(i, user.role),
        role: user.role,
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      (_Filter.all, 'Semua'),
      (_Filter.income, 'Pemasukan'),
      (_Filter.expense, 'Pengeluaran'),
      (_Filter.thisMonth, 'Bulan ini'),
    ];

    return Container(
      height: 52,
      color: AppColors.background,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: filters.map((f) {
          final isSelected = _filter == f.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(f.$2),
              selected: isSelected,
              onSelected: (_) => setState(() => _filter = f.$1),
              selectedColor: AppColors.primary.withValues(alpha: 0.15),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 13,
              ),
              showCheckmark: false,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
