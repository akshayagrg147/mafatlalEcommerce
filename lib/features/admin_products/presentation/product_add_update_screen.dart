import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/custom_textfield.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_products/bloc/admin_product_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_products/bloc/admin_product_state.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/admin_product.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/organisation_model.dart';
import 'package:mafatlal_ecommerce/features/admin_products/presentation/widgets/custom_searchable_dropdown.dart';
import 'package:mafatlal_ecommerce/features/admin_products/presentation/widgets/size_available.dart';
import 'package:mafatlal_ecommerce/helper/toast_utils.dart';

class ProductAddUpdateScreen extends StatefulWidget {
  final AdminProduct? productDetails;

  const ProductAddUpdateScreen({super.key, this.productDetails});

  @override
  State<ProductAddUpdateScreen> createState() => _ProductAddUpdateScreenState();
}

class _ProductAddUpdateScreenState extends State<ProductAddUpdateScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List images = [];

  final List<DataObject> organizations = [];

  final List<DataObject> subCategories = [];
  final List<DataObject> categories = [];

  DataObject? selectedOrganisation;

  DataObject? selectedSubCategory;
  DataObject? selectedCategory;

  final List<AdminVariantOption> sizes = [];
  bool isUpdate = false;

  @override
  void initState() {
    if (widget.productDetails != null) {
      nameController.text = widget.productDetails!.productName;
      priceController.text = widget.productDetails!.price.toString();
      descriptionController.text = widget.productDetails!.description;

      isUpdate = true;
    }
    context.read<AdminProductCubit>().fetchOrganizations();
    context.read<AdminProductCubit>().fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminProductCubit, AdminProductState>(
      listener: (context, state) {
        if (state is FetchOrganisationsSuccessState) {
          organizations.clear();
          organizations.addAll(state.organisations);
        }
        if (state is FetchSubCategoriesSuccessState) {
          subCategories.clear();
          subCategories.addAll(state.subCategories);
        }
        if (state is FetchCategorySuccessState) {
          categories.clear();
          categories.addAll(state.categories);
        }

        if (state is UpdateSelectedOrganisationState) {
          selectedOrganisation = state.organisation;
        }
        if (state is UpdateSelectedCategoryState) {
          selectedCategory = state.category;
          context
              .read<AdminProductCubit>()
              .fetchSubCategories(state.category.id);
          selectedSubCategory = null;
        }
        if (state is UpdateSelectedSubCategoryState) {
          selectedSubCategory = state.subCategory;
        }
        if (state is AddProductSuccessState) {
          Navigator.pop(context, true);
          ToastUtils.showSuccessToast("Product Added Successfully");
        }
      },
      child: ResponsiveWidget(largeScreen: largeScreen()),
    );
  }

  Widget largeScreen() {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: size.width > 1000 ? 1000 : double.maxFinite,
        height: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 35,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Add Product",
                  style: AppTextStyle.f18OutfitBlackW500,
                ),
              ],
            ),
            Expanded(
              child: ListView(children: [
                const SizedBox(
                  height: 40,
                ),
                productForm()
              ]),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget productForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.kBlack.withOpacity(0.1), // Minimal shadow color
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(1, 1), // Slight offset for a subtle effect
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Image",
              style: AppTextStyle.f16OutfitGreyW500,
            ),
            const SizedBox(
              height: 7,
            ),
            BlocBuilder<AdminProductCubit, AdminProductState>(
              buildWhen: (previous, current) =>
                  current is UpdateProductImageState,
              builder: (context, state) {
                return Container(
                    height: 200,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: AppColors.kGrey100,
                        borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: images.isEmpty
                        ? addImage()
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [addImage()],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) =>
                                          imageItem(index),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                            width: 15,
                                          ),
                                      itemCount: images.length)),
                            ],
                          ));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Title",
              style: AppTextStyle.f16OutfitGreyW500,
            ),
            const SizedBox(
              height: 7,
            ),
            CustomTextField(
              hint: "Hp T-Shirt",
              textEditingController: nameController,
              validation: (value) {
                if (value?.trim().isEmpty == true) {
                  return "Product Title is Required";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Description",
              style: AppTextStyle.f16OutfitGreyW500,
            ),
            const SizedBox(
              height: 7,
            ),
            CustomTextField(
              hint: "",
              textEditingController: descriptionController,
              maxLines: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                BlocBuilder<AdminProductCubit, AdminProductState>(
                    buildWhen: (previous, current) =>
                        current is UpdateSelectedOrganisationState ||
                        current is FetchOrganisationsLoadingState ||
                        current is FetchOrganisationsSuccessState ||
                        current is FetchOrganisationsErrorState,
                    builder: (context, state) {
                      if (state is FetchOrganisationsLoadingState) {
                        return const LoadingAnimation();
                      }
                      return CustomSearchableDropdown<DataObject>(
                          items: organizations,
                          selectedItem: selectedOrganisation,
                          label: (DataObject o) => o.name,
                          searchHintText: "Search Organisation by name",
                          hintText: "Select Organisation",
                          onChanged: (DataObject? value) {
                            context
                                .read<AdminProductCubit>()
                                .updateSelectedOrganisation(value!);
                          });
                    }),
                const SizedBox(
                  width: 15,
                ),
                BlocBuilder<AdminProductCubit, AdminProductState>(
                    buildWhen: (previous, current) =>
                        current is UpdateSelectedCategoryState ||
                        current is FetchCategoryLoadingState ||
                        current is FetchCategorySuccessState ||
                        current is FetchCategoriesErrorState,
                    builder: (context, state) {
                      if (state is FetchCategoryLoadingState) {
                        return const LoadingAnimation();
                      }
                      return CustomSearchableDropdown<DataObject>(
                          items: categories,
                          selectedItem: selectedCategory,
                          label: (DataObject o) => o.name,
                          searchHintText: "Search Categories by name",
                          hintText: "Select Category",
                          onChanged: (DataObject? value) {
                            context
                                .read<AdminProductCubit>()
                                .updateSelectedCategory(value!);
                          });
                    }),
                const SizedBox(
                  width: 15,
                ),
                BlocBuilder<AdminProductCubit, AdminProductState>(
                    buildWhen: (previous, current) =>
                        current is UpdateSelectedSubCategoryState ||
                        current is FetchSubCategoriesLoadingState ||
                        current is FetchSubCategoriesSuccessState ||
                        current is FetchSubCategoriesErrorState,
                    builder: (context, state) {
                      if (state is FetchSubCategoriesLoadingState) {
                        return const LoadingAnimation();
                      }
                      return CustomSearchableDropdown<DataObject>(
                          items: subCategories,
                          selectedItem: selectedSubCategory,
                          label: (DataObject o) => o.name,
                          searchHintText: "Search SubCategories by name",
                          hintText: "Select SubCategory",
                          onChanged: (DataObject? value) {
                            context
                                .read<AdminProductCubit>()
                                .updateSelectedSubCategory(value!);
                          });
                    }),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Price",
              style: AppTextStyle.f16OutfitGreyW500,
            ),
            const SizedBox(
              height: 7,
            ),
            CustomTextField(
              width: 300,
              hint: "Enter Price",
              textEditingController: priceController,
              textInputType: TextInputType.number,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validation: (value) {
                if (value?.trim().isEmpty == true) {
                  return "Price is Required";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            SizeAvailable(sizes: sizes),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<AdminProductCubit, AdminProductState>(
                buildWhen: (previous, current) =>
                    current is AddProductLoadingState ||
                    current is AddProductErrorState,
                builder: (context, state) {
                  if (state is AddProductErrorState) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        state.message,
                        style: AppTextStyle.f14RedW500,
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),
            Center(
              child: BlocBuilder<AdminProductCubit, AdminProductState>(
                buildWhen: (previous, current) =>
                    current is AddProductLoadingState ||
                    current is AddProductSuccessState ||
                    current is AddProductErrorState,
                builder: (context, state) {
                  if (state is AddProductLoadingState) {
                    return const LoadingAnimation();
                  }
                  return CustomElevatedButton(
                      backgroundColor: AppColors.kBlack,
                      textStyle: AppTextStyle.f14WhiteW500,
                      width: 160,
                      onPressed: () {
                        if (images.isEmpty) {
                          context
                              .read<AdminProductCubit>()
                              .showError("Please add atleast one image");
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          context.read<AdminProductCubit>().addProduct(
                              name: nameController.text,
                              description: descriptionController.text,
                              images: images,
                              price: priceController.text.isEmpty
                                  ? 0
                                  : int.parse(priceController.text),
                              categoryId: selectedCategory?.id,
                              subCategoryId: selectedSubCategory?.id,
                              orgId: selectedOrganisation?.id,
                              sizes: sizes);
                        }
                      },
                      label: "${isUpdate ? "Update" : "Add"} Product");
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget imageItem(int index) {
    final img = images[index];

    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            final result = await ImagePickerWeb.getImageInfo();

            if (result != null) {
              images[index] = result;
              context.read<AdminProductCubit>().updateProductimageState();
            }
          },
          child: Container(
            width: 150,
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: img is String
                ? CachedNetworkImage(
                    imageUrl: img,
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  )
                : img is MediaInfo
                    ? Image.memory(img.data!, fit: BoxFit.cover)
                    : SizedBox.shrink(),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              images.removeAt(index);
              context.read<AdminProductCubit>().updateProductimageState();
            },
            icon: Icon(
              Icons.close,
              color: AppColors.kRed,
            ),
          ),
        )
      ],
    );
  }

  Widget addImage() {
    return CustomElevatedButton(
        width: 180,
        onPressed: () async {
          final result = await ImagePickerWeb.getImageInfo();
          if (result != null) {
            images.add(result);
            context.read<AdminProductCubit>().updateProductimageState();
          }
        },
        backgroundColor: AppColors.kWhite,
        textColor: AppColors.kBlack,
        label: "+ Add Image");
  }
}
