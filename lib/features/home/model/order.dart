import 'package:mafatlal_ecommerce/features/home/model/address.dart';

class Order {
  final int orderId;
  final int productQuantity;
  final int userId;
  final String price;
  final String? productImage;
  final String? description;
  final String orderStatus;
  final Address deliveryAddress;
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
    required this.deliveryAddress,
    required this.createdOn,
    this.createdBy,
    this.updatedOn,
    this.updatedBy,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final state = json['delievery_state'];
    final address = json['delievery_address'];
    final district = json['delievery_district'];
    final city = json['delievery_city'];
    final pincode = json['delievery_pincode'].toString();
    return Order(
      orderId: json['order_id'],
      productQuantity: json['product_quantity'],
      userId: json['user_id'],
      price: json['price'],
      orderStatus: json['order_status'],
      deliveryAddress: Address(
          address: address ?? "",
          state: state ?? "",
          pincode: pincode ?? "",
          district: district ?? "",
          city: city ?? ""),
      createdOn: DateTime.parse(json['created_on']),
      createdBy: json['created_by']?.toString(),
      updatedOn: json['updated_on'] != null
          ? DateTime.parse(json['updated_on'])
          : null,
      updatedBy: json['updated_by']?.toString(),
    );
  }
}
