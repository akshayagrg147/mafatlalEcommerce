import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';

class SizeSelection extends StatefulWidget {
  final List<String> sizesAvailable;
  final String? selectedSize;
  final Function(String size) onSizeSelected;
  const SizeSelection(
      {super.key,
      required this.sizesAvailable,
      this.selectedSize,
      required this.onSizeSelected});

  @override
  State<SizeSelection> createState() => _SizeSelectionState();
}

class _SizeSelectionState extends State<SizeSelection> {
  String? selectedSize;
  @override
  void initState() {
    selectedSize = widget.selectedSize;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return size(widget.sizesAvailable[index],
                isSelected: selectedSize == widget.sizesAvailable[index]);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 7,
            );
          },
          itemCount: widget.sizesAvailable.length),
    );
  }

  Widget size(String size, {bool isSelected = false}) {
    return InkWell(
      onTap: () {
        selectedSize = size;
        widget.onSizeSelected(size);
        setState(() {});
      },
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isSelected ? AppColors.kRed : null,
            border: Border.all(
                color: !isSelected ? AppColors.kGrey : AppColors.kRed)),
        child: Center(
          child: Text(
            size,
            style: !isSelected
                ? AppTextStyle.f12OutfitBlackW500
                : AppTextStyle.f12outfitWhiteW600,
          ),
        ),
      ),
    );
  }
}
