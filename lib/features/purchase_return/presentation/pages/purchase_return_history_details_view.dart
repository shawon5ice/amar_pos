import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:amar_pos/features/purchase_return/data/models/purchase_return_history_response_model.dart';
import 'package:amar_pos/features/purchase_return/presentation/purchase_return_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/methods/helper_methods.dart';

class PurchaseReturnHistoryDetailsView extends StatefulWidget {
  static const String routeName = '/purchase/history-details';

  const PurchaseReturnHistoryDetailsView({super.key, required this.orderInfo});

  final PurchaseReturnOrderInfo orderInfo;

  @override
  State<PurchaseReturnHistoryDetailsView> createState() =>
      _PurchaseReturnHistoryDetailsViewState();
}

class _PurchaseReturnHistoryDetailsViewState
    extends State<PurchaseReturnHistoryDetailsView> {
  PurchaseReturnController controller = Get.find();

  int i = 1;

  @override
  void initState() {
    i = 1;
    controller.getPurchaseReturnHistoryDetails(context, widget.orderInfo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.orderInfo.orderNo),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Expanded(
                child: GetBuilder<PurchaseReturnController>(
                  id: 'purchase_return_history_details',
                  builder: (controller) {
                    if (controller.detailsLoading) {
                      return Center(
                          child: SpinKitFoldingCube(
                        size: 100,
                        color: AppColors.primary,
                      ));
                    } else if (controller
                            .purchaseReturnHistoryDetailsResponseModel !=
                        null) {
                      return Column(
                        children: [
                          addH(12),
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller
                                                    .purchaseReturnHistoryDetailsResponseModel!
                                                    .data
                                                    .business
                                                    .name,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  "Phone: ${controller.purchaseReturnHistoryDetailsResponseModel!.data.business.phone}"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  addW(40),
                                  Flexible(
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Image.network(
                                            controller
                                                .purchaseReturnHistoryDetailsResponseModel!
                                                .data
                                                .business
                                                .photoUrl,
                                            width: 100,
                                          ))),
                                ],
                              ),
                              addH(8),
                              Text(
                                "Address: ${controller.purchaseReturnHistoryDetailsResponseModel!.data.business.address}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              addH(20),
                              SvgPicture.string(Barcode.code128(useCode128B: false, useCode128C: false).toSvg(widget.orderInfo.orderNo, height: 80)),

                            ],
                          ),
                          addH(
                            12,
                          ),
                          Divider(
                            color: AppColors.inputBorderColor,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text(widget.orderInfo.orderNo)),
                              addW(8),
                              Expanded(
                                  flex: 3,
                                  child: Text(
                                    'PURCHASE RETURN ORDER',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                  )),
                              addW(8),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "${widget.orderInfo.dateTime.split(',').first}\n${widget.orderInfo.dateTime.split(',').last}",
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          Divider(color: AppColors.inputBorderColor),
                          addH(12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  "Supplier Name: ${widget.orderInfo.supplier}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("Phone: ${widget.orderInfo.phone}"),
                              Text(
                                  "Address: ${controller.purchaseReturnHistoryDetailsResponseModel?.data.supplier.address}"),
                            ],
                          ),
                          addH(12),
                          // Product Table
                          Table(
                            border: TableBorder.all(color: Colors.grey),
                            columnWidths: {
                              0: FixedColumnWidth(40.w),
                              1: FlexColumnWidth(),
                              2: FixedColumnWidth(60.w),
                              3: FixedColumnWidth(40.w),
                              4: FixedColumnWidth(60.w),
                            },
                            children: [
                              TableRow(
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                children: const [
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 8),
                                      child: AutoSizeText("SL.",
                                          textAlign: TextAlign.center)),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 8),
                                      child: AutoSizeText("Product Name")),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 8),
                                      child: AutoSizeText("Price",
                                          textAlign: TextAlign.center)),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 8),
                                      child: AutoSizeText("QTY",
                                          textAlign: TextAlign.center)),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 8),
                                      child: AutoSizeText("Total",
                                          textAlign: TextAlign.center)),
                                ],
                              ),
                              ...controller
                                  .purchaseReturnHistoryDetailsResponseModel!
                                  .data
                                  .details
                                  .map((product) {
                                return TableRow(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 8),
                                        child: AutoSizeText("${i++}",
                                            textAlign: TextAlign.center)),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(product.name),
                                            addH(4),
                                            if (product.snNo != null)
                                              Wrap(
                                                spacing: 4,
                                                runSpacing: 4,
                                                children: product.snNo!
                                                    .map((e) => Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 4),
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8)),
                                                            color: Colors.black,
                                                          ),
                                                          child: AutoSizeText(
                                                            e.serialNo,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ))
                                                    .toList(),
                                              )
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 8),
                                        child: AutoSizeText(
                                            Methods.getFormattedNumber(
                                                product.unitPrice.toDouble()),
                                            textAlign: TextAlign.center)),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 8),
                                        child: AutoSizeText(
                                            Methods.getFormattedNumber(
                                                product.quantity.toDouble()),
                                            textAlign: TextAlign.center)),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 8),
                                        child: AutoSizeText(
                                            Methods.getFormattedNumber(
                                                product.total.toDouble()),
                                            textAlign: TextAlign.center)),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Summary Section
                          Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Sub Total:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(controller
                                        .purchaseReturnHistoryDetailsResponseModel!
                                        .data
                                        .subTotal
                                        .toStringAsFixed(2)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Expense:"),
                                    Text(controller
                                        .purchaseReturnHistoryDetailsResponseModel!
                                        .data
                                        .expense
                                        .toStringAsFixed(2)),
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment:
                                //   MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text("VAT:"),
                                //     Text(controller
                                //         .purchaseReturnHistoryDetailsResponseModel!
                                //         .data
                                //         .vat
                                //         .toStringAsFixed(2)),
                                //   ],
                                // ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Deduction:"),
                                    Text(controller
                                        .purchaseReturnHistoryDetailsResponseModel!
                                        .data
                                        .deduction
                                        .toStringAsFixed(2)),
                                  ],
                                ),
                                Divider(color: Colors.black),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Payable Amount:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(controller
                                        .purchaseReturnHistoryDetailsResponseModel!
                                        .data
                                        .payable
                                        .toStringAsFixed(2)),
                                  ],
                                ),
                                ...controller
                                    .purchaseReturnHistoryDetailsResponseModel!
                                    .data
                                    .paymentDetails
                                    .map(
                                  (e) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Paid By " + e.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(e.amount.toStringAsFixed(2)),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Due Amount:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(controller
                                        .purchaseReturnHistoryDetailsResponseModel!
                                        .data
                                        .dueAmount
                                        .toStringAsFixed(2)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                "Created by: ${controller.purchaseReturnHistoryDetailsResponseModel!.data.createdBy}",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      );
                    }
                    return Center(
                      child: Text("No data found!"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to convert amount to words (a basic implementation)
  String _convertToWords(double amount) {
    // Replace this with a proper implementation or library for converting numbers to words
    return "One Thousand Ten Taka Only";
  }
}
