import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.kRed),
            color: AppColors.kRed.withOpacity(.05),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            'Add',
            style: AppTextStyle.f14KRedOutfitW500,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.kRed,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
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
            style: AppTextStyle.f12outfitWhiteW600,
          ),
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              child: Icon(
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
