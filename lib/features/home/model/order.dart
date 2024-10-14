import 'package:mafatlal_ecommerce/features/home/model/address.dart';

class Order {
  final int orderId;
  final int productQuantity;
  final int userId;
  final String price;
  final String? productImage;
  final String? description;
  final String orderStatus;
  final Address? shipping;
  final Address? billing;
  final DateTime createdOn;
  final String? createdBy;
  final DateTime? updatedOn;
  final String? updatedBy;

  Order({
    required this.orderId,
    required this.productQuantity,
    required this.userId,
    required this.price,
    this.productImage,
    this.description,
    required this.orderStatus,
    this.shipping,
    required this.createdOn,
    this.billing,
    this.createdBy,
    this.updatedOn,
    this.updatedBy,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final shippingAddress =
        json['shipping'] != null ? Address.fromJson(json['shipping']) : null;
    final billingAdress = json['billing'] != null
        ? Address.fromJson(json['billing'])
        : shippingAddress;
    return Order(
      orderId: json['order_id'],
      productQuantity: json['product_quantity'],
      userId: json['user_id'],
      price: json['price'],
      orderStatus: json['order_status'],
      shipping: shippingAddress,
      billing: billingAdress,
      createdOn: DateTime.parse(json['created_on']).toLocal(),
      createdBy: json['created_by']?.toString(),
      updatedOn: json['updated_on'] != null
          ? DateTime.parse(json['updated_on'])
          : null,
      updatedBy: json['updated_by']?.toString(),
    );
  }
}
