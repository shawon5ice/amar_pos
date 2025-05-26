import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/supplier_payment/supplier_payment_invoice_details_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/supplier_payment/supplier_payment_controller.dart';
import 'package:amar_pos/features/return/presentation/controller/return_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/methods/number_to_word.dart';

class SupplierPaymentInvoiceDetailsViewWidget extends StatefulWidget {

  const SupplierPaymentInvoiceDetailsViewWidget({
    super.key,
  });

  @override
  State<SupplierPaymentInvoiceDetailsViewWidget> createState() => _SupplierPaymentInvoiceDetailsViewWidgetState();
}

class _SupplierPaymentInvoiceDetailsViewWidgetState extends State<SupplierPaymentInvoiceDetailsViewWidget> {
  SupplierPaymentController controller = Get.find();

  late int orderId;
  late String orderNo;
  late double amount;

  int i= 1;
  @override
  void initState() {
    orderId = Get.arguments[0];
    orderNo = Get.arguments[1];
    amount = Get.arguments[2];

    i = 1;
    controller.getSupplierPaymentDetail(orderId);
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
                  GetBuilder<SupplierPaymentController>(
                    id: 'sold_history_details',
                    builder: (controller) {
                      if (controller.detailsLoading) {
                        return Center(child: RandomLottieLoader.lottieLoader());
                      } else if (controller.supplierPaymentInvoiceDetailsResponseModel !=
                          null) {
                        SupplierPaymentInvoiceDetailsData data =
                            controller.supplierPaymentInvoiceDetailsResponseModel!.data;
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
                                                      "Phone: ${controller.supplierPaymentInvoiceDetailsResponseModel!.data.business.phone}"),
                                                  addH(8),
                                                  Text(
                                                    "Address: ${data.business.address}",
                                                    // maxLines: 2,
                                                    overflow: TextOverflow.visible,
                                                  ),
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
                                  Expanded(flex: 2, child: Text(data.slNo)),
                                  addW(8),
                                  const Expanded(
                                      flex: 3,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'DUE PAYMENT INVOICE',
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
                                      .toSvg(data.slNo,
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
                                          child: AutoSizeText("Payment Method")),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 8),
                                          child: AutoSizeText("Amount",
                                              textAlign: TextAlign.center)),
                                    ],
                                  ),
                                  ...data.details.map((payment) {
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
                                            child: AutoSizeText(payment.paymentMethod.name)),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 8),
                                            child: AutoSizeText(
                                                Methods.getFormattedNumber(payment.amount),
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
                                        _convertToWords(amount),
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
                                      value: amount,
                                      isTitleBold: true,
                                      isValueBold: true,
                                    ),
                                    // TitleWithValue(
                                    //   title: "Change Amount",
                                    //   value: data.changeAmount,
                                    //   isTitleBold: true,
                                    //   isValueBold: true,
                                    // ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text("Prepared by: ${data.creator.name}",
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
        bottomNavigationBar: GetBuilder<SupplierPaymentController>(
            id: 'download_print_buttons',
            builder: (controller){
              if(controller.supplierPaymentInvoiceDetailsResponseModel != null){
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
                            controller.downloadPaymentReceipt(receiptId: orderId, slNo: orderNo);
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
                            controller.downloadPaymentReceipt(receiptId: orderId, slNo: orderNo,shouldPrint: true);
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
