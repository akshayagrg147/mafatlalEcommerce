import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/cart_screen.dart';

class CartBtn extends StatelessWidget {
  const CartBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Stack(
        children: [
          Center(
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.route);
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: AppColors.kRed,
                  size: 35,
                )),
          ),
          Positioned(
            right: 3,
            top: 5,
            child: StreamBuilder<BoxEvent>(
                stream: CartHelper.watchCart(),
                builder: (context, eventSnapshot) {
                  final quantity = CartHelper.getAllProductQuantity();
                  if (quantity == 0) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: AppColors.kRed, shape: BoxShape.circle),
                    child: Text(
                      quantity.toString(),
                      style: AppTextStyle.f8WhiteW600,
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

class CartBtnRoundedrect extends StatelessWidget {
  const CartBtnRoundedrect({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CartScreen.route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kRed,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            SvgPicture.string(
              AssetPath.icCartSvg,
              color: AppColors.kWhite,
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 8,
            ),
            StreamBuilder<BoxEvent>(
                stream: CartHelper.watchCart(),
                builder: (context, eventSnapshot) {
                  final quantity = CartHelper.getAllProductQuantity();
                  if (quantity == 0) {
                    return const Text(
                      "My Cart",
                      style: AppTextStyle.f14WhiteW500,
                    );
                  }
                  return Text(
                    "$quantity Items",
                    style: AppTextStyle.f14WhiteW500,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
