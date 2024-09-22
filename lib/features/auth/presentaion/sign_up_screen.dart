import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/custom_dropdown.dart';
import 'package:mafatlal_ecommerce/components/custom_textfield.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/state_district.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
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
  final TextEditingController _gstController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedState;
  String? selectedDistrict;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: largScreenForm(),
      smallScreen: smallScreenForm(),
    );
  }

  String? gstNumberValidator(String? value) {
    // GST number must be 15 characters long and alphanumeric
    if (value == null || value.isEmpty) {
      return 'GST number is required';
    } else if (value.length != 15) {
      return 'GST number must be 15 characters long';
    } else if (!RegExp(
            r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
        .hasMatch(value)) {
      return 'Invalid GST number format';
    }
    return null;
  }

  Widget largScreenForm() {
    return Scaffold(
      backgroundColor: AppColors.kGrey200,
      body: Center(
        child: Container(
          width: 600,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
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
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_circle_left_outlined,
                            size: 30,
                          )),
                      Image.asset(
                        AssetPath.logo,
                        width: 150,
                      ),
                      SizedBox(
                        width: 30,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    AppStrings.registerAccount,
                    style: AppTextStyle.f22BlackW600,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
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
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: CustomTextField(
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
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
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
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: CustomTextField(
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
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<AuthCubit, AuthState>(
                          buildWhen: (previous, current) =>
                              current is GetDistrictListState,
                          builder: (context, state) {
                            return CustomDropDown<String>(
                                width: 250,
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
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: BlocBuilder<AuthCubit, AuthState>(
                          buildWhen: (previous, current) =>
                              current is GetDistrictListState ||
                              current is UpdateDistrictState,
                          builder: (context, state) {
                            return CustomDropDown<String>(
                                label: "Select District",
                                selectedValue: selectedDistrict,
                                items: StateDistricts.getDistrictList(
                                    selectedState),
                                validator: (value) {
                                  return value != null
                                      ? null
                                      : "Please select a district";
                                },
                                onChanged: (value) {
                                  selectedDistrict = value;
                                  CubitsInjector.authCubit
                                      .updateDistrict(value!);
                                },
                                labelFormat: (value) => value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    hint: "Gst No.",
                    suffixWidget: const Icon(Icons.numbers),
                    formatters: [
                      LengthLimitingTextInputFormatter(
                          15), // Limit input to 15 characters
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                    ],
                    validation: gstNumberValidator,
                    textEditingController: _gstController,
                  ),
                  const SizedBox(
                    height: 26,
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
                        width: 400,
                        backgroundColor: AppColors.kRed,
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            CubitsInjector.authCubit.registerUser(
                                email: _emailController.text,
                                pwd: _pwdController.text,
                                name: _nameController.text,
                                state: selectedState!,
                                district: selectedDistrict!,
                                gstNo: _gstController.text);
                          }
                        },
                        label: AppStrings.signUp,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        textStyle: AppTextStyle.f16WhiteW600,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
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
    );
  }

  Widget smallScreenForm() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kTransparent,
          forceMaterialTransparency: true,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      AssetPath.logo,
                      width: 150,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const Text(
                      AppStrings.registerAccount,
                      style: AppTextStyle.f32BlackW600,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      AppStrings.completeYourDetails,
                      style: AppTextStyle.f16GreyW500,
                    ),
                    const SizedBox(
                      height: 30,
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
                    const SizedBox(
                      height: 20,
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
                    const SizedBox(
                      height: 20,
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
                    const SizedBox(
                      height: 20,
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
                    const SizedBox(
                      height: 20,
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
                    const SizedBox(
                      height: 20,
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
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      hint: "Gst No.",
                      suffixWidget: const Icon(Icons.numbers),
                      formatters: [
                        LengthLimitingTextInputFormatter(
                            15), // Limit input to 15 characters
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                      ],
                      validation: gstNumberValidator,
                      textEditingController: _gstController,
                    ),
                    const SizedBox(
                      height: 40,
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
                          backgroundColor: AppColors.kRed,
                          onPressed: () {
                            if (_formKey.currentState?.validate() == true) {
                              CubitsInjector.authCubit.registerUser(
                                  email: _emailController.text,
                                  pwd: _pwdController.text,
                                  name: _nameController.text,
                                  state: selectedState!,
                                  district: selectedDistrict!,
                                  gstNo: _gstController.text);
                            }
                          },
                          label: AppStrings.signUp,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          textStyle: AppTextStyle.f16WhiteW600,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
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
