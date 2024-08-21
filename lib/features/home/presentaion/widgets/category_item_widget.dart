import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/model/category_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/category_product_screen.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;
  const CategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (MediaQuery.of(context).size.width > 800) {
          CubitsInjector.homeCubit.showCategoryWidget(category);
        } else {
          Navigator.pushNamed(context, CategoryProductScreen.route,
              arguments: category);
        }
      },
      child: SizedBox(
        height: 150,
        width: 100,
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              decoration: BoxDecoration(
                  color: AppColors.kRed.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: category.imgUrl,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              category.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: AppTextStyle.f14BlackW500,
            )
          ],
        ),
      ),
    );
  }
}
