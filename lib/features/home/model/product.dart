import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';

class Product {
  final int productId;
  final String productName;
  final String productCategory;
  final Variant? variant;
  final String? productImage;
  final num price;
  late int quantity;

  Product(
      {required this.productId,
      required this.productName,
      required this.productCategory,
      this.variant,
      this.productImage,
      required this.price,
      this.quantity = 0});

  num getPrice() {
    if (variant != null) {
      return variant!.selectedVariant.price;
    }
    return price;
  }

  factory Product.nullProduct() =>
      Product(productId: -1, productName: "", productCategory: "", price: 0);

  factory Product.fromJson(
    Map<String, dynamic> json,
  ) {
    final id = json['product_id'] ?? json['id'];
    final variants = (json['size_available'] as Map);
    Variant? variant;
    if (variants.isNotEmpty) {
      variant = Variant.fromJson(variants.entries.first);
    }

    final quantity = CartHelper.getProductQuantity(id, variant: variant);

    return Product(
      productId: id,
      productName: json['product_name'] ?? json['name'],
      productCategory: json['product_category'],
      variant: variant,
      productImage: json['product_image'],
      quantity: quantity,
      price: num.tryParse(json['price'] ?? "0") ?? 0,
    );
  }

  Map<String, dynamic> toCartProductJson() {
    final Map<String, dynamic> map = {
      'product_id': productId,
      'quantity': quantity,
      'price': price
    };
    if (variant != null) {
      map[variant!.variantTitle] = variant!.selectedVariant.name;
      map['price'] = variant!.selectedVariant.price;
    }
    return map;
  }
}

class Variant {
  final String variantTitle;
  final List<VariantOption> variantOptions;
  late VariantOption selectedVariant;

  Variant({
    required this.variantTitle,
    required this.variantOptions,
    required this.selectedVariant,
  });

  factory Variant.fromJson(MapEntry json) {
    final options = List<VariantOption>.from((json.value as Map).entries.map(
        (e) => VariantOption(name: e.key.toString(), price: e.value as int)));
    return Variant(
        variantTitle: json.key,
        variantOptions: options,
        selectedVariant: options.first);
  }

  copyWith(VariantOption selectedVariant) {
    return Variant(
        variantTitle: variantTitle,
        variantOptions: variantOptions,
        selectedVariant: selectedVariant);
  }
}

class VariantOption {
  final String name;
  final int price;

  VariantOption({required this.name, required this.price});
}
