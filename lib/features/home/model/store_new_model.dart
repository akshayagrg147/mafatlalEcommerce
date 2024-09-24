class CategoriesAndProducts {
  final String status;
  final Data data;
  final String message;

  CategoriesAndProducts({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CategoriesAndProducts.fromJson(Map<String, dynamic> json) {
    return CategoriesAndProducts(
      status: json['status']?.toString() ?? '',
      data: Data.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
      message: json['message']?.toString() ?? '',
    );
  }
}

class Data {
  final List<Category_new> categories;
  final List<Product_new> products;

  Data({
    required this.categories,
    required this.products,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map((x) => Category_new.fromJson(x as Map<String, dynamic>? ?? {}))
          .toList(),
      products: (json['products'] as List<dynamic>? ?? [])
          .map((x) => Product_new.fromJson(x as Map<String, dynamic>? ?? {}))
          .toList(),
    );
  }
}

class Category_new {
  final int id;
  final String name;
  final String img;
  final List<SubCategory_new> subCategories;

  Category_new({
    required this.id,
    required this.name,
    required this.img,
    required this.subCategories,
  });

  factory Category_new.fromJson(Map<String, dynamic> json) {
    return Category_new(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
      subCategories: (json['sub_categories'] as List<dynamic>? ?? [])
          .map(
              (x) => SubCategory_new.fromJson(x as Map<String, dynamic>? ?? {}))
          .toList(),
    );
  }
}

class SubCategory_new {
  final int id;
  final String name;
  final String img;
  final bool isDistrict;
  final bool isState;
  final bool isOrganization;

  SubCategory_new({
    required this.id,
    required this.name,
    required this.img,
    required this.isDistrict,
    required this.isState,
    required this.isOrganization,
  });

  factory SubCategory_new.fromJson(Map<String, dynamic> json) {
    return SubCategory_new(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
      isDistrict: json['is_district'] as bool? ?? false,
      isState: json['is_state'] as bool? ?? false,
      isOrganization: json['is_organization'] as bool? ?? false,
    );
  }
}

class Product_new {
  final int productId;
  final int selectedCategoryId;
  final String productName;
  final String productCategory;
  final Map<String, Map<String, int>> sizeAvailable;
  final List<Map<String, String>> productImage;
  final String price;

  Product_new({
    required this.productId,
    required this.selectedCategoryId,
    required this.productName,
    required this.productCategory,
    required this.sizeAvailable,
    required this.productImage,
    required this.price,
  });

  factory Product_new.fromJson(Map<String, dynamic> json) {
    return Product_new(
      productId: json['product_id'] as int? ?? 0,
      selectedCategoryId: json['Selected_category_id'] as int? ?? 0,
      productName: json['product_name']?.toString() ?? '',
      productCategory: json['product_category']?.toString() ?? '',
      sizeAvailable: _parseSizeAvailable(json['size_available']),
      productImage: _parseProductImage(json['product_image']),
      price: json['price']?.toString() ?? '',
    );
  }

  static Map<String, Map<String, int>> _parseSizeAvailable(
      dynamic sizeAvailable) {
    if (sizeAvailable is Map) {
      return sizeAvailable.map((key, value) {
        if (value is Map) {
          return MapEntry(
              key,
              Map<String, int>.from(
                  value.map((k, v) => MapEntry(k, v as int? ?? 0))));
        }
        return MapEntry(key, <String, int>{});
      });
    }
    return {};
  }

  static List<Map<String, String>> _parseProductImage(dynamic productImage) {
    if (productImage is List) {
      return productImage.map((item) {
        if (item is Map) {
          return Map<String, String>.from(
              item.map((k, v) => MapEntry(k, v?.toString() ?? '')));
        }
        return <String, String>{};
      }).toList();
    }
    return [];
  }
}
