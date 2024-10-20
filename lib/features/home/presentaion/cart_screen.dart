import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
import 'package:mafatlal_ecommerce/features/checkout/presentation/checkout_screen.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/footer_widget.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/header.dart';
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
    return ResponsiveWidget(
      largeScreen: largeScreen(),
      smallScreen: smallScreen(),
    );
  }

  Widget largeScreen() {
    final List<String> bannerImages = [
      AssetPath.banner1,
      AssetPath.banner2,
      AssetPath.banner3,
    ];
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Header(),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) =>
            current is FetchCartLoadingState ||
            current is FetchCartSuccessState ||
            current is FetchCartFailedState,
        builder: (context, state) {
          return ListView(
            children: [
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Text(
                  "Cart",
                  style: AppTextStyle.f24PoppinsBluew400,
                ),
              ),
              if (state is FetchCartFailedState)
                SizedBox(
                  height: 500,
                  child: Center(
                    child: Text(
                      state.message,
                      style: AppTextStyle.f16BlackW600,
                    ),
                  ),
                ),
              if (CubitsInjector.homeCubit.cartProducts.isEmpty)
                const SizedBox(
                  height: 500,
                  child: Center(
                    child: Text(
                      "No Products added Yet",
                      style: AppTextStyle.f16BlackW600,
                    ),
                  ),
                ),
              if (state is FetchCartLoadingState)
                const SizedBox(height: 500, child: LoadingAnimation()),
              ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ProductListTile(
                      product: CubitsInjector.homeCubit.cartProducts[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 75,
                      color: AppColors.paleGray,
                    );
                  },
                  itemCount: CubitsInjector.homeCubit.cartProducts.length),
              if (CubitsInjector.homeCubit.cartProducts.isNotEmpty)
                buildTotal(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                child: buildCheckout(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Footer()
            ],
          );
        },
      ),
    );
  }

  Widget buildCheckout() {
    if (CubitsInjector.homeCubit.cartProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerRight,
      child: CubitsInjector.authCubit.currentUser != null
          ? CustomElevatedButton(
              width: 200,
              label: 'Check Out',
              backgroundColor: AppColors.kblue,
              textStyle: AppTextStyle.f16WhiteW600,
              borderRadius: 24,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              onPressed: () {
                Navigator.pushNamed(context, CheckoutScreen.route);
              },
            )
          : CustomElevatedButton(
              width: 250,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.route);
              },
              backgroundColor: AppColors.kBlack,
              textColor: AppColors.kWhite,
              textStyle: AppTextStyle.f18PoppinsWhitew600,
              label: "Login To Proceed",
            ),
    );
  }

  Widget buildTotal(
      {double horizontalPadding = 48, bool isSmallScreen = false}) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => current is UpdateCartBillingState,
      builder: (context, state) {
        final quantity = state is UpdateCartBillingState ? state.itemCount : 0;
        final amount = state is UpdateCartBillingState ? state.amount : 0;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  height: 2,
                  color: AppColors.paleGray,
                ),
                const SizedBox(
                  height: 20,
                ),
                if (isSmallScreen)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Grand Total :",
                          style: AppTextStyle.f28PoppinsDarkGreyw600
                              .copyWith(fontSize: 20)),
                      Text(
                        "Total Items ($quantity)",
                        style: AppTextStyle.f18PoppinsBlackw400
                            .copyWith(fontSize: 14),
                      ),
                      Text(
                        "₹ ${amount.toStringAsFixed(2)}",
                        style: AppTextStyle.f28PoppinsBlackw600
                            .copyWith(fontSize: 20),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Grand Total :",
                          style: AppTextStyle.f28PoppinsDarkGreyw600),
                      Text(
                        "Total Items ($quantity)",
                        style: AppTextStyle.f18PoppinsBlackw400,
                      ),
                      Text(
                        "₹ ${amount.toStringAsFixed(2)}",
                        style: AppTextStyle.f28PoppinsBlackw600,
                      ),
                    ],
                  )
              ]),
        );
      },
    );
  }

  Widget smallScreen() {
    return Scaffold(
        appBar: AppBar(
          elevation: 5,
          backgroundColor: AppColors.kWhite,
          surfaceTintColor: AppColors.kWhite,
          title: Text(
            "Cart / Checkout",
            style: AppTextStyle.f24PoppinsBluew400.copyWith(fontSize: 18),
          ),
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
              current is FetchCartLoadingState ||
              current is FetchCartSuccessState ||
              current is FetchCartFailedState,
          builder: (context, state) {
            if (state is FetchCartFailedState) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTextStyle.f16BlackW600,
                ),
              );
            }
            if (state is FetchCartLoadingState) {
              return const LoadingAnimation();
            }
            if (CubitsInjector.homeCubit.cartProducts.isEmpty) {
              return const Center(
                child: Text(
                  "No Products added Yet",
                  style: AppTextStyle.f16BlackW600,
                ),
              );
            }

            return ListView(
              children: [
                const SizedBox(height: 15),
                ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ProductListTile(
                        isSmallScreen: true,
                        product: CubitsInjector.homeCubit.cartProducts[index],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 40,
                        color: AppColors.paleGray,
                      );
                    },
                    itemCount: CubitsInjector.homeCubit.cartProducts.length),
                if (CubitsInjector.homeCubit.cartProducts.isNotEmpty)
                  buildTotal(
                    horizontalPadding: 18,
                    isSmallScreen: true,
                  ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: buildCheckout(),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Footer()
              ],
            );
          },
        ));
  }
}
