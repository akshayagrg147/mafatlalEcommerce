class SubCategory {
  final int id;
  final String name;
  final String image;
  SubCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["id"],
        name: json["name"],
        image: json["image"] ?? "",
      );
}
