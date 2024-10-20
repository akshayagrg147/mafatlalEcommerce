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
import 'package:mafatlal_ecommerce/features/admin_products/presentation/widgets/custom_searchable_dropdown.dart';
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

  StateModel nullState = StateModel(id: -1, name: "Select State");
  DistrictModel nullDistrict = DistrictModel(
      id: -1, name: "Select District", stateId: -1, stateName: "Select State");

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
          _states.add(nullState);
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
          _districts.add(nullDistrict);
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
                      return CustomSearchableDropdown<StateModel>(
                          width: double.maxFinite,
                          items: _states,
                          selectedItem: selectedState,
                          label: (StateModel o) => o.name,
                          searchHintText: "Search State by name",
                          hintText: "Select State",
                          onChanged: (StateModel? value) {
                            widget.bloc.selectState(value!);
                          });
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
                      return CustomSearchableDropdown<DistrictModel>(
                          width: double.maxFinite,
                          items: _districts,
                          selectedItem: selectedDistrict,
                          label: (DistrictModel o) => o.name,
                          searchHintText: "Search District by name",
                          hintText: "Select District",
                          onChanged: (DistrictModel? value) {
                            widget.bloc.selectDistrict(value!);
                          });
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

                            // if (widget.organisation?.image == null &&
                            //     selectedFile == null) {
                            //   errMsg = "Please add image";
                            //   widget.bloc.showErrorMessage(
                            //       AddOrganisationFailedState(errMsg!));
                            //   return;
                            // }
                            if (_formKey.currentState!.validate()) {
                              if (isEdit) {
                                widget.bloc.updateOrganisation(
                                    nameController.text,
                                    organisationId: widget.organisation!.id,
                                    state: selectedState,
                                    district: selectedDistrict);
                              } else {
                                widget.bloc.addOrganisation(nameController.text,
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
