import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/dummy/dummy_transactions.dart';
import '../../../data/dummy/dummy_bills.dart';
import '../../../data/models/bill_model.dart';
import '../../../shared/widgets/balance_card.dart';
import '../../../shared/widgets/quick_action_card.dart';
import '../../../shared/widgets/recent_transaction_card.dart';

class BendaharaDashboard extends ConsumerWidget {
  const BendaharaDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final income = DummyTransactions.totalIncomeThisMonth(now.month, now.year);
    final expense = DummyTransactions.totalExpenseThisMonth(now.month, now.year);
    final balance = 2000000.0 + income - expense;

    final unpaidBills = DummyBills.all.where((b) => b.status != BillStatus.paid).length;
    final recentTransactions = DummyTransactions.all.take(3).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            BalanceCard(
              balance: balance,
              totalIncome: income,
              totalExpense: expense,
            ),
            const SizedBox(height: 24),
            _buildUnpaidAlert(unpaidBills),
            const SizedBox(height: 24),
            const Text(
              'Aksi Cepat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: QuickActionCard(
                    icon: Icons.add_circle_outline_rounded,
                    label: 'Pemasukan',
                    color: AppColors.income,
                    onTap: () => context.push(AppRoutes.addTransaction, extra: 'income'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: QuickActionCard(
                    icon: Icons.remove_circle_outline_rounded,
                    label: 'Pengeluaran',
                    color: AppColors.expense,
                    onTap: () => context.push(AppRoutes.addTransaction, extra: 'expense'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: QuickActionCard(
                    icon: Icons.receipt_long_rounded,
                    label: 'Tagihan',
                    color: AppColors.primary,
                    onTap: () => context.go(AppRoutes.billing),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Transaksi Terbaru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            ...recentTransactions.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RecentTransactionCard(
                transaction: t,
                onTap: () => context.push('/transactions/${t.id}'),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Bendahara',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Kelola kas & transaksi',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildUnpaidAlert(int count) {
    if (count == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Ada $count tagihan iuran yang belum lunas bulan ini.',
              style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
