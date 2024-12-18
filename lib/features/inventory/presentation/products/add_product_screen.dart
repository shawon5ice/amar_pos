import 'dart:io';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/date_selection_field_widget.dart';
import 'package:amar_pos/features/inventory/data/products/product_brand_category_warranty_unit_list_response_model.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/dotted_border_painter.dart';
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

  late TextEditingController productNameController;
  late TextEditingController productIdController;
  late TextEditingController costingPriceController;
  late TextEditingController wholeSalePriceController;
  late TextEditingController mrpPriceController;
  late TextEditingController vatController;
  late TextEditingController noStockAlertController;
  DateTime? manufacturingDate;
  DateTime? expireDate;
  final formKey = GlobalKey<FormState>();



  String? fileName;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        fileName = result.files.single.path;
      });
    }
  }


  @override
  void initState() {
     productNameController = TextEditingController();
     productIdController = TextEditingController();
     costingPriceController = TextEditingController();
     wholeSalePriceController = TextEditingController();
     mrpPriceController = TextEditingController();
     vatController = TextEditingController();
     noStockAlertController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    productIdController.dispose();
     productIdController.dispose();
     costingPriceController.dispose();
     wholeSalePriceController.dispose();
     mrpPriceController.dispose();
     vatController.dispose();
     noStockAlertController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Add Product"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        value,
                        "Product Name",
                      ),
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
                            final String? scannedCode =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const QRCodeScannerScreen(),
                              ),
                            );
                            if (scannedCode != null && scannedCode.isNotEmpty) {
                              setState(() {
                                productIdController.text = scannedCode ?? '';
                              });
                            }
                          },
                          child: const Icon(Icons.qr_code_scanner_sharp)),
                      hintText: "Scan/Type here...",
                      inputType: TextInputType.text,
                      validator: (value) =>
                          FieldValidator.nonNullableFieldValidator(
                        value,
                        "Product ID",
                      ),
                    ),
                    GetBuilder<ProductController>(
                      id: 'category_dd',
                      builder: (controller) => CustomDropdown<Categories>(
                        isMandatory: true,
                        items: controller
                                .productBrandCategoryWarrantyUnitListResponseModel
                                ?.data
                                .categories ??
                            [],
                        itemLabel: (item) => item.name,
                        // How to display the item
                        value: controller.selectedCategory,
                        title: "Category",
                        hintText: controller.filterListLoading
                            ? 'Loading...'
                            : controller.productBrandCategoryWarrantyUnitListResponseModel ==
                                    null
                                ? 'Something went wrong'
                                : 'Select a category...',
                        searchHintText: 'Search for an item...',
                        onChanged: (value) {
                          setState(() {
                            controller.selectedCategory = value;
                          });
                        },
                          validator: (value) {
                            if (value == null) {
                              return "Please select a category";
                            }
                            return null;
                          },
                      ),
                    ),
                    GetBuilder<ProductController>(
                      id: 'brand_dd',
                      builder: (controller) => CustomDropdown<Brands>(
                        isMandatory: false,
                        items: controller
                                .productBrandCategoryWarrantyUnitListResponseModel
                                ?.data
                                .brands ??
                            [],
                        itemLabel: (item) => item.name,
                        // How to display the item
                        value: controller.selectedBrand,
                        title: "Brand",
                        hintText: controller.filterListLoading
                            ? 'Loading...'
                            : controller.productBrandCategoryWarrantyUnitListResponseModel ==
                                    null
                                ? 'Something went wrong'
                                : 'Select a brand...',
                        searchHintText: 'Search for an item...',
                        onChanged: (value) {
                          controller.selectedBrand = value;
                          controller.update(['brand_dd']);
                        },
                      ),
                    ),
                    GetBuilder<ProductController>(
                      id: 'unit_dd',
                      builder: (controller) => CustomDropdown<Units>(
                        isMandatory: true,
                        items: controller
                                .productBrandCategoryWarrantyUnitListResponseModel
                                ?.data
                                .units ??
                            [],
                        itemLabel: (item) => item.name,
                        // How to display the item
                        value: controller.selectedUnits,
                        title: "Unit",
                        hintText: controller.filterListLoading
                            ? 'Loading...'
                            : controller.productBrandCategoryWarrantyUnitListResponseModel ==
                                    null
                                ? 'Something went wrong'
                                : 'Select a unit...',
                        searchHintText: 'Search for an item...',
                        onChanged: (value) {
                          controller.selectedUnits = value;
                          controller.update(['unit_dd']);
                        },
                      ),
                    ),
                    GetBuilder<ProductController>(
                      id: 'warranty_dd',
                      builder: (controller) => CustomDropdown<Warranties>(
                        isMandatory: false,
                        items: controller
                                .productBrandCategoryWarrantyUnitListResponseModel
                                ?.data
                                .warranties ??
                            [],
                        itemLabel: (item) => item.name.toString(),
                        // How to display the item
                        value: controller.selectedWarranties,
                        title: "Unit",
                        hintText: controller.filterListLoading
                            ? 'Loading...'
                            : controller.productBrandCategoryWarrantyUnitListResponseModel ==
                                    null
                                ? 'Something went wrong'
                                : 'Select a unit...',
                        searchHintText: 'Search for an item...',
                        onChanged: (value) {
                          controller.selectedWarranties = value;
                          controller.update(['warranty_dd']);
                        },
                      ),
                    ),
                    CustomDateSelectionFieldWidget(
                      onDateSelection: (DateTime? selectedDate) {
                        manufacturingDate = selectedDate;
                      },
                      title: "Manufacturing Date",
                    ),
                    CustomDateSelectionFieldWidget(
                      onDateSelection: (DateTime? selectedDate) {
                        expireDate = selectedDate;
                      },
                      title: "Expiry Date",
                    ),

                    addH(16.h),
                    const FieldTitle("Costing Price",),
                    addH(8.h),
                    CustomTextField(
                      textCon: costingPriceController,
                      hintText: "Type here...",
                      inputType: TextInputType.number,
                    ),

                    addH(16.h),
                    const RichFieldTitle(
                      text: "Wholesale Price",
                    ),
                    addH(8.h),
                    CustomTextField(
                      textCon: wholeSalePriceController,
                      hintText: "Type here...",
                      inputType: TextInputType.number,
                      validator: (value) =>
                          FieldValidator.nonNullableFieldValidator(
                            value,
                            "Wholesale price",
                          ),
                    ),

                    addH(16.h),
                    const RichFieldTitle(
                      text: "MRP",
                    ),
                    addH(8.h),
                    CustomTextField(
                      textCon: mrpPriceController,
                      hintText: "Type here...",
                      inputType: TextInputType.number,
                      validator: (value) =>
                          FieldValidator.nonNullableFieldValidator(
                            value,
                            "MRP",
                      ),
                    ),

                    addH(16.h),
                    const FieldTitle("VAT",),
                    addH(8.h),
                    CustomTextField(
                      textCon: vatController,
                      hintText: "Type here...",
                      inputType: TextInputType.number,
                    ),
                    addH(16.h),
                    const FieldTitle("No Stock Alert",),
                    addH(8.h),
                    CustomTextField(
                      textCon: noStockAlertController,
                      hintText: "Type here...",
                      inputType: TextInputType.number,
                    ),
                    addH(16.h),
                    const FieldTitle(
                      "Upload Photo",
                    ),
                    addH(8.h),
                    InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      onTap: selectFile,
                      child: CustomPaint(
                        painter: DottedBorderPainter(
                          color: const Color(0xffD8E0EC),
                        ),
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Center(
                            child: fileName == null
                                ? const Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_outlined,
                                    size: 40, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  "Select product picture",
                                  style:
                                  TextStyle(color: Colors.grey),
                                ),
                              ],
                            )
                                : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                fit: BoxFit.cover,
                                File(fileName!),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: CustomButton(
        text: "Add Now",
        marginHorizontal: 20,
        marginVertical: 10,
        onTap: () {
          if (formKey.currentState!.validate()) {

          }
        },
      ),
    );
  }
}
