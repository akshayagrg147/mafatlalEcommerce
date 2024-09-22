import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/model/order_detail.dart';

class OrderedProductTile extends StatelessWidget {
  final OrderedProduct product;
  const OrderedProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: AppColors.kWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.kGrey200),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      product.productImage,
                    ),
                    fit: BoxFit.contain)),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: AppTextStyle.f14OutfitBlackW500,
                  ),
                  if (product.size != null)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.kGrey200),
                      child: Text(
                        product.size!,
                        style: AppTextStyle.f14OutfitBlackW500,
                      ),
                    )
                ],
              )),
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "₹${product.price} x ${product.quantity}",
              style: AppTextStyle.f12OutfitBlackW500,
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "₹${product.price * product.quantity}",
              style: AppTextStyle.f12OutfitBlackW500,
            ),
          ),
        ],
      ),
    );
  }
}
