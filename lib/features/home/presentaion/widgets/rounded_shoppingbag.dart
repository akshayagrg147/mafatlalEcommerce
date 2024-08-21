import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';

class RoundedShoppingBag extends StatelessWidget {
  const RoundedShoppingBag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle, border: Border.all(color: AppColors.kGrey)),
      child: Image.asset(
        AssetPath.shoppingBag,
        fit: BoxFit.contain,
      ),
    );
  }
}
