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

class ProductListTile extends StatelessWidget {
  final Product product;

  const ProductListTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100 * SizeConfig.heightMultiplier,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.kBlack.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                color: AppColors.kGrey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(2, 2))
          ]),
      padding: EdgeInsets.symmetric(
          horizontal: 6 * SizeConfig.widthMultiplier,
          vertical: 5 * SizeConfig.heightMultiplier),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 80 * SizeConfig.widthMultiplier,
            height: double.maxFinite,
            child: CachedNetworkImage(
              imageUrl: product.productImage ?? "",
            ),
          ),
          SizedBox(
            width: 10 * SizeConfig.widthMultiplier,
          ),
          SizedBox(
            width: 150 * SizeConfig.widthMultiplier,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  maxLines: 2,
                  style: AppTextStyle.f14BlackW500,
                ),
                SizedBox(
                  height: 8 * SizeConfig.heightMultiplier,
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
                SizedBox(
                  height: 8 * SizeConfig.heightMultiplier,
                ),
                Text(
                  "₹${product.price}",
                  style: AppTextStyle.f12BlackW500,
                ),
              ],
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: StreamBuilder<BoxEvent>(
                stream: CartHelper.watchCart(product.productId),
                builder: (context, eventSnapshot) {
                  if (eventSnapshot.hasData) {
                    final data = eventSnapshot.data?.value ?? {};
                    if (product.productId == eventSnapshot.data?.key) {
                      product.quantity = data['quantity'] ?? 0;
                      product.selectedSize = data['size'];
                    }
                  }
                  return AddToCartWidget(
                    quantity: product.quantity,
                    productId: product.productId,
                    productSize: product.selectedSize,
                  );
                }),
          )
        ],
      ),
    );
  }
}
