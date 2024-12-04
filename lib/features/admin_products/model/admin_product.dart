import 'dart:developer';

class AdminProduct {
  final int productId;
  final String productName;
  final int? categoryId;
  final String? categoryName;
  final int? subCategoryId;
  final String? subCategoryName;
  final int? organisationId;
  final String? organisationName;
  final AdminVariant? variant;
  final String description;
  final List<String>? productImage;
  final num price;
  final double gstPercentage;

  AdminProduct({
    required this.productId,
    required this.productName,
    required this.categoryName,
    this.variant,
    this.productImage,
    this.organisationId,
    this.organisationName,
    required this.price,
    this.categoryId,
    this.subCategoryId,
    this.subCategoryName,
    required this.gstPercentage,
    required this.description,
  });

  factory AdminProduct.nullProduct() => AdminProduct(
      productId: -1,
      productName: "",
      categoryName: "",
      price: 0,
      gstPercentage: 0,
      description: "");

  factory AdminProduct.fromJson(
    Map<String, dynamic> json,
  ) {
    final id = json['product_id'] ?? json['id'];
    print("id :- $id ${json['product_name'] ?? json['name']}\n jsn:- $json");
    if (id == 76) {
      log("message");
    }
    final variants = (json['size_available'] as Map?);

    AdminVariant? variant;
    if (variants?.isNotEmpty == true) {
      variant = AdminVariant.fromJson(variants!.entries.first);
    }
    List<String> images = [];
    if (json['product_image'] is String) {
      images.add(json['product_image']);
    } else if (json['product_image'] is Map) {
      images = (json['product_image'] as Map)
          .values
          .map((e) => e.toString())
          .toList();
    }
    return AdminProduct(
      productId: id,
      productName: json['product_name'] ?? json['name'],
      categoryName: json['organization_name'],
      categoryId:
          json['organization_id'] is int ? json['organization_id'] : null,
      subCategoryId:
          json['sub_category_id'] is int ? json['sub_category_id'] : null,
      subCategoryName: json['sub_category_name'],
      organisationId: json['product_organization_id'] is int
          ? json['product_organization_id']
          : null,
      organisationName: json['product_organization'],
      variant: variant,
      productImage: images,
      price: num.tryParse(json['price'] ?? "0") ?? 0,
      gstPercentage: double.tryParse(json['gst_percentage'] ?? "0") ?? 0,
      description: json['description'] ?? "",
    );
  }
}

class AdminVariant {
  final String variantTitle;
  final List<AdminVariantOption> variantOptions;

  AdminVariant({
    required this.variantTitle,
    required this.variantOptions,
  });

  factory AdminVariant.fromJson(MapEntry json) {
    final options = List<AdminVariantOption>.from((json.value as Map)
        .entries
        .map((e) =>
            AdminVariantOption(name: e.key.toString(), price: e.value as int)));
    return AdminVariant(
      variantTitle: json.key,
      variantOptions: options,
    );
  }
}

class AdminVariantOption {
  late String name;
  late int price;

  AdminVariantOption({required this.name, required this.price});
}
