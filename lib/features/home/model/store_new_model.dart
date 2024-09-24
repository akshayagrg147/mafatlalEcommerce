// To parse this JSON data, do
//
//     final categoriesAndProducts = categoriesAndProductsFromJson(jsonString);

import 'dart:convert';

CategoriesAndProducts categoriesAndProductsFromJson(String str) =>
    CategoriesAndProducts.fromJson(json.decode(str));

String categoriesAndProductsToJson(CategoriesAndProducts data) =>
    json.encode(data.toJson());

class CategoriesAndProducts {
  String status;
  Data data;
  String message;

  CategoriesAndProducts({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CategoriesAndProducts.fromJson(Map<String, dynamic> json) =>
      CategoriesAndProducts(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  List<Category_new> categories;
  List<Product_new> products;

  Data({
    required this.categories,
    required this.products,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        categories: List<Category_new>.from(
            json["categories"].map((x) => Category_new.fromJson(x))),
        products: List<Product_new>.from(
            json["products"].map((x) => Product_new.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Category_new {
  int id;
  String name;
  String img;
  List<SubCategory_new> subCategories;

  Category_new({
    required this.id,
    required this.name,
    required this.img,
    required this.subCategories,
  });

  factory Category_new.fromJson(Map<String, dynamic> json) => Category_new(
        id: json["id"],
        name: json["name"],
        img: json["img"],
        subCategories: List<SubCategory_new>.from(
            json["sub_categories"].map((x) => SubCategory_new.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "img": img,
        "sub_categories":
            List<dynamic>.from(subCategories.map((x) => x.toJson())),
      };
}

class SubCategory_new {
  int id;
  String name;
  String img;
  bool isDistrict;
  bool isState;
  bool isOrganization;

  SubCategory_new({
    required this.id,
    required this.name,
    required this.img,
    required this.isDistrict,
    required this.isState,
    required this.isOrganization,
  });

  factory SubCategory_new.fromJson(Map<String, dynamic> json) =>
      SubCategory_new(
        id: json["id"],
        name: json["name"],
        img: json["img"],
        isDistrict: json["is_district"],
        isState: json["is_state"],
        isOrganization: json["is_organization"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "img": img,
        "is_district": isDistrict,
        "is_state": isState,
        "is_organization": isOrganization,
      };
}

class Product_new {
  int productId;
  int selectedCategoryId;
  String productName;
  String productCategory;
  SizeAvailable sizeAvailable;
  List<ProductImage> productImage;
  String price;

  Product_new({
    required this.productId,
    required this.selectedCategoryId,
    required this.productName,
    required this.productCategory,
    required this.sizeAvailable,
    required this.productImage,
    required this.price,
  });

  factory Product_new.fromJson(Map<String, dynamic> json) => Product_new(
        productId: json["product_id"],
        selectedCategoryId: json["Selected_category_id"],
        productName: json["product_name"],
        productCategory: json["product_category"],
        sizeAvailable: SizeAvailable.fromJson(json["size_available"]),
        productImage: List<ProductImage>.from(
            json["product_image"].map((x) => ProductImage.fromJson(x))),
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "Selected_category_id": selectedCategoryId,
        "product_name": productName,
        "product_category": productCategory,
        "size_available": sizeAvailable.toJson(),
        "product_image":
            List<dynamic>.from(productImage.map((x) => x.toJson())),
        "price": price,
      };
}

class ProductImage {
  String image1;
  String? image2;

  ProductImage({
    required this.image1,
    this.image2,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        image1: json["image_1"],
        image2: json["image_2"],
      );

  Map<String, dynamic> toJson() => {
        "image_1": image1,
        "image_2": image2,
      };
}

class SizeAvailable {
  Sizes size;

  SizeAvailable({
    required this.size,
  });

  factory SizeAvailable.fromJson(Map<String, dynamic> json) => SizeAvailable(
        size: Sizes.fromJson(json["size"]),
      );

  Map<String, dynamic> toJson() => {
        "size": size.toJson(),
      };
}

class Sizes {
  int l;
  int xl;
  int xxl;

  Sizes({
    required this.l,
    required this.xl,
    required this.xxl,
  });

  factory Sizes.fromJson(Map<String, dynamic> json) => Sizes(
        l: json["l"],
        xl: json["xl"],
        xxl: json["xxl"],
      );

  Map<String, dynamic> toJson() => {
        "l": l,
        "xl": xl,
        "xxl": xxl,
      };
}
