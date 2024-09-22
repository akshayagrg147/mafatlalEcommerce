import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class CustomSearchableDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final String Function(T) label;
  final Function(T?)? onChanged;
  final String searchHintText;
  final String hintText;
  const CustomSearchableDropdown(
      {super.key,
      required this.items,
      this.selectedItem,
      required this.label,
      this.onChanged,
      required this.searchHintText,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kGrey200),
      ),
      child: SearchableDropdown<T>(
        hintText: Text(hintText),
        margin: const EdgeInsets.all(15),
        searchHintText: searchHintText,
        items: List.generate(
            items.length,
            (i) => SearchableDropdownMenuItem<T>(
                value: items[i],
                label: label(items[i]),
                child: Text(label(items[i])))),
        onChanged: onChanged,
      ),
    );
  }
}
