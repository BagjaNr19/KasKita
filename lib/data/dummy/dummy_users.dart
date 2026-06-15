import '../models/app_user.dart';

class DummyUsers {
  static const AppUser warga = AppUser(
    id: 'u001',
    name: 'Budi Santoso',
    email: 'budi@warga.id',
    role: UserRole.warga,
    rtRw: 'RT 03 / RW 07',
    houseNumber: 'No. 12',
    phoneNumber: '0812-3456-7890',
  );

  static const AppUser bendahara = AppUser(
    id: 'u002',
    name: 'Siti Aminah',
    email: 'siti@rt03.id',
    role: UserRole.bendahara,
    rtRw: 'RT 03 / RW 07',
    houseNumber: 'No. 05',
    phoneNumber: '0813-2222-3333',
  );

  static const AppUser ketua = AppUser(
    id: 'u003',
    name: 'H. Sukirman',
    email: 'ketua@rt03.id',
    role: UserRole.ketua,
    rtRw: 'RT 03 / RW 07',
    houseNumber: 'No. 01',
    phoneNumber: '0811-9999-8888',
  );

  static const AppUser admin = AppUser(
    id: 'u004',
    name: 'Admin Kaskita',
    email: 'admin@kaskita.id',
    role: UserRole.admin,
    rtRw: 'RT 03 / RW 07',
    houseNumber: '-',
    phoneNumber: '0800-0000-0000',
  );

  static const List<AppUser> all = [warga, bendahara, ketua, admin];
}
