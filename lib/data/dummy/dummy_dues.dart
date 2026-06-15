import '../models/due_model.dart';

class DummyDues {
  static final List<DueModel> all = [
    DueModel(
      id: 'd001',
      residentId: 'r001',
      residentName: 'Budi Santoso',
      houseNumber: 'No. 12',
      month: 6,
      year: 2025,
      amount: 50000,
      status: DueStatus.paid,
      paidAt: DateTime(2025, 6, 5),
    ),
    DueModel(
      id: 'd002',
      residentId: 'r002',
      residentName: 'Dewi Lestari',
      houseNumber: 'No. 08',
      month: 6,
      year: 2025,
      amount: 50000,
      status: DueStatus.paid,
      paidAt: DateTime(2025, 6, 3),
    ),
    DueModel(
      id: 'd003',
      residentId: 'r003',
      residentName: 'Agus Hermawan',
      houseNumber: 'No. 15',
      month: 6,
      year: 2025,
      amount: 50000,
      status: DueStatus.unpaid,
    ),
    DueModel(
      id: 'd004',
      residentId: 'r004',
      residentName: 'Rina Wahyuni',
      houseNumber: 'No. 03',
      month: 6,
      year: 2025,
      amount: 50000,
      status: DueStatus.pending,
      paidAt: DateTime(2025, 6, 7),
    ),
    DueModel(
      id: 'd005',
      residentId: 'r005',
      residentName: 'Hendra Kusuma',
      houseNumber: 'No. 21',
      month: 6,
      year: 2025,
      amount: 50000,
      status: DueStatus.unpaid,
    ),
    DueModel(
      id: 'd006',
      residentId: 'r006',
      residentName: 'Yuni Astuti',
      houseNumber: 'No. 07',
      month: 6,
      year: 2025,
      amount: 50000,
      status: DueStatus.paid,
      paidAt: DateTime(2025, 6, 6),
    ),
    DueModel(
      id: 'd007',
      residentId: 'r007',
      residentName: 'Bambang Susilo',
      houseNumber: 'No. 18',
      month: 6,
      year: 2025,
      amount: 50000,
      status: DueStatus.unpaid,
    ),
    DueModel(
      id: 'd008',
      residentId: 'r008',
      residentName: 'Sri Handayani',
      houseNumber: 'No. 09',
      month: 6,
      year: 2025,
      amount: 50000,
      status: DueStatus.pending,
      paidAt: DateTime(2025, 6, 8),
    ),
    DueModel(
      id: 'd009',
      residentId: 'r009',
      residentName: 'Doni Prasetyo',
      houseNumber: 'No. 25',
      month: 6,
      year: 2025,
      amount: 50000,
      status: DueStatus.paid,
      paidAt: DateTime(2025, 6, 4),
    ),
    DueModel(
      id: 'd010',
      residentId: 'r010',
      residentName: 'Evi Kurniawati',
      houseNumber: 'No. 13',
      month: 6,
      year: 2025,
      amount: 50000,
      status: DueStatus.unpaid,
    ),
  ];

  static int get unpaidCount =>
      all.where((d) => d.status == DueStatus.unpaid).length;
  static int get paidCount =>
      all.where((d) => d.status == DueStatus.paid).length;
  static int get pendingCount =>
      all.where((d) => d.status == DueStatus.pending).length;
}
