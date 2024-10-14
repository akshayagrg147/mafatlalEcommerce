import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/home/model/address.dart';

class CustomerDetailis extends StatelessWidget {
  final Address? shippingAddress;
  final Address? billingAddress;
  final String customerName;
  final String customerEmail;

  const CustomerDetailis(
      {super.key,
      this.shippingAddress,
      this.billingAddress,
      required this.customerName,
      required this.customerEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kGrey200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey
                .withOpacity(0.2), // Light grey shadow with 20% opacity
            spreadRadius: 2, // Extent of the shadow
            blurRadius: 7, // Blurring effect
            offset: Offset(
                0, 3), // Horizontal and Vertical displacement of the shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Customer",
            style: AppTextStyle.f16OutfitBlackW500,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            customerName,
            style: AppTextStyle.f14OutfitBlackW500.copyWith(color: Colors.blue),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Contact Information",
            style: AppTextStyle.f16OutfitBlackW500,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            customerEmail,
            style: AppTextStyle.f14OutfitBlackW500.copyWith(color: Colors.blue),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Shipping Address",
            style: AppTextStyle.f16OutfitBlackW500,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            shippingAddress?.addressString ?? "",
            style: AppTextStyle.f14OutfitBlackW500,
          ),
          if (shippingAddress?.mobile.isNotEmpty == true)
            Text(
              shippingAddress?.mobile ?? '',
              style:
                  AppTextStyle.f14OutfitBlackW500.copyWith(color: Colors.blue),
            ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Billing Address",
            style: AppTextStyle.f16OutfitBlackW500,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            billingAddress?.addressString ?? "",
            style: AppTextStyle.f14OutfitBlackW500,
          ),
          if (billingAddress?.mobile.isNotEmpty == true)
            Text(
              billingAddress?.mobile ?? '',
              style:
                  AppTextStyle.f14OutfitBlackW500.copyWith(color: Colors.blue),
            ),
        ],
      ),
    );
  }
}
