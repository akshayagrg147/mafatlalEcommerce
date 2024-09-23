import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';

class HomeBanner extends StatelessWidget {
  final String imagePath;

  const HomeBanner({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.kGrey200),
        image: DecorationImage(
          image: AssetImage(imagePath), // Use the passed image path
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
