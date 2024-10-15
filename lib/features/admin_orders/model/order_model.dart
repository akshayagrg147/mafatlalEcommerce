import 'package:mafatlal_ecommerce/features/home/model/address.dart';

class OrderModel {
  final int orderId;
  final DateTime createdOn;
  final String customerName;
  final int productQuantity;
  final int userId;
  final String channel;
  final String price;
  final String? delieveryMethod;
  final String orderStatus;
  final Address? shipping;
  final Address? billing;
  final String? trackingUrl;
  final String paymentStatus;

  OrderModel({
    required this.orderId,
    required this.paymentStatus,
    required this.createdOn,
    required this.customerName,
    required this.productQuantity,
    required this.userId,
    required this.channel,
    required this.price,
    this.delieveryMethod,
    required this.orderStatus,
    this.shipping,
    this.billing,
    this.trackingUrl,
  });

  factory OrderModel.fromMap(Map<String, dynamic> json) => OrderModel(
        orderId: json["order_id"],
        createdOn: DateTime.parse(json["created_on"]).toLocal(),
        customerName: json["customer_name"],
        productQuantity: json["product_quantity"],
        userId: json["user_id"],
        channel: json["channel"],
        price: json["price"],
        delieveryMethod: json["delievery_method"],
        orderStatus: json["order_status"],
        paymentStatus: json['payment_status'] ?? '',
        shipping: json["shipping"] == null
            ? null
            : Address.fromJson(json["shipping"]),
        billing:
            json["billing"] == null ? null : Address.fromJson(json["billing"]),
        trackingUrl: json["tracking_url"],
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId,
        "created_on": createdOn?.toIso8601String(),
        "customer_name": customerName,
        "product_quantity": productQuantity,
        "user_id": userId,
        "channel": channel,
        "price": price,
        "delievery_method": delieveryMethod,
        "order_status": orderStatus,
        "shipping": shipping?.toJson(),
        "billing": billing?.toJson(),
        "tracking_url": trackingUrl,
        "payment_status": paymentStatus
      };
}
