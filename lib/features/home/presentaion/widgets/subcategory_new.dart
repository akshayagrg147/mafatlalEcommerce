import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SubCategoryItem extends StatefulWidget {
  final String name;
  final String imagePath;
  final int itemlength;

  const SubCategoryItem(
      {super.key,
      required this.name,
      required this.imagePath,
      required this.itemlength});

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.blue.shade100 : Colors.white,
          boxShadow: _isHovered
              ? [BoxShadow(color: Colors.blue.shade300, blurRadius: 10)]
              : [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
        ),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.imagePath,
              height: 60,
              width: MediaQuery.sizeOf(context).width / widget.itemlength,
              placeholder: (context, url) => const CircularProgressIndicator(),
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
    );
  }
}
