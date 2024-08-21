import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/custom_textfield.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_cubit.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_state.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/sign_up_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/home_screen.dart';
import 'package:mafatlal_ecommerce/helper/toast_utils.dart';
import 'package:mafatlal_ecommerce/helper/validators.dart';

class LoginScreen extends StatefulWidget {
  static const String route = "/loginScreen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: loginFormLargeScreen(),
      smallScreen: loginFormSmallScreen(),
    );
  }

  Widget loginFormLargeScreen() {
    return Scaffold(
      backgroundColor: AppColors.kGrey200,
      body: Center(
        child: Container(
          width: 550,
          height: 500,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.kBlack.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(1, 1), // changes position of shadow
                ),
              ]),
          child: loginForm(400),
        ),
      ),
    );
  }

  Widget loginFormSmallScreen() {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: loginForm(),
        ),
      ),
    );
  }

  Widget loginForm([double? width]) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetPath.logo,
              width: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              AppStrings.welcomeBack,
              style: AppTextStyle.f22BlackW600,
            ),
            Text(
              AppStrings.signInWithEmailPwd,
              style: AppTextStyle.f16GreyW500,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              width: width ?? double.maxFinite,
              hint: "Email",
              suffixWidget: const Icon(Icons.mail_outline),
              textEditingController: _emailController,
              formatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
              validation: (value) {
                if (value?.isEmpty == true) {
                  return "Email is Required";
                }
                return Validator.isValidEmail(value ?? "")
                    ? null
                    : "Invalid Email";
              },
            ),
            const SizedBox(
              height: 30,
            ),
            CustomTextField(
              width: width ?? double.maxFinite,
              hint: "Password",
              suffixWidget: const Icon(Icons.lock_outline),
              textEditingController: _pwdController,
              formatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
              validation: (value) {
                if (value?.isEmpty == true) {
                  return "Password is Required";
                }
                return (value?.length ?? 0) > 4
                    ? null
                    : "Password should be of at least 4 characters";
              },
            ),
            const SizedBox(
              height: 30,
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is LoginSuccessState) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.route, (route) => false);
                }
                if (state is LoginFailedState) {
                  ToastUtils.showErrorToast(state.message);
                }
              },
              buildWhen: (previous, current) =>
                  current is LoginLoadingState ||
                  current is LoginFailedState ||
                  current is LoginSuccessState,
              builder: (context, state) {
                if (state is LoginLoadingState) {
                  return const LoadingAnimation();
                }
                return CustomElevatedButton(
                  width: width ?? double.maxFinite,
                  backgroundColor: AppColors.kRed,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState?.validate() == true) {
                      CubitsInjector.authCubit.loginUser(
                          email: _emailController.text,
                          pwd: _pwdController.text);
                    }
                  },
                  lable: AppStrings.signIn,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  textStyle: AppTextStyle.f16WhiteW600,
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            RichText(
                text: TextSpan(children: [
              const TextSpan(
                  text: AppStrings.dontHaveAccount,
                  style: AppTextStyle.f16GreyW500),
              TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(context, RegistrationScreen.route);
                    },
                  text: "\t${AppStrings.signUp}",
                  style: AppTextStyle.f16RedW600)
            ]))
          ],
        ),
      ),
    );
  }
}
