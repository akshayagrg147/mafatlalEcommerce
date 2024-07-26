import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/cart_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onMenuTap;

  @override
  final Size preferredSize;

  HomeAppBar({Key? key, this.onMenuTap})
      : preferredSize = Size.fromHeight(65 * SizeConfig.heightMultiplier),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 65 * SizeConfig.heightMultiplier,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
        onTap: onMenuTap,
        child: Icon(
          Icons.menu,
          color: AppColors.kGrey,
          size: 40 * SizeConfig.imageSizeMultiplier,
        ),
      ),
      title: TextField(
        decoration: InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 5 * SizeConfig.widthMultiplier,
            vertical: 8 * SizeConfig.heightMultiplier,
          ),
          fillColor: AppColors.kGrey200,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12 * SizeConfig.widthMultiplier,
            ),
            child: Icon(
              Icons.search_sharp,
              color: AppColors.kGrey,
              size: 30 * SizeConfig.imageSizeMultiplier,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: AppTextStyle.f16GreyW500,
          hintText: AppStrings.searchHint,
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CartScreen.route);
            },
            icon: Icon(
              Icons.shopping_cart,
              color: AppColors.kOrange,
              size: 35 * SizeConfig.imageSizeMultiplier,
            ))
      ],
    );
  }
}
