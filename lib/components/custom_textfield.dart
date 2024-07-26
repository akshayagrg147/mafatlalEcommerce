import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {this.validation,
      this.textInputType,
      this.textEditingController,
      this.suffixWidget,
      this.prefixWidget,
      this.formatters,
      this.onChanged,
      this.isObscure = false,
      this.isDisabled = false,
      this.hint,
      this.label,
      this.errorText,
      this.action = TextInputAction.done,
      this.maxLength,
      this.maxLines,
      this.textCapitalization = TextCapitalization.words,
      this.enabled = true,
      this.isDense = false,
      Key? key,
      this.width})
      : super(key: key);
  final TextEditingController? textEditingController;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validation;
  final TextInputType? textInputType;
  final bool isObscure;
  final bool? isDisabled;
  final bool? enabled;
  final String? hint;
  final String? label;
  final bool? isDense;
  final String? errorText;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final int? maxLength;
  final int? maxLines;
  final TextInputAction action;
  final List<TextInputFormatter>? formatters;
  final TextCapitalization textCapitalization;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width == null
          ? SizeConfig.getMaxWidth()
          : width! * SizeConfig.widthMultiplier,
      child: TextFormField(
        textCapitalization: textCapitalization,
        inputFormatters: formatters,
        enabled: enabled,
        maxLength: maxLength,
        textInputAction: action,

        maxLines: maxLines,
        // cursorColor: grey80,
        controller: textEditingController,
        onChanged: onChanged,

        onEditingComplete: () {},
        onFieldSubmitted: (va) {},
        keyboardType: textInputType,
        style: AppTextStyle.f16BlackW400,
        textAlignVertical: TextAlignVertical.center,
        obscureText: isObscure,
        validator: validation,
        decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: AppColors.kWhite,
            errorText: errorText,
            prefixIcon: prefixWidget,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            counterText: "",
            counterStyle: const TextStyle(fontSize: 0),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 20 * SizeConfig.widthMultiplier,
                vertical: 12 * SizeConfig.heightMultiplier),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: AppColors.kGrey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: AppColors.kGrey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            hintText: hint,
            errorStyle: AppTextStyle.f12RedW500,
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.0,
                color: AppColors.kRed,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: AppColors.kOrange),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 12 * SizeConfig.widthMultiplier),
              child: suffixWidget,
            ),
            hintStyle: AppTextStyle.f14GreyW500),
      ),
    );
  }
}
