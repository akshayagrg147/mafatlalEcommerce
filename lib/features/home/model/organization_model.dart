// Main model class to hold the response

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
      id: json['id'],
      name: json['name'],
      stateId: json['state_id'],
      stateName: json['state_name'],
      districtId: json['district_id'],
      districtName: json['district_name'],
      subCategoryId: json['sub_category_id'],
      subCategoryName: json['sub_category_name'],
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
}
