import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/forgot_password_screen.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/sign_up_screen.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/splash_screen.dart';
import 'package:mafatlal_ecommerce/features/home/model/category_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/cart_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/category_product_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/home_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/product_details.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/search_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/order_success_widget.dart';

class GenerateRoute {
  static Route<dynamic>? Function(RouteSettings)? onGenerateRoute =
      (RouteSettings settings) {
    switch (settings.name) {
      //Before Login
      case SplashScreen.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const SplashScreen());
      case LoginScreen.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const LoginScreen());
      case RegistrationScreen.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const RegistrationScreen());
      case ForgotPwdScreen.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ForgotPwdScreen());
      case HomeScreen.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const HomeScreen());
      case ProductDetailsScreen.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ProductDetailsScreen());
      case SearchScreen.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const SearchScreen());
      case CategoryProductScreen.route:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => CategoryProductScreen(
                  category: settings.arguments as Category,
                ));
      case CartScreen.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const CartScreen());
      case OrderSuccess.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const OrderSuccess());
      default:
        return null;
    }
  };
}
