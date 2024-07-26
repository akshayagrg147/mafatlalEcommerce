import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/add_to_cart_btn.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/size_selection_widget.dart';

class ProductGridTile extends StatelessWidget {
  final Product product;
  final Color bgColor;
  final double shadowOpacity;
  ProductGridTile({super.key, required this.product})
      : bgColor = AppColors.kGrey200,
        shadowOpacity = 0.5;
  const ProductGridTile.subList({super.key, required this.product})
      : bgColor = AppColors.kWhite,
        shadowOpacity = 0.2;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240 * SizeConfig.heightMultiplier,
      width: 135 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.kBlack.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                color: AppColors.kGrey.withOpacity(shadowOpacity),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(2, 2))
          ]),
      padding: EdgeInsets.symmetric(
          horizontal: 6 * SizeConfig.widthMultiplier,
          vertical: 5 * SizeConfig.heightMultiplier),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 140 * SizeConfig.heightMultiplier,
            width: double.maxFinite,
            child: CachedNetworkImage(
              imageUrl: product.productImage ?? "",
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: 8 * SizeConfig.heightMultiplier,
          ),
          Text(
            product.productName,
            maxLines: 2,
            style: AppTextStyle.f14BlackW500,
          ),
          SizeSelection(
              sizesAvailable: product.sizeAvailable.sizes ?? [],
              selectedSize: product.selectedSize,
              onSizeSelected: (size) {
                product.selectedSize = size;
                if (product.quantity > 0) {
                  CartHelper.updateProduct(
                      product.productId, size, product.quantity);
                }
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₹${product.price}",
                style: AppTextStyle.f12BlackW500,
              ),
              StreamBuilder<BoxEvent>(
                  stream: CartHelper.watchCart(product.productId),
                  builder: (context, eventSnapshot) {
                    if (eventSnapshot.hasData) {
                      final data = eventSnapshot.data?.value ?? {};
                      product.quantity = data['quantity'] ?? 0;
                      product.selectedSize = data['size'];
                    }
                    return AddToCartWidget(
                        quantity: product.quantity,
                        productId: product.productId,
                        productSize: product.selectedSize);
                  })
            ],
          )
        ],
      ),
    );
  }
}
