import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/order_history.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/cart_btn.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/search_field.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final GlobalKey _menuKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.kBlack.withOpacity(0.1), // Minimal shadow color
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(1, 1), // Slight offset for a subtle effect
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 70),
              child: Image.asset(
                AssetPath.logo,
                fit: BoxFit.fitHeight,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: width * 0.3,
              child: SearchInput(
                  textController: CubitsInjector.homeCubit.searchController,
                  hintText: "Search here"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (CubitsInjector.authCubit.currentUser != null)
                    accountHeader()
                  else
                    CustomElevatedButton(
                        width: 150,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.route);
                        },
                        backgroundColor: AppColors.kBlack,
                        textColor: AppColors.kWhite,
                        label: "Login"),
                  Container(
                    width: 2,
                    height: 40,
                    color: AppColors.kGrey200,
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                  ),
                  const CartBtnRoundedrect()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget accountHeader() {
    return PopupMenuButton<int>(
        position: PopupMenuPosition.under,
        shadowColor: AppColors.kBlack.withOpacity(.3),
        surfaceTintColor: AppColors.kWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.kGrey200, width: 1),
        ),
        color: AppColors.kWhite,
        elevation: 3,
        offset: const Offset(25, 10),
        onSelected: (value) {
          if (value == 1) {
            Navigator.pushNamed(context, OrdersHistory.route);
          } else if (value == 2) {
            CubitsInjector.authCubit.logOut();
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.history, color: AppColors.kRed),
                    const SizedBox(width: 10),
                    Text(
                      'Your Orders',
                      style: AppTextStyle.f14BlackW500,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.kRed),
                    const SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: AppTextStyle.f14BlackW500,
                    ),
                  ],
                ),
              ),
            ],
        child: Text(
          'Hello, ${CubitsInjector.authCubit.currentUser?.fullName ?? ""}',
          style: AppTextStyle.f18OutfitBlackW500,
        ));
  }
}
