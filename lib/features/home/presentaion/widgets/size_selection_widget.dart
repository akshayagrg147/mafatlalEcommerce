import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';

class SizeSelection extends StatefulWidget {
  final Variant variant;
  final Function(VariantOption option) onVariantSelected;
  const SizeSelection(
      {super.key, required this.variant, required this.onVariantSelected});

  @override
  State<SizeSelection> createState() => _SizeSelectionState();
}

class _SizeSelectionState extends State<SizeSelection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return size(widget.variant.variantOptions[index],
                isSelected: widget.variant.selectedVariant ==
                    widget.variant.variantOptions[index]);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 7,
            );
          },
          itemCount: widget.variant.variantOptions.length),
    );
  }

  Widget size(VariantOption option, {bool isSelected = false}) {
    return InkWell(
      onTap: () {
        if (!isSelected) {
          widget.onVariantSelected(option);
          widget.variant.selectedVariant = option;
          setState(() {});
        }
      },
      child: Container(
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isSelected ? AppColors.kRed : null,
            border: Border.all(
                color: !isSelected ? AppColors.kGrey : AppColors.kRed)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          option.name,
          style: !isSelected
              ? AppTextStyle.f12OutfitBlackW500
              : AppTextStyle.f12outfitWhiteW600,
        ),
      ),
    );
  }
}
