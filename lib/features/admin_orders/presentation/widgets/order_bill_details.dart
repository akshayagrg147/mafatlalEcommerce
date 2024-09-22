import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/model/order_detail.dart';

class OrderBillDetails extends StatelessWidget {
  final OrderDetailModel orderDetails;
  const OrderBillDetails({super.key, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.kGrey200),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              rowTile(
                  title: "Subtotal",
                  value: "₹${orderDetails.price}",
                  substring: "${orderDetails.quantity} Items"),
              const SizedBox(
                height: 16,
              ),
              rowTile(
                title: "Shipping",
                value: "₹0.00",
              ),
              Divider(
                height: 32,
                color: AppColors.kGrey200,
              ),
              rowTile(
                  title: "Total",
                  value: "₹${orderDetails.price}",
                  isBold: true),
            ],
          ),
        ));
  }

  Widget rowTile(
      {required String title,
      required String value,
      String? substring,
      bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyle.f14OutfitBlackW500.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w400),
          ),
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
              flex: 3,
              child: substring != null
                  ? Text(
                      substring,
                      style: AppTextStyle.f14OutfitBlackW500
                          .copyWith(fontWeight: FontWeight.w400),
                    )
                  : const SizedBox()),
          const Expanded(flex: 1, child: SizedBox()),
          Text(
            value,
            style: AppTextStyle.f14OutfitBlackW500.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
