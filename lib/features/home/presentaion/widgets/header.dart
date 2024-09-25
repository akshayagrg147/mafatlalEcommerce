import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/cart_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/search_field.dart';

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late HomeCubit homeCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeCubit = BlocProvider.of<HomeCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.kBlack.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20,
              runSpacing: 16,
              children: [
                // Logo
                Image.asset(
                  AssetPath.logo1,
                  fit: BoxFit.fitHeight,
                  height: 40,
                ),
                // Search field
                if (constraints.maxWidth > 600)
                  SizedBox(
                    width: constraints.maxWidth > 800 ? 600 : 350,
                    child: SearchInput(
                      textController: CubitsInjector.homeCubit.searchController,
                      hintText: "Search here",
                    ),
                  ),
                // Right-side items
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 15,
                    runSpacing: 12,
                    children: [
                      ...headerItems(constraints),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> headerItems(BoxConstraints constraints) {
    return [
      _textWithDownArrow('Uniform'),
      CustomElevatedButton(
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        onPressed: () {
          Navigator.pushNamed(context, LoginScreen.route);
        },
        backgroundColor: AppColors.kBlack,
        textColor: AppColors.kWhite,
        label: "Login",
      ),
      CartIcons(),
      if (CubitsInjector.authCubit.currentUser == null)
        const SizedBox.shrink()
      else
        UserButton(),
    ];
  }

  Widget CartIcons() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, CartScreen.route);
        },
        child: Container(
          padding: const EdgeInsets.all(4),
          child: const Icon(
            Icons.shopping_cart,
            size: 24,
            color: AppColors.kGrey,
          ),
        ),
      ),
    );
  }

  Widget _textWithDownArrow(String label) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PopupMenuButton<String>(
        onSelected: (selectedCategoryName) {
          print(selectedCategoryName);
          var category =
              CubitsInjector.homeCubit.storeData!.categories.firstWhere(
            (cat) => cat.name == selectedCategoryName,
            orElse: () =>
                Category_new(id: 0, name: "", img: "", subCategories: []),
          );
          homeCubit.UpdateSubCategory(
              category.subCategories, selectedCategoryName);
        },
        itemBuilder: (BuildContext context) {
          var categories = CubitsInjector.homeCubit.storeData!.categories;

          return categories.map((category) {
            return PopupMenuItem<String>(
              value: category.name, // Assuming category has a 'name' field
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                child: Text(
                  category.name,
                  style: AppTextStyle.f16BlackW400,
                ),
              ),
            );
          }).toList();
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) => current is UpdateLabelSuccessState,
          builder: (context, state) {
            if (state is UpdateLabelSuccessState) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      state.selectedCategoryName,
                      style: AppTextStyle.f16BlackW400,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                    size: 24,
                  ),
                ],
              );
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    label,
                    style: AppTextStyle.f16BlackW400,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                  size: 24,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget UserButton() {
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      shadowColor: AppColors.kBlack.withOpacity(.3),
      surfaceTintColor: AppColors.kWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.kGrey200, width: 1),
      ),
      color: AppColors.kWhite,
      elevation: 3,
      offset: const Offset(25, 10),
      onSelected: (value) {
        if (value == 'Your Orders') {
          // Navigate to orders history
        } else if (value == 'Logout') {
          CubitsInjector.authCubit.logOut();
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            value: 'Your Orders',
            child: Text('Your Orders'),
          ),
          const PopupMenuItem(
            value: 'Logout',
            child: Text('Logout'),
          ),
        ];
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.kblue,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              CubitsInjector.authCubit.currentUser == null
                  ? 'demo'
                  : CubitsInjector.authCubit.currentUser!.fullName.toString(),
              style: AppTextStyle.f12WhiteW500,
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
