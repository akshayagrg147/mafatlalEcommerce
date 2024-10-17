import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';

class SameAsShippingAddressWidget extends StatefulWidget {
  const SameAsShippingAddressWidget({super.key});

  @override
  State<SameAsShippingAddressWidget> createState() =>
      _SameAsShippingAddressWidgetState();
}

class _SameAsShippingAddressWidgetState
    extends State<SameAsShippingAddressWidget> {
  bool isSameAsShippingAddress = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
            value: isSameAsShippingAddress,
            onChanged: (val) {
              setState(() {
                isSameAsShippingAddress = val!;
              });
              CubitsInjector.homeCubit.saveAddress(
                  CubitsInjector.authCubit.currentUser!.shippingAddress!,
                  isUpdate: false,
                  isShipping: false);
            }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Same as Shipping Address",
            style: AppTextStyle.f18PoppinsBlackw400,
          ),
        )
      ],
    );
  }
}
