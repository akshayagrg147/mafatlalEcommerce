import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/search_field.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20,
              runSpacing: 16,
              children: [
                // Logo
                Image.asset(
                  AssetPath.logo1,
                  fit: BoxFit.fitHeight,
                  height: 40,
                ),
                // Search field
                if (constraints.maxWidth > 600)
                  SizedBox(
                    width: constraints.maxWidth > 800 ? 600 : 350,
                    child: SearchInput(
                      textController: CubitsInjector.homeCubit.searchController,
                      hintText: "Search here",
                    ),
                  ),
                // Right-side items
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    // if (CubitsInjector.authCubit.currentUser != null)
                      ...headerItems(constraints),
                    // else
                    //   CustomElevatedButton(
                    //     width: 150,
                    //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    //     onPressed: () {
                    //       Navigator.pushNamed(context, LoginScreen.route);
                    //     },
                    //     backgroundColor: AppColors.kBlack,
                    //     textColor: AppColors.kWhite,
                    //     label: "Login",
                    //   ),
                    CartIcons(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> headerItems(BoxConstraints constraints) {
    return [
      _textWithDownArrow('Home'),
      _textWithDownArrow('Uniforms'),
      _textWithDownArrow('General Items'),
      _textWithDownArrow('Wish list'),
      UserButton(),
    ];
  }

  Widget CartIcons() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: const Icon(
          Icons.shopping_cart,
          size: 24,
          color: AppColors.kGrey,
        ),
      ),
    );
  }

  Widget _textWithDownArrow(String label) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
    );
  }

  Widget UserButton() {
    return PopupMenuButton<String>(
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
          // Navigate to orders history
        } else if (value == 'Logout') {
          CubitsInjector.authCubit.logOut();
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            value: 'Your Orders',
            child: Text('Your Orders'),
          ),
          const PopupMenuItem(
            value: 'Logout',
            child: Text('Logout'),
          ),
        ];
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.kblue,
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
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
    );
  }
}