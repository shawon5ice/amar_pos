import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/core/widgets/reusable/serial_no/product_serial_no_dialog.dart';
import 'package:amar_pos/features/inventory/presentation/products/add_product_screen.dart';
import 'package:amar_pos/features/purchase/presentation/pages/purchase_summary.dart';
import 'package:amar_pos/features/purchase_return/data/models/create_purchase_return_order_model.dart';
import 'package:amar_pos/features/purchase_return/presentation/purchase_return_controller.dart';
import 'package:amar_pos/features/purchase_return/presentation/widgets/purchase_return_order_product_sn_selection_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/methods/number_input_formatter.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/dashed_line.dart';
import '../../../../core/widgets/loading/random_lottie_loader.dart';
import '../../../../core/widgets/methods/helper_methods.dart';
import '../../../../core/widgets/qr_code_scanner.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/reusable/forbidden_access_full_screen_widget.dart';
import '../../../inventory/data/products/product_list_response_model.dart';
import 'purchase_return_summary.dart';


class PurchaseReturnView extends StatefulWidget {
  const PurchaseReturnView({super.key});

  @override
  State<PurchaseReturnView> createState() => _PurchaseReturnViewState();
}

class _PurchaseReturnViewState extends State<PurchaseReturnView> {
  final PurchaseReturnController controller = Get.find();

  final TextEditingController _purchasePrice = TextEditingController();

  final formKey = GlobalKey<FormState>();

  List<TextEditingController> purchaseControllers = [];
  List<TextEditingController> purchaseReturnQTYControllers = [];
  
  @override
  void initState() {
    suggestionEditingController = TextEditingController();
    if (!controller.isEditing) {
      controller.createPurchaseReturnOrderModel =
          CreatePurchaseReturnOrderModel.defaultConstructor();
      controller.purchaseOrderProducts.clear();
    } else {
      for (var e in controller.createPurchaseReturnOrderModel.products) {
        if(purchaseControllers.isNotEmpty && !controller.isEditing){
          purchaseControllers.insert(0,TextEditingController(
            text: e.unitPrice.toString(),
          ));
          purchaseReturnQTYControllers.insert(0,TextEditingController(
            text: e.quantity.toString(),
          ));
        }else{
          purchaseControllers.add(TextEditingController(
            text: e.unitPrice.toString(),
          ));
          purchaseReturnQTYControllers.add(TextEditingController(
            text: e.quantity.toString(),
          ));
        }
      }
      logger.i(purchaseControllers.length);
    }
    super.initState();
  }

  late TextEditingController suggestionEditingController;



