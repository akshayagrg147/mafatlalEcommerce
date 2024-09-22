import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/custom_textfield.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_products/bloc/admin_product_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_products/bloc/admin_product_state.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/organisation_model.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/subcategory_model.dart';
import 'package:mafatlal_ecommerce/features/admin_products/presentation/widgets/custom_searchable_dropdown.dart';

class ProductAddUpdateScreen extends StatefulWidget {
  const ProductAddUpdateScreen({super.key});

  @override
  State<ProductAddUpdateScreen> createState() => _ProductAddUpdateScreenState();
}

class _ProductAddUpdateScreenState extends State<ProductAddUpdateScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Organisation> organizations = [];

  final List<SubCategory> subCategories = [];

  Organisation? selectedOrganisation;

  SubCategory? selectedSubCategory;

  @override
  void initState() {
    context.read<AdminProductCubit>().fetchOrganizations();
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

        if (state is UpdateSelectedOrganisationState) {
          selectedOrganisation = state.organisation;
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
                SizedBox(
                  height: 40,
                ),
                productForm()
              ]),
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
          Container(
            height: 200,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: AppColors.kGrey100,
                borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: CustomElevatedButton(
                width: 180,
                onPressed: () {},
                backgroundColor: AppColors.kWhite,
                textColor: AppColors.kBlack,
                label: "+ Add Image"),
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
          BlocBuilder<AdminProductCubit, AdminProductState>(
              buildWhen: (previous, current) =>
                  current is UpdateSelectedOrganisationState ||
                  current is FetchOrganisationsLoadingState ||
                  current is FetchOrganisationsSuccessState ||
                  current is FetchOrganisationsErrorState,
              builder: (context, state) {
                return CustomSearchableDropdown<Organisation>(
                    items: organizations,
                    selectedItem: selectedOrganisation,
                    label: (Organisation o) => o.name,
                    searchHintText: "Search Organisation by name",
                    hintText: "Organisation",
                    onChanged: (Organisation? value) {
                      context
                          .read<AdminProductCubit>()
                          .updateSelectedOrganisation(value!);
                    });
              })
        ],
      ),
    );
  }
}
