import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/balance_card.dart';
import '../../../data/dummy/dummy_transactions.dart';
import '../../../data/dummy/dummy_residents.dart';
import '../../../data/dummy/dummy_bills.dart';
import '../../../data/models/bill_model.dart';
import '../../../shared/widgets/recent_transaction_card.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final income = DummyTransactions.totalIncomeThisMonth(now.month, now.year);
    final expense = DummyTransactions.totalExpenseThisMonth(now.month, now.year);
    final balance = 2000000.0 + income - expense; // Dummy calculation

    final totalResidents = DummyResidents.data.length;
    final unpaidBills = DummyBills.all.where((b) => b.month == now.month && b.year == now.year && b.status != BillStatus.paid).length;

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
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Warga', '$totalResidents KK', Icons.people_alt_rounded, AppColors.primary)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Belum Bayar', '$unpaidBills KK', Icons.warning_rounded, AppColors.error)),
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
                onTap: () {}, // Handled in Cash screen
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
              'Dashboard Admin',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Ringkasan kas & warga',
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
