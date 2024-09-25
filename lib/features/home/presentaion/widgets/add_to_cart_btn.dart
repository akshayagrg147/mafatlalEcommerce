import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';

class AddToCartWidget extends StatelessWidget {
  final int quantity;
  final int productId;
  final Variant? variant;
  final bool isCart;

  const AddToCartWidget({
    super.key,
    required this.quantity,
    required this.productId,
    this.variant,
    this.isCart = false,
  });

  @override
  Widget build(BuildContext context) {
    if (quantity == 0) {
      return GestureDetector(
        onTap: () {
          CartHelper.addProduct(productId, 1, variant: variant);
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
                CartHelper.removeProduct(productId, variant: variant);
                if (isCart) {
                  CubitsInjector.homeCubit
                      .updateCartProductList(productId, variant: variant);
                }
              } else {
                CartHelper.updateProduct(productId, quantity - 1,
                    variant: variant);
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
              CartHelper.updateProduct(productId, quantity + 1,
                  variant: variant);
            },
          ),
        ],
      ),
    );
  }
}
