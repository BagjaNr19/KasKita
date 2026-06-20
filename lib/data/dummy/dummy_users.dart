import '../models/app_user.dart';

class DummyUsers {
  static const admin = AppUser(
    id: 'usr_001',
    name: 'Budi Santoso',
    email: 'admin@kaskita.id',
    role: UserRole.admin,
    houseNumber: 'A-01',
    phoneNumber: '081234567890',
  );

  static const bendahara = AppUser(
    id: 'usr_002',
    name: 'Siti Aminah',
    email: 'bendahara@kaskita.id',
    role: UserRole.bendahara,
    houseNumber: 'A-02',
    phoneNumber: '081234567891',
  );

  static const warga = AppUser(
    id: 'usr_003',
    name: 'Agus Pratama',
    email: 'warga@kaskita.id',
    role: UserRole.warga,
    houseNumber: 'B-05',
    phoneNumber: '081234567892',
  );

  static const List<AppUser> all = [admin, bendahara, warga];

  static AppUser? findByEmail(String email) {
    try {
      return all.firstWhere((u) => u.email == email);
    } catch (e) {
      return null;
    }
  }
}
