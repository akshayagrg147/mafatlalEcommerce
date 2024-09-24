import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/components/vertical_tabbar.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/subcat_products_view.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/subcategory_grid_tile.dart';

class CategoryProductScreen extends StatelessWidget {
  static const String route = "/categoryProductScreen";
  final Category_new category;

  const CategoryProductScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: largeScreen(context),
      smallScreen: smallScreen(context),
    );
  }

  Widget largeScreen(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            SizedBox(
              width: 50,
            ),
            Text(
              category.name,
              style: AppTextStyle.f16OutfitBlackW500,
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(child: verticalTabs(context)),
      ],
    );
  }

  Widget smallScreen(context) {
    return Scaffold(
        appBar: MediaQuery.of(context).size.width > 800
            ? null
            : AppBar(
                title: Text("${category.name}\t",
                    style: AppTextStyle.f16BlackW400),
              ),
        body: verticalTabs(context));
  }

  Widget verticalTabs(context) {
    return VerticalTabs(
      backgroundColor: AppColors.kWhite,
      tabBackgroundColor: AppColors.kWhite,
      selectedTabTextStyle: AppTextStyle.f12OrangeW600,
      unSelectedTabTextStyle: AppTextStyle.f12GreyW400,
      indicatorColor: Colors.red,
      tabsWidth: MediaQuery.of(context).size.width > 800 ? 100 : 65,
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
    );
  }
}
