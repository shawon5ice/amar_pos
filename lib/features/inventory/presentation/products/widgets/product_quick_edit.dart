import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/product_bar_code_generateor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../data/products/product_list_response_model.dart';

class ProductQuickViewScreen extends StatefulWidget {
  const ProductQuickViewScreen({super.key});

  @override
  State<ProductQuickViewScreen> createState() => _ProductQuickViewScreenState();
}

class _ProductQuickViewScreenState extends State<ProductQuickViewScreen> {
  final ProductController controller = Get.find();

  late TextEditingController stockInController;
  late TextEditingController stockOutController;
  late TextEditingController costingPriceController;
  late TextEditingController wholeSalePriceController;
  late TextEditingController mrpPriceController;
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
    stockInController = TextEditingController();
    stockOutController = TextEditingController();
    costingPriceController = TextEditingController();
    wholeSalePriceController = TextEditingController();
    mrpPriceController = TextEditingController();
    if (Get.arguments != null) {
      initializeData();
    }

    super.initState();
  }

  Future<void> initializeData() async {
    productInfo = Get.arguments;
    controller.generatedBarcode = "";
    logger.e(productInfo!.toJson());
    costingPriceController.text = productInfo?.costingPrice.toString() ?? '';
    mrpPriceController.text = productInfo?.mrpPrice.toString() ?? '';
    wholeSalePriceController.text =
        productInfo?.wholesalePrice.toString() ?? '';

    fileName = productInfo?.image;
  }

  @override
  void dispose() {
    stockInController.dispose();
    stockOutController.dispose();
    costingPriceController.dispose();
    wholeSalePriceController.dispose();
    mrpPriceController.dispose();

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
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.network(
                              fileName!,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        addH(20.h),
                        FieldTitle(
                          productInfo!.name,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                        addH(20.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 3,
                                child: VerticalFieldTitleWithValue(
                                  title: "Product ID",
                                  value: productInfo!.sku,
                                )),
                            addW(20.w),
                            Expanded(
                                flex: 2,
                                child: VerticalFieldTitleWithValue(
                                  title: "Warranty",
                                  value: productInfo!.warranty?.name ?? '--',
                                )),
                          ],
                        ),
                        addH(20.h),
                        VerticalFieldTitleWithValue(
                          title: "Category",
                          value: productInfo!.category?.name ?? '--',
                        ),
                        addH(20.h),
                        VerticalFieldTitleWithValue(
                          title: "Brand",
                          value: productInfo!.brand?.name ?? '--',
                        ),
                      ],
                    ),
                  ),
                  addH(20.h),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Costing",
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                            color: const Color(0xff7C7C7C),
                                            fontSize: 12.sp),
                                  ),
                                  addH(8),
                                  CustomTextField(
                                    brdrClr: Colors.transparent,
                                    textCon: costingPriceController,
                                    hintText: "",
                                    enabledFlag: false,
                                  )
                                ],
                              ),
                            ),
                            addW(12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Wholesale",
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                            color: const Color(0xff7C7C7C),
                                            fontSize: 12.sp),
                                  ),
                                  addH(8),
                                  CustomTextField(
                                    textCon: wholeSalePriceController,
                                    hintText: 'wholesale price',
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  )
                                ],
                              ),
                            ),
                            addW(12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "MRP",
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xff7C7C7C),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  addH(8),
                                  CustomTextField(
                                    textCon: mrpPriceController,
                                    hintText: 'wholesale price',
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  addH(20.h),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Current Stock",
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                            color: const Color(0xff7C7C7C),
                                            fontSize: 12.sp),
                                  ),
                                  addH(8),
                                  CustomTextField(
                                    brdrClr: Colors.transparent,
                                    textCon: TextEditingController(
                                        text: productInfo!.stock.toString()),
                                    hintText: "",
                                    enabledFlag: false,
                                  )
                                ],
                              ),
                            ),
                            addW(12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Stock In",
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                            color: const Color(0xff93B7A7),
                                            fontSize: 12.sp),
                                  ),
                                  addH(8),
                                  CustomTextField(
                                    textCon: stockInController,
                                    hintText: 'stock in',
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  )
                                ],
                              ),
                            ),
                            addW(12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Stock Out",
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                            color: const Color(0xffFF7373),
                                            fontSize: 12.sp),
                                  ),
                                  addH(8),
                                  CustomTextField(
                                    textCon: stockOutController,
                                    hintText: 'stock out',
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  addH(20.h),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ProductBarCodeGenerator(),
                                arguments: productInfo);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            height: 56.h,
                            decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(40))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Print",
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                          color: Colors.white, fontSize: 20.sp),
                                ),
                                addW(20.w),
                                SvgPicture.asset(AppAssets.barcodeSampleIcon),
                              ],
                            ),
                          ),
                        ),
                      ),
                      addW(16.w),
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              controller.quickEditProduct(
                                id: productInfo!.id,
                                mrpPrice: mrpPriceController.text,
                                stockIn: stockInController.text,
                                stockOut: stockOutController.text,
                                wholeSalePrice: wholeSalePriceController.text,
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            height: 56.h,
                            decoration: const BoxDecoration(
                                color: AppColors.accent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            child: Center(
                              child: Text(
                                "Update",
                                style: context.textTheme.titleMedium?.copyWith(
                                    color: Colors.white, fontSize: 20.sp),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
