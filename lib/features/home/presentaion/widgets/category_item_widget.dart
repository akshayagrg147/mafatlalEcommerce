import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/home/model/category_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/category_product_screen.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;
  const CategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CategoryProductScreen.route,
            arguments: category);
      },
      child: SizedBox(
        height: 90 * SizeConfig.widthMultiplier,
        width: 60 * SizeConfig.widthMultiplier,
        child: Column(
          children: [
            Container(
              height: 60 * SizeConfig.widthMultiplier,
              width: 60 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                  color: AppColors.kOrange.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12)),
            ),
            SizedBox(
              height: 6 * SizeConfig.heightMultiplier,
            ),
            Text(category.category)
          ],
        ),
      ),
    );
  }
}
