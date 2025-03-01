import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/methods/number_input_formatter.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/features/inventory/presentation/products/add_product_screen.dart';
import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/presentation/pages/purchase_summary.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/helpers/error_extractor.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/dashed_line.dart';
import '../../../../core/widgets/methods/helper_methods.dart';
import '../../../../core/widgets/qr_code_scanner.dart';
import 'package:get/get.dart';
import '../../../inventory/data/products/product_list_response_model.dart';
import '../widgets/purchase_order_product_sn_selection_dialog.dart';

class PurchaseView extends StatefulWidget {
  PurchaseView({super.key, required this.onSuccess});
  Function(int value) onSuccess;

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {
  final PurchaseController controller = Get.find();

  final TextEditingController _purchasePrice = TextEditingController();

  final formKey = GlobalKey<FormState>();

  List<TextEditingController> purchaseControllers = [];
  List<TextEditingController> purchaseQTYControllers = [];

  @override
  void initState() {
    if (!controller.isEditing) {
      controller.createPurchaseOrderModel =
          CreatePurchaseOrderModel.defaultConstructor();
      controller.purchaseOrderProducts.clear();
      controller.getAllProducts(
        search: "",
        page: 1,
      );
    } else {
      for (var e in controller.createPurchaseOrderModel.products) {
        if(purchaseControllers.isNotEmpty){
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
      logger.i(purchaseControllers.length);
    }
    super.initState();
  }

  late TextEditingController suggestionEditingController;

  // @override
  // void didUpdateWidget(covariant PurchaseView oldWidget) {
  //   if (widget != oldWidget) {
  //     FocusScope.of(context).unfocus();
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void dispose() {
    for (int i = 0; i < purchaseControllers.length; i++) {
      purchaseControllers[i].dispose();
      purchaseQTYControllers[i].dispose();
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
          body: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: GetBuilder<PurchaseController>(
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
                                          await Navigator.of(context).push(
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
                                            .suggestionsCallback(scannedCode);
                                        if (items.length == 1) {
                                          suggestionEditingController.clear();
                                          controller
                                              .addPlaceOrderProduct(items.first);
                                          int value = controller
                                              .createPurchaseOrderModel.products
                                              .singleWhere(
                                                  (e) => e.id == items.first.id)
                                              .quantity;
                                          logger.i(value);
                                          if (value>1) {
                                            logger.e("HERE");
                                            int index = controller
                                                .createPurchaseOrderModel.products
                                                .indexOf(controller
                                                    .createPurchaseOrderModel.products
                                                    .singleWhere((e) =>
                                                        e.id == items.first.id));
                                            purchaseQTYControllers[index].text =
                                            (value++).toString();
                                            logger.e(purchaseQTYControllers[index].text);
                                            controller.update(['purchase_order_items']);
                                          } else {
                                            if(purchaseControllers.isNotEmpty){
                                              purchaseControllers.insert(0,
                                                  TextEditingController(
                                                      text: items
                                                          .first.wholesalePrice
                                                          .toString()));
                                              purchaseQTYControllers.insert(0,
                                                  TextEditingController(
                                                      text: value.toString()));
                                            }else{
                                              purchaseControllers.add(
                                                  TextEditingController(
                                                      text: items
                                                          .first.wholesalePrice
                                                          .toString()));
                                              purchaseQTYControllers.add(
                                                  TextEditingController(
                                                      text: value.toString()));
                                            }
                                          }
        
                                          FocusScope.of(context).unfocus();
                                        }
                                      }
                                    },
                                    child: const Icon(
                                      Icons.qr_code_scanner_sharp,
                                      color: AppColors.accent,
                                    )),
                                hintText: "Scan / Type ID or name",
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 18),
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
                                        .createPurchaseOrderModel.products.length;
                                i++) {
                              if (product.id ==
                                  controller
                                      .createPurchaseOrderModel.products[i].id) {
                                value = controller.createPurchaseOrderModel
                                    .products[i].quantity;
                                break;
                              }
                            }
        
                            if (controller.purchaseOrderProducts
                                .any((e) => e.id == product.id)) {
                              purchaseQTYControllers[i].text =
                                  (++value).toString();
                              logger.i(purchaseQTYControllers[i].text);
                            } else {
                              if(purchaseControllers.isNotEmpty){
                                purchaseControllers.insert(0,TextEditingController(
                                    text: product.wholesalePrice.toString()));
                                purchaseQTYControllers
                                    .insert(0,TextEditingController(text: "1"));
                              }else{
                                purchaseControllers.add(TextEditingController(
                                    text: product.wholesalePrice.toString()));
                                purchaseQTYControllers
                                    .add(TextEditingController(text: "1"));
                              }
                            }
                            controller.addPlaceOrderProduct(product);
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
                          loadingBuilder: (_) => const Center(
                            child: CircularProgressIndicator(),
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
                          Get.toNamed(AddProductScreen.routeName,arguments: true);
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                  )
                ],
              ),
              addH(12),
              Expanded(
                child: GetBuilder<PurchaseController>(
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
                                          purchaseQTYControllers.removeAt(index);
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
                                                  BorderRadius.circular(10.r),
                                            ),
                                          ),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.r)),
                                              child: Image.network(
                                                controller
                                                    .purchaseOrderProducts[index]
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
                                                            return PurchaseOrderProductSnSelectionDialog(
                                                              product: controller
                                                                  .createPurchaseOrderModel
                                                                  .products[index],
                                                              productInfo: controller
                                                                  .purchaseOrderProducts[
                                                              index],
                                                              controller: controller,
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: GetBuilder<PurchaseController>(
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
                                                                    .createPurchaseOrderModel
                                                                    .products[index]
                                                                    .serialNo
                                                                    .length >
                                                                    controller
                                                                        .createPurchaseOrderModel
                                                                        .products[index]
                                                                        .quantity? AppColors.error : controller
                                                                    .createPurchaseOrderModel
                                                                    .products[index]
                                                                    .serialNo
                                                                    .length ==
                                                                    controller
                                                                        .createPurchaseOrderModel
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
                                                    .createPurchaseOrderModel
                                                    .products[index]
                                                    .id
                                                    .toString()),
                                                textCon:
                                                    purchaseControllers[index],
                                                onChanged: (value) {
                                                  if (value.isNotEmpty) {
                                                    controller
                                                        .createPurchaseOrderModel
                                                        .products[index].unitPrice = double.parse(value.replaceAll(',', ''));
                                                    controller.update(
                                                        ['sub_total', 'vat']);
                                                  } else {
                                                    controller
                                                        .createPurchaseOrderModel
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
                                                    .createPurchaseOrderModel
                                                    .products[index]
                                                    .id
                                                    .toString()),
                                                textCon:
                                                    purchaseQTYControllers[index],
                                                onChanged: (value) {
                                                  if (value.isNotEmpty) {
                                                    controller
                                                        .createPurchaseOrderModel
                                                        .products[index]
                                                        .quantity =
                                                        int.parse(value.replaceAll(',', ''));
                                                    controller.update(
                                                        ['sub_total', 'vat','sn_status']);
                                                  } else {
                                                    controller
                                                        .createPurchaseOrderModel
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
                                            GetBuilder<PurchaseController>(
                                                id: 'sub_total',
                                                builder: (controller) {
                                                  return CustomTextField(
                                                      contentPadding: 12,
                                                      txtSize: 14,
                                                      enabledFlag: false,
                                                      textCon: TextEditingController(
                                                          text: Methods.getFormattedNumber(
                                                              controller
                                                                  .createPurchaseOrderModel
                                                                  .products[index]
                                                                  .unitPrice
                                                                  .toDouble() *
                                                                  controller
                                                                      .createPurchaseOrderModel
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
          bottomNavigationBar: GetBuilder<PurchaseController>(
            id: "billing_summary_button",
            builder: (controller) => controller.purchaseOrderProducts.isNotEmpty
                ? CustomButton(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    for(int i = 0; i < controller.createPurchaseOrderModel.products.length; i++){
                      if(controller.createPurchaseOrderModel.products[i].serialNo.isNotEmpty && controller.createPurchaseOrderModel.products[i].serialNo.length != controller.createPurchaseOrderModel.products[i].quantity){
                        ErrorExtractor.showSingleErrorDialog(context, "Please fix SN quantity issue of ${controller.purchaseOrderProducts[i].name}");
                        return;
                      }
                    }
                    if (formKey.currentState!.validate()) {
                      await Get.to(() => PurchaseSummary(onSuccess: (value){
                        if(value){
                          controller.clearEditing();
                          widget.onSuccess(1);
                        }
                      },))
                          ?.then((value) {
                        FocusScope.of(context).unfocus();
                      });
                    }
                  },
                  text: "Billing Summary",
                )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
