import 'dart:io';
import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/date_selection_field_widget.dart';
import 'package:amar_pos/features/inventory/data/products/product_brand_category_warranty_unit_list_response_model.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../data/products/product_list_response_model.dart';

class ProductQuickViewScreen extends StatefulWidget {
  const ProductQuickViewScreen({super.key});

  @override
  State<ProductQuickViewScreen> createState() => _ProductQuickViewScreenState();
}

class _ProductQuickViewScreenState extends State<ProductQuickViewScreen> {
  final ProductController controller = Get.find();

  late TextEditingController productNameController;
  late TextEditingController productIdController;
  late TextEditingController costingPriceController;
  late TextEditingController wholeSalePriceController;
  late TextEditingController mrpPriceController;
  late TextEditingController vatController;
  late TextEditingController noStockAlertController;
  String? manufacturingDate;
  String? expireDate;
  Categories? selectedCategory;
  Brands? selectedBrand;
  Units? selectedUnits;
  Warranties? selectedWarranties;
  final formKey = GlobalKey<FormState>();

  ProductInfo? productInfo;

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
    if (Get.arguments != null) {
      initializeData();
    }

    super.initState();
  }

  Future<void> initializeData() async {
    productInfo = Get.arguments;
    logger.e(productInfo!.toJson());
    productNameController.text = productInfo?.name ?? '';
    productIdController.text = productInfo?.sku ?? '';
    costingPriceController.text = productInfo?.costingPrice.toString() ?? '';
    mrpPriceController.text = productInfo?.mrpPrice.toString() ?? '';
    wholeSalePriceController.text =
        productInfo?.wholesalePrice.toString() ?? '';
    vatController.text = productInfo?.vat.toString() ?? '';
    noStockAlertController.text = productInfo?.alertQuantity.toString() ?? '';

    if (productInfo?.category != null) {
      selectedCategory = controller
          .productBrandCategoryWarrantyUnitListResponseModel?.data.categories
          .singleWhere((e) => e.id == productInfo?.category!.id);
    }

    if (productInfo?.brand != null) {
      selectedBrand = controller
          .productBrandCategoryWarrantyUnitListResponseModel?.data.brands
          .singleWhere((e) => e.id == productInfo?.brand!.id);
    }

    if (productInfo?.warranty != null) {
      selectedWarranties = controller
          .productBrandCategoryWarrantyUnitListResponseModel?.data.warranties
          .singleWhere((e) => e.id == productInfo?.warranty!.id);
    }

    if (productInfo?.unit != null) {
      selectedUnits = controller
          .productBrandCategoryWarrantyUnitListResponseModel?.data.units
          .singleWhere((e) => e.id == productInfo?.unit!.id);
    }

    fileName = productInfo?.image;
  }

  @override
  void dispose() {
    productIdController.dispose();
    productNameController.dispose();
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
        title: const Text("Quick View"),
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

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