  @override
  void dispose() {
    for (int i = 0; i < purchaseControllers.length; i++) {
      purchaseControllers[i].dispose();
      purchaseReturnQTYControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: (!controller.createAccess && !controller.isEditing) ? const ForbiddenAccessFullScreenWidget() : Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: GetBuilder<PurchaseReturnController>(
                      id: "purchase_return_product_list",
                      builder: (controller) {
                        return TypeAheadField<ProductInfo>(
                          hideOnUnfocus: true,
                          hideOnSelect: true,
                          showOnFocus: true,
                          builder: (context, textController, focusNode) {
                            suggestionEditingController = textController;
                            return TextField(
                              autofocus: false,
                              controller: suggestionEditingController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.accent, width: 1),
                                ),
                                suffixIcon: InkWell(
                                    onTap: () async {
                                      final scannedCode = await Navigator.of(context).push<String>(
                                        MaterialPageRoute(
                                          builder: (_) => const QRCodeScannerScreen(),
                                        ),
                                      );

                                      if (scannedCode == null || scannedCode.isEmpty) return;

                                      suggestionEditingController.text = scannedCode;

                                      final items = await controller.suggestionsCallback(scannedCode);

                                      if (items.length != 1) {
                                        Methods.showSnackbar(msg: "No product found with keyword: $scannedCode");
                                        return;
                                      }

                                      final item = items.first;
                                      suggestionEditingController.clear();

                                      // Check if the product already exists in the current order
                                      final productList = controller.createPurchaseReturnOrderModel.products;
                                      final existingIndex = productList.indexWhere((e) => e.id == item.id);

                                      PurchaseReturnProductModel? product;

                                      if (existingIndex != -1) {
                                        // Product exists already
                                        product = productList[existingIndex];
                                        final initialQty = product.quantity;

                                        // Don't increment again if your controller method already does
                                        logger.i("Existing quantity before add: $initialQty");

                                        controller.addPlaceOrderProduct(item, unitPrice: product.unitPrice);

                                        logger.i("Quantity after addPlaceOrderProduct: ${product.quantity}");

                                        purchaseReturnQTYControllers[existingIndex].text = product.quantity.toString();
                                        controller.update(['purchase_order_items']);
                                      } else {
                                        // Product not in list — add new
                                        controller.addPlaceOrderProduct(item, unitPrice: item.wholesalePrice);

                                        final newIndex = productList.indexWhere((e) => e.id == item.id);
                                        if (newIndex == -1) {
                                          logger.e("Product insert failed");
                                          return;
                                        }

                                        product = productList[newIndex];

                                        final priceController = TextEditingController(text: item.wholesalePrice.toString());
                                        final qtyController = TextEditingController(text: product.quantity.toString());

                                        if (purchaseControllers.isNotEmpty) {
                                          purchaseControllers.insert(0, priceController);
                                          purchaseReturnQTYControllers.insert(0, qtyController);
                                        } else {
                                          purchaseControllers.add(priceController);
                                          purchaseReturnQTYControllers.add(qtyController);
                                        }
                                      }

                                      FocusScope.of(context).unfocus();
                                    },
                                    child: const Icon(
                                      Icons.qr_code_scanner_sharp,
                                      color: AppColors.accent,
                                    )),
                                hintText: "Scan / Type ID or name",
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                                hintStyle: const TextStyle(color: Colors.grey),
                              ),
                            );
                          },
                          suggestionsCallback: controller.suggestionsCallback,
                          itemBuilder: (context, product) {
                            return ListTile(
                              minVerticalPadding: 4,
                              isThreeLine: true,
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.sku,
                                    style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const DashedLine(),
                                  Text(product.name),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                      "WSP: ${Methods.getFormatedPrice(product.wholesalePrice.toDouble())}"),
                                  const Spacer(),
                                  Text(
                                      "MRP: ${Methods.getFormatedPrice(product.mrpPrice.toDouble())}")
                                ],
                              ),
                            );
                          },
                          onSelected: (product) {
                            int i = 0;
                            int value = 0;
                            for (;
                            i <
                                controller
                                    .createPurchaseReturnOrderModel.products.length;
                            i++) {
                              if (product.id ==
                                  controller
                                      .createPurchaseReturnOrderModel.products[i].id) {
                                value = controller.createPurchaseReturnOrderModel
                                    .products[i].quantity;
                                break;
                              }
                            }

                            if (controller.purchaseOrderProducts
                                .any((e) => e.id == product.id)) {
                              purchaseReturnQTYControllers[i].text =
                                  (++value).toString();
                              logger.i(purchaseReturnQTYControllers[i].text);
                            } else {
                              if(purchaseControllers.isNotEmpty){
                                purchaseControllers.insert(0,TextEditingController(
                                    text: product.wholesalePrice.toString()));
                                purchaseReturnQTYControllers
                                    .insert(0,TextEditingController(text: "1"));
                              }else{
                                purchaseControllers.add(TextEditingController(
                                    text: product.wholesalePrice.toString()));
                                purchaseReturnQTYControllers
                                    .add(TextEditingController(text: "1"));
                              }
                            }
                            controller.addPlaceOrderProduct(product, unitPrice: product.wholesalePrice);
                            suggestionEditingController.clear();
                            FocusScope.of(context).unfocus();
                          },
                          decorationBuilder: (context, child) {
                            return Material(
                              type: MaterialType.card,
                              elevation: 8,
                              borderRadius: BorderRadius.circular(8),
                              child: child,
                            );
                          },
                          offset: const Offset(0, 4),
                          constraints: const BoxConstraints(
                            maxHeight: 300,
                          ),
                          emptyBuilder: (_) => const Center(
                            child: Text("No Items found!"),
                          ),
                          loadingBuilder: (_) => Center(
                            child:RandomLottieLoader.lottieLoader(),
                          ),
                        );
                      },
                    ),
                  ),
                  addW(12),
                  Expanded(
                    child: CircleAvatar(
                      backgroundColor: AppColors.accent,
                      child: IconButton(
                        onPressed: () {
                          Get.toNamed(AddProductScreen.routeName, arguments: true);
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                  )
                ],
              ),
              addH(12),
              Expanded(
                child: GetBuilder<PurchaseReturnController>(
                  id: "purchase_order_items",
                  builder: (controller) {
                    if (controller.purchaseOrderProducts.isEmpty) {
                      return Align(
                        alignment: Alignment.center,
                        child: AspectRatio(
                          aspectRatio: 3 / 2,
                          child: Image.asset("assets/images/place_order.png"),
                        ),
                      );
                    } else {
                      return Form(
                        key: formKey,
                        child: ListView.builder(
                          itemCount: controller.purchaseOrderProducts.length,
                          itemBuilder: (_, index) {
                            return Slidable(
                              endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    addW(10),
                                    CustomSlidableAction(
                                        onPressed: (context) {
                                          purchaseControllers.removeAt(index);
                                          purchaseReturnQTYControllers.removeAt(index);
                                          controller.removePlaceOrderProduct(
                                              controller
                                                  .purchaseOrderProducts[index]);
                                        },
                                        backgroundColor: const Color(0xffEF4B4B),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            AppAssets.deleteIc,
                                            // Path to your SVG file
                                            height: 24,
                                            width: 24,
                                          ),
                                        )),
                                  ]),
                              key: Key(controller.purchaseOrderProducts[index].id
                                  .toString()),
                              child: Container(
                                margin: const EdgeInsets.only(top: 4, bottom: 4),
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 70.w,
                                          height: 70.w,
                                          padding: EdgeInsets.all(1.px),
                                          decoration: ShapeDecoration(
                                            color: const Color(0x33BEBEBE)
                                                .withOpacity(.3),
                                            // image: DecorationImage(image: NetworkImage(controller.supplierList[index].photo!)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                          ),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.r)),
                                              child: Image.network(
                                                controller.purchaseOrderProducts[index]
                                                    .thumbnailImage
                                                    .toString(),
                                                height: 70.w,
                                                width: 70.w,
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        addW(12.w),
                                        Expanded(
                                          flex: 8,
                                          child: Container(
                                            margin: const EdgeInsets.only(top: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  controller
                                                      .purchaseOrderProducts[index]
                                                      .name,
                                                  style: context
                                                      .textTheme.titleSmall
                                                      ?.copyWith(
                                                    fontSize: 13.sp,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                addH(8.h),
                                                addH(8.h),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: AutoSizeText(
                                                        maxLines: 1,
                                                        "ID : ${controller.purchaseOrderProducts[index].sku}",
                                                        style: TextStyle(
                                                            color:
                                                            const Color(0xff40ACE3),
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14.sp),
                                                      ),
                                                    ),
                                                    addW(12),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            isScrollControlled: true,
                                                            shape:
                                                            const RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius.circular(
                                                                      20)),
                                                            ),
                                                            builder: (context) {
                                                              return PurchaseReturnOrderProductSnSelectionDialog(
                                                                product: controller
                                                                    .createPurchaseReturnOrderModel
                                                                    .products[index],
                                                                productInfo: controller
                                                                    .purchaseOrderProducts[
                                                                index],
                                                                controller: controller,
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: GetBuilder<PurchaseReturnController>(
                                                            id: 'sn_status',
                                                            builder: (controller){
                                                            return Container(
                                                              height: 30.h,
                                                              padding: const EdgeInsets.symmetric(
                                                                  horizontal: 12),
                                                              decoration: BoxDecoration(
                                                                  color:controller
                                                                      .createPurchaseReturnOrderModel
                                                                      .products[index]
                                                                      .serialNo
                                                                      .length>controller
                                                                      .createPurchaseReturnOrderModel
                                                                      .products[index]
                                                                      .quantity? AppColors.error : controller
                                                                      .createPurchaseReturnOrderModel
                                                                      .products[index]
                                                                      .serialNo
                                                                      .length ==
                                                                      controller
                                                                          .createPurchaseReturnOrderModel
                                                                          .products[index]
                                                                          .quantity
                                                                      ? Color(0xff94DB8C)
                                                                      : const Color(0xffF6FFF6),
                                                                  borderRadius: BorderRadius.all(
                                                                      Radius.circular(20.r)),
                                                                  border: Border.all(
                                                                      color:
                                                                      const Color(0xff94DB8C)
                                                                          .withOpacity(.3))),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "SN",
                                                                    style: context
                                                                        .textTheme.titleSmall
                                                                        ?.copyWith(
                                                                      color: Colors.black,
                                                                      fontSize: 14.sp,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                  const Spacer(),
                                                                  SvgPicture.asset(
                                                                    AppAssets.snAdd,
                                                                    height: 14,
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          }
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    addH(8.h),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Unit Price",
                                                  style: TextStyle(
                                                      color: AppColors.primary),
                                                ),
                                                addH(4),
                                                CustomTextField(
                                                    contentPadding: 12,
                                                    txtSize: 14,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      NumberInputFormatter(),
                                                    ],
                                                    onTap: () {
                                                      purchaseControllers[
                                                      index]
                                                          .selection =
                                                          TextSelection
                                                              .fromPosition(
                                                            TextPosition(
                                                                offset:
                                                                purchaseControllers[
                                                                index]
                                                                    .text
                                                                    .length),
                                                          );
                                                    },
                                                    key: Key(controller
                                                        .createPurchaseReturnOrderModel
                                                        .products[index]
                                                        .id
                                                        .toString()),
                                                    textCon:
                                                    purchaseControllers[index],
                                                    onChanged: (value) {
                                                      if (value.isNotEmpty) {
                                                        controller
                                                            .createPurchaseReturnOrderModel
                                                            .products[index].unitPrice = double.parse(value.replaceAll(',', ''));
                                                        controller.update(
                                                            ['sub_total', 'vat']);
                                                      } else {
                                                        controller
                                                            .createPurchaseReturnOrderModel
                                                            .products[index]
                                                            .unitPrice = 0;
                                                      }
                                                    },
                                                    hintText: 'Unit price'),
                                              ],
                                            )),
                                        addW(12.w),
                                        Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Quantity",
                                                  style: TextStyle(
                                                      color: AppColors.primary),
                                                ),
                                                addH(4),
                                                CustomTextField(
                                                    contentPadding: 12,
                                                    txtSize: 14,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      NumberInputFormatter(),
                                                    ],
                                                    onTap: () {
                                                      purchaseReturnQTYControllers[
                                                      index]
                                                          .selection =
                                                          TextSelection
                                                              .fromPosition(
                                                            TextPosition(
                                                                offset:
                                                                purchaseReturnQTYControllers[
                                                                index]
                                                                    .text
                                                                    .length),
                                                          );
                                                    },
                                                    key: Key(controller
                                                        .createPurchaseReturnOrderModel
                                                        .products[index]
                                                        .id
                                                        .toString()),
                                                    textCon:
                                                    purchaseReturnQTYControllers[index],
                                                    onChanged: (value) {
                                                      if (value.isNotEmpty) {
                                                        controller
                                                            .createPurchaseReturnOrderModel
                                                            .products[index]
                                                            .quantity =
                                                            int.parse(value.replaceAll(',', ''));
                                                        controller.update(
                                                            ['sub_total', 'vat','sn_status']);
                                                      } else {
                                                        controller
                                                            .createPurchaseReturnOrderModel
                                                            .products[index]
                                                            .quantity = 0;
                                                      }
                                                    },
                                                    hintText: 'quantity'),
                                              ],
                                            )),
                                        addW(12.w),
                                        Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Sub Total",
                                                  style: TextStyle(
                                                      color: AppColors.primary),
                                                ),
                                                addH(4),
                                                GetBuilder<PurchaseReturnController>(
                                                    id: 'sub_total',
                                                    builder: (controller) {
                                                      return CustomTextField(
                                                          contentPadding: 12,
                                                          txtSize: 14,
                                                          enabledFlag: false,
                                                          textCon: TextEditingController(
                                                              text: Methods.getFormattedNumber(
                                                                  controller
                                                                      .createPurchaseReturnOrderModel
                                                                      .products[index]
                                                                      .unitPrice
                                                                      .toDouble() *
                                                                      controller
                                                                          .createPurchaseReturnOrderModel
                                                                          .products[index]
                                                                          .quantity
                                                                          .toDouble())),
                                                          hintText: 'Subtotal');
                                                    }),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: GetBuilder<PurchaseReturnController>(
              id: "billing_summary_button",
              builder: (controller) => controller.purchaseOrderProducts.isNotEmpty
                  ? CustomButton(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      for(int i = 0; i < controller.createPurchaseReturnOrderModel.products.length; i++){
                        if(controller.createPurchaseReturnOrderModel.products[i].serialNo.isNotEmpty && controller.createPurchaseReturnOrderModel.products[i].serialNo.length != controller.createPurchaseReturnOrderModel.products[i].quantity){
                          ErrorExtractor.showSingleErrorDialog(context, "Please fix SN quantity issue of ${controller.purchaseOrderProducts[i].name}");
                          return;
                        }
                      }
                      if(formKey.currentState!.validate()){
                        await Get.to(() => PurchaseReturnSummary())?.then((value) {
                          FocusScope.of(context).unfocus();
                        });
                      }

                    },
                    text: "Return Summary",
                  )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
