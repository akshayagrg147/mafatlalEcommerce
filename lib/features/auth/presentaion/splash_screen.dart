import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_cubit.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_state.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/home_screen.dart';
import 'package:mafatlal_ecommerce/helper/enums.dart';
import 'package:mafatlal_ecommerce/helper/shared_preference_helper.dart';
import 'package:mafatlal_ecommerce/routes/auto_route/mf_router.gr.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  static const String route = "/splashScreen";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthCubit authCubit;

  void checkAndNavigateToRespectiveScreen() async {
    await SharedPreferencesHelper.instance.init();
    authCubit.getCurrentUser();
    if (kIsWeb) {
      if (authCubit.currentUser?.userType == UserType.admin) {
        // context.router.replace(AdminHom)
      } else {
        context.router.replace(const HomeRoute());
      }
    }
  }

  @override
  void initState() {
    authCubit = BlocProvider.of<AuthCubit>(context);
    checkAndNavigateToRespectiveScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Scaffold(body: LoadingAnimation());
    }
    return Scaffold(
      backgroundColor: AppColors.kOrange,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is GetCurrentUserSuccessState) {
            Navigator.pushNamed(context, HomeScreen.route);
          }
          if (state is GetCurrentUserFailedState) {
            Navigator.pushNamed(context, LoginScreen.route);
          }
        },
        child: Center(
          child: Icon(
            Icons.flutter_dash,
            size: 60 * SizeConfig.imageSizeMultiplier,
          ),
        ),
      ),
    );
  }
}
