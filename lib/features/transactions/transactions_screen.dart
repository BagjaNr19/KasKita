import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../data/models/app_user.dart';
import '../../data/models/transaction_model.dart';
import '../../data/dummy/dummy_transactions.dart';
import '../../features/auth/auth_provider.dart';
import '../../shared/widgets/recent_transaction_card.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/custom_bottom_nav.dart';

enum _Filter { all, income, expense, thisMonth }

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  _Filter _filter = _Filter.all;
  int _navIndex = 1;

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

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    switch (index) {
      case 0:
        context.go(AppRoutes.dashboard);
        break;
      case 1:
        break;
      case 2:
        context.go(AppRoutes.dues);
        break;
      case 3:
        context.go(AppRoutes.reports);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).currentUser;
    final transactions = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transaksi'),
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
        actions: [
          if (user != null && user.role.canAddTransaction)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.addTransaction),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Tambah'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: transactions.isEmpty
                ? EmptyState(
                    icon: Icons.receipt_long_rounded,
                    title: 'Tidak ada transaksi',
                    subtitle: 'Belum ada transaksi pada filter ini.',
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
        currentIndex: _navIndex,
        onTap: _onNavTap,
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
              selectedColor: AppColors.primary.withOpacity(0.15),
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
