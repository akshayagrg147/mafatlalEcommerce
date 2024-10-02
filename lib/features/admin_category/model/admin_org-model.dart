class AdminOrganisation {
  final int id;
  final String name;
  final String? image;
  final int? stateId;
  final String? stateName;
  final int? districtId;
  final String? districtName;

  AdminOrganisation({
    required this.id,
    required this.name,
    this.image,
    this.stateId,
    this.stateName,
    this.districtId,
    this.districtName,
  });

  factory AdminOrganisation.fromJson(Map<String, dynamic> json) {
    return AdminOrganisation(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      stateId: json['state_id'] is int ? json['state_id'] : null,
      stateName: json['state'],
      districtId: json['district_id'] is int ? json['district_id'] : null,
      districtName: json['district'],
    );
  }
}
