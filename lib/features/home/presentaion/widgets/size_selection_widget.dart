import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';

class SizeSelection extends StatefulWidget {
  final Map<String, Map<String, int>> sizeAvailable; // Update to use sizeAvailable
  final Function(String size) onSizeSelected; // Updated callback to accept a size
  const SizeSelection({
    super.key,
    required this.sizeAvailable,
    required this.onSizeSelected,
  });

  @override
  State<SizeSelection> createState() => _SizeSelectionState();
}

class _SizeSelectionState extends State<SizeSelection> {
  String? selectedSize; // Track selected size

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // Extract size options from sizeAvailable map
          final sizeKey = widget.sizeAvailable.keys.elementAt(index);
          return size(sizeKey, isSelected: selectedSize == sizeKey);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 7,
          );
        },
        itemCount: widget.sizeAvailable.length,
      ),
    );
  }

  Widget size(String option, {bool isSelected = false}) {
    return InkWell(
      onTap: () {
        if (!isSelected) {
          widget.onSizeSelected(option); // Update to call new callback
          selectedSize = option; // Update selected size
          setState(() {});
        }
      },
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isSelected ? AppColors.kRed : null,
          border: Border.all(
            color: !isSelected ? AppColors.kGrey : AppColors.kRed,
          ),
        ),
        child: Center(
          child: Text(
            option,
            style: !isSelected
                ? AppTextStyle.f12OutfitBlackW500
                : AppTextStyle.f12outfitWhiteW600,
          ),
        ),
      ),
    );
  }
}
