import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/forgot_password_screen.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/sign_up_screen.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/splash_screen.dart';
import 'package:mafatlal_ecommerce/features/home/model/category_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/cart_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/category_product_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/home_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/order_history.dart';
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
        return TransparentRouteBuilder(
            settings: settings, builder: (_) => const CartScreen());
      case OrderSuccess.route:
        return TransparentRouteBuilder(
            settings: settings, builder: (_) => const OrderSuccess());
      case OrdersHistory.route:
        return TransparentRouteBuilder(
            settings: settings, builder: (_) => const OrdersHistory());
      default:
        return null;
    }
  };
}

class TransparentRouteBuilder extends PageRoute<void> {
  final WidgetBuilder builder;

  TransparentRouteBuilder({
    required this.builder,
    RouteSettings? settings,
  }) : super(settings: settings, fullscreenDialog: false);

  @override
  bool get opaque => false; // Make the route transparent

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Color? get barrierColor =>
      Colors.black.withOpacity(0.5); // Semi-transparent background

  @override
  String? get barrierLabel => 'Transparent Route';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context); // Build the widget using the builder function
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation, // Fade transition
      child: child,
    );
  }

  @override
  bool get maintainState => true;
}
