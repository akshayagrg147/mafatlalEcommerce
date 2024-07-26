import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/custom_textfield.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding:
              EdgeInsets.symmetric(horizontal: 20 * SizeConfig.widthMultiplier),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    SizedBox(
                      height: 120 * SizeConfig.heightMultiplier,
                    ),
                    Text(
                      AppStrings.welcomeBack,
                      style: AppTextStyle.f32BlackW600,
                    ),
                    SizedBox(
                      height: 8 * SizeConfig.heightMultiplier,
                    ),
                    Text(
                      AppStrings.signInWithEmailPwd,
                      style: AppTextStyle.f16GreyW500,
                    ),
                    SizedBox(
                      height: 60 * SizeConfig.heightMultiplier,
                    ),
                    CustomTextField(
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
                    SizedBox(
                      height: 40 * SizeConfig.heightMultiplier,
                    ),
                    CustomTextField(
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
                    SizedBox(
                      height: 25 * SizeConfig.heightMultiplier,
                    ),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Padding(
                    //     padding: EdgeInsets.only(
                    //         right: (SizeConfig.screenWidth <= 600 ? 0 : 180) *
                    //             SizeConfig.widthMultiplier),
                    //     child: TextButton(
                    //       onPressed: () {
                    //         Navigator.pushNamed(context, ForgotPwdScreen.route);
                    //       },
                    //       child: Text(AppStrings.forgotPassword,
                    //           style: AppTextStyle.f16BlackW400.copyWith(
                    //               decoration: TextDecoration.underline)),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 40 * SizeConfig.heightMultiplier,
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
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState?.validate() == true) {
                              CubitsInjector.authCubit.loginUser(
                                  email: _emailController.text,
                                  pwd: _pwdController.text);
                            }
                          },
                          lable: AppStrings.signIn,
                          padding: EdgeInsets.symmetric(
                              vertical: 12 * SizeConfig.heightMultiplier),
                          textStyle: AppTextStyle.f16WhiteW600,
                        );
                      },
                    ),
                    SizedBox(
                      height: 50 * SizeConfig.heightMultiplier,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: AppStrings.dontHaveAccount,
                          style: AppTextStyle.f16GreyW500),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                  context, RegistrationScreen.route);
                            },
                          text: "\t${AppStrings.signUp}",
                          style: AppTextStyle.f16OrangeW600)
                    ]))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
