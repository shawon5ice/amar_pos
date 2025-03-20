import 'package:amar_pos/core/methods/helper_methods.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/core/widgets/reusable/filter_bottom_sheet/filter_controller.dart';
import 'package:amar_pos/core/widgets/reusable/filter_bottom_sheet/product_brand_category_warranty_unit_response_model.dart';
import 'package:amar_pos/core/widgets/reusable/outlet_dd/outlet_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import '../../../constants/app_colors.dart';
import '../../../data/model/outlet_model.dart';

class SimpleFilterBottomSheetWidget extends StatefulWidget {
  SimpleFilterBottomSheetWidget({
    super.key,
    required this.selectedBrand,
    required this.selectedCategory,
    required this.selectedDateTimeRange,
    required this.onSubmit,
    this.disableDateTime,
    this.disableOutlet,
    this.selectedOutlet,
  });

  FilterItem? selectedBrand;
  bool? disableDateTime;
  bool? disableOutlet;
  FilterItem? selectedCategory;
  OutletModel? selectedOutlet;
  DateTimeRange? selectedDateTimeRange;
  Function(FilterItem? selectedBrand, FilterItem? selectedCategory,
      DateTimeRange? selectedDateTimeRange, OutletModel? selectedOutlet) onSubmit;

  @override
  State<SimpleFilterBottomSheetWidget> createState() =>
      _SimpleFilterBottomSheetWidgetState();
}

class _SimpleFilterBottomSheetWidgetState
    extends State<SimpleFilterBottomSheetWidget> {
  final FilterController _controller = Get.put(FilterController());

  late TextEditingController _dateTimeController;

  @override
  void initState() {
    _dateTimeController = TextEditingController();
    if (_controller.productBrandCategoryWarrantyUnitListResponseModel == null) {
      _controller.getCategoriesBrandWarrantyUnits();
    }

    brand = widget.selectedBrand;
    category = widget.selectedCategory;
    outlet = widget.selectedOutlet;
    _controller.selectedDateTimeRange.value = widget.selectedDateTimeRange;
    if(widget.selectedDateTimeRange != null){
      _dateTimeController.text = "${formatDate(widget.selectedDateTimeRange!.start)} - ${formatDate(widget.selectedDateTimeRange!.end)}";
    }
    super.initState();
  }

  FilterItem? brand;
  FilterItem? category;
  OutletModel? outlet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
        MediaQuery.of(context).viewInsets.bottom, // Adjusts for keyboard
      ),
      child: SingleChildScrollView(
        child: GetBuilder<FilterController>(
            id: 'filter_list',
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Text(
                        "Filter",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if(widget.disableDateTime == null)Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldTitle('Date Range'),
                        addH(4),
                        GetBuilder<FilterController>(
                            id: 'date_time',
                            builder: (controller) {
                              return CustomTextField(
                                  readOnly: true,
                                  onTap: () async {
                                    DateTimeRange? selectedDate =
                                    await showDateRangePicker(
                                      context: context,
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 1000)),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 1000)),
                                      initialDateRange:
                                      controller.selectedDateTimeRange.value,
                                    );
                                    if (selectedDate != null) {
                                      controller.selectedDateTimeRange.value =
                                          selectedDate;
                                      _dateTimeController.text =
                                      "${formatDate(controller.selectedDateTimeRange.value!.start)} - ${formatDate(controller.selectedDateTimeRange.value!.end)}";
                                      controller.update(['date_time']);
                                    }
                                  },
                                  suffixWidget:
                                  controller.selectedDateTimeRange.value != null
                                      ? IconButton(
                                      onPressed: () {
                                        controller.selectedDateTimeRange.value =
                                        null;
                                        _dateTimeController.clear();
                                        controller.update(['date_time']);
                                      },
                                      icon: const Icon(
                                        Icons.cancel_outlined,
                                        color: AppColors.error,
                                      ))
                                      : IconButton(
                                    onPressed: null,
                                    icon: Icon(Icons.calendar_month_outlined),
                                  ),
                                  textCon: _dateTimeController,
                                  txtSize: 12,
                                  hintText: "Select Date Range");
                            }),
                      ],
                    ),
                    addH(8),
                    if(widget.disableOutlet == null)OutletDropDownWidget(
                        filled: true,
                        hideTitle: false,
                        onOutletSelection: (value){
                          outlet = value;

                    }),
                    addH(8),
                    GetBuilder<FilterController>(
                        id: 'brand_dd',
                        builder: (controller) {
                          return CustomDropdownWithSearchWidget<FilterItem>(
                            items: controller.brands,
                            isMandatory: false,
                            title: "Brand",
                            filled: true,
                            // noTitle: true,
                            itemLabel: (value) => value.name ?? '',
                            value: brand,
                            onChanged: (value) {
                              brand = value;
                              controller.update(['brand_dd','filter_list']);
                            },
                            hintText: controller.loading
                                ? "Loading..."
                                : controller.brands.isEmpty
                                    ? "No brand found..."
                                    : "Select Brand",
                            searchHintText: "Search a brand",
                          );
                        }),
                    addH(8),
                    GetBuilder<FilterController>(
                        id: 'category_dd',
                        builder: (controller) {
                          return CustomDropdownWithSearchWidget<FilterItem>(
                            items: controller.categories,
                            isMandatory: false,
                            filled: true,
                            title: "Category",
                            // noTitle: true,
                            itemLabel: (value) => value.name ?? '',
                            value: category,
                            onChanged: (value) {
                              category = value;
                              controller.update(['category_dd','filter_list']);
                            },
                            hintText: controller.loading
                                ? "Loading..."
                                : controller.categories.isEmpty
                                    ? "No categories found..."
                                    : "Select Category",
                            searchHintText: "Search a category",
                          );
                        }),

                    addH(12),
                    Wrap(
                      runSpacing: 8,spacing: 8,
                      children: [
                        if(brand != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                                border: Border.all(color: AppColors.inputBorderColor),
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(brand?.name ?? ''),
                                addW(8),
                                GestureDetector(
                                    onTap: (){
                                      brand = null;
                                      controller.update(['filter_list']);
                                    },
                                    child: Icon(Icons.cancel_outlined,color: AppColors.error,))
                              ],
                            ),
                          ),
                        if(category != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: AppColors.inputBorderColor),
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(category?.name ?? ''),
                                addW(8),
                                GestureDetector(
                                    onTap: (){
                                      category = null;
                                      controller.update(['filter_list']);
                                    },
                                    child: Icon(Icons.cancel_outlined,color: AppColors.error,))
                              ],
                            ),
                          ),
                      ],
                    ),
                    addH(12),
                    CustomButton(
                      text: "Apply Filter",
                      radius: 8,
                      onTap: () {
                        // Get.back();
                        widget.onSubmit(
                          brand,
                          category,
                          controller.selectedDateTimeRange.value,
                          outlet,
                        );
                      },
                    ),
                    addH(12),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
