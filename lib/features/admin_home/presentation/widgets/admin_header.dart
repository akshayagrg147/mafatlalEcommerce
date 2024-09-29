import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.kGrey900,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Image.asset(
            AssetPath.logo,
            height: 50,
          ),
          const Spacer(),
          TextButton(
              onPressed: () {
                CubitsInjector.authCubit.logOut();
              },
              child: Text(
                'Logout',
                style: AppTextStyle.f14WhiteW500,
              ))
        ],
      ),
    );
  }
}
