import 'package:mafatlal_ecommerce/features/home/model/subcategory_model.dart';

class Category {
  final String name;
  final int id;
  final String imgUrl;
  final List<SubCategory> subCategories;

  Category(
      {required this.id,
      required this.imgUrl,
      required this.name,
      required this.subCategories});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        name: json['name'] ?? "",
        imgUrl: json['img'] ?? "",
        subCategories: List<SubCategory>.from(
            ((json['sub_categories'] as List?) ?? [])
                .map((e) => SubCategory.fromJson(e))));
  }
}
