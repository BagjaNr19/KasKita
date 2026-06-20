import '../models/resident_model.dart';

class DummyResidents {
  static final List<ResidentModel> data = [
    const ResidentModel(id: 'res_001', name: 'Budi Santoso', houseNumber: 'A-01', phoneNumber: '081234567890'),
    const ResidentModel(id: 'res_002', name: 'Siti Aminah', houseNumber: 'A-02', phoneNumber: '081234567891'),
    const ResidentModel(id: 'res_003', name: 'Agus Pratama', houseNumber: 'B-05', phoneNumber: '081234567892'),
    const ResidentModel(id: 'res_004', name: 'Rina Wijaya', houseNumber: 'B-06', phoneNumber: '081234567893'),
    const ResidentModel(id: 'res_005', name: 'Hendra Setiawan', houseNumber: 'C-01', phoneNumber: '081234567894'),
    const ResidentModel(id: 'res_006', name: 'Maya Sari', houseNumber: 'C-02', phoneNumber: '081234567895'),
    const ResidentModel(id: 'res_007', name: 'Eko Putra', houseNumber: 'D-03', phoneNumber: '081234567896'),
    const ResidentModel(id: 'res_008', name: 'Dian Permata', houseNumber: 'D-04', phoneNumber: '081234567897', isActive: false),
    const ResidentModel(id: 'res_009', name: 'Joko Anwar', houseNumber: 'E-01', phoneNumber: '081234567898'),
    const ResidentModel(id: 'res_010', name: 'Putri Larasati', houseNumber: 'E-02', phoneNumber: '081234567899'),
  ];
}
