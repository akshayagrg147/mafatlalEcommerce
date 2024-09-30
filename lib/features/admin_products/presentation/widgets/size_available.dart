import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/components/custom_textfield.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/admin_product.dart';

class SizeAvailable extends StatefulWidget {
  final List<AdminVariantOption> sizes;
  const SizeAvailable({super.key, required this.sizes});

  @override
  State<SizeAvailable> createState() => _SizeAvailableState();
}

class _SizeAvailableState extends State<SizeAvailable> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sizes :",
                style: AppTextStyle.f16OutfitGreyW500,
              ),
              IconButton(
                onPressed: () {
                  widget.sizes.add(AdminVariantOption(name: '', price: 0));
                  setState(() {});
                },
                icon: const Icon(
                  Icons.add,
                  size: 30,
                ),
                color: AppColors.kBlack,
              )
            ],
          ),
          const SizedBox(
            height: 7,
          ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(color: AppColors.kGrey400),
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.kGrey400),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Size",
                      style: AppTextStyle.f16OutfitGreyW500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Price",
                      style: AppTextStyle.f16OutfitGreyW500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Actions",
                      style: AppTextStyle.f16OutfitGreyW500,
                    ),
                  ),
                ],
              ),
              ...widget.sizes.mapIndexed(
                (index, e) => TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomTextField(
                      height: 50,
                      cursorHeight: 15,
                      textEditingController:
                          TextEditingController(text: e.name),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      borderRadius: 5,
                      onChanged: (value) {
                        widget.sizes[index].name = value.toString();
                      },
                      validation: (value) {
                        if (value!.isEmpty) {
                          return "Size is Required";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomTextField(
                      height: 50,
                      cursorHeight: 15,
                      textEditingController:
                          TextEditingController(text: e.price.toString()),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      borderRadius: 5,
                      textStyle: AppTextStyle.f12OutfitBlackW500,
                      onChanged: (value) {
                        widget.sizes[index].price = int.parse(value.toString());
                      },
                      validation: (value) {
                        if (value!.isEmpty) {
                          return "Price is Required";
                        }
                        if (int.tryParse(value) == null) {
                          return "Invalid Price";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    child: IconButton(
                      onPressed: () {
                        widget.sizes.removeAt(index);
                        setState(() {});
                      },
                      icon: Icon(Icons.close),
                      color: AppColors.kRed,
                    ),
                  )
                ]),
              )
            ],
          )
        ],
      ),
    );
  }
}
