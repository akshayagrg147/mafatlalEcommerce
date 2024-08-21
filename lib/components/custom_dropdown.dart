import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';

class CustomDropDown<T> extends StatelessWidget {
  final String label;
  final T? selectedValue;
  final void Function(T?)? onChanged;
  final String Function(T) labelFormat;
  final List<T> items;
  final String? Function(T?)? validator;
  final double? width;
  const CustomDropDown(
      {super.key,
      required this.label,
      required this.selectedValue,
      this.onChanged,
      required this.items,
      required this.labelFormat,
      this.validator,
      this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width == null ? double.maxFinite : width!,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<T>(
          focusColor: AppColors.kWhite,
          isExpanded: true,
          validator: validator,
          isDense: true,
          style: AppTextStyle.f16BlackW600,
          decoration: InputDecoration(
            focusColor: AppColors.kWhite,
            hoverColor: AppColors.kGrey,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            border: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: AppColors.kGrey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: AppColors.kGrey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            errorStyle: AppTextStyle.f12RedAccentW500,
            fillColor: AppColors.kWhite,
            filled: true,
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.0,
                color: AppColors.kRedAccent,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: AppColors.kRed),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          hint: Text(label, style: AppTextStyle.f14OutfitGreyW500),
          iconEnabledColor: AppColors.kBlack,
          icon: const Icon(Icons.keyboard_arrow_down),
          menuMaxHeight: 400,
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Text(labelFormat(item),
                          style: AppTextStyle.f16BlackW600),
                    ),
                  ))
              .toList(),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((T value) {
              return Text(
                labelFormat(value),
                style: AppTextStyle.f16BlackW400,
              );
            }).toList();
          },
          value: selectedValue,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
