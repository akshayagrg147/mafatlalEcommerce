import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/subcategory_detail.dart';

class SubCategoryList extends StatelessWidget {
  final List<SubCategory_new> subcategories;

  const SubCategoryList({required this.subcategories});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: subcategories.length,
      separatorBuilder: (context, index) => const SizedBox(width: 25),
      itemBuilder: (context, index) {
        final subcategory = subcategories[index];
        return SubCategoryItem(
          imagePath: subcategory.img,
          name: subcategory.name,
          itemlength: subcategories.length,
          subid: subcategory.id,
        );
      },
    );
  }
}

class SubCategoryItem extends StatefulWidget {
  final String name;
  final String imagePath;
  final int itemlength;
  final subid;

  const SubCategoryItem(
      {super.key,
      required this.name,
      required this.imagePath,
      required this.itemlength,
      required this.subid});

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
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return SubCategoryDetail(
              subid: widget.subid,
            );
          }));
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
