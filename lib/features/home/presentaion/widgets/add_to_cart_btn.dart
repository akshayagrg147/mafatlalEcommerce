import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';

class AddToCartWidget extends StatelessWidget {
  final int quantity;
  final int productId;
  final String? productSize;
  const AddToCartWidget({
    super.key,
    required this.quantity,
    required this.productId,
    required this.productSize,
  });

  @override
  Widget build(BuildContext context) {
    if (quantity == 0) {
      return GestureDetector(
        onTap: () {
          CartHelper.addProduct(productId, productSize, 1);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 8 * SizeConfig.widthMultiplier,
              vertical: 3 * SizeConfig.heightMultiplier),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.kBlack),
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            'Add',
            style: AppTextStyle.f14BlackW500,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.kOrange,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 5 * SizeConfig.widthMultiplier,
                  vertical: 4 * SizeConfig.heightMultiplier),
              child: const Icon(
                Icons.remove,
                color: AppColors.kWhite,
              ),
            ),
            onTap: () {
              if (quantity <= 1) {
                CartHelper.removeProduct(productId);
              } else {
                CartHelper.updateProduct(productId, productSize, quantity - 1);
              }
            },
          ),
          Text(
            '$quantity',
            style: AppTextStyle.f12WhiteW500,
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 5 * SizeConfig.widthMultiplier,
                  vertical: 4 * SizeConfig.heightMultiplier),
              child: const Icon(
                Icons.add,
                color: AppColors.kWhite,
              ),
            ),
            onTap: () {
              CartHelper.updateProduct(productId, productSize, quantity + 1);
            },
          ),
        ],
      ),
    );
  }
}
