import 'package:fluttertoast/fluttertoast.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';

class ToastUtils {
  // Function to show a success toast
  static void showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.kGreen,
      textColor: AppColors.kWhite,
      fontSize: 16.0 * SizeConfig.textMultiplier,
    );
  }

  // Function to show an error toast
  static void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.kRed,
      textColor: AppColors.kWhite,
      fontSize: 16.0 * SizeConfig.textMultiplier,
    );
  }
}
