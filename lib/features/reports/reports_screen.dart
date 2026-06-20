import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/app_user.dart';
import '../../data/dummy/dummy_transactions.dart';
import '../../data/models/transaction_model.dart';
import '../../features/auth/auth_provider.dart';
import '../../shared/widgets/recent_transaction_card.dart';
import '../../shared/widgets/custom_bottom_nav.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  int _selectedMonth = DateTime.now().month;
  final int _selectedYear = DateTime.now().year;
  final int _navIndex = 3;

  final _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  List<TransactionModel> get _transactions =>
      DummyTransactions.byMonth(_selectedMonth, _selectedYear);

  double get _income => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (s, t) => s + t.amount);

  double get _expense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (s, t) => s + t.amount);

  void _onNavTap(int index, UserRole role) {
    if (index == 3) return;

    if (role == UserRole.admin) {
      if (index == 0) context.go(AppRoutes.dashboard);
      if (index == 1) context.go(AppRoutes.residents);
      if (index == 2) context.go(AppRoutes.cash);
      if (index == 4) context.go(AppRoutes.profile);
    } else if (role == UserRole.bendahara) {
      if (index == 0) context.go(AppRoutes.dashboard);
      if (index == 1) context.go(AppRoutes.transactions);
      if (index == 2) context.go(AppRoutes.billing);
      if (index == 4) context.go(AppRoutes.profile);
    } else if (role == UserRole.warga) {
      if (index == 0) context.go(AppRoutes.dashboard);
      if (index == 1) context.go(AppRoutes.cash);
      if (index == 2) context.go(AppRoutes.dues);
      if (index == 4) context.go(AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).currentUser;
    if (user == null) return const Scaffold();
    
    const saldoAwal = 2000000.0;
    final saldoAkhir = saldoAwal + _income - _expense;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Laporan Keuangan'),
        automaticallyImplyLeading: false,
        actions: [
          if (user.role.canExportReport)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: OutlinedButton.icon(
                onPressed: _exportPdf,
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
                label: const Text('Ekspor PDF'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthSelector(),
            const SizedBox(height: 20),
            _buildSummaryCards(saldoAwal, saldoAkhir),
            const SizedBox(height: 20),
            _buildPieChart(),
            const SizedBox(height: 20),
            _buildTransactionList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => _onNavTap(i, user.role),
        role: user.role,
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedMonth,
                isExpanded: true,
                items: List.generate(
                  12,
                  (i) => DropdownMenuItem(
                    value: i + 1,
                    child: Text(
                      _months[i],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                onChanged: (v) => setState(() => _selectedMonth = v!),
              ),
            ),
          ),
          const Text(
            ' 2025',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(double saldoAwal, double saldoAkhir) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                'Saldo Awal',
                saldoAwal,
                Icons.account_balance_rounded,
                AppColors.info,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _summaryCard(
                'Saldo Akhir',
                saldoAkhir,
                Icons.savings_rounded,
                AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                'Total Pemasukan',
                _income,
                Icons.arrow_downward_rounded,
                AppColors.income,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _summaryCard(
                'Total Pengeluaran',
                _expense,
                Icons.arrow_upward_rounded,
                AppColors.expense,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryCard(String label, double amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.formatCompact(amount),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    if (_income == 0 && _expense == 0) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Text(
            'Tidak ada transaksi bulan ini',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Bulan Ini',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: PieChart(
                  PieChartData(
                    sections: [
                      if (_income > 0)
                        PieChartSectionData(
                          value: _income,
                          color: AppColors.income,
                          radius: 50,
                          title: '',
                        ),
                      if (_expense > 0)
                        PieChartSectionData(
                          value: _expense,
                          color: AppColors.expense,
                          radius: 50,
                          title: '',
                        ),
                    ],
                    centerSpaceRadius: 30,
                    sectionsSpace: 4,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _pieLegend(AppColors.income, 'Pemasukan',
                        CurrencyFormatter.format(_income)),
                    const SizedBox(height: 12),
                    _pieLegend(AppColors.expense, 'Pengeluaran',
                        CurrencyFormatter.format(_expense)),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    _pieLegend(
                      AppColors.primary,
                      'Selisih',
                      CurrencyFormatter.format(_income - _expense),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pieLegend(Color color, String label, String value) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    final transactions = _transactions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaksi ${_months[_selectedMonth - 1]} $_selectedYear',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (transactions.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Text(
                'Tidak ada transaksi bulan ini',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ),
          )
        else
          ...transactions.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RecentTransactionCard(
                transaction: t,
                onTap: () => context.push('/transactions/${t.id}'),
              ),
            ),
          ),
      ],
    );
  }

  void _exportPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ekspor PDF (fitur dummy) — akan tersedia segera'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.info,
      ),
    );
  }
}
