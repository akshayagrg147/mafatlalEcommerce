class AdminCategory {
  final int id;
  final String name;
  final String image;
  final String? bannerImg;

  AdminCategory({
    required this.id,
    required this.name,
    required this.image,
    this.bannerImg,
  });

  factory AdminCategory.fromJson(Map<String, dynamic> json) {
    return AdminCategory(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      bannerImg: json['banner_image'] != null &&
              (json['banner_image'] is List && json['banner_image'].isNotEmpty)
          ? json['banner_image']?.first
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
