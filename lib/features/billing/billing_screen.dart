import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../data/models/app_user.dart';
import '../../data/models/bill_model.dart';
import '../../data/dummy/dummy_bills.dart';
import '../../data/dummy/dummy_residents.dart';
import '../../features/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/custom_bottom_nav.dart';

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> {
  final List<BillModel> _bills = List.from(DummyBills.all);

  void _onNavTap(int index, UserRole role) {
    if (index == 2) return;
    if (role == UserRole.bendahara) {
      if (index == 0) context.go(AppRoutes.dashboard);
      if (index == 1) context.go(AppRoutes.transactions);
      if (index == 3) context.go(AppRoutes.reports);
      if (index == 4) context.go(AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).currentUser;
    if (user == null) return const Scaffold();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Penagihan Iuran'),
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Form Buat Tagihan Massal (Dummy)')),
                );
              },
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Buat'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: _bills.isEmpty
          ? const Center(child: Text('Belum ada data tagihan'))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _bills.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final bill = _bills[index];
                return _buildBillCard(bill);
              },
            ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 2,
        onTap: (i) => _onNavTap(i, user.role),
        role: user.role,
      ),
    );
  }

  Widget _buildBillCard(BillModel bill) {
    final resident = DummyResidents.data.firstWhere((r) => r.id == bill.residentId);

    Color statusColor;
    String statusText;
    switch (bill.status) {
      case BillStatus.paid:
        statusColor = AppColors.primary;
        statusText = 'Lunas';
        break;
      case BillStatus.pending:
        statusColor = AppColors.info;
        statusText = 'Menunggu';
        break;
      case BillStatus.unpaid:
        statusColor = AppColors.error;
        statusText = 'Belum Lunas';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          resident.name,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Bulan: ${bill.month}/${bill.year}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text('Rp ${bill.amount.toInt()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
              onSelected: (value) {
                if (value == 'mark_paid') {
                  setState(() {
                    final i = _bills.indexWhere((b) => b.id == bill.id);
                    if (i >= 0) {
                      _bills[i] = _bills[i].copyWith(status: BillStatus.paid);
                    }
                  });
                } else if (value == 'remind') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kirim pengingat ke ${resident.name}')),
                  );
                }
              },
              itemBuilder: (context) => [
                if (bill.status != BillStatus.paid)
                  const PopupMenuItem(value: 'mark_paid', child: Text('Tandai Lunas')),
                if (bill.status != BillStatus.paid)
                  const PopupMenuItem(value: 'remind', child: Text('Kirim Pengingat')),
                const PopupMenuItem(value: 'detail', child: Text('Lihat Detail')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
