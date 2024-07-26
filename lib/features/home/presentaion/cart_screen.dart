import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
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
    CubitsInjector.homeCubit.initializeCartStream();
    super.initState();
  }

  @override
  void dispose() {
    CubitsInjector.homeCubit.resetCart();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: SizeConfig.screenWidth > 1000
            ? 1000 * SizeConfig.widthMultiplier
            : double.maxFinite,
        child: Scaffold(
            appBar: AppBar(
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
                    padding: EdgeInsets.symmetric(
                        horizontal: 16 * SizeConfig.widthMultiplier,
                        vertical: 20 * SizeConfig.heightMultiplier),
                    itemCount: CubitsInjector.homeCubit.cartProducts.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 15 * SizeConfig.heightMultiplier,
                      );
                    },
                    itemBuilder: (context, index) {
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
