import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/methods/helper_methods.dart';
import '../../../../core/widgets/methods/number_to_word.dart';
import '../../data/models/purchase_history_details/purchase_history_details_response_model.dart';

class PurchaseHistoryDetailsView extends StatefulWidget {
  static const String routeName = '/purchase/history-details';

  const PurchaseHistoryDetailsView({
    super.key,
  });

  @override
  State<PurchaseHistoryDetailsView> createState() =>
      _PurchaseHistoryDetailsViewState();
}

class _PurchaseHistoryDetailsViewState
    extends State<PurchaseHistoryDetailsView> {
  PurchaseController controller = Get.find();

  int i = 1;

  late int orderId;
  late String orderNo;

  @override
  void initState() {
    orderId = Get.arguments[0];
    orderNo = Get.arguments[1];

    i = 1;
    controller.getPurchaseHistoryDetails(context, orderId);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              GetBuilder<PurchaseController>(
                id: 'purchase_history_details',
                builder: (controller) {
                  if (controller.detailsLoading) {
                    return Expanded(
                      child: Center(child: RandomLottieLoader.lottieLoader()),
                    );
                  } else if (controller.purchaseHistoryDetailsResponseModel !=
                      null) {
                    PurchaseHistoryDetailsData data =
                        controller.purchaseHistoryDetailsResponseModel!.data;
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
                              const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'PURCHASE ORDER',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
                              addW(8),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  data.dateTime,
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
                                    Text("Supplier Name: ${data.supplier.name}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text("Phone: ${data.supplier.phone}"),
                                    Text("Address: ${data.supplier.address}"),
                                  ],
                                ),
                              ),
                              addW(20),
                              SvgPicture.string(Barcode.code128(
                                      useCode128B: false, useCode128C: false)
                                  .toSvg(data.orderNo,
                                      height: 60, width: context.width / 3)),
                            ],
                          ),
                          addH(20),
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
                                                product.unitPrice.toDouble()),
                                            textAlign: TextAlign.center)),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 8),
                                        child: AutoSizeText(
                                            Methods.getFormattedNumber(
                                                product.quantity.toDouble()),
                                            textAlign: TextAlign.center)),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
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
                          addH(8),
                          Row(
                            children: [
                              Text("In Words : ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Expanded(
                                  child: Text(
                                _convertToWords(data.payable),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Summary Section
                          Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleWithValue(
                                  title: "Sub Total",
                                  value: data.subTotal,
                                  isTitleBold: true,
                                  isValueBold: true,
                                ),
                                TitleWithValue(
                                  title: "Expense",
                                  value: data.expense,
                                ),
                                TitleWithValue(
                                  title: "Discount",
                                  value: data.discount,
                                ),
                                const Divider(color: Colors.black),
                                TitleWithValue(
                                  title: "Payable Amount",
                                  value: data.payable,
                                  isTitleBold: true,
                                  isValueBold: true,
                                ),
                                ...data.paymentDetails.map(
                                  (e) => TitleWithValue(
                                    title: "Paid By ${e.name}",
                                    value: e.amount,
                                  ),
                                ),
                                TitleWithValue(
                                  title: "Due Amount",
                                  value: data.dueAmount,
                                  isTitleBold: true,
                                  isValueBold: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text("Created by: ${data.createdBy}",
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
      bottomNavigationBar: GetBuilder<PurchaseController>(
        id: 'download_print_buttons',
        builder: (controller){
          if(controller.purchaseHistoryDetailsResponseModel != null){
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
                        controller.downloadPurchaseHistory(
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
                        controller.downloadPurchaseHistory(
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
        Text("$title : ",
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
