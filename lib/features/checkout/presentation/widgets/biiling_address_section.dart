import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/components/custom_radio_btn.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';

enum BillingEnum {
  sameAsShipping("Same as shipping address"),
  billing("Use a different billing address");

  final String label;
  const BillingEnum(this.label);
}

class BillingAddressSection extends StatefulWidget {
  final Widget billingAddressForm;
  final Function(BillingEnum) onChanged;
  final BillingEnum selectedBillingEnum;
  const BillingAddressSection(
      {super.key,
      required this.billingAddressForm,
      required this.onChanged,
      required this.selectedBillingEnum});

  @override
  State<BillingAddressSection> createState() => _BillingAddressSectionState();
}

class _BillingAddressSectionState extends State<BillingAddressSection> {
  BillingEnum selectedBillingEnum = BillingEnum.sameAsShipping;

  @override
  void initState() {
    selectedBillingEnum = widget.selectedBillingEnum;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Billing Address",
          style: AppTextStyle.f24PoppinsBlackw600,
        ),
        const SizedBox(
          height: 20,
        ),
        billingRadioTile(BillingEnum.sameAsShipping),
        const SizedBox(
          height: 10,
        ),
        billingRadioTile(BillingEnum.billing),
        const SizedBox(
          height: 10,
        ),
        if (selectedBillingEnum == BillingEnum.billing)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.kGrey200,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.kGrey400),
            ),
            child: widget.billingAddressForm,
          )
      ],
    );
  }

  Widget billingRadioTile(BillingEnum billingEnum) {
    final isSelected = selectedBillingEnum == billingEnum;
    return GestureDetector(
      onTap: () {
        widget.onChanged.call(billingEnum);
        setState(() {
          selectedBillingEnum = billingEnum;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.kGrey200 : AppColors.kWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isSelected ? AppColors.kBlack : AppColors.kGrey400)),
        child: Row(
          children: [
            CustomRadioBtn(isSelected: isSelected),
            const SizedBox(
              width: 20,
            ),
            Text(
              billingEnum.label,
              style: AppTextStyle.f18OutfitBlackW500,
            )
          ],
        ),
      ),
    );
  }
}
