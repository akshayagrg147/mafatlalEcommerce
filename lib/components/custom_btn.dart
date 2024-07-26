import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String lable;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final double? width;
  const CustomElevatedButton({
    required this.onPressed,
    required this.lable,
    this.backgroundColor = AppColors.kOrange,
    this.textColor = AppColors.kWhite,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(12.0),
    this.textStyle = const TextStyle(),
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width == null
          ? SizeConfig.getMaxWidth()
          : width! * SizeConfig.widthMultiplier,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          onPrimary: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding,
          textStyle: textStyle,
        ),
        child: Text(
          lable,
          style: textStyle,
        ),
      ),
    );
  }
}
