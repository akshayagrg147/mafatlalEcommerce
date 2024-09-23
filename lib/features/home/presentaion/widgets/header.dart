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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.kBlack.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 70),
                  child: Image.asset(
                    AssetPath.logo1,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                if (constraints.maxWidth > 600)
                  SizedBox(
                    width: width * 0.3,
                    child: SearchInput(
                      textController: CubitsInjector.homeCubit.searchController,
                      hintText: "Search here",
                    ),
                  ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (CubitsInjector.authCubit.currentUser != null)
                        headerItems(constraints)
                      else
                        // headerItems(constraints)

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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget headerItems(BoxConstraints constraints) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4, // Horizontal space between items
      runSpacing: 10, // Vertical space between items when wrapping
      children: [
        if (constraints.maxWidth > 700) _textWithDownArrow('Home'),
        if (constraints.maxWidth > 750) _textWithDownArrow('Uniforms'),
        if (constraints.maxWidth > 800) _textWithDownArrow('General Items'),
        if (constraints.maxWidth > 850) _textWithDownArrow('Wish list'),
        if (constraints.maxWidth > 600) UserButton(context),
        if (constraints.maxWidth > 550) CartIcons(),
      ],
    );
  }

  Widget UserButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PopupMenuButton<String>(
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
          if (value == 'Your Orders') {
            Navigator.pushNamed(context, OrdersHistory.route);
          } else if (value == 'Logout') {
            CubitsInjector.authCubit.logOut();
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              value: 'Your Orders',
              child: Text('Your Orders'),
            ),
            PopupMenuItem(
              value: 'Logout',
              child: Text('Logout'),
            ),
          ];
        },
        child: Container(
          height: 30,
          width: 110,
          decoration: BoxDecoration(
            color: AppColors.kblue,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ankit',
                style: AppTextStyle.f12WhiteW500,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CartIcons() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: Icon(
          Icons.shopping_cart,
          size: 30,
          color: AppColors.kGrey,
        ),
      ),
    );
  }

  Widget _textWithDownArrow(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            print('Tapped $label');
          },
          child: Row(
            children: [
              Text(
                label,
                style: AppTextStyle.f12OutfitBlackW500,
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
