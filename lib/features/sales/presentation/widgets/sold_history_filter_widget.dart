import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/date_range_selection_field_widget.dart';
import 'package:amar_pos/features/sales/presentation/controller/sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/reusable/filter_bottom_sheet/filter_controller.dart';
import '../../../../core/widgets/reusable/filter_bottom_sheet/product_brand_category_warranty_unit_response_model.dart';
import '../../../inventory/presentation/products/widgets/custom_drop_down_widget.dart';

class SoldHistoryFilterBottomSheet extends StatefulWidget {
  final bool saleHistory;
  final FilterItem? selectedBrand;
  final FilterItem? selectedCategory;

  SoldHistoryFilterBottomSheet({
    super.key,
    required this.saleHistory,
    required this.selectedBrand,
    required this.selectedCategory,
  });

  @override
  State<SoldHistoryFilterBottomSheet> createState() =>
      _ProductListFilterBottomSheetState();
}

class _ProductListFilterBottomSheetState
    extends State<SoldHistoryFilterBottomSheet> {
  SalesController controller = Get.find();
  FilterController _controller = Get.put(FilterController());

  FilterItem? brand;
  FilterItem? category;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    brand = widget.selectedBrand;
    category = widget.selectedCategory;
    if (_controller.productBrandCategoryWarrantyUnitListResponseModel == null) {
      _controller.getCategoriesBrandWarrantyUnits();
    }
    controller.update(['selected_b_C']);
    _controller.update(['category_dd', 'brand_dd']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: GetBuilder<SalesController>(
                id: 'filter_list',
                builder: (context) {
                  return Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 4,
                          width: 40,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Visibility(
                              visible: true,
                              child: TextButton(
                                onPressed: null,
                                child: const Text(
                                  "",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: const Text(
                                "Filter",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                style: const ButtonStyle(
                                    foregroundColor:
                                        WidgetStatePropertyAll(Colors.red)),
                                onPressed: () {
                                  setState(() {
                                    controller.clearFilter();
                                  });
                                },
                                child: const Text(
                                  "Clear",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        addH(10),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Column(
                              children: [
                                CustomDateRangeSelectionFieldWidget(
                                  noInputBorder: true,
                                  fontSize: 14,
                                  onDateRangeSelection:
                                      controller.setSelectedDateRange,
                                  initialDate:
                                      controller.selectedDateTimeRange.value,
                                ),
                                Divider(
                                  height: 4,
                                  color: Color(0xffB1B1B1),
                                  thickness: .5,
                                ),
                                addH(8),
                                GetBuilder<SalesController>(
                                  id: 'filter_view',
                                  builder: (controller) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Retail Sals",
                                              style: TextStyle(
                                                  color: Color(0xff7C7C7C),
                                                  fontSize: 14),
                                            ),
                                            addW(20),
                                            Checkbox(
                                                value: controller.retailSale,
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    controller.retailSale =
                                                        value;
                                                    controller.update(
                                                        ['filter_view']);
                                                  }
                                                })
                                          ],
                                        ),
                                      ),
                                      addW(20),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Wholesale",
                                              style: TextStyle(
                                                  color: Color(0xff7C7C7C),
                                                  fontSize: 14),
                                            ),
                                            addW(20),
                                            Checkbox(
                                                value: controller.wholeSale,
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    controller.wholeSale =
                                                        value;
                                                    controller.update(
                                                        ['filter_view']);
                                                  }
                                                })
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 4,
                                  color: Color(0xffB1B1B1),
                                  thickness: .5,
                                ),
                                addH(8),
                                if(!widget.saleHistory)GetBuilder<FilterController>(
                                    id: 'brand_dd',
                                    builder: (fController) {
                                      return CustomDropdownWithSearchWidget<
                                          FilterItem>(
                                        items: fController.brands,
                                        isMandatory: false,
                                        title: "Brand",
                                        filled: true,
                                        // noTitle: true,
                                        itemLabel: (value) => value.name ?? '',
                                        value: brand,
                                        onChanged: (value) {
                                          brand = value;
                                          controller.brand = brand;
                                          fController.update(['brand_dd','selected_b_C']);
                                        },
                                        hintText: fController.loading
                                            ? "Loading..."
                                            : fController.brands.isEmpty
                                                ? "No brand found..."
                                                : "Select Brand",
                                        searchHintText: "Search a brand",
                                      );
                                    }),
                                if(!widget.saleHistory)addH(8),
                                if(!widget.saleHistory)GetBuilder<FilterController>(
                                    id: 'category_dd',
                                    builder: (fController) {
                                      return CustomDropdownWithSearchWidget<
                                          FilterItem>(
                                        items: fController.categories,
                                        isMandatory: false,
                                        filled: true,
                                        title: "Category",
                                        // noTitle: true,
                                        itemLabel: (value) => value.name ?? '',
                                        value: category,
                                        onChanged: (value) {
                                          category = value;
                                          controller.category = value;
                                          fController.update(['category_dd','selected_b_C']);
                                        },
                                        hintText: fController.loading
                                            ? "Loading..."
                                            : fController.categories.isEmpty
                                                ? "No categories found..."
                                                : "Select Category",
                                        searchHintText: "Search a category",
                                      );
                                    }),
                                if(!widget.saleHistory)GetBuilder<FilterController>(
                                  id: 'selected_b_C',
                                  builder: (fController) => Column(
                                    children: [
                                      addH(8),
                                      Wrap(
                                        runSpacing: 8,
                                        spacing: 8,
                                        children: [
                                          if (brand != null)
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: AppColors
                                                          .inputBorderColor),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(brand?.name ?? ''),
                                                  addW(8),
                                                  GestureDetector(
                                                      onTap: () {
                                                        brand = null;
                                                        controller.brand = null;
                                                        controller.update([
                                                          'filter_list',
                                                          'selected_b_C'
                                                        ]);
                                                        fController.update(
                                                            ['brand_dd']);
                                                      },
                                                      child: Icon(
                                                        Icons.cancel_outlined,
                                                        color: AppColors.error,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          if (category != null)
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: AppColors
                                                          .inputBorderColor),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(category?.name ?? ''),
                                                  addW(8),
                                                  GestureDetector(
                                                      onTap: () {
                                                        category = null;
                                                        controller.category = null;
                                                        fController.update([
                                                          'filter_list',
                                                          'selected_b_C'
                                                        ]);
                                                        fController.update(
                                                            ['category_dd']);
                                                      },
                                                      child: Icon(
                                                        Icons.cancel_outlined,
                                                        color: AppColors.error,
                                                      ))
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        addH(20),
                        CustomButton(
                          text: "Apply",
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              Get.back();
                              if (widget.saleHistory) {
                                controller.getSoldHistory();
                              } else {
                                controller.getSoldProducts();
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
