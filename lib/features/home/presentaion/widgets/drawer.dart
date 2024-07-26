import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.kOrange),
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
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
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
              style: AppTextStyle.f14GreyW500,
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
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(LoginScreen.route, (route) => false);

              // To close the drawer as well
            },
          ),
        ],
      );
    },
  );
}
