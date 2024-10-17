import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/components/searchable_dropdown.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';

class CustomSearchableDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final String Function(T) label;
  final Function(T?)? onChanged;
  final String searchHintText;
  final String hintText;
  final double width;
  const CustomSearchableDropdown(
      {super.key,
      required this.items,
      this.selectedItem,
      required this.label,
      this.onChanged,
      this.width = 300,
      required this.searchHintText,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kGrey200),
      ),
      child: SearchableDropdown<T>(
        items: items,
        displayItem: label,
        hintText: hintText,
        onChanged: onChanged,
        selectedItem: selectedItem,
        filterFunction: (query, item) {
          return label(item).toLowerCase().startsWith(query.toLowerCase());
        },
      ),

      // SearchableDropdown<T>(
      //   hintText: Text(hintText),
      //   margin: const EdgeInsets.all(15),
      //   searchHintText: searchHintText,
      //   isDialogExpanded: false,
      //   width: 300,
      //   items: List.generate(
      //       items.length,
      //       (i) => SearchableDropdownMenuItem<T>(
      //           value: items[i],
      //           label: label(items[i]),
      //           child: Text(label(items[i])))),
      //   onChanged: onChanged,
      // ),
    );
  }
}
