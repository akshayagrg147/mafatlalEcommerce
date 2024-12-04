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
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(color: AppColors.kWhite, boxShadow: [
        BoxShadow(
          color: AppColors.kBlack.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(0, 1), // changes position of shadow
        ),
      ]),
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
                style: AppTextStyle.f14BlackW500,
              ))
        ],
      ),
    );
  }
}
