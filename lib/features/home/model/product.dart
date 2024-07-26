import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';

class Product {
  final int productId;
  final String productName;
  final String productCategory;
  final SizeAvailable sizeAvailable;
  final String? productImage;
  final num price;
  int quantity;
  String? selectedSize;

  Product({
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.sizeAvailable,
    this.productImage,
    required this.quantity,
    this.selectedSize,
    required this.price,
  });

  factory Product.fromJson(
    Map<String, dynamic> json,
  ) {
    final id = json['product_id'] ?? json['id'];
    final sizesAvailable = SizeAvailable.fromJson(json['size_available']);
    final cartQuantity = CartHelper.getProductQuantity(id);
    String? selectedSize = CartHelper.getProductSize(id);
    if ((sizesAvailable.sizes ?? []).isNotEmpty && selectedSize == null) {
      selectedSize = sizesAvailable.sizes!.first;
    }

    return Product(
        productId: id,
        productName: json['product_name'] ?? json['name'],
        productCategory: json['product_category'],
        sizeAvailable: sizesAvailable,
        productImage: json['product_image'],
        price: num.tryParse(json['price'] ?? "0") ?? 0,
        quantity: cartQuantity,
        selectedSize: selectedSize);
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_category': productCategory,
      'size_available': sizeAvailable.toJson(),
      'product_image': productImage,
      'price': price,
    };
  }
}

class SizeAvailable {
  List<String>? sizes;

  SizeAvailable({this.sizes});

  factory SizeAvailable.fromJson(Map<String, dynamic> json) {
    return SizeAvailable(
      sizes: List<String>.from(json['size'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'size': sizes,
    };
  }
}
