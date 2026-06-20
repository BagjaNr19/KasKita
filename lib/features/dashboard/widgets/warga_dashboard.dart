import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/dummy/dummy_transactions.dart';
import '../../../data/dummy/dummy_bills.dart';
import '../../../data/models/bill_model.dart';
import '../../../shared/widgets/balance_card.dart';
import '../../../shared/widgets/recent_transaction_card.dart';
import '../../auth/auth_provider.dart';

class WargaDashboard extends ConsumerWidget {
  const WargaDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).currentUser!;
    final now = DateTime.now();
    final income = DummyTransactions.totalIncomeThisMonth(now.month, now.year);
    final expense = DummyTransactions.totalExpenseThisMonth(now.month, now.year);
    final balance = 2000000.0 + income - expense;

    final myBills = DummyBills.getForResident(user.id);
    final currentBill = myBills.isNotEmpty ? myBills.first : null;

    final recentTransactions = DummyTransactions.all.take(3).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(user.name),
            const SizedBox(height: 24),
            BalanceCard(
              balance: balance,
              totalIncome: income,
              totalExpense: expense,
            ),
            const SizedBox(height: 24),
            _buildMyDuesStatus(context, currentBill),
            const SizedBox(height: 24),
            const Text(
              'Transaksi Kas Terbaru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            ...recentTransactions.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RecentTransactionCard(
                transaction: t,
                onTap: () {}, // Handled in Cash screen
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Halo,',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
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

  Widget _buildMyDuesStatus(BuildContext context, BillModel? bill) {
    if (bill == null) return const SizedBox.shrink();

    Color bgColor;
    Color textColor;
    IconData icon;
    String statusText;

    switch (bill.status) {
      case BillStatus.paid:
        bgColor = AppColors.primary.withValues(alpha: 0.1);
        textColor = AppColors.primary;
        icon = Icons.check_circle_outline_rounded;
        statusText = 'Iuran bulan ini sudah lunas';
        break;
      case BillStatus.unpaid:
        bgColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        icon = Icons.cancel_outlined;
        statusText = 'Iuran bulan ini belum dibayar';
        break;
      case BillStatus.pending:
        bgColor = AppColors.info.withValues(alpha: 0.1);
        textColor = AppColors.info;
        icon = Icons.hourglass_empty_rounded;
        statusText = 'Menunggu konfirmasi pembayaran';
        break;
    }

    return InkWell(
      onTap: () => context.go(AppRoutes.dues),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: textColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                statusText,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: textColor),
          ],
        ),
      ),
    );
  }
}
