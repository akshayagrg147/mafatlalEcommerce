import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/presentation/subcategory_detail.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:shimmer/shimmer.dart';

class SubCategoryList extends StatelessWidget {
  final List<SubCategory_new> subcategoriesss;

  const SubCategoryList({required this.subcategoriesss});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: subcategoriesss.length,
      separatorBuilder: (context, index) =>
          SizedBox(width: ResponsiveWidget.isSmallScreen(context) ? 20 : 60),
      itemBuilder: (context, index) {
        final subcategory = subcategoriesss[index];
        final widget = SubCategoryItem(
          imagePath: subcategory.img,
          name: subcategory.name,
          itemlength: subcategoriesss.length,
          subcategories: subcategoriesss,
        );
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.only(
                left: ResponsiveWidget.isSmallScreen(context) ? 20 : 60),
            child: widget,
          );
        }
        return widget;
      },
    );
  }
}

class SubCategoryItem extends StatefulWidget {
  final String name;
  final String imagePath;
  final int itemlength;
  final List<SubCategory_new> subcategories;

  const SubCategoryItem(
      {super.key,
      required this.name,
      required this.imagePath,
      required this.itemlength,
      required this.subcategories});

  @override
  _SubCategoryItemState createState() => _SubCategoryItemState();
}

class _SubCategoryItemState extends State<SubCategoryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, SubCategoryDetail.route, arguments: {
            "subcategories": widget.subcategories,
            "name": widget.name
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: widget.imagePath,
                height: 60,
                // width: MediaQuery.sizeOf(context).width / widget.itemlength,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 60,
                    // Same height as the image
                    // width: MediaQuery.sizeOf(context).width / widget.itemlength,
                    // Same width as the image
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(widget.name, style: AppTextStyle.f18PoppinsDarkGreyw600),
            ],
          ),
        ),
      ),
    );
  }
}
