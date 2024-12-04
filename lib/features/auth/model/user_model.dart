import 'dart:convert';

import 'package:mafatlal_ecommerce/features/home/model/address.dart';
import 'package:mafatlal_ecommerce/helper/enums.dart';

class User {
  final int id;
  final UserType userType;
  final String email;
  final String fullName;
  final String state;
  final String district;
  final String gstNumber;
  final Address? billingAddress;
  final Address? shippingAddress;

  User(
      {required this.id,
      required this.userType,
      required this.email,
      required this.fullName,
      required this.state,
      required this.district,
      this.billingAddress,
      this.shippingAddress,
      required this.gstNumber});

  factory User.fromJsonString(String data) {
    return User.fromJson(jsonDecode(data));
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        userType: UserType.fromCode(json['user_type']),
        email: json['email'],
        fullName: json['full_name'],
        state: json['state'],
        district: json['district'],
        gstNumber: json['gst_number'] ?? '',
        billingAddress:
            json['billing'] != null ? Address.fromJson(json['billing']) : null,
        shippingAddress: json['shipping'] != null
            ? Address.fromJson(json['shipping'])
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'user_type': userType.code,
      'state': state,
      'district': district,
      'billing': billingAddress?.toJson(),
      'shipping': shippingAddress?.toJson(),
      'gst_number': gstNumber
    };
  }

  String get getUserDataString => jsonEncode(toJson());
}
