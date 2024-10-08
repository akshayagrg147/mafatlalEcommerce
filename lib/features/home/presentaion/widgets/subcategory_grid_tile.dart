import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/features/home/model/subcategory_model.dart';

class SubCategoryGridTile extends StatelessWidget {
  final SubCategory_new subCategory;

  const SubCategoryGridTile({super.key, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CachedNetworkImage(
          imageUrl: subCategory.img,
          height: 40,
        ),
        SizedBox(
          height: 6,
        ),
        Text(subCategory.name)
      ],
    );
  }
}
