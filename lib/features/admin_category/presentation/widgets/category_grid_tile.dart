import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_cat_model.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/widgets/add_update_cat.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/widgets/show_delete_confirmation_dialog.dart';

class CategoryGridTile extends StatelessWidget {
  final bool isCategory;
  final AdminCategory data;

  const CategoryGridTile.category({super.key, required this.data})
      : isCategory = true;

  const CategoryGridTile.subCategory({super.key, required this.data})
      : isCategory = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        border: Border.all(color: AppColors.kGrey200),
      ),
      padding: EdgeInsets.all(12),
      child: Stack(
        children: [
          SizedBox.expand(
            child: Column(
              children: [
                Expanded(
                    flex: 5,
                    child: CachedNetworkImage(
                      imageUrl: data.image ?? '',
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, color: AppColors.kBlack),
                    )),
                SizedBox(
                  height: 10,
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: Text(
                    data.name ?? '',
                    maxLines: 2,
                    style: AppTextStyle.f16OutfitBlackW500,
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    final bloc = BlocProvider.of<AdminCategoryCubit>(context);
                    final widget = isCategory
                        ? AddUpdateCat.category(
                            bloc: bloc,
                            category: data,
                          )
                        : AddUpdateCat.subCategory(
                            bloc: bloc,
                            subCategory: data,
                          );
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Center(
                            child: widget,
                          );
                        });
                  },
                  icon: const Icon(Icons.edit),
                  color: AppColors.kGreen,
                ),
                IconButton(
                  onPressed: () {
                    ShowDeleteConfirmation.show(context,
                        data: data, isCategory: isCategory, onDeleteTap: () {
                      isCategory
                          ? BlocProvider.of<AdminCategoryCubit>(context)
                              .deleteCategory(data.id)
                          : BlocProvider.of<AdminCategoryCubit>(context)
                              .deleteSubCategory(data.id);
                    });
                  },
                  icon: const Icon(Icons.delete),
                  color: AppColors.kRed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
