class ResidentModel {
  final String id;
  final String name;
  final String houseNumber;
  final String phoneNumber;
  final bool isActive;

  const ResidentModel({
    required this.id,
    required this.name,
    required this.houseNumber,
    required this.phoneNumber,
    this.isActive = true,
  });

  ResidentModel copyWith({
    String? name,
    String? houseNumber,
    String? phoneNumber,
    bool? isActive,
  }) {
    return ResidentModel(
      id: id,
      name: name ?? this.name,
      houseNumber: houseNumber ?? this.houseNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isActive: isActive ?? this.isActive,
    );
  }
}
