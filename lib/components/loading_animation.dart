import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});
  static void show(BuildContext context, {bool isDismissable = false}) {
    showDialog(
        context: context,
        barrierDismissible: isDismissable,
        builder: (context) {
          return WillPopScope(
              onWillPop: () async {
                return isDismissable;
              },
              child: const LoadingAnimation());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        color: AppColors.kRed,
      ),
    );
  }
}
