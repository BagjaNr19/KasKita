enum TransactionType { income, expense }

enum TransactionCategory {
  dues,         // iuran
  maintenance,  // pemeliharaan
  security,     // keamanan
  social,       // sosial/kegiatan
  utilities,    // utilitas
  donation,     // donasi
  other,        // lain-lain
}

extension TransactionCategoryExtension on TransactionCategory {
  String get label {
    switch (this) {
      case TransactionCategory.dues:
        return 'Iuran Warga';
      case TransactionCategory.maintenance:
        return 'Pemeliharaan';
      case TransactionCategory.security:
        return 'Keamanan';
      case TransactionCategory.social:
        return 'Sosial & Kegiatan';
      case TransactionCategory.utilities:
        return 'Utilitas';
      case TransactionCategory.donation:
        return 'Donasi';
      case TransactionCategory.other:
        return 'Lain-lain';
    }
  }
}

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final TransactionCategory category;
  final String? note;
  final String createdBy;
  final bool hasProof;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.note,
    required this.createdBy,
    this.hasProof = false,
  });
}
