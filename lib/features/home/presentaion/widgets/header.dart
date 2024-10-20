import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/cart_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/home_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/order_history.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/search_field.dart';
import 'package:mafatlal_ecommerce/services/navigation_service.dart';
import 'package:url_launcher/url_launcher.dart';

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    homeCubit = BlocProvider.of<HomeCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          color: AppColors.lightGray,
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _launchPhone, // Makes phone number clickable
                  child: const Icon(
                    Icons.phone,
                    color: AppColors.kBlack,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _launchPhone, // Makes phone number clickable
                  child: Text(
                    '+91-22-6771 3800',
                    style: AppTextStyle.f14RobotoDarkgrayW500,
                  ),
                ),
              ),
              const SizedBox(width: 28),
              GestureDetector(
                onTap: _launchEmail, // Makes email clickable
                child: const Icon(
                  Icons.email,
                  color: AppColors.kBlack,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _launchEmail, // Makes email clickable
                  child: Text('technology@mafatlals.com',
                      style: AppTextStyle.f14RobotoDarkgrayW500),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 48),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Logo and Search
              GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.route, (route) => false);
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Image.asset(
                    AssetPath.logo1,
                    fit: BoxFit.fitHeight,
                    height: 70,
                  ),
                ),
              ),
              const SizedBox(width: 35), // Space between logo and search
              Container(
                width: 380,
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                child: SearchInput(
                  textController: CubitsInjector.homeCubit.searchController,
                  hintText: "Search here",
                ),
              ),
              const Spacer(),
              _textWithDownArrow(),
              const SizedBox(width: 20),
              if (CubitsInjector.authCubit.currentUser == null)
                CustomElevatedButton(
                  width: 150,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.route);
                  },
                  backgroundColor: AppColors.kBlack,
                  textColor: AppColors.kWhite,
                  label: "Login",
                )
              else
                const SizedBox(width: 10),
              // Space between login button and cart
              if (CubitsInjector.authCubit.currentUser == null)
                const SizedBox.shrink()
              else
                UserButton(),
              CartIcons(),

              // Menu and Cart Icons
            ],
          ),
        ),
      ],
    );
  }

  Widget CartIcons() {
    if (NavigationService.getCurrentRouteName() == CartScreen.route) {
      return const SizedBox.shrink();
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, CartScreen.route);
        },
        child: Container(
          height: 35,
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              const Icon(
                Icons.shopping_cart,
                size: 24,
                color: AppColors.kGrey,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: StreamBuilder<BoxEvent>(
                    stream: CartHelper.watchCart(),
                    builder: (context, eventSnapshot) {
                      final quantity = CartHelper.getAllProductQuantity();
                      if (quantity == 0) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: AppColors.kRed, shape: BoxShape.circle),
                        child: Text(
                          NumberFormat.compact().format(quantity),
                          style: AppTextStyle.f10WhiteW600,
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textWithDownArrow() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PopupMenuButton<String>(
        color: AppColors.kWhite,
        surfaceTintColor: AppColors.kWhite,
        onSelected: (selectedCategoryName) {
          var category =
              CubitsInjector.homeCubit.storeData!.categories.firstWhere(
            (cat) => cat.name == selectedCategoryName,
            orElse: () =>
                Category_new(id: 0, name: "", img: "", subCategories: []),
          );
          homeCubit.UpdateSubCategory(
              category.subCategories, selectedCategoryName);
          homeCubit.UpdateproductAccordingtoCategory(category.id);
        },
        itemBuilder: (BuildContext context) {
          var categories = CubitsInjector.homeCubit.storeData!.categories;
          return categories.map((category) {
            return PopupMenuItem<String>(
              value: category.name,
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
          buildWhen: (previous, current) =>
              current is UpdateLabelSuccessState ||
              current is FetchStoreDataSuccessState,
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
                    homeCubit.storeData?.categories.first.name ?? '',
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
          Navigator.pushNamed(context, OrdersHistory.route);
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

  void _launchPhone() async {
    const phoneUrl = 'tel:+91-22-6771-3800';
    if (await canLaunchUrl(Uri.parse(phoneUrl))) {
      await launchUrl(Uri.parse(phoneUrl));
    } else {
      throw 'Could not launch $phoneUrl';
    }
  }

  // Function to launch email
  void _launchEmail() async {
    const emailUrl = 'mailto:technology@mafatlals.com';
    if (await canLaunchUrl(Uri.parse(emailUrl))) {
      await launchUrl(Uri.parse(emailUrl));
    } else {
      throw 'Could not launch $emailUrl';
    }
  }
}
