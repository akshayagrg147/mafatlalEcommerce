class AdminProduct {
  final int productId;
  final String productName;
  final int? organisationId;
  final String? organisationName;
  final int? subCategoryId;
  final String? subCategoryName;
  final AdminVariant? variant;
  final String description;
  final String? productImage;
  final num price;

  AdminProduct({
    required this.productId,
    required this.productName,
    required this.organisationName,
    this.variant,
    this.productImage,
    required this.price,
    this.organisationId,
    this.subCategoryId,
    this.subCategoryName,
    required this.description,
  });

  factory AdminProduct.nullProduct() => AdminProduct(
      productId: -1,
      productName: "",
      organisationName: "",
      price: 0,
      description: "");

  factory AdminProduct.fromJson(
    Map<String, dynamic> json,
  ) {
    final id = json['product_id'] ?? json['id'];
    final variants = (json['size_available'] as Map);
    AdminVariant? variant;
    if (variants.isNotEmpty) {
      variant = AdminVariant.fromJson(variants.entries.first);
    }

    return AdminProduct(
      productId: id,
      productName: json['product_name'] ?? json['name'],
      organisationName: json['organization_name'],
      organisationId: json['organization_id'],
      subCategoryId: json['sub_category_id'],
      subCategoryName: json['sub_category_name'],
      variant: variant,
      productImage: json['product_image'],
      price: num.tryParse(json['price'] ?? "0") ?? 0,
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
  final String name;
  final int price;

  AdminVariantOption({required this.name, required this.price});
}
