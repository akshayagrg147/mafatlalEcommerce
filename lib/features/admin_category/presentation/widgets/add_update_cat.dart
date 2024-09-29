import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/custom_textfield.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_state.dart';
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_cat_model.dart';
import 'package:mafatlal_ecommerce/helper/toast_utils.dart';

class AddUpdateCat extends StatefulWidget {
  final AdminCategory? category;
  final AdminCategory? subCategory;
  final bool isCategory;
  final AdminCategoryCubit bloc;

  const AddUpdateCat.category({super.key, this.category, required this.bloc})
      : subCategory = null,
        isCategory = true;

  const AddUpdateCat.subCategory(
      {this.category, super.key, this.subCategory, required this.bloc})
      : isCategory = false;

  @override
  State<AddUpdateCat> createState() => _AddUpdateCatState();
}

class _AddUpdateCatState extends State<AddUpdateCat> {
  bool isEdit = false;
  final nameController = TextEditingController();
  XFile? selectedFile;
  String? errMsg;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.category != null && widget.isCategory) {
      isEdit = true;
      nameController.text = widget.category!.name;
    } else if (widget.subCategory != null && !widget.isCategory) {
      isEdit = true;
      nameController.text = widget.subCategory!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCategoryCubit, AdminCategoryState>(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is AddCategoryFailedState ||
            state is AddSubCategoryFailedState) {
          errMsg = (state as dynamic).message;
        }
        if (state is AddCategorySuccessState ||
            state is AddSubCategorySuccessState) {
          Navigator.pop(context);
          ToastUtils.showSuccessToast(
              "${widget.isCategory ? "Category" : "Sub Category"} Added Successfully");
        }
      },
      buildWhen: (previous, current) {
        return current is AddCategoryFailedState ||
            current is AddCategorySuccessState ||
            current is AddCategoryLoadingState;
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
                        "${isEdit ? "Update" : "Add"} ${widget.isCategory ? "Category" : "Sub Category"}",
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
                      final img = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
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
                          ? Image.network(selectedFile!.path)
                          : widget.isCategory && widget.category?.image != null
                              ? CachedNetworkImage(
                                  imageUrl: widget.category!.image)
                              : !widget.isCategory &&
                                      widget.subCategory?.image != null
                                  ? CachedNetworkImage(
                                      imageUrl: widget.subCategory!.image)
                                  : CustomElevatedButton(
                                      width: 180,
                                      onPressed: () async {
                                        final img = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
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
                    hint:
                        "${widget.isCategory ? "Category" : "Sub Category"} Name",
                    validation: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter ${widget.isCategory ? "Category" : "Sub Category"} Name";
                      }
                      return null;
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
                            if (widget.isCategory) {
                              if ((widget.category?.image != null ||
                                  selectedFile != null)) {
                                if (_formKey.currentState!.validate()) {
                                  if (isEdit) {
                                    widget.bloc.updateCategory(
                                        nameController.text,
                                        categoryId: widget.category!.id,
                                        img: widget.category!.image,
                                        image: selectedFile);
                                  } else {
                                    widget.bloc.addCategory(nameController.text,
                                        image: selectedFile!);
                                  }
                                }
                              } else {
                                errMsg = "Please add image";
                                setState(() {});
                                return;
                              }
                            } else {
                              if ((widget.subCategory?.image != null ||
                                  selectedFile != null)) {
                                if (_formKey.currentState!.validate()) {
                                  if (isEdit) {
                                    widget.bloc.updateSubCategory(
                                        nameController.text,
                                        subCategoryId: widget.subCategory!.id,
                                        image: selectedFile,
                                        img: widget.subCategory!.image);
                                  } else {
                                    widget.bloc.addSubCategory(
                                        widget.category!.id,
                                        name: nameController.text,
                                        image: selectedFile!);
                                  }
                                }
                              } else {
                                errMsg = "Please add image";
                                setState(() {});
                                return;
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
