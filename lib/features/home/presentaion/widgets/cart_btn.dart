import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/cart_screen.dart';

class CartBtn extends StatelessWidget {
  const CartBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40 * SizeConfig.widthMultiplier,
      child: Stack(
        children: [
          Center(
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.route);
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: AppColors.kOrange,
                  size: 35 * SizeConfig.imageSizeMultiplier,
                )),
          ),
          Positioned(
            right: 3,
            top: 5 * SizeConfig.heightMultiplier,
            child: StreamBuilder<BoxEvent>(
                stream: CartHelper.watchCart(),
                builder: (context, eventSnapshot) {
                  final quantity = CartHelper.getAllProductQuantity();
                  if (quantity == 0) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    padding: EdgeInsets.all(4 * SizeConfig.heightMultiplier),
                    decoration: const BoxDecoration(
                        color: AppColors.kOrange, shape: BoxShape.circle),
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
