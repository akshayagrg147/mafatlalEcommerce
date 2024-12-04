import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';

class TextBtn extends StatelessWidget {
  final void Function()? onTap;
  final String label;
  final TextStyle? labelStyle;
  const TextBtn({super.key, this.onTap, required this.label, this.labelStyle});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: labelStyle ??
            AppTextStyle.f14RobotoDarkgrayW500.copyWith(
                decoration: TextDecoration.underline,
                decorationColor: AppColors.darkGray),
      ),
    );
  }
}
