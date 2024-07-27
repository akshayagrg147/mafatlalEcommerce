class SubCategory {
  final String name;
  final int id;
  final String imgUrl;

  SubCategory({required this.id, required this.name, required this.imgUrl});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'] ?? "",
      imgUrl: json['img'] ?? "",
    );
  }
}
