import 'package:amar_pos/features/return/presentation/controller/return_controller.dart';
import 'package:amar_pos/features/return/presentation/page/return_summary.dart';
import 'package:amar_pos/features/return/presentation/widgets/return_order_product_sn_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/dashed_line.dart';
import '../../../../core/widgets/methods/helper_methods.dart';
import '../../../../core/widgets/qr_code_scanner.dart';
import '../../../inventory/data/products/product_list_response_model.dart';
import '../../../inventory/presentation/products/add_product_screen.dart';
import '../../../sales/presentation/widgets/sn_dialog_widget.dart';

class ReturnPage extends StatefulWidget {
  const ReturnPage({super.key});

  @override
  State<ReturnPage> createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  late TextEditingController suggestionEditingController;


  @override
  void initState() {
    suggestionEditingController = TextEditingController();
    super.initState();
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
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: GetBuilder<ReturnController>(
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
                                            .addPlaceOrderProduct(items.first);
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
                        Get.toNamed(AddProductScreen.routeName);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                )
              ],
            ),
            addH(12),

            Expanded(
              child: GetBuilder<ReturnController>(
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
                    return ListView.builder(
                      itemCount: controller.returnOrderProducts.length,
                      itemBuilder: (_, index) {
                        return Slidable(
                          endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                addW(10),
                                CustomSlidableAction(
                                    onPressed: (context) => controller
                                        .removePlaceOrderProduct(controller
                                        .returnOrderProducts[index]),
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
                                      width: 70,
                                      height: 70,
                                      padding: EdgeInsets.all(1),
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
                                            controller.returnOrderProducts[index]
                                                .thumbnailImage
                                                .toString(),
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    addW(12),
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
                                                .returnOrderProducts[index]
                                                .name,
                                            style: context
                                                .textTheme.titleSmall
                                                ?.copyWith(
                                              fontSize: 13,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          addH(8),
                                          Text(
                                            "ID : ${controller.returnOrderProducts[index].sku}",
                                            style: TextStyle(
                                                color:
                                                const Color(0xff40ACE3),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                addH(12),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                          "Price : ${Methods.getFormatedPrice(controller.returnOrderProducts[index].mrpPrice.toDouble())}",
                                          style: const TextStyle(
                                              color: AppColors.primary),
                                        )),
                                    Expanded(
                                        child: Text(
                                          "Vat : ${Methods.getFormatedPrice((controller.returnOrderProducts[index].vat*(controller.returnOrderProducts[index].mrpPrice/100)).toDouble())}",
                                          style: const TextStyle(
                                              color: AppColors.primary),
                                        )),
                                    Expanded(
                                        child: Text(
                                          "Sub Total : ${Methods.getFormatedPrice(controller.returnOrderProducts[index].mrpPrice.toDouble() * controller.createOrderModel.products[index].quantity.toDouble())}",
                                          style: const TextStyle(
                                              color: AppColors.primary),
                                        )),
                                  ],
                                ),
                                addH(12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        // margin: EdgeInsets.only(right: 20),
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: const Color(0xffFFFBED)
                                                .withOpacity(.3),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.r)),
                                            border: Border.all(
                                                color: const Color(0xffff9000)
                                                    .withOpacity(.3),
                                                width: .5)),
                                        child: Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Quantity : ${controller.createOrderModel.products[index].quantity}",
                                                  style: context
                                                      .textTheme.titleSmall
                                                      ?.copyWith(
                                                    color: const Color(0xffFF9000),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                addW(8),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        controller
                                                            .changeQuantityOfProduct(
                                                            index, false);
                                                      },
                                                      child: const Icon(
                                                          Icons.keyboard_arrow_down,
                                                          size: 24,
                                                          color: AppColors.error),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        controller
                                                            .changeQuantityOfProduct(
                                                            index, true);
                                                      },
                                                      child: const Icon(
                                                        Icons.keyboard_arrow_up,
                                                        size: 24,
                                                        color: AppColors.lightGreen,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.vertical(
                                                  top: Radius.circular(20)),
                                            ),
                                            builder: (context) {
                                              return ReturnOrderProductSnSelectionDialog(
                                                product: controller
                                                    .createOrderModel
                                                    .products[index],
                                                productInfo: controller
                                                    .returnOrderProducts[index],
                                                controller: controller,
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 30,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          decoration: BoxDecoration(
                                              color: const Color(0xffF6FFF6),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.r)),
                                              border: Border.all(
                                                  color: const Color(0xff94DB8C)
                                                      .withOpacity(.3))),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Serial No.",
                                                style: context
                                                    .textTheme.titleSmall
                                                    ?.copyWith(
                                                  color:
                                                  const Color(0xff009D5D),
                                                  fontSize: 14,
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
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: GetBuilder<ReturnController>(
          id: "billing_summary_button",
          builder: (controller) => controller.returnOrderProducts.isNotEmpty
              ? CustomButton(
                onTap: () async {
                  await Get.to(() => const ReturnSummary())?.then((value) {
                    FocusScope.of(context).unfocus();
                  });
                },
                text: "Return Summary",
              )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
