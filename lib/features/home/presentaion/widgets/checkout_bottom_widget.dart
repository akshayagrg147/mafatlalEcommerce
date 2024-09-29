import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_cubit.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_state.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
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
          if (CubitsInjector.authCubit.currentUser != null)
            BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (previous, current) =>
                    current is FetchCurrentUserSuccessState,
                builder: (context, state) {
                  if (CubitsInjector.authCubit.currentUser?.shippingAddress !=
                      null) {
                    return addressWidget(context);
                  }
                  return CustomElevatedButton(
                    label: 'Add Shipping Address',
                    backgroundColor: AppColors.kRed,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    onPressed: () {
                      AddEditAddress.show(context, isShipping: true);
                    },
                  );
                })
          else
            CustomElevatedButton(
              label: 'Login To Proceed',
              backgroundColor: AppColors.kRed,
              padding: const EdgeInsets.symmetric(vertical: 20),
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.route);
              },
            ),
          SizedBox(
            height: 10,
          ),
          BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (previous, current) =>
                  current is FetchCurrentUserSuccessState,
              builder: (context, state) {
                if (CubitsInjector.authCubit.currentUser?.shippingAddress ==
                    null) {
                  return const SizedBox.shrink();
                }
                if (CubitsInjector.authCubit.currentUser?.billingAddress !=
                    null) {
                  return addressWidget(context, isShipping: false);
                }
                return CustomElevatedButton(
                  label: 'Add Billing Address',
                  backgroundColor: AppColors.kRed,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  onPressed: () {
                    AddEditAddress.show(context, isShipping: false);
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
              buildWhen: (previous, current) =>
                  current is FetchCurrentUserSuccessState,
              builder: (context, state) {
                if (CubitsInjector.authCubit.currentUser?.shippingAddress !=
                        null &&
                    CubitsInjector.authCubit.currentUser?.billingAddress !=
                        null) {
                  return CustomElevatedButton(
                    label: 'Place Order',
                    backgroundColor: AppColors.kRed,
                    textStyle: AppTextStyle.f16WhiteW600,
                    padding: EdgeInsets.symmetric(vertical: 20),
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
}

Widget addressWidget(BuildContext context, {bool isShipping = true}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        isShipping ? "Deliver To" : "Billing Address",
        style: AppTextStyle.f16BlackW600,
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
              (isShipping
                          ? CubitsInjector
                              .authCubit.currentUser?.shippingAddress
                          : CubitsInjector
                              .authCubit.currentUser?.billingAddress)
                      ?.addressString ??
                  "",
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
                  address:
                      CubitsInjector.authCubit.currentUser?.shippingAddress,
                  isShipping: isShipping);
            },
          ),
        ],
      ),
    ],
  );
}
