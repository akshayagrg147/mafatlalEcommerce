import 'package:mafatlal_ecommerce/features/home/model/address.dart';

class OrderDetailModel {
  final Address? shipping;
  final Address? billing;
  final int orderId;
  final int userId;
  final String price;
  final String customerName;
  final String customerEmail;
  final List<OrderedProduct> products;
  final int quantity;
  final String orderStatus;
  final String paymentStatus;
  final String razorpayPaymentId;
  final num taxedPrice;
  final String gstNumber;
  final DateTime orderPlaced;
  final String? trackingUrl;

  OrderDetailModel({
    this.shipping,
    this.billing,
    required this.orderId,
    required this.userId,
    required this.price,
    required this.products,
    required this.quantity,
    required this.orderStatus,
    required this.orderPlaced,
    required this.customerName,
    required this.customerEmail,
    required this.paymentStatus,
    required this.razorpayPaymentId,
    required this.taxedPrice,
    required this.gstNumber,
    this.trackingUrl,
  });

  factory OrderDetailModel.fromMap(Map<String, dynamic> json) {
    String gstNumber = json["gst_number"] ?? '';
    if (gstNumber.isEmpty) {
      gstNumber = "Unregistered Party";
    }
    return OrderDetailModel(
        shipping: json["shipping"] != null
            ? Address.fromJson(json["shipping"])
            : null,
        billing:
            json["billing"] != null ? Address.fromJson(json["billing"]) : null,
        orderId: json["order_id"],
        userId: json["user_id"],
        price: json["price"],
        products: json["products"] == null
            ? []
            : List<OrderedProduct>.from(
                json["products"]!.map((x) => OrderedProduct.fromMap(x))),
        quantity: json["quantity"],
        orderStatus: json["order_status"],
        orderPlaced: DateTime.parse(json["order_placed"]).toLocal(),
        trackingUrl: json["tracking_url"],
        customerName: json['customer_name'] ?? "",
        customerEmail: json['customer_email'] ?? "",
        paymentStatus: json["payment_status"],
        razorpayPaymentId: json["razorpay_payment_id"],
        taxedPrice: json["taxed_price"],
        gstNumber: gstNumber);
  }
}

class OrderedProduct {
  final int productId;
  final int quantity;
  final num price;
  final List<String>? productImage;
  final String productName;
  final String productCategory;
  final String? size;
  final num gstPercentage;

  OrderedProduct({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.productImage,
    required this.productName,
    required this.productCategory,
    required this.gstPercentage,
    this.size,
  });

  num getGstAmount() {
    return (price * (gstPercentage / 100)) * quantity;
  }

  factory OrderedProduct.fromMap(Map<String, dynamic> json) => OrderedProduct(
        productId: json["product_id"],
        quantity: json["quantity"],
        price: json["price"],
        productImage: json["product_image"] is Map
            ? List<String>.from(
                json["product_image"].values.map((e) => e.toString()))
            : null,
        productName: json["product_name"],
        productCategory: json["product_category"],
        size: json["size"],
        gstPercentage: num.tryParse(json["gst_percentage"] ?? '') ?? 0.0,
      );

  Map<String, dynamic> toMap() => {
        "product_id": productId,
        "quantity": quantity,
        "price": price,
        "product_image": productImage,
        "product_name": productName,
        "product_category": productCategory,
        "size": size,
      };
}
