import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/custom_dropdown.dart';
import 'package:mafatlal_ecommerce/components/custom_textfield.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/state_district.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_cubit.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_state.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/home_screen.dart';
import 'package:mafatlal_ecommerce/helper/toast_utils.dart';
import 'package:mafatlal_ecommerce/helper/validators.dart';

class RegistrationScreen extends StatefulWidget {
  static const String route = "/registrationScreen";

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _rePwdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedState;
  String? selectedDistrict;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kTransparent,
          forceMaterialTransparency: true,
        ),
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
                      height: 30 * SizeConfig.heightMultiplier,
                    ),
                    Text(
                      AppStrings.registerAccount,
                      style: AppTextStyle.f32BlackW600,
                    ),
                    SizedBox(
                      height: 8 * SizeConfig.heightMultiplier,
                    ),
                    Text(
                      AppStrings.completeYourDetails,
                      style: AppTextStyle.f16GreyW500,
                    ),
                    SizedBox(
                      height: 30 * SizeConfig.heightMultiplier,
                    ),
                    CustomTextField(
                      hint: "Name",
                      suffixWidget: const Icon(Icons.person_2_outlined),
                      textEditingController: _nameController,
                      validation: (value) {
                        if (value?.isEmpty == true) {
                          return "Name is Required";
                        }
                        return (value ?? "").trim().length > 3
                            ? null
                            : "Please Enter a valid Name";
                      },
                    ),
                    SizedBox(
                      height: 20 * SizeConfig.heightMultiplier,
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
                      height: 20 * SizeConfig.heightMultiplier,
                    ),
                    CustomTextField(
                      hint: "Password",
                      suffixWidget: const Icon(Icons.lock_outline),
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
                      textEditingController: _pwdController,
                    ),
                    SizedBox(
                      height: 20 * SizeConfig.heightMultiplier,
                    ),
                    CustomTextField(
                      hint: "Confirm Password",
                      suffixWidget: const Icon(Icons.lock_outline),
                      formatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      validation: (value) {
                        if (value?.isEmpty == true) {
                          return "Confirm Password is Required";
                        }
                        return value == _pwdController.text
                            ? null
                            : "Password And Confirm Password should be equal";
                      },
                      textEditingController: _rePwdController,
                    ),
                    SizedBox(
                      height: 20 * SizeConfig.heightMultiplier,
                    ),
                    BlocBuilder<AuthCubit, AuthState>(
                      buildWhen: (previous, current) =>
                          current is GetDistrictListState,
                      builder: (context, state) {
                        return CustomDropDown<String>(
                            label: "Select State",
                            selectedValue: selectedState,
                            items: StateDistricts.stateList,
                            validator: (value) {
                              return value != null
                                  ? null
                                  : "Please select a state";
                            },
                            onChanged: (value) {
                              selectedState = value;
                              selectedDistrict = null;
                              CubitsInjector.authCubit.updateState(value!);
                            },
                            labelFormat: (value) {
                              return value.toString();
                            });
                      },
                    ),
                    SizedBox(
                      height: 20 * SizeConfig.heightMultiplier,
                    ),
                    BlocBuilder<AuthCubit, AuthState>(
                      buildWhen: (previous, current) =>
                          current is GetDistrictListState ||
                          current is UpdateDistrictState,
                      builder: (context, state) {
                        return CustomDropDown<String>(
                            label: "Select District",
                            selectedValue: selectedDistrict,
                            items:
                                StateDistricts.getDistrictList(selectedState),
                            validator: (value) {
                              return value != null
                                  ? null
                                  : "Please select a district";
                            },
                            onChanged: (value) {
                              selectedDistrict = value;
                              CubitsInjector.authCubit.updateDistrict(value!);
                            },
                            labelFormat: (value) => value);
                      },
                    ),
                    SizedBox(
                      height: 40 * SizeConfig.heightMultiplier,
                    ),
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is RegisterUserFailedState) {
                          ToastUtils.showErrorToast(state.message);
                        }
                        if (state is RegisterUserSuccessState) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, HomeScreen.route, (route) => false);
                        }
                      },
                      buildWhen: (previous, current) =>
                          current is RegisterUserLoadingState ||
                          current is RegisterUserSuccessState ||
                          current is RegisterUserFailedState,
                      builder: (context, state) {
                        if (state is RegisterUserLoadingState) {
                          return const LoadingAnimation();
                        }
                        return CustomElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() == true) {
                              CubitsInjector.authCubit.registerUser(
                                  email: _emailController.text,
                                  pwd: _pwdController.text,
                                  name: _nameController.text,
                                  state: selectedState!,
                                  district: selectedDistrict!);
                            }
                          },
                          lable: AppStrings.signUp,
                          padding: EdgeInsets.symmetric(
                              vertical: 12 * SizeConfig.heightMultiplier),
                          textStyle: AppTextStyle.f16WhiteW600,
                        );
                      },
                    ),
                    SizedBox(
                      height: 30 * SizeConfig.heightMultiplier,
                    ),
                    Text(
                      AppStrings.agreetotermsAndConditions,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.f16GreyW500,
                    ),
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
