import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';

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
      this.borderRadius = 12,
      this.isDense = false,
      this.textStyle,
      this.height,
      this.contentPadding,
      this.onSaved,
      this.cursorHeight,
      Key? key,
      this.width})
      : super(key: key);
  final TextEditingController? textEditingController;
  final ValueChanged<String>? onChanged;
  final void Function(String?)? onSaved;
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
  final double? height;
  final double? cursorHeight;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width == null ? double.maxFinite : width!,
      height: height,
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
        onSaved: onSaved,
        onEditingComplete: () {},
        onFieldSubmitted: (va) {},
        keyboardType: textInputType,
        style: textStyle ?? AppTextStyle.f16BlackW400,
        textAlignVertical: TextAlignVertical.center,
        obscureText: isObscure,
        validator: validation,
        cursorHeight: cursorHeight,
        decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: AppColors.kWhite,
            errorText: errorText,
            prefixIcon: prefixWidget,
            counterText: "",
            counterStyle: const TextStyle(fontSize: 0),
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: AppColors.kGrey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: AppColors.kGrey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
            hintText: hint,
            errorStyle: AppTextStyle.f12RedAccentW500.copyWith(height: 0.8),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.0,
                color: AppColors.kRedAccent,
              ),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: AppColors.kRed),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 12),
              child: suffixWidget,
            ),
            hintStyle: AppTextStyle.f14OutfitGreyW500),
      ),
    );
  }
}
