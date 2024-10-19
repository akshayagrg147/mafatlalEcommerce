import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/components/input_quantity.dart';
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
  final bool isIntrisicWidth;
  final bool isGridTile;
  final Function()? onAdded;

  const AddToCartWidget(
      {super.key,
      required this.quantity,
      required this.productId,
      this.variant,
      this.isCart = false,
      this.isGridTile = false,
      this.isIntrisicWidth = true,
      this.onAdded});

  @override
  Widget build(BuildContext context) {
    int quant = quantity == 0 ? 1 : quantity;
    if (isGridTile) {
      return quantity > 0
          ? Text(
              "Added",
              style: AppTextStyle.f14BlackW500,
            )
          : GestureDetector(
              onTap: () {
                CartHelper.addProduct(productId, 1, variant: variant);
              },
              child: Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
    if (isCart == false) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputQty(
            minVal: 0,
            initVal: quant,
            isIntrinsicWidth: isIntrisicWidth,
            maxVal: 100000,
            decoration: QtyDecorationProps(
              contentPadding: const EdgeInsets.symmetric(horizontal: 2),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              plusBtn: quantityBtn(Icons.add),
              minusBtn: quantityBtn(Icons.remove),
            ),
            onQtyChanged: (val) {
              quant = val;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              CartHelper.addProduct(productId, quant, variant: variant);
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
          )
        ],
      );
    }

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

    return InputQty(
      minVal: 0,
      initVal: quantity,
      maxVal: 100000,
      decoration: QtyDecorationProps(
        contentPadding: const EdgeInsets.symmetric(horizontal: 2),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        plusBtn: quantityBtn(Icons.add),
        minusBtn: quantityBtn(Icons.remove),
      ),
      onQtyChanged: (val) {
        if (val < 1) {
          CartHelper.removeProduct(productId, variant: variant);
          if (isCart) {
            CubitsInjector.homeCubit
                .updateCartProductList(productId, variant: variant);
          }
        } else {
          CartHelper.updateProduct(productId, val, variant: variant);
        } // num
      },
    );

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

Widget quantityBtn(IconData icon) {
  return Container(
      decoration: BoxDecoration(
        color: AppColors.kRed,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.kWhite,
        ),
      ));
}
