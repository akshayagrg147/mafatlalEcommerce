import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/custom_dropdown.dart';
import 'package:mafatlal_ecommerce/components/custom_textfield.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/state_district.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/checkout/bloc/checkout_cubit.dart';
import 'package:mafatlal_ecommerce/features/checkout/bloc/checkout_state.dart';
import 'package:mafatlal_ecommerce/features/checkout/presentation/widgets/biiling_address_section.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/model/address.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/order_success_widget.dart';
import 'package:mafatlal_ecommerce/helper/toast_utils.dart';

class CheckoutScreen extends StatefulWidget {
  static const String route = "/checkout";

  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _gstController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressController2 = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  String? selectedDistrict;
  String? selectedState;
  BillingEnum selectedBillingEnum =
      CubitsInjector.authCubit.currentUser?.billingAddress != null
          ? BillingEnum.billing
          : BillingEnum.sameAsShipping;

  final TextEditingController _billingAddressController =
      TextEditingController();
  final TextEditingController _billingAddressController2 =
      TextEditingController();
  final TextEditingController _billingLandmarkController =
      TextEditingController();
  final TextEditingController _billingCityController = TextEditingController();
  final TextEditingController _billingPinCodeController =
      TextEditingController();
  final TextEditingController _billingMobileNumberController =
      TextEditingController();
  String? billingSelectedDistrict;
  String? billingSelectedState;

  bool saveAddress = false;

