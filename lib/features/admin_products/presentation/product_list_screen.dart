import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_products/bloc/admin_product_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_products/bloc/admin_product_state.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/admin_product.dart';
import 'package:mafatlal_ecommerce/features/admin_products/presentation/product_add_update_screen.dart';
import 'package:mafatlal_ecommerce/features/admin_products/presentation/widgets/product_table_tile.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<AdminProduct> products = [];
  int page = 1;
  @override
  void initState() {
    context.read<AdminProductCubit>().getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(12, 30, 12, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Products",
                style: AppTextStyle.f18OutfitBlackW500,
              ),
              CustomElevatedButton(
                  backgroundColor: AppColors.kBlack,
                  textStyle: AppTextStyle.f14WhiteW500,
                  width: 160,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return const ProductAddUpdateScreen();
                    }));
                  },
                  label: "Add Product")
            ],
          ),
          SizedBox(
            height: 35,
          ),
          Expanded(
            child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: AppColors.kWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.7), // Shadow color with opacity
                        spreadRadius: 3, // How much the shadow spreads
                        blurRadius: 5, // Blurring effect
                        offset: Offset(0, 3), // Shadow position (x, y)
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12)),
                constraints:
                    const BoxConstraints(minHeight: 200, maxHeight: 700),
                child: BlocConsumer<AdminProductCubit, AdminProductState>(
                  listener: (context, state) {
                    if (state is FetchProductsSuccessState) {
                      products.clear();
                      products.addAll(state.products);
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is FetchProductsSuccessState ||
                      current is FetchProductsErrorState ||
                      current is FetchProductsLoadingState,
                  builder: (context, state) {
                    if (state is FetchProductsLoadingState) {
                      return const LoadingAnimation();
                    }

                    return productTable();
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget productTable() {
    return DataTable2(
        headingRowColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return AppColors.kGrey200; // Customize heading row color here
          },
        ),
        minWidth: 1000,
        fixedLeftColumns: 1,
        columns: [
          DataColumn2(
              label: Center(child: Text('Product')),
              size: ColumnSize.S,
              fixedWidth: 350),
          DataColumn2(label: Text('Size'), size: ColumnSize.S, fixedWidth: 250),
          DataColumn2(
            label: Text('Organisation'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Subcategory'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Price'),
            size: ColumnSize.S,
          ),
        ],
        rows: List<DataRow2>.generate(
            products.length,
            (index) => DataRow2(
                    specificRowHeight: 60,
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => OrderDetailsScreen(
                      //             orderId: orders[index].orderId)));
                    },
                    cells: [
                      DataCell(
                        ProductTableTile(
                          product: products[index],
                        ),
                      ),
                      DataCell(
                        Text(
                          (products[index].variant?.variantOptions ?? [])
                              .map((e) => e.name)
                              .join(",\t\t"),
                          style: AppTextStyle.f14OutfitGreyW500,
                        ),
                      ),
                      DataCell(
                        Text(
                          products[index].categoryName ?? "--",
                          style: AppTextStyle.f14OutfitGreyW500,
                        ),
                      ),
                      DataCell(
                        Text(
                          products[index].subCategoryName ?? "--",
                          style: AppTextStyle.f14OutfitGreyW500,
                        ),
                      ),
                      DataCell(
                        Text(
                          "₹${products[index].price}",
                          style: AppTextStyle.f14OutfitBlackW500,
                        ),
                      ),
                    ])));
  }
}
