import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/inventory/data/products/product_brand_category_warranty_unit_list_response_model.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/field_title.dart';
import '../../../../core/widgets/methods/field_validator.dart';
import '../../../../core/widgets/qr_code_scanner.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductController controller = Get.find();

  late TextEditingController productIdController;
  late TextEditingController categoryTextEditingController;

  @override
  void initState() {
    productIdController = TextEditingController();
    categoryTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    productIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addH(16.h),
                const RichFieldTitle(
                  text: "Product Name",
                ),
                addH(8.h),
                CustomTextField(
                  textCon: TextEditingController(),
                  hintText: "Type product name...",
                  inputType: TextInputType.text,
                  validator: (value) =>
                      FieldValidator.nonNullableFieldValidator(
                          value, "Product Name",),
                ),

                addH(16.h),
                const RichFieldTitle(
                  text: "Product ID",
                ),
                addH(8.h),
                CustomTextField(
                  textCon: productIdController,
                  suffixWidget: InkWell(
                      onTap: () async {
                        final String? scannedCode = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const QRCodeScannerScreen(),
                          ),
                        );
                        if(scannedCode != null && scannedCode.isNotEmpty){
                          setState(() {
                            productIdController.text = scannedCode?? '';
                          });
                        }

                      },
                      child: const Icon(Icons.qr_code_scanner_sharp)),
                  hintText: "Scan/Type here...",
                  inputType: TextInputType.text,
                  validator: (value) =>
                      FieldValidator.nonNullableFieldValidator(
                        value, "Product ID",),
                ),

                addH(16.h),
                const RichFieldTitle(
                  text: "Category",
                ),
                addH(8.h),
                GetBuilder<ProductController>(
                  id: 'outlet_dd',
                  builder: (controller) => DropdownButtonHideUnderline(
                    child: DropdownButton2<Categories>(
                      isExpanded: true,
                      hint: Text(
                        controller.filterListLoading ? 'Loading...' : controller.productBrandCategoryWarrantyUnitListResponseModel == null ? AppStrings.kWentWrong : 'Select a category...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: controller.productBrandCategoryWarrantyUnitListResponseModel!.data.categories
                          .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                          .toList(),
                      value: null,
                      onChanged: (value) {
                        setState(() {
                          // controller.selectedOutlet = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 58,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.inputBorderColor),
                            borderRadius: const BorderRadius.all(Radius.circular(8))
                        ),
                        // width: 200,
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: categoryTextEditingController,
                        searchInnerWidgetHeight: 58,
                        searchInnerWidget: Container(
                          height: 58,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            controller: categoryTextEditingController,
                            validator: (value){
                              if(controller.selectedCategory == null){
                                return "Please select a category";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Search for an item...',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return item.value!.name.toLowerCase().toString().contains(searchValue.toLowerCase());
                        },
                      ),
                      //This to clear the search value when you close the menu
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          categoryTextEditingController.clear();
                        }
                      },
                    ),
                  ),),
                GetBuilder<ProductController>(
                  id: 'outlet_dd',
                  builder: (controller) => CustomDropdown<Categories>(
                    items: controller.productBrandCategoryWarrantyUnitListResponseModel?.data.categories ?? [],
                    itemLabel: (item) => item.name, // How to display the item
                    value: controller.selectedCategory,
                    title: "Category",
                    hintText: controller.filterListLoading
                        ? 'Loading...'
                        : controller.productBrandCategoryWarrantyUnitListResponseModel == null
                        ? 'Something went wrong'
                        : 'Select a category...',
                    searchHintText: 'Search for an item...',
                    searchController: categoryTextEditingController,
                    onChanged: (value) {
                      setState(() {
                        controller.selectedCategory = value;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
