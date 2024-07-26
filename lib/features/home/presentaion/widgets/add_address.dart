import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/custom_dropdown.dart';
import 'package:mafatlal_ecommerce/components/custom_textfield.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/state_district.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/model/address.dart';

class AddEditAddress extends StatefulWidget {
  final Address? address;
  const AddEditAddress({super.key, this.address});

  static void show(context, {Address? address}) {
    if (SizeConfig.screenWidth > 1000) {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16)),
                  child: AddEditAddress(
                    address: address,
                  )),
            );
          });
    } else {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          builder: (context) {
            return AddEditAddress(
              address: address,
            );
          });
    }
  }

  @override
  State<AddEditAddress> createState() => _AddEditAddressState();
}

class _AddEditAddressState extends State<AddEditAddress> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  String? selectedDistrict;
  String? selectedState;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.address != null) {
      _addressController.text = widget.address!.address;
      _cityController.text = widget.address!.city;
      _pinCodeController.text = widget.address!.pincode;
      selectedState = widget.address!.state;
      selectedDistrict = widget.address!.district;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: 16 * SizeConfig.widthMultiplier,
          vertical: 14 * SizeConfig.heightMultiplier),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                Text(
                  "${widget.address != null ? "Update" : "Add"} Address",
                  style: AppTextStyle.f16BlackW400,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close_sharp,
                      color: AppColors.kBlack,
                      size: 30,
                    ))
              ],
            ),
            SizedBox(
              height: 18 * SizeConfig.heightMultiplier,
            ),
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
            SizedBox(
              height: 12 * SizeConfig.heightMultiplier,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: BlocBuilder<HomeCubit, HomeState>(
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
                            CubitsInjector.homeCubit.updateState(value!);
                          },
                          labelFormat: (value) {
                            return value.toString();
                          });
                    },
                  ),
                ),
                SizedBox(
                  width: 16 * SizeConfig.widthMultiplier,
                ),
                Expanded(
                  flex: 1,
                  child: BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) =>
                        current is GetDistrictListState ||
                        current is UpdateDistrictState,
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
                            selectedDistrict = value;
                            CubitsInjector.homeCubit.updateDistrict(value!);
                          },
                          labelFormat: (value) => value);
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 12 * SizeConfig.heightMultiplier,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    hint: "Enter City",
                    textEditingController: _cityController,
                    validation: (value) {
                      if (value?.trim().isEmpty == true) {
                        return "City is Required";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 16 * SizeConfig.widthMultiplier,
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
            SizedBox(
              height: 20 * SizeConfig.heightMultiplier,
            ),
            CustomElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  final address = Address(
                      address: _addressController.text,
                      state: selectedState!,
                      pincode: _pinCodeController.text,
                      district: selectedDistrict!,
                      city: _cityController.text);
                  CubitsInjector.homeCubit.updateAddress(address);
                  Navigator.pop(context);
                }
              },
              lable: "Save Address",
              padding: EdgeInsets.symmetric(
                  vertical: 8 * SizeConfig.heightMultiplier),
              textStyle: AppTextStyle.f16WhiteW600,
            )
          ],
        ),
      ),
    );
  }
}
