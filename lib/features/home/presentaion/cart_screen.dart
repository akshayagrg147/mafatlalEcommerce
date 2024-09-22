import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/checkout_bottom_widget.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/product_list_tile.dart';

class CartScreen extends StatefulWidget {
  static const String route = "/cartScreen";

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    CubitsInjector.homeCubit.fetchCartProducts();
    super.initState();
  }

  @override
  void dispose() {
    CubitsInjector.homeCubit.resetCart();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: size.width > 800 ? 500 : double.maxFinite,
        child: Scaffold(
            appBar: AppBar(
              elevation: 5,
              backgroundColor: AppColors.kWhite,
              surfaceTintColor: AppColors.kWhite,
              title: Text("My Cart", style: AppTextStyle.f16BlackW400),
            ),
            bottomSheet: BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  current is UpdateCartBillingState,
              builder: (context, state) {
                if (state is UpdateCartBillingState &&
                    CubitsInjector.homeCubit.cartProducts.isNotEmpty) {
                  return CheckOutBottomWidget(
                    amount: state.amount,
                    itemCount: state.itemCount,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            body: BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  current is FetchCartLoadingState ||
                  current is FetchCartSuccessState ||
                  current is FetchCartFailedState,
              builder: (context, state) {
                if (state is FetchCartLoadingState) {
                  return const LoadingAnimation();
                }
                if (state is FetchCartFailedState) {
                  return Center(
                    child: Text(
                      state.message,
                      style: AppTextStyle.f16BlackW600,
                    ),
                  );
                }
                if (CubitsInjector.homeCubit.cartProducts.isEmpty) {
                  return Center(
                    child: Text(
                      "No Products added Yet",
                      style: AppTextStyle.f16BlackW600,
                    ),
                  );
                }
                return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    itemCount: CubitsInjector.homeCubit.cartProducts.length + 1,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 15,
                      );
                    },
                    itemBuilder: (context, index) {
                      if (index >=
                          CubitsInjector.homeCubit.cartProducts.length) {
                        return const SizedBox(
                          height: 200,
                        );
                      }
                      return ProductListTile(
                        product: CubitsInjector.homeCubit.cartProducts[index],
                      );
                    });
              },
            )),
      ),
    );
  }
}
