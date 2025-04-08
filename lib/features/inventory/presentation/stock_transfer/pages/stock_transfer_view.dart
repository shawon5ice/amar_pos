import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/methods/number_input_formatter.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/core/widgets/reusable/forbidden_access_full_screen_widget.dart';
import 'package:amar_pos/core/widgets/reusable/outlet_dd/outlet_dropdown_widget.dart';
import 'package:amar_pos/features/inventory/presentation/products/add_product_screen.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/pages/stock_transfer_details_view.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/pages/widgets/stock_transfer_product_sn_selection_dialog.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/stock_transfer_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/network/helpers/error_extractor.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/dashed_line.dart';
import '../../../../../core/widgets/methods/helper_methods.dart';
import '../../../../../core/widgets/qr_code_scanner.dart';
import '../../../../return/presentation/page/return_summary.dart';
import '../../../data/products/product_list_response_model.dart';

class StockTransferView extends StatefulWidget {
  StockTransferView({super.key, required this.onSuccess});

  Function(int value) onSuccess;

  @override
  State<StockTransferView> createState() => _StockTransferViewState();
}

class _StockTransferViewState extends State<StockTransferView> {
  // final PurchaseController controller = Get.find();
  final StockTransferController controller = Get.put(StockTransferController());

  final TextEditingController _purchasePrice = TextEditingController();

  final formKey = GlobalKey<FormState>();

  List<TextEditingController> purchaseQTYControllers = [];
  late TextEditingController _remarks;

  @override
  void initState() {
    suggestionEditingController = TextEditingController();
    _remarks = TextEditingController();
    // if (!controller.isEditing) {
    //   controller.createPurchaseOrderModel =
    //       CreatePurchaseOrderModel.defaultConstructor();
    //   controller.purchaseOrderProducts.clear();
    // } else {
    //   for (var e in controller.createPurchaseOrderModel.products) {
    //     if(purchaseQTYControllers.isNotEmpty && !controller.isEditing){
    //       purchaseQTYControllers.insert(0,TextEditingController(
    //         text: e.quantity.toString(),
    //       ));
    //     }else{
    //       purchaseQTYControllers.add(TextEditingController(
    //         text: e.quantity.toString(),
    //       ));
    //     }
    //   }
    //   logger.i(purchaseQTYControllers.length);
    // }
    super.initState();
  }

  late TextEditingController suggestionEditingController;

  // @override
  // void didUpdateWidget(covariant StockTransferView oldWidget) {
  //   if (widget != oldWidget) {
  //     FocusScope.of(context).unfocus();
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void dispose() {
    for (int i = 0; i < purchaseQTYControllers.length; i++) {
      purchaseQTYControllers[i].dispose();
    }
    super.dispose();
  }

