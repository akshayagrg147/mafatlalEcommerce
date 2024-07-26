import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';

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
      height: 20 * SizeConfig.heightMultiplier,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return size(widget.sizesAvailable[index],
                isSelected: selectedSize == widget.sizesAvailable[index]);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 5 * SizeConfig.widthMultiplier,
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
        height: 20 * SizeConfig.heightMultiplier,
        width: 18 * SizeConfig.heightMultiplier,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isSelected ? AppColors.kOrange : null,
            border: Border.all(
                color: !isSelected ? AppColors.kBlack : AppColors.kOrange)),
        child: Center(
          child: Text(
            size,
            style: !isSelected
                ? AppTextStyle.f10BlackW500
                : AppTextStyle.f10WhiteW600,
          ),
        ),
      ),
    );
  }
}
