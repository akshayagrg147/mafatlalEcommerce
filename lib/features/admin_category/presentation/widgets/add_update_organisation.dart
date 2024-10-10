import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/custom_dropdown.dart';
import 'package:mafatlal_ecommerce/components/custom_textfield.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_state.dart';
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_org-model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/district_model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/state_model.dart';
import 'package:mafatlal_ecommerce/helper/toast_utils.dart';

class AddUpdateorganisation extends StatefulWidget {
  final AdminCategoryCubit bloc;
  final AdminOrganisation? organisation;

  const AddUpdateorganisation(
      {super.key, required this.bloc, this.organisation});

  @override
  State<AddUpdateorganisation> createState() => _AddUpdateorganisationState();
}

class _AddUpdateorganisationState extends State<AddUpdateorganisation> {
  String? errMsg;
  bool isEdit = false;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  MediaInfo? selectedFile;
  StateModel? selectedState;
  final List<StateModel> _states = [];
  final List<DistrictModel> _districts = [];

  DistrictModel? selectedDistrict;

  @override
  void initState() {
    if (widget.organisation != null) {
      isEdit = true;
      nameController.text = widget.organisation!.name;

      if (widget.organisation!.stateId != null) {
        selectedState = StateModel(
            id: widget.organisation!.stateId!,
            name: widget.organisation!.stateName!);
      }
      if (widget.organisation!.districtId != null) {
        selectedDistrict = DistrictModel(
            id: widget.organisation!.districtId!,
            name: widget.organisation!.districtName!,
            stateId: widget.organisation!.stateId!,
            stateName: widget.organisation!.stateName!);
      }
    }
    widget.bloc.fetchStates();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCategoryCubit, AdminCategoryState>(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is AddOrganisationFailedState) {
          errMsg = (state as dynamic).message;
        }
        if (state is AddOrganisationSuccessState) {
          Navigator.pop(context);
          ToastUtils.showSuccessToast("Organisation Added Successfully");
        }
        if (state is FetchStatesSuccessState) {
          _states.clear();
          _states.addAll(state.states);
          if (selectedState != null && isEdit) {
            if (_states.contains(selectedState)) {
              widget.bloc.fetchDistricts(selectedState!.id);
            } else {
              selectedState = null;
              selectedDistrict = null;
            }
          }
        }
        if (state is FetchDistrictsSuccessState) {
          _districts.clear();
          _districts.addAll(state.districts);
          if (selectedDistrict != null && isEdit) {
            if (!_districts.contains(selectedDistrict)) {
              selectedDistrict = null;
            }
          }
        }
        if (state is UpdateSelectedState) {
          selectedState = state.state;
          widget.bloc.fetchDistricts(selectedState!.id);
        }
        if (state is UpdateSelectedDistrict) {
          selectedDistrict = state.district;
        }
      },
      buildWhen: (previous, current) {
        return current is AddOrganisationFailedState ||
            current is AddOrganisationSuccessState ||
            current is AddOrganisationLoadingState;
      },
      builder: (context, state) {
        return Container(
          width: 400,
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Material(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        "${isEdit ? "Update" : "Add"} Organisation",
                        style: AppTextStyle.f18PoppinsBluew600,
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Image",
                    style: AppTextStyle.f16OutfitGreyW500,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final img = await ImagePickerWeb.getImageInfo();
                      if (img != null) {
                        setState(() {
                          selectedFile = img;
                        });
                      }
                    },
                    child: Container(
                      height: 150,
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: AppColors.kGrey100,
                          borderRadius: BorderRadius.circular(12)),
                      alignment: Alignment.center,
                      child: selectedFile != null
                          ? Image.memory(selectedFile!.data!)
                          : widget.organisation?.image != null
                              ? CachedNetworkImage(
                                  imageUrl: widget.organisation!.image!)
                              : CustomElevatedButton(
                                  width: 180,
                                  onPressed: () async {
                                    final img =
                                        await ImagePickerWeb.getImageInfo();
                                    if (img != null) {
                                      setState(() {
                                        selectedFile = img;
                                      });
                                    }
                                  },
                                  backgroundColor: AppColors.kWhite,
                                  textColor: AppColors.kBlack,
                                  label: "+ Add Image"),
                    ),
                  ),
                  if (errMsg != null)
                    Text(
                      errMsg!,
                      style: AppTextStyle.f12RedAccentW500,
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    textEditingController: nameController,
                    hint: "Organisation Name",
                    validation: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter Organisation Name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<AdminCategoryCubit, AdminCategoryState>(
                    buildWhen: (previous, current) =>
                        current is FetchStatesSuccessState ||
                        current is FetchStatesFailedState ||
                        current is UpdateSelectedState ||
                        current is FetchStatesLoadingState,
                    bloc: widget.bloc,
                    builder: (context, state) {
                      return CustomDropDown<StateModel>(
                          label: "Select State",
                          selectedValue: selectedState,
                          items: _states,
                          onChanged: (value) {
                            widget.bloc.selectState(value!);
                          },
                          labelFormat: (value) {
                            return value.name;
                          });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<AdminCategoryCubit, AdminCategoryState>(
                    buildWhen: (previous, current) =>
                        current is FetchDistrictsSuccessState ||
                        current is FetchDistrictsFailedState ||
                        current is UpdateSelectedDistrict ||
                        current is FetchDistrictsLoadingState,
                    bloc: widget.bloc,
                    builder: (context, state) {
                      return CustomDropDown<DistrictModel>(
                          label: "Select District",
                          selectedValue: selectedDistrict,
                          items: _districts,
                          onChanged: (value) {
                            widget.bloc.selectDistrict(value!);
                          },
                          labelFormat: (value) {
                            return value.name;
                          });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  state is AddCategoryLoadingState ||
                          state is AddSubCategoryLoadingState
                      ? const LoadingAnimation()
                      : CustomElevatedButton(
                          width: double.maxFinite,
                          label: isEdit ? "Update" : "Add",
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          onPressed: () async {
                            errMsg = null;

                            if (widget.organisation?.image == null &&
                                selectedFile == null) {
                              errMsg = "Please add image";
                              widget.bloc.showErrorMessage(
                                  AddOrganisationFailedState(errMsg!));
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              if (isEdit) {
                                widget.bloc.updateOrganisation(
                                    nameController.text,
                                    organisationId: widget.organisation!.id,
                                    image: selectedFile,
                                    state: selectedState,
                                    district: selectedDistrict);
                              } else {
                                widget.bloc.addOrganisation(nameController.text,
                                    image: selectedFile!,
                                    state: selectedState,
                                    district: selectedDistrict);
                              }
                            }
                          })
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
