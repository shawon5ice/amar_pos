import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/inventory/presentation/products/add_product_screen.dart';
import 'package:amar_pos/features/sales/presentation/page/billing_summary.dart';
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
import '../../../../core/network/helpers/error_extractor.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/dashed_line.dart';
import '../../../../core/widgets/methods/helper_methods.dart';
import '../../../../core/widgets/qr_code_scanner.dart';
import '../../data/models/create_order_model.dart';
import '../controller/sales_controller.dart';
import 'package:get/get.dart';
import '../../../inventory/data/products/product_list_response_model.dart';
import '../widgets/sale_order_product_sn_selection_dialog.dart';
import '../widgets/sn_dialog_widget.dart';

class PlaceOrder extends StatefulWidget {
  PlaceOrder({super.key});

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final SalesController controller = Get.find();

  List<TextEditingController> purchaseControllers = [];
  List<TextEditingController> purchaseQTYControllers = [];

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (!controller.isEditing) {
      controller.createOrderModel =
          CreateSaleOrderModel.defaultConstructor();
      controller.placeOrderProducts.clear();
    } else {
      for (var e in controller.createOrderModel.products) {
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
      logger.i(purchaseControllers.length);
    }
    super.initState();
  }

  late TextEditingController suggestionEditingController;


  void initializeData() {
    logger.i("initializeData called. Product count: ${controller.createOrderModel.products.length}");

    if (controller.createOrderModel.products.isEmpty) {
      logger.e("Products are empty! Initialization skipped.");
      return;
    }

    setState(() {
      purchaseControllers.clear();
      purchaseQTYControllers.clear();

      for (var e in controller.createOrderModel.products) {
        purchaseControllers.add(TextEditingController(
          text: e.unitPrice.toString(),
        ));
        purchaseQTYControllers.add(TextEditingController(
          text: e.quantity.toString(),
        ));
      }
      logger.i("Initialized ${purchaseControllers.length} controllers.");
    });
  }



  @override
  void dispose() {
    for (int i = 0; i < purchaseControllers.length; i++) {
      purchaseControllers[i].dispose();
      purchaseQTYControllers[i].dispose();
    }
    super.dispose();
  }

