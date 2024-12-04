import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';

class ExpandableCategoryDropdown extends StatefulWidget {
  @override
  _ExpandableCategoryDropdownState createState() =>
      _ExpandableCategoryDropdownState();
}

class _ExpandableCategoryDropdownState
    extends State<ExpandableCategoryDropdown> {
  bool isExpanded = false;
  late List<Category_new> categories;

  @override
  void initState() {
    super.initState();
    categories = CubitsInjector.homeCubit.storeData?.categories ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is FetchStoreDataSuccessState ||
          current is UpdateLabelSuccessState,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.category_outlined,
                    color: AppColors.kBlack,
                    size: 30,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      CubitsInjector.homeCubit.selectedCategory?.name ?? "",
                      style: AppTextStyle.f16BlackW400,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                ],
              ),
            ),
            if (isExpanded)
              Container(
                margin: EdgeInsets.only(left: 30),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () => CubitsInjector.homeCubit
                            .updateSelectedCategory(category: category),
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color:
                                  CubitsInjector.homeCubit.selectedCategory ==
                                          category
                                      ? AppColors.kWhite
                                      : Colors.transparent),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Text(
                            category.name,
                            style: AppTextStyle.f16BlackW400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      },
    );
  }
}
