import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/cart_btn.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onMenuTap;

  @override
  final Size preferredSize;

  HomeAppBar({Key? key, this.onMenuTap})
      : preferredSize = Size.fromHeight(65),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      toolbarHeight: 65,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
        onTap: onMenuTap,
        child: Icon(
          Icons.menu,
          color: AppColors.kGrey,
          size: 40,
        ),
      ),
      title: TextField(
        decoration: InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 8,
          ),
          fillColor: AppColors.kGrey200,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
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
        const CartBtn(),
        SizedBox(
          width: 15,
        )
      ],
    );
  }
}
