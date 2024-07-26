import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_cubit.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_state.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/home_screen.dart';
import 'package:mafatlal_ecommerce/helper/shared_preference_helper.dart';

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
  }

  @override
  void initState() {
    authCubit = BlocProvider.of<AuthCubit>(context);
    checkAndNavigateToRespectiveScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
