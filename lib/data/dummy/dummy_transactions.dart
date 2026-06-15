import '../models/transaction_model.dart';

class DummyTransactions {
  static final List<TransactionModel> all = [
    TransactionModel(
      id: 't001',
      title: 'Iuran Warga Bulan Juni 2025',
      amount: 1250000,
      date: DateTime(2025, 6, 5),
      type: TransactionType.income,
      category: TransactionCategory.dues,
      note: 'Iuran terkumpul dari 25 KK x Rp 50.000',
      createdBy: 'Siti Aminah',
      hasProof: true,
    ),
    TransactionModel(
      id: 't002',
      title: 'Pembayaran Satpam RT',
      amount: 800000,
      date: DateTime(2025, 6, 3),
      type: TransactionType.expense,
      category: TransactionCategory.security,
      note: 'Honor satpam bulan Juni 2025',
      createdBy: 'Siti Aminah',
      hasProof: true,
    ),
    TransactionModel(
      id: 't003',
      title: 'Perbaikan Lampu Jalan',
      amount: 350000,
      date: DateTime(2025, 6, 1),
      type: TransactionType.expense,
      category: TransactionCategory.maintenance,
      note: 'Penggantian 3 lampu jalan yang rusak',
      createdBy: 'H. Sukirman',
      hasProof: true,
    ),
    TransactionModel(
      id: 't004',
      title: 'Iuran Warga Bulan Mei 2025',
      amount: 1200000,
      date: DateTime(2025, 5, 7),
      type: TransactionType.income,
      category: TransactionCategory.dues,
      note: 'Iuran terkumpul dari 24 KK',
      createdBy: 'Siti Aminah',
      hasProof: true,
    ),
    TransactionModel(
      id: 't005',
      title: 'Acara Gotong Royong Mei',
      amount: 250000,
      date: DateTime(2025, 5, 25),
      type: TransactionType.expense,
      category: TransactionCategory.social,
      note: 'Konsumsi dan perlengkapan gotong royong',
      createdBy: 'Siti Aminah',
      hasProof: false,
    ),
    TransactionModel(
      id: 't006',
      title: 'Donasi Warga Pak Ahmad',
      amount: 500000,
      date: DateTime(2025, 5, 20),
      type: TransactionType.income,
      category: TransactionCategory.donation,
      note: 'Donasi sukarela untuk kas RT',
      createdBy: 'Siti Aminah',
      hasProof: true,
    ),
    TransactionModel(
      id: 't007',
      title: 'Biaya Kebersihan Taman',
      amount: 150000,
      date: DateTime(2025, 5, 15),
      type: TransactionType.expense,
      category: TransactionCategory.maintenance,
      note: 'Pemeliharaan taman RT per bulan',
      createdBy: 'Siti Aminah',
      hasProof: false,
    ),
    TransactionModel(
      id: 't008',
      title: 'Iuran Warga Bulan April 2025',
      amount: 1150000,
      date: DateTime(2025, 4, 6),
      type: TransactionType.income,
      category: TransactionCategory.dues,
      note: 'Iuran terkumpul dari 23 KK',
      createdBy: 'Siti Aminah',
      hasProof: true,
    ),
    TransactionModel(
      id: 't009',
      title: 'Pembelian Kotak P3K',
      amount: 120000,
      date: DateTime(2025, 4, 10),
      type: TransactionType.expense,
      category: TransactionCategory.utilities,
      note: 'Pengisian ulang obat P3K pos ronda',
      createdBy: 'H. Sukirman',
      hasProof: true,
    ),
    TransactionModel(
      id: 't010',
      title: 'Kegiatan HUT RI RT 03',
      amount: 600000,
      date: DateTime(2025, 8, 10),
      type: TransactionType.expense,
      category: TransactionCategory.social,
      note: 'Dekorasi, lomba, dan konsumsi warga HUT RI ke-80',
      createdBy: 'H. Sukirman',
      hasProof: true,
    ),
  ];

  static List<TransactionModel> byMonth(int month, int year) {
    return all
        .where((t) => t.date.month == month && t.date.year == year)
        .toList();
  }

  static double totalIncomeThisMonth(int month, int year) {
    return byMonth(month, year)
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double totalExpenseThisMonth(int month, int year) {
    return byMonth(month, year)
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }
}
