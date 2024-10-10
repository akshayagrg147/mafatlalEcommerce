import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/admin_product.dart';

class ProductTableTile extends StatelessWidget {
  final AdminProduct product;
  const ProductTableTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.kGrey400)),
          child: CachedNetworkImage(
            imageUrl: product.productImage?.isNotEmpty == true
                ? product.productImage!.first
                : "",
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: AppColors.kBlack),
          ),
        ),
        SizedBox(
          width: 14,
        ),
        Expanded(
          child: Text(
            product.productName,
            style: AppTextStyle.f14OutfitBlackW500,
          ),
        ),
      ],
    );
  }
}
