import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/cart_btn.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/search_field.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onMenuTap;

  @override
  final Size preferredSize;

  HomeAppBar({Key? key, this.onMenuTap})
      : preferredSize = Size.fromHeight(65),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      toolbarHeight: 65,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
        onTap: onMenuTap,
        child: Icon(
          Icons.menu,
          color: AppColors.kGrey,
          size: 40,
        ),
      ),
      title: Container(
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        child: SearchInput(
          textController: CubitsInjector.homeCubit.searchController,
          hintText: "Search here",
        ),
      ),
      actions: [
        const CartBtn(),
        SizedBox(
          width: 15,
        )
      ],
    );
  }
}
