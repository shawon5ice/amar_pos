import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection_controller.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../../core/widgets/methods/helper_methods.dart';
import '../../../../../../core/widgets/methods/number_to_word.dart';
import '../../../../../pos_printing/pos_invoice_model.dart';
import '../../../../../purchase/data/models/purchase_history_details/purchase_history_details_response_model.dart';
import '../../../../data/models/due_collection/due_collection_details_response_model.dart';

class DueCollectionDetailsView extends StatefulWidget {
  static const String routeName = '/purchase/history-details';

  const DueCollectionDetailsView({
    super.key,
  });

  @override
  State<DueCollectionDetailsView> createState() =>
      _DueCollectionDetailsViewState();
}

class _DueCollectionDetailsViewState
    extends State<DueCollectionDetailsView> {
  DueCollectionController controller = Get.find();

  int i = 1;

  late int orderId;
  late String orderNo;

  @override
  void initState() {
    orderId = Get.arguments[0];
    orderNo = Get.arguments[1];

    i = 1;
    controller.getDueCollectionDetails(context, orderId);
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
                  GetBuilder<DueCollectionController>(
                    id: 'due_collection_details',
                    builder: (controller) {
                      if (controller.detailsLoading) {
                        return Center(child: RandomLottieLoader.lottieLoader());
                      } else if (controller.dueCollectionDetailsResponseModel !=
                          null) {
                        DueCollectionDetailsData data = controller.dueCollectionDetailsResponseModel!.data;
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
                                                      "Phone: ${controller.dueCollectionDetailsResponseModel!.data.business.phone}"),
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
                              const Divider(
                                color: AppColors.inputBorderColor,
                              ),
                              Row(
                                children: [
                                  Expanded(flex: 2, child: Text(data.slNo)),
                                  addW(8),
                                  const Expanded(
                                      flex: 3,
                                      child: Text(
                                        'EXPENSE VOUCHER',
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
                                        Text("Client Name: ${data.client.name}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text("Phone: ${data.client.phone}"),
                                        Text("Address: ${data.client.address}"),
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
                                            child: AutoSizeText(product.paymentMethod.name)),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 8),
                                            child: AutoSizeText(
                                                Methods.getFormattedNumber(
                                                    product.amount),
                                                textAlign: TextAlign.center)),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                              addH(8),
                              Row(
                                children: [
                                  const Text("In Words : ",
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                                  Expanded(
                                      child: Text(
                                        _convertToWords(data.details.first.amount),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                                      value: data.details.first.amount,
                                      isTitleBold: true,
                                      isValueBold: true,
                                    ),
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
        bottomNavigationBar: GetBuilder<DueCollectionController>(
            id: 'download_print_buttons',
            builder: (controller){
              if(controller.dueCollectionDetailsResponseModel != null){
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
                            controller.downloadDueCollection(
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
                            controller.downloadDueCollection(
                                shouldPrint: true,
                                orderNo: orderNo,
                                isPdf: true,
                                orderId: orderId);
                          },
                        ),
                      ),
                      // addW(20),
                      // Expanded(
                      //   child: CustomButton(
                      //     text: "POS Print",
                      //     radius: 8,
                      //     color: AppColors.primary,
                      //     onTap: () {
                      //
                      //       DueCollectionDetailsData invoice = controller
                      //           .dueCollectionDetailsResponseModel!.data;
                      //
                      //       // final Map<String, double> paymentDetails = invoice.de.fold({}, (map, e) {
                      //       //   final key = e.bank != null ? e.bank!.name : e.name;
                      //       //   map[key] = e.amount;
                      //       //   return map;
                      //       // });
                      //
                      //       Map<String, dynamic> upperSectionData = {
                      //         "Sub Total" : invoice.details.first.amount,
                      //       };
                      //
                      //       var posInvoiceModel = PosInvoiceModel(
                      //           storeName: invoice.business.name,
                      //           storeAddress: invoice.business.address,
                      //           storePhone: invoice.business.phone,
                      //           customerName: invoice.client.name,
                      //           customerPhone: invoice.client.phone,
                      //           customerAddress: invoice.client.address,
                      //           invoiceDate: invoice.date,
                      //           invoiceNo: invoice.slNo,
                      //           paymentUpperSection: upperSectionData,
                      //           paymentDetails: paymentDetails,
                      //           changeAmount: null,
                      //           products: invoice.details
                      //               .map((e) => PosProduct(
                      //               name: e.name,
                      //               qty: e.quantity,
                      //               unitPrice: e.unitPrice,
                      //               subTotal: e.total))
                      //               .toList());
                      //
                      //       Get.to(BluetoothPrinterScreen(),arguments: posInvoiceModel);
                      //       Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothPrinterScreen(),),);
                      //       controller.downloadSaleHistory(
                      //           shouldPrint: true,
                      //           orderNo: orderNo,
                      //           isPdf: true,
                      //           orderId: orderId);
                      //
                      //     },
                      //   ),
                      // ),
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
