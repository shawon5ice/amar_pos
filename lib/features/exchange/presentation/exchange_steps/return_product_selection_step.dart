import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/exchange/exchange_controller.dart';
import 'package:amar_pos/features/exchange/presentation/widgets/exchange_product_sn_selection_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/methods/number_input_formatter.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/dashed_line.dart';
import '../../../../core/widgets/methods/helper_methods.dart';
import '../../../../core/widgets/qr_code_scanner.dart';
import '../../../inventory/data/products/product_list_response_model.dart';
import '../../../inventory/presentation/products/add_product_screen.dart';
import '../../../return/presentation/widgets/return_order_product_sn_selection_dialog.dart';
import '../../data/models/create_exchange_request_model.dart';

class ReturnProductSelectionStep extends StatefulWidget {
  const ReturnProductSelectionStep({super.key});

  @override
  State<ReturnProductSelectionStep> createState() => _ReturnProductSelectionStepState();
}

class _ReturnProductSelectionStepState extends State<ReturnProductSelectionStep> {
  late TextEditingController suggestionEditingController;

  final formKey = GlobalKey<FormState>();

  List<TextEditingController> purchaseControllers = [];
  List<TextEditingController> purchaseQTYControllers = [];

  ExchangeController controller = Get.put(ExchangeController());
  @override
  void initState() {
    suggestionEditingController = TextEditingController();
    if(controller.isEditing){
      for (var e in controller.exchangeRequestModel.returnProducts) {
        if(purchaseControllers.isNotEmpty && !controller.isEditing){
          purchaseControllers.insert(0,TextEditingController(
            text: e.unitPrice.toString(),
          ));
          purchaseQTYControllers.insert(0,TextEditingController(
            text: e.quantity.toString(),
          ));
        }else{
          purchaseControllers.add(TextEditingController(
            text: e.unitPrice.toString(),
          ));
          purchaseQTYControllers.add(TextEditingController(
            text: e.quantity.toString(),
          ));
        }
      }
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 8,
              child: GetBuilder<ExchangeController>(
                id: "sales_product_list",
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
                                final productList = controller.exchangeRequestModel.returnProducts;
                                final existingIndex = productList.indexWhere((e) => e.id == item.id);

                                ProductModel? product;

                                if (existingIndex != -1) {
                                  // Product exists already
                                  product = productList[existingIndex];
                                  final initialQty = product.quantity;

                                  // Don't increment again if your controller method already does
                                  logger.i("Existing quantity before add: $initialQty");

                                  controller.addProduct(item, unitPrice: product.unitPrice, isReturn: true);

                                  logger.i("Quantity after addPlaceOrderProduct: ${product.quantity}");

                                  purchaseQTYControllers[existingIndex].text = product.quantity.toString();
                                  controller.update(['purchase_order_items']);
                                } else {
                                  // Product not in list — add new
                                  controller.addProduct(item, unitPrice: item.mrpPrice, isReturn: true);

                                  final newIndex = productList.indexWhere((e) => e.id == item.id);
                                  if (newIndex == -1) {
                                    logger.e("Product insert failed");
                                    return;
                                  }

                                  product = productList[newIndex];

                                  final priceController = TextEditingController(text: item.mrpPrice.toString());
                                  final qtyController = TextEditingController(text: product.quantity.toString());

                                  if (purchaseControllers.isNotEmpty) {
                                    purchaseControllers.insert(0, priceController);
                                    purchaseQTYControllers.insert(0, qtyController);
                                  } else {
                                    purchaseControllers.add(priceController);
                                    purchaseQTYControllers.add(qtyController);
                                  }
                                }

                                FocusScope.of(context).unfocus();
                              },
                              // onTap: () async {
                              //   final String? scannedCode =
                              //   await Navigator.of(context).push(
                              //     MaterialPageRoute(
                              //       builder: (context) =>
                              //       const QRCodeScannerScreen(),
                              //     ),
                              //   );
                              //   if (scannedCode != null &&
                              //       scannedCode.isNotEmpty) {
                              //     suggestionEditingController.text =
                              //         scannedCode;
                              //     var items = await controller
                              //         .suggestionsCallback(scannedCode);
                              //     if (items.length == 1) {
                              //       suggestionEditingController.clear();
                              //       controller
                              //           .addProduct(items.first, unitPrice: items.first.mrpPrice, isReturn: true);
                              //       int value = controller
                              //           .exchangeRequestModel.returnProducts
                              //           .singleWhere(
                              //               (e) => e.id == items.first.id)
                              //           .quantity;
                              //       logger.i(value);
                              //       if (value>1) {
                              //         logger.e("HERE");
                              //         int index = controller
                              //             .exchangeRequestModel.returnProducts
                              //             .indexOf(controller
                              //             .exchangeRequestModel.returnProducts
                              //             .singleWhere((e) =>
                              //         e.id == items.first.id));
                              //         purchaseQTYControllers[index].text =
                              //             (value++).toString();
                              //         logger.e(purchaseQTYControllers[index].text);
                              //         controller.update(['purchase_order_items']);
                              //       } else {
                              //         if(purchaseControllers.isNotEmpty){
                              //           purchaseControllers.insert(0,
                              //               TextEditingController(
                              //                   text: items
                              //                       .first.mrpPrice
                              //                       .toString()));
                              //           purchaseQTYControllers.insert(0,
                              //               TextEditingController(
                              //                   text: value.toString()));
                              //         }else{
                              //           purchaseControllers.add(
                              //               TextEditingController(
                              //                   text: items
                              //                       .first.mrpPrice
                              //                       .toString()));
                              //           purchaseQTYControllers.add(
                              //               TextEditingController(
                              //                   text: value.toString()));
                              //         }
                              //       }
                              //
                              //       FocusScope.of(context).unfocus();
                              //     }else{
                              //       Methods.showSnackbar(msg: "No product found with keyword:$scannedCode");
                              //     }
                              //   }
                              // },
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
                      for (; i < controller.exchangeRequestModel.returnProducts.length; i++) {
                        if (product.id == controller.exchangeRequestModel.returnProducts[i].id) {
                          value = controller.exchangeRequestModel
                              .returnProducts[i].quantity;
                          break;
                        }
                      }

                      if (controller.returnOrderProducts
                          .any((e) => e.id == product.id)) {
                        purchaseQTYControllers[i].text =
                            (++value).toString();
                        logger.i(purchaseQTYControllers[i].text);
                      } else {
                        if(purchaseControllers.isNotEmpty){
                          purchaseControllers.insert(0,TextEditingController(
                              text: product.mrpPrice.toString()));
                          purchaseQTYControllers
                              .insert(0,TextEditingController(text: "1"));
                        }else{
                          purchaseControllers.add(TextEditingController(
                              text: product.mrpPrice.toString()));
                          purchaseQTYControllers
                              .add(TextEditingController(text: "1"));
                        }
                      }
                      controller.addProduct(product, unitPrice: product.mrpPrice, isReturn: true);
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
                      child: RandomLottieLoader.lottieLoader(),
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
        SizedBox(
          height: context.height * .6,
          child: GetBuilder<ExchangeController>(
            id: "place_order_items",
            builder: (controller) {
              if (controller.returnOrderProducts.isEmpty) {
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
                    shrinkWrap: true, // important
                    // physics: NeverScrollableScrollPhysics(), // important
                    itemCount: controller.returnOrderProducts.length+1,
                    itemBuilder: (_, index) {
                      if(index == controller.returnOrderProducts.length) {
                        return addH(context.height/2);
                      }
                      return Slidable(
                        endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              addW(10),
                              CustomSlidableAction(
                                  onPressed: (context) {
                                    purchaseControllers.removeAt(index);
                                    purchaseQTYControllers.removeAt(index);
                                    controller.removePlaceOrderProduct(
                                        controller
                                            .returnOrderProducts[index],true);
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
                        key: Key(controller.returnOrderProducts[index].id
                            .toString()),
                        child: Container(
                          margin: const EdgeInsets.only(top: 4, bottom: 4),
                          padding: EdgeInsets.only(top: 12,left: 12, right: 12, bottom: controller.returnOrderProducts[index].isVatApplicable == 1 ? 4 : 12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
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
                                          controller
                                              .returnOrderProducts[index]
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
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller
                                              .returnOrderProducts[
                                          index]
                                              .name,
                                          style: context
                                              .textTheme.titleSmall
                                              ?.copyWith(
                                            fontSize: 13.sp,
                                          ),
                                          // maxLines: 2,
                                          overflow: TextOverflow.visible,
                                        ),
                                        addH(8.h),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: AutoSizeText(
                                                maxLines: 1,
                                                "ID : ${controller.returnOrderProducts[index].sku}",
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
                                                      return ExchangeProductSnSelectionDialog(
                                                        product: controller
                                                            .exchangeRequestModel
                                                            .returnProducts[index],
                                                        productInfo: controller
                                                            .returnOrderProducts[
                                                        index],
                                                        controller: controller,
                                                      );
                                                    },
                                                  );
                                                },
                                                child: GetBuilder<ExchangeController>(
                                                  id: 'sn_status',
                                                  builder: (controller){
                                                    return Container(
                                                      height: 30.h,
                                                      // width: 64.w,
                                                      // width: 100.w,
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          color:controller
                                                              .exchangeRequestModel
                                                              .returnProducts[index]
                                                              .serialNo
                                                              .length >
                                                              controller
                                                                  .exchangeRequestModel
                                                                  .returnProducts[index]
                                                                  .quantity? AppColors.error : controller
                                                              .exchangeRequestModel
                                                              .returnProducts[index]
                                                              .serialNo
                                                              .length ==
                                                              controller
                                                                  .exchangeRequestModel
                                                                  .returnProducts[index]
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
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            "SN",
                                                            style: context
                                                                .textTheme.titleSmall
                                                                ?.copyWith(
                                                              color: Colors.black,
                                                              fontSize: 10.sp,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          SvgPicture.asset(
                                                            AppAssets.snAdd,
                                                            height: 12.sp,
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              addH(8),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  .exchangeRequestModel
                                                  .returnProducts[index]
                                                  .id
                                                  .toString()),
                                              textCon:
                                              purchaseControllers[index],
                                              onChanged: (value) {
                                                if (value.isNotEmpty) {
                                                  controller
                                                      .exchangeRequestModel
                                                      .returnProducts[index].unitPrice = double.parse(value.replaceAll(',', ''));
                                                  controller.update(
                                                      ['sub_total', 'vat']);
                                                } else {
                                                  controller
                                                      .exchangeRequestModel
                                                      .returnProducts[index]
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
                                                purchaseQTYControllers[
                                                index]
                                                    .selection =
                                                    TextSelection
                                                        .fromPosition(
                                                      TextPosition(
                                                          offset:
                                                          purchaseQTYControllers[
                                                          index]
                                                              .text
                                                              .length),
                                                    );
                                              },
                                              key: Key(controller
                                                  .exchangeRequestModel
                                                  .returnProducts[index]
                                                  .id
                                                  .toString()),
                                              textCon:
                                              purchaseQTYControllers[index],
                                              onChanged: (value) {
                                                if (value.isNotEmpty) {
                                                  controller
                                                      .exchangeRequestModel
                                                      .returnProducts[index]
                                                      .quantity =
                                                      int.parse(value.replaceAll(',', ''));
                                                  controller.update(
                                                      ['sub_total', 'vat','sn_status']);
                                                } else {
                                                  controller
                                                      .exchangeRequestModel
                                                      .returnProducts[index]
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
                                          GetBuilder<ExchangeController>(
                                              id: 'sub_total',
                                              builder: (controller) {
                                                return Column(
                                                  children: [
                                                    CustomTextField(
                                                        contentPadding: 12,
                                                        txtSize: 14,
                                                        enabledFlag: false,
                                                        textCon: TextEditingController(
                                                            text: Methods.getFormattedNumber(
                                                                controller
                                                                    .exchangeRequestModel
                                                                    .returnProducts[index]
                                                                    .unitPrice
                                                                    .toDouble() *
                                                                    controller
                                                                        .exchangeRequestModel
                                                                        .returnProducts[index]
                                                                        .quantity
                                                                        .toDouble())),
                                                        hintText: 'Subtotal'),
                                                    if(controller.returnOrderProducts[index].isVatApplicable == 1)
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          addH(2),
                                                          Text(
                                                            "VAT: ${Methods.getFormattedNumber(((controller.returnOrderProducts[index].vat/100) * controller.exchangeRequestModel.returnProducts[index].unitPrice * controller.exchangeRequestModel.returnProducts[index].quantity).toDouble())}",
                                                            style: TextStyle(
                                                                color: AppColors.error, fontWeight: FontWeight.normal),
                                                          ),
                                                        ],
                                                      )
                                                  ],
                                                );
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
    );
  }
}
