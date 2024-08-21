import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/add_address.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/order_success_widget.dart';
import 'package:mafatlal_ecommerce/helper/toast_utils.dart';

class CheckOutBottomWidget extends StatelessWidget {
  final num amount;
  final int itemCount;
  const CheckOutBottomWidget(
      {super.key, required this.amount, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
                color: AppColors.kGrey.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 1)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Bill Details",
            style: AppTextStyle.f16BlackW600,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.shopping_bag_rounded,
                color: AppColors.kBlack,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Items Total",
                style: AppTextStyle.f14BlackW500,
              ),
              const Spacer(),
              Text(
                "₹ $amount",
                style: AppTextStyle.f14BlackW500,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(
                Icons.category_outlined,
                color: AppColors.kBlack,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "No. of Items",
                style: AppTextStyle.f14BlackW500,
              ),
              const Spacer(),
              Text(
                itemCount.toString(),
                style: AppTextStyle.f14BlackW500,
              ),
            ],
          ),
          Divider(
            height: 30,
          ),
          BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) => current is UpdateAddressState,
              builder: (context, state) {
                if (CubitsInjector.homeCubit.deliveryAddress != null) {
                  return addressWidget(context);
                }
                return CustomElevatedButton(
                  lable: 'Add Address',
                  backgroundColor: AppColors.kRed,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  onPressed: () {
                    AddEditAddress.show(context);
                  },
                );
              }),
          SizedBox(
            height: 10,
          ),
          BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is PlaceOrderFailedState) {
                  ToastUtils.showErrorToast(state.message);
                }
                if (state is PlaceOrderSuccessState) {
                  Navigator.pushReplacementNamed(context, OrderSuccess.route);
                }
                if (state is PlaceOrderLoadingState) {
                  LoadingAnimation.show(context);
                }
              },
              buildWhen: (previous, current) => current is UpdateAddressState,
              builder: (context, state) {
                if (CubitsInjector.homeCubit.deliveryAddress != null) {
                  return CustomElevatedButton(
                    lable: 'Place Order',
                    backgroundColor: AppColors.kRed,
                    textStyle: AppTextStyle.f16WhiteW600,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    onPressed: () {
                      CubitsInjector.homeCubit.placeOrder();
                    },
                  );
                }
                return const SizedBox.shrink();
              }),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget addressWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Deliver To",
          style: AppTextStyle.f16BlackW600,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.delivery_dining_sharp,
              color: AppColors.kBlack,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                CubitsInjector.homeCubit.deliveryAddress?.addressString ?? "",
                textAlign: TextAlign.left,
                style: AppTextStyle.f14BlackW500,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            TextButton(
              child: Text(
                "Change",
                style: AppTextStyle.f14BlackW500
                    .copyWith(decoration: TextDecoration.underline),
              ),
              onPressed: () {
                AddEditAddress.show(context,
                    address: CubitsInjector.homeCubit.deliveryAddress);
              },
            ),
          ],
        ),
      ],
    );
  }
}
