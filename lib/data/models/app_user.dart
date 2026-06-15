enum UserRole { warga, bendahara, ketua, admin }

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.warga:
        return 'Warga';
      case UserRole.bendahara:
        return 'Bendahara';
      case UserRole.ketua:
        return 'Ketua RT/RW';
      case UserRole.admin:
        return 'Admin';
    }
  }

  bool get canAddTransaction =>
      this == UserRole.bendahara || this == UserRole.admin;
  bool get canManageDues =>
      this == UserRole.bendahara || this == UserRole.admin;
  bool get canExportReport =>
      this == UserRole.bendahara ||
      this == UserRole.ketua ||
      this == UserRole.admin;
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String rtRw;
  final String houseNumber;
  final String? phoneNumber;
  final String? avatarInitials;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.rtRw,
    required this.houseNumber,
    this.phoneNumber,
    this.avatarInitials,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
