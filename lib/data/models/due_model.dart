enum DueStatus { paid, unpaid, pending }

extension DueStatusExtension on DueStatus {
  String get label {
    switch (this) {
      case DueStatus.paid:
        return 'Lunas';
      case DueStatus.unpaid:
        return 'Belum Lunas';
      case DueStatus.pending:
        return 'Menunggu';
    }
  }
}

class DueModel {
  final String id;
  final String residentId;
  final String residentName;
  final String houseNumber;
  final int month; // 1–12
  final int year;
  final double amount;
  final DueStatus status;
  final DateTime? paidAt;

  const DueModel({
    required this.id,
    required this.residentId,
    required this.residentName,
    required this.houseNumber,
    required this.month,
    required this.year,
    required this.amount,
    required this.status,
    this.paidAt,
  });

  String get monthLabel {
    const months = [
      '',
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${months[month]} $year';
  }
}
