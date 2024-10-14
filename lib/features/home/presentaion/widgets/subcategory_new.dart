import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/presentation/subcategory_detail.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';

class SubCategoryList extends StatelessWidget {
  final List<SubCategory_new> subcategoriesss;

  const SubCategoryList({required this.subcategoriesss});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: subcategoriesss.length,
      separatorBuilder: (context, index) => const SizedBox(width: 25),
      itemBuilder: (context, index) {
        final subcategory = subcategoriesss[index];
        return SubCategoryItem(
          imagePath: subcategory.img,
          name: subcategory.name,
          itemlength: subcategoriesss.length,
          subcategories: subcategoriesss,
        );
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
        child: Container(
          padding: EdgeInsets.all(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.imagePath,
                  height: 60,
                  width: MediaQuery.sizeOf(context).width / widget.itemlength,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _isHovered ? Colors.blue : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
