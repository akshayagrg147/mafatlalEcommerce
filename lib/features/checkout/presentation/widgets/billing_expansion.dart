import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';

class BillingExpansion extends StatefulWidget {
  final Widget body;
  final num amount;
  const BillingExpansion({
    super.key,
    required this.body,
    required this.amount,
  });

  @override
  State<BillingExpansion> createState() => _BillingExpansionState();
}

class _BillingExpansionState extends State<BillingExpansion> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.kWhite,
          border: Border(bottom: BorderSide(color: AppColors.kGrey400))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 15),
                    child: Row(
                      children: [
                        Text(
                          "${isExpanded ? "Hide" : "Show"} Order Summary",
                          style: AppTextStyle.f18PoppinsDarkGreyw400,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: AppColors.kBlack),
                        const Spacer(),
                        Text(
                          "₹ ${widget.amount.toStringAsFixed(2)}",
                          style: AppTextStyle.f12OutfitBlackW500,
                        )
                      ],
                    ))),
          ),
          if (isExpanded) const Divider(),
          if (isExpanded) widget.body,
        ],
      ),
    );
  }
}