  void updatePricesForSaleType(List<TextEditingController> controllers) {
    // for (int i = 0; i < controller.createStockTransferRequestModel.products.length; i++) {
    //   controllers[i].text = controller.createStockTransferRequestModel.products[i].unitPrice.toString();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: !controller.purchaseCreateAccess
              ? ForbiddenAccessFullScreenWidget()
              : Column(
                  children: [
                    OutletDropDownWidget(
                        isMandatory: true,
                        filled: true,
                        borderRadius: 40,
                        onOutletSelection: (outlet) {
                          if (outlet != null) {
                            controller.createStockTransferRequestModel.storeId =
                                outlet.id;
                          }
                        }),
                    addH(8),
                    GetBuilder<StockTransferController>(
                      id: "selling_party_selection",
                      builder: (controller) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          controller.update([
                            'selling_party_selection',
                            'purchase_order_items'
                          ]);
                        });
                        return Row(
                          children: [
                            CustomRadioButton(
                              title: "Requisition",
                              value: true,
                            ),
                            addW(10),
                            CustomRadioButton(
                              title: "Transfer",
                              value: false,
                            ),
                          ],
                        );
                      },
                    ),
                    addH(8),
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: GetBuilder<StockTransferController>(
                            id: "purchase_product_list",
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
                                            final String? scannedCode =
                                                await Navigator.of(context)
                                                    .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const QRCodeScannerScreen(),
                                              ),
                                            );
                                            if (scannedCode != null &&
                                                scannedCode.isNotEmpty) {
                                              suggestionEditingController.text =
                                                  scannedCode;
                                              var items = await controller
                                                  .suggestionsCallback(
                                                      scannedCode);
                                              if (items.length == 1) {
                                                suggestionEditingController
                                                    .clear();
                                                controller.addPlaceOrderProduct(
                                                    items.first,
                                                    unitPrice: items
                                                        .first.wholesalePrice);
                                                int value = controller
                                                    .createStockTransferRequestModel
                                                    .products
                                                    .singleWhere((e) =>
                                                        e.id == items.first.id)
                                                    .quantity;
                                                logger.i(value);
                                                if (value > 1) {
                                                  logger.e("HERE");
                                                  int index = controller
                                                      .createStockTransferRequestModel
                                                      .products
                                                      .indexOf(controller
                                                          .createStockTransferRequestModel
                                                          .products
                                                          .singleWhere((e) =>
                                                              e.id ==
                                                              items.first.id));
                                                  purchaseQTYControllers[index]
                                                          .text =
                                                      (value++).toString();
                                                  logger.e(
                                                      purchaseQTYControllers[
                                                              index]
                                                          .text);
                                                  controller.update(
                                                      ['purchase_order_items']);
                                                } else {
                                                  if (purchaseQTYControllers
                                                      .isNotEmpty) {
                                                    purchaseQTYControllers.insert(
                                                        0,
                                                        TextEditingController(
                                                            text: value
                                                                .toString()));
                                                  } else {
                                                    purchaseQTYControllers.add(
                                                        TextEditingController(
                                                            text: value
                                                                .toString()));
                                                  }
                                                }

                                                FocusScope.of(context)
                                                    .unfocus();
                                              } else {
                                                Methods.showSnackbar(
                                                    msg:
                                                        "No product found with keyword:$scannedCode");
                                              }
                                            }
                                          },
                                          child: const Icon(
                                            Icons.qr_code_scanner_sharp,
                                            color: AppColors.accent,
                                          )),
                                      hintText: "Scan / Type ID or name",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 18),
                                    ),
                                  );
                                },
                                suggestionsCallback:
                                    controller.suggestionsCallback,
                                itemBuilder: (context, product) {
                                  return ListTile(
                                    minVerticalPadding: 4,
                                    isThreeLine: true,
                                    dense: true,
                                    visualDensity: VisualDensity.compact,
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              .createStockTransferRequestModel
                                              .products
                                              .length;
                                      i++) {
                                    if (product.id ==
                                        controller
                                            .createStockTransferRequestModel
                                            .products[i]
                                            .id) {
                                      value = controller
                                          .createStockTransferRequestModel
                                          .products[i]
                                          .quantity;
                                      break;
                                    }
                                  }

                                  if (controller.purchaseOrderProducts
                                      .any((e) => e.id == product.id)) {
                                    purchaseQTYControllers[i].text =
                                        (++value).toString();
                                    logger.i(purchaseQTYControllers[i].text);
                                  } else {
                                    if (purchaseQTYControllers.isNotEmpty) {
                                      purchaseQTYControllers.insert(
                                          0, TextEditingController(text: "1"));
                                    } else {
                                      purchaseQTYControllers.add(
                                          TextEditingController(text: "1"));
                                    }
                                  }
                                  controller.addPlaceOrderProduct(product,
                                      unitPrice: product.wholesalePrice);
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
                                Get.toNamed(AddProductScreen.routeName,
                                    arguments: true);
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ),
                        )
                      ],
                    ),
                    addH(8),
                    Expanded(
                      child: GetBuilder<StockTransferController>(
                        id: "purchase_order_items",
                        builder: (controller) {
                          if (controller.purchaseOrderProducts.isEmpty) {
                            return Align(
                              alignment: Alignment.center,
                              child: AspectRatio(
                                aspectRatio: 3 / 2,
                                child: Image.asset(
                                    "assets/images/place_order.png"),
                              ),
                            );
                          } else {
                            return Form(
                              key: formKey,
                              child: ListView.builder(
                                itemCount:
                                    controller.purchaseOrderProducts.length,
                                itemBuilder: (_, index) {
                                  return Slidable(
                                    endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          addW(10),
                                          CustomSlidableAction(
                                              onPressed: (context) {
                                                purchaseQTYControllers
                                                    .removeAt(index);
                                                controller.removePlaceOrderProduct(
                                                    controller
                                                            .purchaseOrderProducts[
                                                        index]);
                                              },
                                              backgroundColor:
                                                  const Color(0xffEF4B4B),
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                    key: Key(controller
                                        .purchaseOrderProducts[index].id
                                        .toString()),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 4, bottom: 4),
                                      padding: const EdgeInsets.all(12),
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
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.r)),
                                                    child: Image.network(
                                                      controller
                                                          .purchaseOrderProducts[
                                                              index]
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
                                                          .purchaseOrderProducts[
                                                              index]
                                                          .name,
                                                      style: context
                                                          .textTheme.titleSmall
                                                          ?.copyWith(
                                                        fontSize: 13.sp,
                                                      ),
                                                      // maxLines: 2,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                    addH(8.h),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: AutoSizeText(
                                                            maxLines: 1,
                                                            "ID : ${controller.purchaseOrderProducts[index].sku}",
                                                            style: TextStyle(
                                                                color: const Color(
                                                                    0xff40ACE3),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    14.sp),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Quantity",
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.primary),
                                                  ),
                                                  addH(4),
                                                  CustomTextField(
                                                      contentPadding: 12,
                                                      txtSize: 14,
                                                      width: 150,
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
                                                          .createStockTransferRequestModel
                                                          .products[index]
                                                          .id
                                                          .toString()),
                                                      textCon:
                                                          purchaseQTYControllers[
                                                              index],
                                                      onChanged: (value) {
                                                        int tempQty = controller
                                                            .createStockTransferRequestModel
                                                            .products[index]
                                                            .quantity;
                                                        if (value.isNotEmpty) {
                                                          controller
                                                                  .createStockTransferRequestModel
                                                                  .products[index]
                                                                  .quantity =
                                                              int.parse(value
                                                                  .replaceAll(
                                                                      ',', ''));
                                                          controller.update([
                                                            'sub_total',
                                                            'vat',
                                                            'sn_status'
                                                          ]);
                                                        } else {
                                                          controller
                                                              .createStockTransferRequestModel
                                                              .products[index]
                                                              .quantity = 0;
                                                        }
                                                      },
                                                      hintText: 'quantity'),
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20)),
                                                    ),
                                                    builder: (context) {
                                                      return StockTransferProductSnSelectionDialog(
                                                        product: controller
                                                            .createStockTransferRequestModel
                                                            .products[index],
                                                        productInfo: controller
                                                                .purchaseOrderProducts[
                                                            index],
                                                        controller: controller,
                                                      );
                                                    },
                                                  );
                                                },
                                                child: controller.isRequisition
                                                    ? SizedBox.shrink()
                                                    : GetBuilder<
                                                        StockTransferController>(
                                                        id: 'sn_status',
                                                        builder: (controller) {
                                                          return Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 20),
                                                            height: 30.h,
                                                            width: 100.w,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            decoration: BoxDecoration(
                                                                color: controller.createStockTransferRequestModel.products[index].serialNo.length > controller.createStockTransferRequestModel.products[index].quantity
                                                                    ? AppColors.error
                                                                    : controller.createStockTransferRequestModel.products[index].serialNo.length == controller.createStockTransferRequestModel.products[index].quantity
                                                                        ? Color(0xff94DB8C)
                                                                        : const Color(0xffF6FFF6),
                                                                borderRadius: BorderRadius.all(Radius.circular(20.r)),
                                                                border: Border.all(color: const Color(0xff94DB8C).withOpacity(.3))),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                  "SN",
                                                                  style: context
                                                                      .textTheme
                                                                      .titleSmall
                                                                      ?.copyWith(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        10.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                SvgPicture
                                                                    .asset(
                                                                  AppAssets
                                                                      .snAdd,
                                                                  height: 12.sp,
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                              )
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
          bottomNavigationBar: controller.purchaseOrderProducts.isNotEmpty? Row(
            children: [
              Expanded(
                  child: CustomTextField(
                      textCon: _remarks, hintText: "Remarks")),
              addW(12),
              GetBuilder<StockTransferController>(
                id: "billing_summary_button",
                builder: (controller) => Expanded(
                      child: CustomButton(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          if (controller
                                  .createStockTransferRequestModel.storeId ==
                              -1) {
                            ErrorExtractor.showSingleErrorDialog(context,
                                "Please select an outlet to process");
                            return;
                          }
                          if (!controller.isRequisition) {
                            for (int i = 0;
                                i <
                                    controller.createStockTransferRequestModel
                                        .products.length;
                                i++) {
                              if (controller.createStockTransferRequestModel
                                      .products[i].serialNo.isNotEmpty &&
                                  controller.createStockTransferRequestModel
                                          .products[i].serialNo.length !=
                                      controller
                                          .createStockTransferRequestModel
                                          .products[i]
                                          .quantity) {
                                ErrorExtractor.showSingleErrorDialog(context,
                                    "Please fix SN quantity issue of ${controller.purchaseOrderProducts[i].name}");
                                return;
                              }
                            }
                          }

                          controller.createStockTransferRequestModel.remarks = _remarks.text;

                          controller.createStockTransfer().then((value) {
                            if (value) {
                              widget.onSuccess(1);
                              // Get.to(const StockTransferDetailsView(),
                              //     arguments: [
                              //       controller.pOrderId,
                              //       controller.pOrderNo
                              //     ]);
                            }
                          });
                        },
                        text: "Create Now",
                      ),
                    ),
              ),
            ],
          ) : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class CustomRadioButton extends StatelessWidget {
  CustomRadioButton({
    super.key,
    required this.title,
    required this.value,
    this.result,
  });

  final bool value;

  final String title;
  final Function()? result;

  final StockTransferController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.changeTransferType(value);
        },
        child: Container(
          height: 40.sp,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.lightGreen),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              AutoSizeText(
                title,
                minFontSize: 8,
                maxFontSize: 14,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Radio(
                visualDensity: VisualDensity.compact,
                value: value,
                activeColor: const Color(0xff009D5D),
                groupValue: controller.isRequisition,
                onChanged: (value) {
                  controller.changeTransferType(value!);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
