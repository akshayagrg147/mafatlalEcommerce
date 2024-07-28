import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/home_screen.dart';

class OrderSuccess extends StatefulWidget {
  static const String route = "/orderSuccessScreen";
  const OrderSuccess({super.key});

  @override
  State<OrderSuccess> createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess> {
  void returnToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.popUntil(
          context, (route) => route.settings.name == HomeScreen.route);
    });
  }

  @override
  void initState() {
    returnToHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: AppColors.kWhite,
          body: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(AssetPath.successAnim,
                    height: 230 * SizeConfig.heightMultiplier),
                SizedBox(
                  height: 10 * SizeConfig.heightMultiplier,
                ),
                Text(
                  "Order Placed Successfully",
                  style: AppTextStyle.f20GreyW600,
                )
              ],
            ),
          )),
    );
  }
}
