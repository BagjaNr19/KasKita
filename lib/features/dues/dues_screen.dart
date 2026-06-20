import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/bill_model.dart';
import '../../data/models/app_user.dart';
import '../../data/dummy/dummy_bills.dart';
import '../auth/auth_provider.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/custom_bottom_nav.dart';

class DuesScreen extends ConsumerStatefulWidget {
  const DuesScreen({super.key});

  @override
  ConsumerState<DuesScreen> createState() => _DuesScreenState();
}

class _DuesScreenState extends ConsumerState<DuesScreen> {
  BillStatus? _filterStatus; // null = all
  final int _navIndex = 2; // For Warga, Dues is index 2

  List<BillModel> _getFiltered(String residentId) {
    final myBills = DummyBills.getForResident(residentId);
    if (_filterStatus == null) return myBills;
    return myBills.where((d) => d.status == _filterStatus).toList();
  }

  void _onNavTap(int index, UserRole role) {
    if (index == 2) return;
    if (role == UserRole.warga) {
      if (index == 0) context.go(AppRoutes.dashboard);
      if (index == 1) context.go(AppRoutes.cash);
      if (index == 3) context.go(AppRoutes.reports);
      if (index == 4) context.go(AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).currentUser;
    if (user == null) return const Scaffold();

    final filtered = _getFiltered(user.id);
    final myBills = DummyBills.getForResident(user.id);
    final paidCount = myBills.where((b) => b.status == BillStatus.paid).length;
    final pendingCount = myBills.where((b) => b.status == BillStatus.pending).length;
    final unpaidCount = myBills.where((b) => b.status == BillStatus.unpaid).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Iuran Saya'),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
      ),
      body: Column(
        children: [
          _buildSummaryBar(paidCount, pendingCount, unpaidCount),
          _buildFilterChips(),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(
                    icon: Icons.receipt_long_rounded,
                    title: 'Tidak ada data iuran',
                    subtitle: 'Tidak ada iuran dengan status ini.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _buildBillCard(filtered[index]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => _onNavTap(i, user.role),
        role: user.role,
      ),
    );
  }

  Widget _buildSummaryBar(int paid, int pending, int unpaid) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _summaryItem(
              '$paid',
              'Lunas',
              Icons.check_circle_rounded,
              Colors.greenAccent,
            ),
          ),
          Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.3)),
          Expanded(
            child: _summaryItem(
              '$pending',
              'Menunggu',
              Icons.pending_rounded,
              Colors.amberAccent,
            ),
          ),
          Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.3)),
          Expanded(
            child: _summaryItem(
              '$unpaid',
              'Belum Lunas',
              Icons.cancel_rounded,
              Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      (null, 'Semua'),
      (BillStatus.paid, 'Lunas'),
      (BillStatus.unpaid, 'Belum Lunas'),
      (BillStatus.pending, 'Menunggu'),
    ];

    return Container(
      height: 52,
      color: AppColors.background,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: filters.map((f) {
          final isSelected = _filterStatus == f.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(f.$2),
              selected: isSelected,
              onSelected: (_) => setState(() => _filterStatus = f.$1),
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

  Widget _buildBillCard(BillModel bill) {
    Color statusColor;
    String statusText;
    switch (bill.status) {
      case BillStatus.paid:
        statusColor = AppColors.primary;
        statusText = 'Lunas';
        break;
      case BillStatus.pending:
        statusColor = AppColors.info;
        statusText = 'Menunggu Konfirmasi';
        break;
      case BillStatus.unpaid:
        statusColor = AppColors.error;
        statusText = 'Belum Lunas';
        break;
    }

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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.receipt_long_rounded, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Iuran Bulan ${bill.month}/${bill.year}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  CurrencyFormatter.format(bill.amount),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              if (bill.status == BillStatus.unpaid) ...[
                const SizedBox(height: 8),
                SizedBox(
                  height: 28,
                  child: FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Form Upload Bukti Transfer (Dummy)')),
                      );
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Bayar'),
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
