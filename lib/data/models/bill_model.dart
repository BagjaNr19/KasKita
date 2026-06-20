enum BillStatus { paid, unpaid, pending }

extension BillStatusExtension on BillStatus {
  String get label {
    switch (this) {
      case BillStatus.paid:
        return 'Lunas';
      case BillStatus.unpaid:
        return 'Belum Lunas';
      case BillStatus.pending:
        return 'Menunggu';
    }
  }
}

class BillModel {
  final String id;
  final String residentId;
  final String residentName;
  final String houseNumber;
  final int month; // 1–12
  final int year;
  final double amount;
  final BillStatus status;
  final DateTime? paidAt;

  const BillModel({
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

  BillModel copyWith({
    String? id,
    String? residentId,
    String? residentName,
    String? houseNumber,
    int? month,
    int? year,
    double? amount,
    BillStatus? status,
    DateTime? paidAt,
  }) {
    return BillModel(
      id: id ?? this.id,
      residentId: residentId ?? this.residentId,
      residentName: residentName ?? this.residentName,
      houseNumber: houseNumber ?? this.houseNumber,
      month: month ?? this.month,
      year: year ?? this.year,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paidAt: paidAt ?? this.paidAt,
    );
  }
}
