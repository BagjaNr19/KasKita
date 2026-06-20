import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TransactionType _type = TransactionType.income;
  TransactionCategory _category = TransactionCategory.dues;
  DateTime _selectedDate = DateTime.now();
  bool _hasProof = false;
  bool _isSaving = false;

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTypeSelector(),
              const SizedBox(height: 20),
              _buildSection(
                children: [
                  _buildField(
                    controller: _titleController,
                    label: 'Judul Transaksi',
                    hint: 'contoh: Iuran warga bulan Juni',
                    icon: Icons.title_rounded,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Judul wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _amountController,
                    label: 'Nominal (Rp)',
                    hint: '50000',
                    icon: Icons.payments_rounded,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Nominal wajib diisi';
                      if (double.tryParse(v) == null) return 'Nominal tidak valid';
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSection(
                children: [
                  _buildCategoryDropdown(),
                  const SizedBox(height: 16),
                  _buildDatePicker(),
                ],
              ),
              const SizedBox(height: 20),
              _buildSection(
                children: [
                  _buildField(
                    controller: _noteController,
                    label: 'Catatan (opsional)',
                    hint: 'Tambahkan catatan untuk transaksi ini...',
                    icon: Icons.notes_rounded,
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildProofUpload(),
              const SizedBox(height: 32),
              _buildSaveButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _typeOption(TransactionType.income, 'Pemasukan', Icons.arrow_downward_rounded),
          _typeOption(TransactionType.expense, 'Pengeluaran', Icons.arrow_upward_rounded),
        ],
      ),
    );
  }

  Widget _typeOption(TransactionType type, String label, IconData icon) {
    final isSelected = _type == type;
    final color = type == TransactionType.income ? AppColors.income : AppColors.expense;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _type = type),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<TransactionCategory>(
      initialValue: _category,
      decoration: const InputDecoration(
        labelText: 'Kategori',
        prefixIcon: Icon(Icons.category_rounded,
            color: AppColors.textSecondary, size: 20),
      ),
      items: TransactionCategory.values.map((c) {
        return DropdownMenuItem(value: c, child: Text(c.label));
      }).toList(),
      onChanged: (v) {
        if (v != null) setState(() => _category = v);
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context)
                  .colorScheme
                  .copyWith(primary: AppColors.primary),
            ),
            child: child!,
          ),
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Tanggal',
          prefixIcon: Icon(Icons.calendar_today_rounded,
              color: AppColors.textSecondary, size: 20),
        ),
        child: Text(
          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildProofUpload() {
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
          const Text(
            'Bukti Transaksi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              setState(() => _hasProof = !_hasProof);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _hasProof
                        ? 'Foto bukti dipilih (dummy)'
                        : 'Foto bukti dihapus',
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 120,
              decoration: BoxDecoration(
                color: _hasProof
                    ? AppColors.success.withValues(alpha: 0.05)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _hasProof ? AppColors.success : AppColors.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _hasProof
                          ? Icons.check_circle_rounded
                          : Icons.upload_file_rounded,
                      size: 36,
                      color: _hasProof ? AppColors.success : AppColors.textHint,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _hasProof
                          ? 'Foto bukti dipilih ✓'
                          : 'Klik untuk upload foto bukti',
                      style: TextStyle(
                        color: _hasProof
                            ? AppColors.success
                            : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: _hasProof ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    const Text(
                      '(Fitur dummy)',
                      style: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _save,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Simpan Transaksi',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi berhasil disimpan! (dummy)'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
