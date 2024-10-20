import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';

class CustomRadioBtn extends StatelessWidget {
  const CustomRadioBtn(
      {required this.isSelected,
      this.onTap,
      this.selectedColor,
      this.radius = 12,
      super.key});

  final bool isSelected;
  final Color? selectedColor;
  final VoidCallback? onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final activeContainerColor = selectedColor ?? AppColors.kBlack;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (radius * 2),
        height: (radius * 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? activeContainerColor : AppColors.kWhite,
          border: Border.all(
            color: isSelected ? activeContainerColor : AppColors.kGrey400,
          ),
        ),
        alignment: Alignment.center,
        child: isSelected ? centerFilledContainer(context) : null,
      ),
    );
  }

  Widget centerFilledContainer(BuildContext context) {
    return Container(
      width: (radius * 0.75),
      height: (radius * 0.75),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.kWhite,
      ),
    );
  }
}