  void updatePricesForSaleType(List<TextEditingController> controllers) {
    for (int i = 0; i < controller.createOrderModel.products.length; i++) {
      controllers[i].text = controller.createOrderModel.products[i].unitPrice.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            GetBuilder<SalesController>(
              id: "selling_party_selection",
              builder: (controller) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  updatePricesForSaleType(purchaseControllers);
                  controller.justChanged = false;
                  controller.update(['place_order_items']);
                });
                return Row(
                  children: [
                    CustomRadioButton(
                      title: "Retail Sale",
                      value: true,
                    ),
                    addW(10),
                    CustomRadioButton(
                      title: "Wholesale",
                      value: false,
                    ),
                  ],
                );
              },
            ),
            addH(12),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: GetBuilder<SalesController>(
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
                                            .addPlaceOrderProduct(items.first, unitPrice: controller.isRetailSale ?  items.first.mrpPrice : items.first.wholesalePrice );

                                        int value = controller
                                            .createOrderModel.products
                                            .singleWhere(
                                                (e) => e.id == items.first.id)
                                            .quantity;

                                        logger.i(value);

                                        if (value>1) {
                                          logger.e("HERE");
                                          int index = controller
                                              .createOrderModel.products
                                              .indexOf(controller
                                              .createOrderModel.products
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
                                      }else{
                                        Methods.showSnackbar(msg: "No product found with keyword:$scannedCode");
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
                                  .createOrderModel.products.length;
                          i++) {
                            if (product.id ==
                                controller
                                    .createOrderModel.products[i].id) {
                              value = controller.createOrderModel
                                  .products[i].quantity;
                              break;
                            }
                          }

                          if (controller.placeOrderProducts
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
                          controller.addPlaceOrderProduct(product, unitPrice: controller.isRetailSale ? product.mrpPrice : product.wholesalePrice);
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
              child: GetBuilder<SalesController>(
                id: "place_order_items",
                builder: (controller) {
                  if (controller.placeOrderProducts.isEmpty) {
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
                        itemCount: controller.createOrderModel.products.length,
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
                                        controller
                                          .removePlaceOrderProduct(controller
                                              .placeOrderProducts[index]);
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
                            key: Key(controller.placeOrderProducts[index].id
                                .toString()),
                            child: Container(
                              margin: const EdgeInsets.only(top: 4, bottom: 4),
                              padding: EdgeInsets.only(top: 20,left: 20, right: 20, bottom: controller.placeOrderProducts[index].isVatApplicable == 1 ? 4 : 20),
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
                                              controller.placeOrderProducts[index]
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
                                                  .placeOrderProducts[index]
                                                  .name,
                                              style: context
                                                  .textTheme.titleSmall
                                                  ?.copyWith(
                                                fontSize: 13.sp,
                                              ),
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
                                                    "ID : ${controller.placeOrderProducts[index].sku}",
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
                                                          return SaleOrderProductSnSelectionDialog(
                                                            product: controller
                                                                .createOrderModel
                                                                .products[index],
                                                            productInfo: controller
                                                                .placeOrderProducts[
                                                            index],
                                                            controller: controller,
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: GetBuilder<SalesController>(
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
                                                                  .createOrderModel
                                                                  .products[index]
                                                                  .serialNo
                                                                  .length >
                                                                  controller
                                                                      .createOrderModel
                                                                      .products[index]
                                                                      .quantity? AppColors.error : controller
                                                                  .createOrderModel
                                                                  .products[index]
                                                                  .serialNo
                                                                  .length ==
                                                                  controller
                                                                      .createOrderModel
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    // FilteringTextInputFormatter
                                                    //     .digitsOnly,
                                                    // NumberInputFormatter(),
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
                                                      .createOrderModel
                                                      .products[index]
                                                      .id
                                                      .toString()),
                                                  textCon:
                                                  purchaseControllers[index],
                                                  onChanged: (value) {
                                                    if (value.isNotEmpty) {
                                                      controller
                                                          .createOrderModel
                                                          .products[index].unitPrice = double.parse(value.replaceAll(',', ''));
                                                      controller.update(
                                                          ['sub_total', 'vat']);
                                                    } else {
                                                      controller
                                                          .createOrderModel
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
                                                      .createOrderModel
                                                      .products[index]
                                                      .id
                                                      .toString()),
                                                  textCon:
                                                  purchaseQTYControllers[index],
                                                  onChanged: (value) {
                                                    if (value.isNotEmpty) {
                                                      controller
                                                          .createOrderModel
                                                          .products[index]
                                                          .quantity =
                                                          int.parse(value.replaceAll(',', ''));
                                                      controller.update(
                                                          ['sub_total', 'vat','sn_status']);
                                                    } else {
                                                      controller
                                                          .createOrderModel
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
                                              GetBuilder<SalesController>(
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
                                                                        .createOrderModel
                                                                        .products[index]
                                                                        .unitPrice
                                                                        .toDouble() *
                                                                        controller
                                                                            .createOrderModel
                                                                            .products[index]
                                                                            .quantity
                                                                            .toDouble())),
                                                            hintText: 'Subtotal'),
                                                        if(controller.placeOrderProducts[index].isVatApplicable == 1)
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              addH(2),
                                                              Text(
                                                                "VAT: ${Methods.getFormattedNumber((controller.createOrderModel.products[index].vat * controller.createOrderModel.products[index].quantity).toDouble())}",
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
        ),
        bottomNavigationBar: GetBuilder<SalesController>(
          id: "billing_summary_button",
          builder: (controller) => controller.placeOrderProducts.isNotEmpty
              ? Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.accent,
                      child: GestureDetector(
                        child: SvgPicture.asset(
                          AppAssets.pauseBillingIcon,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    addW(12),
                    Expanded(
                      child: CustomButton(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          for(int i = 0; i < controller.createOrderModel.products.length; i++){
                            if(controller.createOrderModel.products[i].serialNo.isNotEmpty && controller.createOrderModel.products[i].serialNo.length != controller.createOrderModel.products[i].quantity){
                              ErrorExtractor.showSingleErrorDialog(context, "Please fix SN quantity issue of ${controller.placeOrderProducts[i].name}");
                              return;
                            }
                          }
                          if (formKey.currentState!.validate()) {
                            await Get.to(() => const BillingSummary())?.then((value) {
                              FocusScope.of(context).unfocus();
                            });
                          }
                        },
                        text: "Billing Summary",
                      ),
                    )
                  ],
                )
              : const SizedBox.shrink(),
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

  final SalesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if(controller.isRetailSale != value){
            controller.changeSellingParties(value);
          }
        },
        child: Container(
          height: 40.sp,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.lightGreen),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Radio(
                visualDensity: VisualDensity.compact,
                value: value,
                activeColor: const Color(0xff009D5D),
                groupValue: controller.isRetailSale,
                onChanged: (value) {
                  controller.changeSellingParties(value!);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
