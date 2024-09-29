import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/home/model/category_model.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/category_product_screen.dart';

class CategoryWidget extends StatelessWidget {
  final Category_new category;
  const CategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (MediaQuery.of(context).size.width > 800) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CategoryProductScreen(category: category)));
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
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.kGrey.withOpacity(.1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(1, 1))
                  ],
                  color: AppColors.kRed.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: category.img,
                errorWidget: (context, url, error) => CachedNetworkImage(
                  imageUrl:
                      "https://w7.pngwing.com/pngs/505/284/png-transparent-india-hindustan-petroleum-bharat-petroleum-logo-india-text-trademark-logo-thumbnail.png",
                  fit: BoxFit.fill,
                ),
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
