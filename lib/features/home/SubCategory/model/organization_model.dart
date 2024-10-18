class Organization {
  final int id;
  final String name;
  final int stateId;
  final String stateName;
  final int districtId;
  final String districtName;
  final int subCategoryId;
  final String subCategoryName;

  Organization({
    required this.id,
    required this.name,
    required this.stateId,
    required this.stateName,
    required this.districtId,
    required this.districtName,
    required this.subCategoryId,
    required this.subCategoryName,
  });

  // Factory method to create an instance from JSON
  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: _parseInt(json['id']),
      name: json['name'] ?? '',
      stateId: _parseInt(json['state_id']),
      stateName: json['state_name'] ?? '',
      districtId: _parseInt(json['district_id']),
      districtName: json['district_name'] ?? '',
      subCategoryId: _parseInt(json['sub_category_id']),
      subCategoryName: json['sub_category_name'] ?? '',
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state_id': stateId,
      'state_name': stateName,
      'district_id': districtId,
      'district_name': districtName,
      'sub_category_id': subCategoryId,
      'sub_category_name': subCategoryName,
    };
  }

  // Helper method to parse integers from dynamic types
  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value) ?? 0; // Return 0 if parsing fails
    }
    return 0; // Default return value for unrecognized types
  }
}