  @override
  void initState() {
    CubitsInjector.homeCubit.fetchCartProducts();
    if (CubitsInjector.authCubit.currentUser?.gstNumber != null) {
      _gstController.text = CubitsInjector.authCubit.currentUser!.gstNumber;
    }
    if (CubitsInjector.authCubit.currentUser?.shippingAddress != null) {
      final address = CubitsInjector.authCubit.currentUser!.shippingAddress!;
      _addressController.text = address.address;
      _addressController2.text = address.address2;
      _landmarkController.text = address.landmark;
      _cityController.text = address.city;
      _pinCodeController.text = address.pincode;
      _mobileNumberController.text = address.mobile;
      selectedState = address.state;
      selectedDistrict = address.district;
    }

    if (CubitsInjector.authCubit.currentUser?.billingAddress != null) {
      final address = CubitsInjector.authCubit.currentUser!.billingAddress!;
      _billingAddressController.text = address.address;
      _billingAddressController2.text = address.address2;
      _billingLandmarkController.text = address.landmark;
      _billingCityController.text = address.city;
      _billingPinCodeController.text = address.pincode;
      _billingMobileNumberController.text = address.mobile;
      billingSelectedState = address.state;
      billingSelectedDistrict = address.district;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state is SelectShippingState) {
          selectedState = state.stateName;
          selectedDistrict = null;
        }
        if (state is SelectShippingDistrict) {
          selectedDistrict = state.districtName;
        }

        if (state is SelectBillingState) {
          billingSelectedState = state.stateName;
          billingSelectedDistrict = null;
        }
        if (state is SelectBillingDistrict) {
          billingSelectedDistrict = state.districtName;
        }
        if (state is CheckoutOrderLoadingState) {
          LoadingAnimation.show(context);
        }
        if (state is CheckoutOrderSuccessState) {
          Navigator.pop(context);
          final shippingAddress = context.read<CheckoutCubit>().shippingAddress;
          final billingAddress = context.read<CheckoutCubit>().billingAddress;
          if (saveAddress) {
            CubitsInjector.homeCubit
                .saveAddress(shippingAddress!, isUpdate: true);
            if (selectedBillingEnum == BillingEnum.billing) {
              CubitsInjector.homeCubit.saveAddress(billingAddress!,
                  isUpdate: true, isShipping: false);
            }
          }

          CubitsInjector.homeCubit.resetCart();
          Navigator.pushReplacementNamed(context, OrderSuccess.route);
        }

        if (state is CheckoutOrderErrorState) {
          Navigator.pop(context);
          ToastUtils.showErrorToast(state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          toolbarHeight: 60,
          shadowColor: AppColors.kBlack.withOpacity(.3),
          backgroundColor: AppColors.kWhite,
          surfaceTintColor: AppColors.kWhite,
          centerTitle: true,
          title: Text(
            "Mafatlal Store",
            style: AppTextStyle.f24PoppinsBlueGreyw600,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.shopping_cart,
                size: 24,
                color: AppColors.kGrey,
              ),
            ),
            const SizedBox(
              width: 48,
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ResponsiveWidget(
            largeScreen: largsScreen(),
            smallScreen: smallScreen(),
          ),
        ),
      ),
    );
  }

  Widget gapH() {
    return const SizedBox(
      height: 20,
    );
  }

  Widget smallScreen() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: SingleChildScrollView(
          child: Column(
        children: [
          checkoutForm(),
        ],
      )),
    );
  }

  Widget largsScreen() {
    return SizedBox.expand(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kWhite,
                  border: Border(right: BorderSide(color: AppColors.kGrey200)),
                ),
                alignment: Alignment.topRight,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 648
                      ? 600
                      : double.maxFinite,
                  child: SingleChildScrollView(
                    child: checkoutForm(),
                  ),
                ),
              )),
          BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) =>
                current is FetchCartLoadingState ||
                current is FetchCartSuccessState ||
                current is FetchCartFailedState,
            builder: (context, state) {
              return Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 30,
                    ),
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width > 600
                            ? 550
                            : double.maxFinite,
                        child: billingInfo()),
                  ));
            },
          ),
        ],
      ),
    );
  }

  Widget billingInfo() {
    final subTotal = CubitsInjector.homeCubit.cartProducts.fold<num>(
        0,
        (previousValue, element) =>
            previousValue + (element.getPrice() * element.quantity));
    final tax = CubitsInjector.homeCubit.cartProducts.fold<num>(
        0,
        (previousValue, element) =>
            previousValue + (element.getTax() * element.quantity));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final product = CubitsInjector.homeCubit.cartProducts[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 90,
                    width: 80, // height: 400px
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF), // background: #FFFFFF
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x1F004392), // box-shadow: #0043921F
                          offset: Offset(0, 8), // offset: 0px 8px
                          blurRadius: 8, // blur radius: 24px
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                        imageUrl: product.productImage.isNotEmpty
                            ? product.productImage.first
                            : "",
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error_outline))),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: double.maxFinite,
                      ),
                      Text(
                        product.productName.replaceAll("\n", " "),
                        maxLines: 2,
                        style: AppTextStyle.f12OutfitBlackW500
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            'Organization:',
                            style: AppTextStyle.f12OutfitBlackW500,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            product.productOrganisation,
                            maxLines: 1,
                            style: AppTextStyle.f12OutfitBlackW500,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.kRed,
                        ),
                        child: Text(
                          product.variant!.selectedVariant.name,
                          style: AppTextStyle.f12GreyW400
                              .copyWith(color: AppColors.kWhite),
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        product.getPriceWithTax().toStringAsFixed(2),
                        style: AppTextStyle.f12outfitGreyW600,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "X\t${product.quantity}",
                        style: AppTextStyle.f12OutfitBlackW500,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "₹ ${product.getAmount().toStringAsFixed(2)}",
                        style: AppTextStyle.f12outfitGreyW600,
                      )
                    ],
                  )
                ],
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 15,
              );
            },
            itemCount: CubitsInjector.homeCubit.cartProducts.length,
            // physics: const NeverScrollableScrollPhysics(),
          ),
        ),
        Divider(
          thickness: 1,
          color: AppColors.kGrey400,
          height: 50,
        ),
        textWithValue(
            label: "Subtotal", value: "₹ ${subTotal.toStringAsFixed(2)}"),
        textWithValue(label: "Taxes", value: "₹ ${tax.toStringAsFixed(2)}"),
        Divider(
          thickness: 1,
          color: AppColors.kGrey400,
          height: 10,
        ),
        const SizedBox(
          height: 10,
        ),
        textWithValue(
            label: "Total",
            labelStyle: AppTextStyle.f18RobotoDarkgrayW500,
            valueStyle: AppTextStyle.f18RobotoDarkgrayW500,
            value: "₹ ${(subTotal + tax).toStringAsFixed(2)}"),
      ],
    );
  }

  Widget textWithValue(
      {required String label,
      required String value,
      TextStyle? labelStyle,
      TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: labelStyle ?? AppTextStyle.f16RobotoBlackW600),
        Text(value, style: valueStyle ?? AppTextStyle.f16RobotoBlackW500),
      ]),
    );
  }

  Widget checkoutForm({MainAxisSize mainAxisSize = MainAxisSize.max}) {
    return Column(
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "GST (Optional",
          style: AppTextStyle.f24PoppinsBlackw600,
        ),
        gapH(),
        CustomTextField(
          hint: "Gst No.",
          suffixWidget: const Icon(Icons.numbers),
          formatters: [
            LengthLimitingTextInputFormatter(
                15), // Limit input to 15 characters
            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
          ],
          validation: (String? value) {
            // GST number must be 15 characters long and alphanumeric
            if (value == null || value.isEmpty) {
              return null;
            } else if (value.length != 15) {
              return 'GST number must be 15 characters long';
            } else if (!RegExp(
                    r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
                .hasMatch(value)) {
              return 'Invalid GST number format';
            }
            return null;
          },
          textEditingController: _gstController,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          "Delivery",
          style: AppTextStyle.f24PoppinsBlackw600,
        ),
        gapH(),
        CustomTextField(
          hint: "Street Address",
          textEditingController: _addressController,
          validation: (value) {
            if (value?.trim().isEmpty == true) {
              return "Address is Required";
            }
            return null;
          },
        ),
        gapH(),
        CustomTextField(
          hint: "Street Address 2 (optional)",
          textEditingController: _addressController2,
          validation: (value) {
            return null;
          },
        ),
        gapH(),
        CustomTextField(
          hint: "Landmark (optional)",
          textEditingController: _landmarkController,
        ),
        gapH(),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: BlocBuilder<CheckoutCubit, CheckoutState>(
                buildWhen: (previous, current) =>
                    current is SelectShippingState,
                builder: (context, state) {
                  return CustomDropDown<String>(
                      label: "Select State",
                      selectedValue: selectedState,
                      items: StateDistricts.stateList,
                      validator: (value) {
                        return value != null ? null : "Please select a state";
                      },
                      onChanged: (value) {
                        context
                            .read<CheckoutCubit>()
                            .selectShippingState(value!);
                      },
                      labelFormat: (value) {
                        return value.toString();
                      });
                },
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 1,
              child: BlocBuilder<CheckoutCubit, CheckoutState>(
                buildWhen: (previous, current) =>
                    current is SelectShippingState ||
                    current is SelectShippingDistrict,
                builder: (context, state) {
                  return CustomDropDown<String>(
                      label: "Select District",
                      selectedValue: selectedDistrict,
                      items: StateDistricts.getDistrictList(selectedState),
                      validator: (value) {
                        return value != null
                            ? null
                            : "Please select a district";
                      },
                      onChanged: (value) {
                        context
                            .read<CheckoutCubit>()
                            .selectShippingDistrict(value!);
                      },
                      labelFormat: (value) => value);
                },
              ),
            ),
          ],
        ),
        gapH(),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: CustomTextField(
                hint: "City",
                textEditingController: _cityController,
                validation: (value) {
                  if (value?.trim().isEmpty == true) {
                    return "City is Required";
                  }

                  return null;
                },
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 1,
              child: CustomTextField(
                hint: "Pincode",
                textEditingController: _pinCodeController,
                textInputType: TextInputType.number,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validation: (value) {
                  if (value?.trim().isEmpty == true) {
                    return "Pincode is Required";
                  } else if (value?.trim().length != 6) {
                    return "Invalid Pincode";
                  }

                  return null;
                },
              ),
            ),
          ],
        ),
        gapH(),
        CustomTextField(
          hint: "Mobile Number",
          textEditingController: _mobileNumberController,
          textInputType: TextInputType.number,
          formatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validation: (value) {
            if (value?.trim().isEmpty == true) {
              return "Mobile Number is Required";
            }
            if (value?.trim().length != 10) {
              return "Invalid Mobile Number";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 30,
        ),
        BillingAddressSection(
            billingAddressForm: billingAddressForm(),
            selectedBillingEnum: selectedBillingEnum,
            onChanged: (val) {
              selectedBillingEnum = val;
            }),
        const SizedBox(
          height: 30,
        ),
        BlocBuilder<CheckoutCubit, CheckoutState>(
          buildWhen: (previous, current) =>
              current is UpdateStateAddressCheckBoxState,
          builder: (context, state) {
            return Row(
              children: [
                Checkbox(
                    value: saveAddress,
                    onChanged: (val) {
                      saveAddress = val!;
                      context.read<CheckoutCubit>().updateSaveAddressCheckbox();
                    }),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Save Address for Next Time',
                  style: AppTextStyle.f14OutfitGreyW500,
                )
              ],
            );
          },
        ),
        gapH(),
        CustomElevatedButton(
          width: double.maxFinite,
          backgroundColor: AppColors.kBlack,
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (_formKey.currentState?.validate() == true) {
              final shippingAddress = Address(
                address: _addressController.text,
                address2: _addressController2.text,
                city: _cityController.text,
                state: selectedState!,
                district: selectedDistrict!,
                landmark: _landmarkController.text,
                pincode: _pinCodeController.text,
                mobile: _mobileNumberController.text,
              );
              final billingAddress =
                  selectedBillingEnum == BillingEnum.sameAsShipping
                      ? shippingAddress
                      : Address(
                          address: _billingAddressController.text,
                          address2: _billingAddressController2.text,
                          city: _billingCityController.text,
                          state: billingSelectedState!,
                          district: billingSelectedDistrict!,
                          landmark: _billingLandmarkController.text,
                          pincode: _billingPinCodeController.text,
                          mobile: _billingMobileNumberController.text,
                        );

              context.read<CheckoutCubit>().placeOrder(
                  cartProducts: CubitsInjector.homeCubit.cartProducts,
                  gstNumber: _gstController.text,
                  shippingAddress: shippingAddress,
                  billingAddress: billingAddress);
            }
          },
          label: "Pay Now",
          padding: const EdgeInsets.symmetric(vertical: 20),
          textStyle: AppTextStyle.f18PoppinsWhitew600,
        )
      ],
    );
  }

  Widget billingAddressForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hint: "Street Address",
          textEditingController: _billingAddressController,
          validation: (value) {
            if (value?.trim().isEmpty == true) {
              return "Address is Required";
            }
            return null;
          },
        ),
        gapH(),
        CustomTextField(
          hint: "Street Address 2 (optional)",
          textEditingController: _billingAddressController2,
          validation: (value) {
            return null;
          },
        ),
        gapH(),
        CustomTextField(
          hint: "Landmark (optional)",
          textEditingController: _billingLandmarkController,
        ),
        gapH(),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: BlocBuilder<CheckoutCubit, CheckoutState>(
                buildWhen: (previous, current) => current is SelectBillingState,
                builder: (context, state) {
                  return CustomDropDown<String>(
                      label: "Select State",
                      selectedValue: billingSelectedState,
                      items: StateDistricts.stateList,
                      validator: (value) {
                        return value != null ? null : "Please select a state";
                      },
                      onChanged: (value) {
                        context
                            .read<CheckoutCubit>()
                            .selectBillingState(value!);
                      },
                      labelFormat: (value) {
                        return value.toString();
                      });
                },
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 1,
              child: BlocBuilder<CheckoutCubit, CheckoutState>(
                buildWhen: (previous, current) =>
                    current is SelectBillingState ||
                    current is SelectBillingDistrict,
                builder: (context, state) {
                  return CustomDropDown<String>(
                      label: "Select District",
                      selectedValue: billingSelectedDistrict,
                      items:
                          StateDistricts.getDistrictList(billingSelectedState),
                      validator: (value) {
                        return value != null
                            ? null
                            : "Please select a district";
                      },
                      onChanged: (value) {
                        context
                            .read<CheckoutCubit>()
                            .selectBillingDistrict(value!);
                      },
                      labelFormat: (value) => value);
                },
              ),
            ),
          ],
        ),
        gapH(),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: CustomTextField(
                hint: "City",
                textEditingController: _billingCityController,
                validation: (value) {
                  if (value?.trim().isEmpty == true) {
                    return "City is Required";
                  }

                  return null;
                },
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 1,
              child: CustomTextField(
                hint: "Pincode",
                textEditingController: _billingPinCodeController,
                textInputType: TextInputType.number,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validation: (value) {
                  if (value?.trim().isEmpty == true) {
                    return "Pincode is Required";
                  } else if (value?.trim().length != 6) {
                    return "Invalid Pincode";
                  }

                  return null;
                },
              ),
            ),
          ],
        ),
        gapH(),
        CustomTextField(
          hint: "Mobile Number",
          textEditingController: _billingMobileNumberController,
          textInputType: TextInputType.number,
          formatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validation: (value) {
            if (value?.trim().isEmpty == true) {
              return "Mobile Number is Required";
            }
            if (value?.trim().length != 10) {
              return "Invalid Mobile Number";
            }
            return null;
          },
        ),
      ],
    );
  }
}
