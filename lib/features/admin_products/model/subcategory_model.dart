class SubCategory {
  final int id;
  final String name;
  final String image;
  final int organisationId;
  final String organisationName;
  SubCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.organisationId,
    required this.organisationName,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["id"],
        name: json["name"],
        image: json["image"] ?? "",
        organisationId: json["organisation_id"],
        organisationName: json["organisation_name"] ?? "",
      );
}
