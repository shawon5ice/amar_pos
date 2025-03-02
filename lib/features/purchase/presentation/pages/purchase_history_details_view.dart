import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/methods/helper_methods.dart';

class PurchaseHistoryDetailsView extends StatefulWidget {
  static const String routeName = '/purchase/history-details';
  const PurchaseHistoryDetailsView({super.key, required this.purchaseOrderInfo});

  final PurchaseOrderInfo purchaseOrderInfo;
  @override
  State<PurchaseHistoryDetailsView> createState() => _PurchaseHistoryDetailsViewState();
}

class _PurchaseHistoryDetailsViewState extends State<PurchaseHistoryDetailsView> {
  PurchaseController controller = Get.find();

  int i= 1;
  @override
  void initState() {
    i = 1;
    controller.getSoldHistoryDetails(context, widget.purchaseOrderInfo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.purchaseOrderInfo.orderNo),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Expanded(
                child: GetBuilder<PurchaseController>(
                  id: 'purchase_history_details',
                  builder: (controller) {
                    if (controller.detailsLoading) {
                      return Center(child: SpinKitFoldingCube(size: 100,color: AppColors.primary,));
                    } else if(controller.purchaseHistoryDetailsResponseModel != null){
                      return Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                                                        .purchaseHistoryDetailsResponseModel!
                                                        .data
                                                        .business
                                                        .name,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "Phone: ${controller.purchaseHistoryDetailsResponseModel!.data.business.phone}"),
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
                                              child: Image.network(controller
                                                  .purchaseHistoryDetailsResponseModel!
                                                  .data
                                                  .business
                                                  .photoUrl,
                                                width: 100,
                                              ))),
                                    ],
                                  ),
                                  addH(8),
                                  Text(
                                    "Address: ${controller.purchaseHistoryDetailsResponseModel!.data.business.address}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          addH(
                            12,
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                                                      "Supplier Name: ${widget.purchaseOrderInfo.supplier}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  Text(
                                                      "Phone: ${widget.purchaseOrderInfo.phone}"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      addW(40),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                "Invoice No.: ${widget.purchaseOrderInfo.orderNo}",
                                                style:const  TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold)),
                                            Text(
                                                "Date & Time: ${widget.purchaseOrderInfo.dateTime}"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  addH(8),
                                  Text(
                                      "Address: ${widget.purchaseOrderInfo.orderNo}"),
                                ],
                              ),
                            ),
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
                                      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                                      child: AutoSizeText("SL.",
                                          textAlign: TextAlign.center)),
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                                      child: AutoSizeText("Product Name")),
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                                      child: AutoSizeText("Price",
                                          textAlign: TextAlign.center)),
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                                      child: AutoSizeText("QTY",
                                          textAlign: TextAlign.center)),
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                                      child: AutoSizeText("Total",
                                          textAlign: TextAlign.center)),
                                ],
                              ),
                              ...controller.purchaseHistoryDetailsResponseModel!
                                  .data.details
                                  .map((product) {
                                return TableRow(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                                        child: AutoSizeText("${i++}",
                                            textAlign: TextAlign.center)),
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(product.name),
                                            addH(4),
                                            if(product.snNo != null)Wrap(
                                              spacing: 4,
                                              runSpacing: 4,
                                              children: product.snNo!.map((e) => Container(
                                                padding: const EdgeInsets.symmetric(horizontal:12,vertical: 4),
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                                  color: Colors.black,
                                                ),
                                                child: AutoSizeText(e.serialNo,style: const TextStyle(color: Colors.white),),
                                              )).toList(),
                                            )
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                                        child: AutoSizeText(Methods.getFormattedNumber(product.unitPrice.toDouble()),
                                            textAlign: TextAlign.center)),
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                                        child: AutoSizeText(Methods.getFormattedNumber(product.quantity.toDouble()),
                                            textAlign: TextAlign.center)),
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                                        child: AutoSizeText(Methods.getFormattedNumber(product.total.toDouble()),
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
                                        .purchaseHistoryDetailsResponseModel!
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
                                        .purchaseHistoryDetailsResponseModel!
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
                                //         .purchaseHistoryDetailsResponseModel!
                                //         .data
                                //         .vat
                                //         .toStringAsFixed(2)),
                                //   ],
                                // ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Discount:"),
                                    Text(controller
                                        .purchaseHistoryDetailsResponseModel!
                                        .data
                                        .discount
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
                                        .purchaseHistoryDetailsResponseModel!
                                        .data
                                        .payable
                                        .toStringAsFixed(2)),
                                  ],
                                ),
                                ...controller.purchaseHistoryDetailsResponseModel!.data.paymentDetails.map((e) => Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Paid By "+e.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(e.amount
                                        .toStringAsFixed(2)),
                                  ],
                                ),),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Change Amount:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(controller
                                        .purchaseHistoryDetailsResponseModel!
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
                                "Prepared by: ${controller.purchaseHistoryDetailsResponseModel!.data.createdBy}",
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
