import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';

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
      width: width == null
          ? SizeConfig.getMaxWidth()
          : width! * SizeConfig.widthMultiplier,
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
            errorStyle: AppTextStyle.f12RedW500,
            fillColor: AppColors.kWhite,
            filled: true,
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
          ),
          hint: Text(label, style: AppTextStyle.f14GreyW500),
          iconEnabledColor: AppColors.kBlack,
          icon: const Icon(Icons.keyboard_arrow_down),
          menuMaxHeight: 400 * SizeConfig.heightMultiplier,
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12 * SizeConfig.widthMultiplier,
                          vertical: 8 * SizeConfig.heightMultiplier),
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

      // DropdownButtonFormField<T>(
      //   decoration: InputDecoration(
      //     enabled: true,
      //     labelText: label,
      //     labelStyle: AppTextStyle.f14GreyW500,
      //     border: const OutlineInputBorder(
      //         borderSide: BorderSide(
      //           width: 1.0,
      //           color: AppColors.kGrey,
      //         ),
      //         borderRadius: BorderRadius.all(Radius.circular(20))),
      //     enabledBorder: const OutlineInputBorder(
      //         borderSide: BorderSide(
      //           width: 1.0,
      //           color: AppColors.kGrey,
      //         ),
      //         borderRadius: BorderRadius.all(Radius.circular(20))),
      //     disabledBorder: const OutlineInputBorder(
      //         borderSide: BorderSide(width: 1.0),
      //         borderRadius: BorderRadius.all(Radius.circular(20))),
      //     errorStyle: AppTextStyle.f16RedW500,
      //     errorBorder: const OutlineInputBorder(
      //       borderSide: BorderSide(
      //         width: 1.0,
      //         color: AppColors.kRed,
      //       ),
      //       borderRadius: BorderRadius.all(Radius.circular(20)),
      //     ),
      //     focusedBorder: const OutlineInputBorder(
      //       borderSide: BorderSide(width: 1.0, color: AppColors.kOrange),
      //       borderRadius: BorderRadius.all(Radius.circular(20)),
      //     ),
      //     focusedErrorBorder: const OutlineInputBorder(
      //       borderSide: BorderSide(width: 1.0),
      //       borderRadius: BorderRadius.all(Radius.circular(20)),
      //     ),
      //   ),
      //   value: selectedValue,
      //   onChanged: onChanged,
      //   validator: validator,
      //   isDense: true,
      //   hint: Text(
      //     label,
      //     style: AppTextStyle.f16GreyW500,
      //   ),
      //   items: List<DropdownMenuItem<T>>.from(items.map((T value) {
      //     return DropdownMenuItem<T>(
      //       value: value,
      //       child: Text(
      //         labelFormat(value),
      //         style: AppTextStyle.f16BlackW400,
      //       ),
      //     );
      //   })),
      // ),
    );
  }
}
