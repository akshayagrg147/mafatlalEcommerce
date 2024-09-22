import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/model/order_detail.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/widgets/ordered_product_tile.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/delivery_status.dart';

class OrderedProductList extends StatelessWidget {
  final OrderDetailModel orderDetails;
  final bool showDispatchOrder;
  const OrderedProductList(
      {super.key, required this.orderDetails, this.showDispatchOrder = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
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
            offset: const Offset(
                0, 3), // Horizontal and Vertical displacement of the shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: DeliveryStatus(status: orderDetails.orderStatus)),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.kGrey200),
            ),
            child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return OrderedProductTile(
                      product: orderDetails.products[index]);
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 1,
                    height: 0,
                    color: AppColors.kGrey200,
                  );
                },
                itemCount: orderDetails.products.length),
          ),
          if (showDispatchOrder)
            const SizedBox(
              height: 22,
            ),
          if (showDispatchOrder)
            CustomElevatedButton(
                width: 160, onPressed: () {}, label: "Dispatch Order"),
        ],
      ),
    );
  }
}
