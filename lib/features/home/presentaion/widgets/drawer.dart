import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/select_category_expantion_widget.dart';
import 'package:mafatlal_ecommerce/routes/auto_route/mf_router.gr.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.kWhite,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.kRed),
            accountName: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                CubitsInjector.authCubit.currentUser?.fullName ?? "",
                style: AppTextStyle.f14WhiteW500,
              ),
            ),
            accountEmail: Text(
              CubitsInjector.authCubit.currentUser?.email ?? "",
              style: AppTextStyle.f12WhiteW500,
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: AppColors.kWhite,
              child: Icon(
                Icons.person,
                size: 30.0,
              ),
            ),
          ),
          if (CubitsInjector.authCubit.currentUser == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomElevatedButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
                onPressed: () {
                  context.router.maybePop();
                  context.router.push(const LoginScreenRoute());
                },
                textColor: AppColors.kWhite,
                label: "Login",
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpandableCategoryDropdown(),
          ),
          if (CubitsInjector.authCubit.currentUser != null)
            ListTile(
              leading: const Icon(
                Icons.history,
                color: AppColors.kBlack,
                size: 30,
              ),
              title: Text(
                'Order History',
                style: AppTextStyle.f14BlackW500,
              ),
              onTap: () {
                context.router.maybePop();
                context.router.push(const OrdersHistoryRoute());
              },
            ),
          if (CubitsInjector.authCubit.currentUser != null)
            ListTile(
              leading: Icon(
                Icons.logout,
                color: AppColors.kRed,
                size: 30,
              ),
              title: Text(
                'Logout',
                style: AppTextStyle.f14RedW500,
              ),
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
        ],
      ),
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // title: Text('Logout Confirmation'),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyle.f14BlackW500,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancel',
              style: AppTextStyle.f14OutfitGreyW500,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Logout', style: AppTextStyle.f14RedW500),
            onPressed: () {
              // Handle the logout action
              CubitsInjector.authCubit.logOut();

              // To close the drawer as well
            },
          ),
        ],
      );
    },
  );
}
