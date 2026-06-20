import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/dummy/dummy_residents.dart';
import '../../data/models/resident_model.dart';

class ResidentsScreen extends StatefulWidget {
  const ResidentsScreen({super.key});

  @override
  State<ResidentsScreen> createState() => _ResidentsScreenState();
}

class _ResidentsScreenState extends State<ResidentsScreen> {
  final List<ResidentModel> _residents = List.from(DummyResidents.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Data Warga'),
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: _showAddResidentDialog,
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
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
      body: _residents.isEmpty
          ? const Center(child: Text('Belum ada data warga'))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _residents.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final r = _residents[index];
                return _buildResidentCard(r);
              },
            ),
    );
  }

  Widget _buildResidentCard(ResidentModel resident) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            resident.name[0].toUpperCase(),
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          resident.name,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.home_rounded, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(resident.houseNumber, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(width: 12),
                const Icon(Icons.phone_rounded, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(resident.phoneNumber, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: resident.isActive ? AppColors.income.withValues(alpha: 0.1) : AppColors.textHint.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                resident.isActive ? 'Aktif' : 'Nonaktif',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: resident.isActive ? AppColors.income : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditResidentDialog(resident);
                } else if (value == 'delete') {
                  setState(() => _residents.removeWhere((r) => r.id == resident.id));
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Hapus', style: TextStyle(color: AppColors.error))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddResidentDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form Tambah Warga (Dummy)')),
    );
  }

  void _showEditResidentDialog(ResidentModel resident) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Form Edit Warga: ${resident.name} (Dummy)')),
    );
  }
}
