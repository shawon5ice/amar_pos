import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/data/models/stock_transfer_history_details/stock_transfer_history_details_response_model.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/data/models/stock_transfer_history_response_model.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/stock_transfer_controller.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/methods/helper_methods.dart';
import '../../../../../core/widgets/methods/number_to_word.dart';

class StockTransferDetailsView extends StatefulWidget {
  static const String routeName = '/inventory/stock-transfer-details';

  const StockTransferDetailsView({
    super.key,
  });

  @override
  State<StockTransferDetailsView> createState() =>
      _StockTransferDetailsViewState();
}

class _StockTransferDetailsViewState
    extends State<StockTransferDetailsView> {
  StockTransferController controller = Get.find();

  int i = 1;

  late int orderId;
  late String orderNo;

  @override
  void initState() {
    orderId = Get.arguments[0];
    orderNo = Get.arguments[1];

    i = 1;
    controller.getStockTransferHistoryDetails(context, orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(orderNo),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  GetBuilder<StockTransferController>(
                    id: 'stock_transfer_history_details',
                    builder: (controller) {
                      if (controller.detailsLoading) {
                        return Center(child: RandomLottieLoader.lottieLoader());
                      } else if (controller.stockTransferHistoryDetailsResponseModel !=
                          null) {
                        StockTransferHistoryDetailsData data =
                            controller.stockTransferHistoryDetailsResponseModel!.data;
                        return SingleChildScrollView(
                          child: Column(
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
                                                    data.business.name,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "Phone: ${data.business.phone}"),
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
                                                data.business.photoUrl,
                                                width: 100,
                                              ))),
                                    ],
                                  ),
                                  addH(8),
                                  Text(
                                    "Address: ${data.business.address}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                                  Expanded(flex: 2, child: Text(data.orderNo)),
                                  addW(8),
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        data.type == 1 ? "REQUISITION" : 'STOCK TRANSFER',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )),
                                  addW(8),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      data.date,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(color: AppColors.inputBorderColor),
                              addH(12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("From Store: ${data.fromStore.name}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text("Phone: ${data.fromStore.phone}"),
                                        Text("Address: ${data.fromStore.address}"),
                                      ],
                                    ),
                                  ),
                                  addW(20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("To Store: ${data.toStore.name}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text("Phone: ${data.toStore.phone}",textAlign: TextAlign.end,),
                                        Text("Address: ${data.toStore.address}", textAlign: TextAlign.end,),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              addH(20),
                              SvgPicture.string(Barcode.code128(
                                  useCode128B: false, useCode128C: false)
                                  .toSvg(data.orderNo,
                                  height: 60, width: context.width / 3)),
                              addH(20),
                              // Product Table
                              Table(
                                border: TableBorder.all(color: Colors.grey),
                                columnWidths: {
                                  0: FixedColumnWidth(40.w),
                                  1: FlexColumnWidth(),
                                  2: FixedColumnWidth(80.w),
                                },
                                children: [
                                  TableRow(
                                    decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                    children:  [
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 8),
                                          child: AutoSizeText("SL.",
                                              textAlign: TextAlign.center)),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 8),
                                          child: AutoSizeText("Product Name",textAlign: TextAlign.center,)),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 8),
                                          child: AutoSizeText("Quantity",
                                              textAlign: TextAlign.center)),
                                    ],
                                  ),
                                  ...data.details.map((product) {
                                    return TableRow(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 8),
                                            child: AutoSizeText("${i++}",
                                                textAlign: TextAlign.center)),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(product.name),
                                                addH(4),
                                                // AutoSizeText("Warranty: ${product.warranty}"),
                                                // addH(4),
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 8),
                                            child: AutoSizeText(
                                                Methods.getFormattedNumber(
                                                    product.quantity.toDouble()),
                                                textAlign: TextAlign.center)),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                              addH(8),
                              // Row(
                              //   children: [
                              //     Text("In Words : ",
                              //         style:
                              //         TextStyle(fontWeight: FontWeight.bold)),
                              //     Expanded(
                              //         child: Text(
                              //           _convertToWords(data.payable),
                              //           style: TextStyle(fontWeight: FontWeight.bold),
                              //         )),
                              //   ],
                              // ),
                              const SizedBox(height: 20),
                              // Summary Section
                              // Align(
                              //   alignment: Alignment.centerRight,
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       TitleWithValue(
                              //         title: "Sub Total",
                              //         value: data.subTotal,
                              //         isTitleBold: true,
                              //         isValueBold: true,
                              //       ),
                              //       TitleWithValue(
                              //         title: "Expense",
                              //         value: data.expense,
                              //       ),
                              //       TitleWithValue(
                              //         title: "Discount",
                              //         value: data.discount,
                              //       ),
                              //       const Divider(color: Colors.black),
                              //       TitleWithValue(
                              //         title: "Payable Amount",
                              //         value: data.payable,
                              //         isTitleBold: true,
                              //         isValueBold: true,
                              //       ),
                              //       Text("Paid By "),
                              //       ...data.paymentDetails.map(
                              //             (e) => TitleWithValue(
                              //           title: e.bank != null ? e.bank!.name : e.name,
                              //           value: e.amount,
                              //         ),
                              //       ),
                              //       TitleWithValue(
                              //         title: "Due Amount",
                              //         value: data.dueAmount,
                              //         isTitleBold: true,
                              //         isValueBold: true,
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              const SizedBox(height: 40),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Remarks: ${data.remarks}",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      }
                      return const Center(
                        child: Text("No data found!"),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: GetBuilder<StockTransferController>(
            id: 'download_print_buttons',
            builder: (controller){
              if(controller.stockTransferHistoryDetailsResponseModel != null){
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: "Download",
                          color: Color(0xff03346E),
                          radius: 8,
                          onTap: () {
                            controller.downloadStockTransferInvoice(
                                isPdf: true, orderId: orderId, orderNo: orderNo);
                          },
                        ),
                      ),
                      addW(20),
                      Expanded(
                        child: CustomButton(
                          text: "Print",
                          radius: 8,
                          color: Color(0xffFF9000),
                          onTap: () {
                            controller.downloadStockTransferInvoice(
                                shouldPrint: true,
                                orderNo: orderNo,
                                isPdf: true,
                                orderId: orderId);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }else{
                return SizedBox.shrink();
              }
            }));
  }

  // Helper function to convert amount to words (a basic implementation)
  String _convertToWords(double amount) {
    return numberToWords(amount);
  }
}

class TitleWithValue extends StatelessWidget {
  const TitleWithValue(
      {super.key,
        required this.value,
        required this.title,
        this.isTitleBold,
        this.isValueBold});

  final num value;
  final String title;
  final bool? isTitleBold;
  final bool? isValueBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight:
                isTitleBold != null ? FontWeight.bold : FontWeight.normal)),
        Text(
          Methods.getFormattedNumberWithDecimal(value.toDouble()),
          style: TextStyle(
              fontWeight:
              isValueBold != null ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}
