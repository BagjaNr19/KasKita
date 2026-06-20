enum UserRole { admin, bendahara, warga }

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Admin / RT';
      case UserRole.bendahara:
        return 'Bendahara';
      case UserRole.warga:
        return 'Warga';
    }
  }

  bool get isAdmin => this == UserRole.admin;
  bool get isBendahara => this == UserRole.bendahara;
  bool get isWarga => this == UserRole.warga;
  
  bool get canAddTransaction => this == UserRole.bendahara;
  bool get canExportReport => this == UserRole.admin || this == UserRole.bendahara;
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? houseNumber;
  final String? phoneNumber;
  final String? avatarInitials;
  final String rtRw; // Added back for profile info

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.houseNumber,
    this.phoneNumber,
    this.avatarInitials,
    this.rtRw = 'RT 01 / RW 01', // Default
  });

  String get initials {
    if (avatarInitials != null) return avatarInitials!;
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
