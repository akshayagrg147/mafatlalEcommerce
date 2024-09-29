import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';

class DateFilterButton extends StatelessWidget {
  final DateTime? selectedDate;
  final String label;
  final TextStyle? labelTextStyle;
  final Function(DateTime selectedDate) onDateSelected;
  final bool Function(DateTime selectedDate)? dateValidator;

  const DateFilterButton(
      {super.key,
      required this.selectedDate,
      required this.onDateSelected,
      required this.label,
      this.labelTextStyle,
      this.dateValidator});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final dt = DateTime.now();
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? dt,
          firstDate: DateTime(2024),
          lastDate: dt,
        );

        if (pickedDate != null &&
            pickedDate != selectedDate &&
            (dateValidator?.call(pickedDate) ?? true)) {
          onDateSelected(pickedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyle.f14OutfitGreyW500,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, color: Colors.grey.shade600),
                const SizedBox(width: 10),
                Text(
                  selectedDate != null
                      ? DateFormat('MMM dd, yyyy').format(selectedDate!)
                      : "Select Date",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
