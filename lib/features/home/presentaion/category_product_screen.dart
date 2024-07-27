import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/components/vertical_tabbar.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/home/model/category_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/subcat_products_view.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/subcategory_grid_tile.dart';

class CategoryProductScreen extends StatelessWidget {
  static const String route = "/categoryProductScreen";
  final Category category;
  const CategoryProductScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${category.name}\t", style: AppTextStyle.f16BlackW400),
      ),
      body: VerticalTabs(
        backgroundColor: AppColors.kWhite,
        tabBackgroundColor: AppColors.kWhite,
        selectedTabTextStyle: AppTextStyle.f12OrangeW600,
        unSelectedTabTextStyle: AppTextStyle.f12GreyW400,
        indicatorColor: Colors.red,
        tabsWidth: 65 * SizeConfig.widthMultiplier,
        direction: TextDirection.ltr,
        indicatorSide: IndicatorSide.end,
        contentScrollAxis: Axis.vertical,
        changePageDuration: const Duration(milliseconds: 500),
        tabs: category.subCategories
            .map((e) => SubCategoryGridTile(subCategory: e))
            .toList(),
        contents: category.subCategories
            .map((e) => SubCategoryProductTab(subCategory: e))
            .toList(),
      ),
    );
  }
}
