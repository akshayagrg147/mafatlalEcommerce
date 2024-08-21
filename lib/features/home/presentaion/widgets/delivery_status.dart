import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';

class DeliveryStatus extends StatelessWidget {
  final String status;
  const DeliveryStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case "Pending":
        return roundedCapsule(
          bgColor: Colors.orangeAccent,
          status: status,
        );
      case "Delivered":
        return roundedCapsule(
          bgColor: Colors.greenAccent,
          status: status,
        );

      case "Cancelled":
        return roundedCapsule(
          bgColor: Colors.redAccent,
          status: status,
        );
      default:
        return roundedCapsule(
          bgColor: Colors.grey,
          status: status,
        );
    }
  }

  Widget roundedCapsule({
    required Color bgColor,
    required String status,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        status,
        style: AppTextStyle.f10outfitWhiteW600,
      ),
    );
  }
}
