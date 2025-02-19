import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/sales/data/models/sale_history/sold_history_response_model.dart';
import 'package:amar_pos/features/sales/presentation/controller/sales_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InvoiceWidget extends StatefulWidget {
  final SaleHistory saleHistory;

  const InvoiceWidget({
    super.key,
    required this.saleHistory,
  });

  @override
  State<InvoiceWidget> createState() => _InvoiceWidgetState();
}

class _InvoiceWidgetState extends State<InvoiceWidget> {
  SalesController controller = Get.find();

  int i= 1;
  @override
  void initState() {
    i = 1;
    controller.getSoldHistoryDetails(context, widget.saleHistory);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.saleHistory.orderNo),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Expanded(
                child: GetBuilder<SalesController>(
                  id: 'sold_history_details',
                  builder: (controller) {
                    if (controller.detailsLoading) {
                      return Center(child: SpinKitFoldingCube(size: 100,color: AppColors.primary,));
                    } else if(controller.saleHistoryDetailsResponseModel != null){
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
                                                        .saleHistoryDetailsResponseModel!
                                                        .data
                                                        .business
                                                        .name,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "Phone: ${controller.saleHistoryDetailsResponseModel!.data.business.phone}"),
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
                                                        .saleHistoryDetailsResponseModel!
                                                        .data
                                                        .business
                                                        .photoUrl,
                                                width: 100,
                                              ))),
                                    ],
                                  ),
                                  addH(8),
                                  Text(
                                    "Address: ${controller.saleHistoryDetailsResponseModel!.data.business.address}",
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
                                                      "Customer Name: ${widget.saleHistory.customer.name}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      "Phone: ${widget.saleHistory.customer.phone}"),
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
                                                "Invoice No.: ${widget.saleHistory.orderNo}",
                                                style:const  TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                "Date & Time: ${widget.saleHistory.date}"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  addH(8),
                                  Text(
                                      "Address: ${widget.saleHistory.customer.name}"),
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
                              ...controller.saleHistoryDetailsResponseModel!
                                  .data.orderDetails
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
                                            Wrap(
                                              spacing: 4,
                                              runSpacing: 4,
                                              children: product.snNo.map((e) => Container(
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
                                        child: AutoSizeText(Methods.getFormattedNumber(product.totalPrice.toDouble()),
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
                                        .saleHistoryDetailsResponseModel!
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
                                        .saleHistoryDetailsResponseModel!
                                        .data
                                        .expense
                                        .toStringAsFixed(2)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("VAT:"),
                                    Text(controller
                                        .saleHistoryDetailsResponseModel!
                                        .data
                                        .vat
                                        .toStringAsFixed(2)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Discount:"),
                                    Text(controller
                                        .saleHistoryDetailsResponseModel!
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
                                        .saleHistoryDetailsResponseModel!
                                        .data
                                        .payable
                                        .toStringAsFixed(2)),
                                  ],
                                ),
                                ...controller.saleHistoryDetailsResponseModel!.data.paymentDetails.map((e) => Row(
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
                                        .saleHistoryDetailsResponseModel!
                                        .data
                                        .changeAmount
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
                                "Prepared by: ${controller.saleHistoryDetailsResponseModel!.data.serviceBy.name}",
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
