import 'package:amar_pos/core/widgets/reusable/payment_dd/ca_payment_method_dropdown_widget.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/book_ledger/book_ledger_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/money_transfer/money_transfer_list_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/ledger/ledger_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/money_transfer_bottom_sheet.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/money_transfer_item.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/methods/helper_methods.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/pager_list_view.dart';
import '../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';

class LedgerScreen extends StatefulWidget {
  static const routeName = '/accounting/ledger-screen';

  const LedgerScreen({super.key});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen>
    with SingleTickerProviderStateMixin {
  LedgerController controller = Get.find();

  ChartOfAccountPaymentMethod? selectedAccount;

  @override
  void initState() {
    // controller.getBookLedger();
    _fetchData();
    _verticalScrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_verticalScrollController.position.pixels >= _verticalScrollController.position.maxScrollExtent - 100) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    List<List<String>> newData = List.generate(
      _pageSize,
          (index) => List.generate(_columnCount, (i) => 'Item ${(_page - 1) * _pageSize + index + 1} - Column ${i + 1}'),
    );

    setState(() {
      _data.addAll(newData);
      _page++;
      _isLoading = false;
    });
  }

  final ScrollController _verticalScrollController = ScrollController();
  final List<List<String>> _data = [];
  bool _isLoading = false;
  int _page = 1;
  final int _pageSize = 20;
  final int _columnCount = 5;

  @override
  void dispose() {
    _verticalScrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ledger"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                DateTimeRange? selectedDate = await showDateRangePicker(
                  context: context,
                  firstDate:
                  DateTime.now().subtract(const Duration(days: 1000)),
                  lastDate: DateTime.now().add(const Duration(days: 1000)),
                  initialDateRange: controller.selectedDateTimeRange.value,
                );
                controller.selectedDateTimeRange.value = selectedDate;
                // controller.getBookLedger();
              },
              icon: SvgPicture.asset(AppAssets.calenderIcon),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // GetBuilder<DueCollectionController>(
              //   id: 'total_widget',
              //   builder: (controller) => Row(
              //     children: [
              //       TotalStatusWidget(
              //         flex: 3,
              //         isLoading: controller.isDueCollectionListLoading,
              //         title: 'Collected From',
              //         value: controller.dueCollectionListResponseModel != null
              //             ? Methods.getFormattedNumber(controller
              //             .dueCollectionListResponseModel!.countTotal
              //             .toDouble())
              //             : null,
              //         asset: AppAssets.person,
              //       ),
              //       addW(12),
              //       TotalStatusWidget(
              //         flex: 4,
              //         isLoading: controller.isDueCollectionListLoading,
              //         title: 'Collection Amount',
              //         value: controller.dueCollectionListResponseModel != null
              //             ? Methods.getFormatedPrice(controller
              //             .dueCollectionListResponseModel!.amountTotal
              //             .toDouble())
              //             : null,
              //         asset: AppAssets.amount,
              //       ),
              //     ],
              //   ),
              // ),
              addH(12),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CAPaymentMethodsDropDownWidget(
                              initialCAPaymentMethod: selectedAccount,
                              lastLevelAccount: true,
                              noTitle: true,
                              height: 48,
                              hint: "Select Account",
                              searchHint: "Search an account",
                              onCAPaymentMethodSelection: (value) {
                                selectedAccount = value;
                                controller.getBookLedger(caID: selectedAccount!.id);
                                controller.update(['selection_status']);
                              }),
                        ),
                        addW(8),
                        CustomSvgIconButton(
                          bgColor: const Color(0xffE1F2FF),
                          onTap: () {
                            controller.downloadList(isPdf: true,);
                          },
                          assetPath: AppAssets.downloadIcon,
                        ),
                        addW(4),
                        CustomSvgIconButton(
                          bgColor: const Color(0xffFFFCF8),
                          onTap: () {
                            controller.downloadList(
                                isPdf: true, shouldPrint: true);
                          },
                          assetPath: AppAssets.printIcon,
                        )

                      ],
                    ),
                    addH(8),
                    GetBuilder<LedgerController>(
                        id: 'selection_status',
                        builder: (controller) {
                          return selectedAccount != null
                              ? RichText(text: TextSpan(text: "Book Ledger report: ",style: TextStyle(color: Colors.grey),children: [TextSpan(text: selectedAccount!.name,style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.black),),]

                          ,
                          )): SizedBox.shrink();
                          // Text("Book Ledger report for ${selectedAccount!.name}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),maxLines: 2,): SizedBox.shrink();
                        }),
                    addH(4),
                    Obx(() {
                      return controller.selectedDateTimeRange.value == null
                          ? const SizedBox.shrink()
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${formatDate(
                              controller.selectedDateTimeRange.value!
                                  .start)} - ${formatDate(
                              controller.selectedDateTimeRange.value!.end)}",
                            style: const TextStyle(
                                fontSize: 14, color: AppColors.error),),
                          addW(16),
                          GestureDetector(
                              onTap: () {
                                controller.selectedDateTimeRange.value = null;

                              },
                              child: Icon(
                                Icons.cancel_outlined, color: AppColors.error,
                                size: 16,))
                        ],
                      );
                    }),
                  ],
                ),
              ),
              addH(8),

              SizedBox(
                height: 600,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Enables full table horizontal scrolling
                  child: SizedBox(
                    width: 800,
                    child: Column(
                      children: [
                        // Table Header
                        Container(
                          decoration: BoxDecoration(color: Colors.grey[300]),
                          child: Row(
                            children: List.generate(
                              _columnCount,
                                  (index) => Container(
                                width: 150,
                                padding: const EdgeInsets.all(12),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                child: Text("Column ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: _verticalScrollController,
                            itemCount: _data.length + (_isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _data.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              return Row(
                                children: _data[index].map((item) {
                                  return Container(
                                    width: 150,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Text(item, textAlign: TextAlign.center),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Expanded(
              //   child: GetBuilder<LedgerController>(
              //     id: 'money_transfer_list',
              //     builder: (controller) {
              //       if (controller.ismoneyTransferListLoading) {
              //         return const Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       }else if(controller.bookLedgerListResponseModel == null){
              //         return Center(
              //           child: Text("Something went wrong", style: context.textTheme.titleLarge,),
              //         );
              //       }else if(controller.ledgerList.isEmpty){
              //         return Center(
              //           child: Text("No data found", style: context.textTheme.titleLarge,),
              //         );
              //       }
              //       return Table(
              //         border: TableBorder.all(
              //           color: Colors.grey,
              //         ),
              //         columnWidths: {
              //           0: FixedColumnWidth(80.w),
              //           1: FlexColumnWidth(80.w),
              //           2: FlexColumnWidth(80.w),
              //           3: FixedColumnWidth(80.w),
              //           4: FixedColumnWidth(80.w),
              //           5: FixedColumnWidth(80.w),
              //         },
              //         children: [
              //           TableRow(
              //             decoration: BoxDecoration(color: Colors.grey[200]),
              //             children: const [
              //               Padding(
              //
              //                   padding: EdgeInsets.all(8),
              //                   child: AutoSizeText(
              //                     "Date",
              //                     maxLines: 1,
              //                     minFontSize: 2,
              //                     maxFontSize: 12,
              //                     textAlign: TextAlign.center,
              //                     style:
              //                     TextStyle(fontWeight: FontWeight.bold),
              //                   )),
              //               Padding(
              //                   padding: EdgeInsets.all(8),
              //                   child: AutoSizeText(
              //                     "ID",
              //                     maxLines: 1,
              //                     minFontSize: 2,
              //                     maxFontSize: 12,
              //                     textAlign: TextAlign.center,
              //                     style:
              //                     TextStyle(fontWeight: FontWeight.bold),
              //                   )),
              //               Padding(
              //                   padding: EdgeInsets.all(8),
              //                   child: AutoSizeText(
              //                     "Particular",
              //                     maxLines: 1,
              //                     minFontSize: 2,
              //                     maxFontSize: 12,
              //                     textAlign: TextAlign.center,
              //                     style:
              //                     TextStyle(fontWeight: FontWeight.bold),
              //                   )),
              //               Padding(
              //                   padding: EdgeInsets.all(8),
              //                   child: AutoSizeText(
              //                     "Debit",
              //                     maxLines: 1,
              //                     minFontSize: 2,
              //                     maxFontSize: 12,
              //                     textAlign: TextAlign.center,
              //                     style:
              //                     TextStyle(fontWeight: FontWeight.bold),
              //                   )),
              //               Padding(
              //                   padding: EdgeInsets.all(8),
              //                   child: AutoSizeText(
              //                     "Credit",
              //                     maxLines: 1,
              //                     minFontSize: 2,
              //                     maxFontSize: 12,
              //                     textAlign: TextAlign.center,
              //                     style:
              //                     TextStyle(fontWeight: FontWeight.bold),
              //                   )),
              //               Padding(
              //                   padding: EdgeInsets.all(8),
              //                   child: AutoSizeText(
              //                     "Balance",
              //                     maxLines: 1,
              //                     minFontSize: 2,
              //                     maxFontSize: 12,
              //                     textAlign: TextAlign.center,
              //                     style:
              //                     TextStyle(fontWeight: FontWeight.bold),
              //                   )),
              //             ],
              //           ),
              //           ...controller.ledgerList.map((e) {
              //             return TableRow(
              //               children: [
              //                 Padding(
              //                     padding: EdgeInsets.all(8),
              //                     child: AutoSizeText(
              //                       e.date ?? "",
              //                       maxLines: 1,
              //                       minFontSize: 2,
              //                       maxFontSize: 12,
              //                       textAlign: TextAlign.center,
              //                     )),
              //                 Padding(
              //                     padding: EdgeInsets.all(8),
              //                     child: AutoSizeText(
              //                       e.slNo ?? "",
              //                       maxLines: 2,
              //                       minFontSize: 2,
              //                       maxFontSize: 12,
              //                       textAlign: TextAlign.center,
              //                     )),
              //                 Padding(
              //                     padding: EdgeInsets.all(8),
              //                     child: AutoSizeText(
              //                       e.accountName ?? "",
              //                       maxLines: 2,
              //                       minFontSize: 2,
              //                       maxFontSize: 12,
              //                       textAlign: TextAlign.center,
              //                     )),
              //                 Padding(
              //                     padding: EdgeInsets.all(8),
              //                     child: Center(
              //                       child: AutoSizeText(
              //                         e.debit.toString() ?? "",
              //                         maxLines: 1,
              //                         minFontSize: 2,
              //                         textAlign: TextAlign.center,
              //                       ),
              //                     )),
              //                 Padding(
              //                     padding: EdgeInsets.all(8),
              //                     child: Center(
              //                       child: AutoSizeText(
              //                         e.credit.toString() ?? "",
              //                         maxLines: 1,
              //                         minFontSize: 2,
              //                         textAlign: TextAlign.center,
              //                       ),
              //                     )),
              //                 Padding(
              //                     padding: EdgeInsets.all(8),
              //                     child: AutoSizeText(
              //                       e.balance.toString() ?? "",
              //                       maxLines: 2,
              //                       minFontSize: 2,
              //                       textAlign: TextAlign.center,
              //                     )),
              //               ],
              //             );
              //           }),
              //           // TableRow(
              //           //   decoration: BoxDecoration(color: Colors.green[900]),
              //           //   children: [
              //           //     SizedBox.shrink(),
              //           //     SizedBox.shrink(),
              //           //     Padding(
              //           //         padding: EdgeInsets.all(8),
              //           //         child: AutoSizeText("Total",
              //           //             maxLines: 1,
              //           //             maxFontSize: 10,
              //           //             minFontSize: 2,
              //           //             textAlign: TextAlign.center,
              //           //             style: TextStyle(
              //           //                 fontWeight: FontWeight.bold,
              //           //                 color: Colors.white))),
              //           //     Padding(
              //           //         padding: EdgeInsets.all(8),
              //           //         child: AutoSizeText(
              //           //             "${Methods.getFormattedNumber(controller.clientLedgerStatementResponseModel!.data!.debit!.toDouble())}",
              //           //             minFontSize: 2,
              //           //             maxFontSize: 10,
              //           //             overflow: TextOverflow.visible,
              //           //             maxLines: 1,
              //           //             textAlign: TextAlign.center,
              //           //             style: TextStyle(
              //           //                 fontWeight: FontWeight.bold,
              //           //                 color: Colors.white))),
              //           //     Padding(
              //           //         padding: EdgeInsets.all(8),
              //           //         child: AutoSizeText(
              //           //             "${Methods.getFormattedNumber(controller.clientLedgerStatementResponseModel!.data!.credit!.toDouble())}",
              //           //             maxLines: 1,
              //           //             minFontSize: 2,
              //           //             maxFontSize: 10,
              //           //             overflow: TextOverflow.visible,
              //           //             textAlign: TextAlign.center,
              //           //             style: TextStyle(
              //           //                 fontWeight: FontWeight.bold,
              //           //                 color: Colors.white))),
              //           //     Padding(
              //           //         padding: EdgeInsets.all(8),
              //           //         child: AutoSizeText(
              //           //             "${Methods.getFormattedNumber(controller.clientLedgerStatementResponseModel!.data!.balance!.toDouble())}",
              //           //             maxLines: 1,
              //           //             minFontSize: 2,
              //           //             maxFontSize: 10,
              //           //             overflow: TextOverflow.visible,
              //           //             textAlign: TextAlign.center,
              //           //             style: TextStyle(
              //           //                 fontWeight: FontWeight.bold,
              //           //                 color: Colors.white))),
              //           //   ],
              //           // ),
              //         ],
              //       );
              //       return RefreshIndicator(
              //         onRefresh: () async {
              //           // controller.getMoneyTransferList(page: 1);
              //         },
              //         child: PagerListView<LedgerData>(
              //           // scrollController: _scrollController,
              //           items: controller.ledgerList,
              //           itemBuilder: (_, item) {
              //             return Container(
              //               margin: const EdgeInsets.only(bottom: 8),
              //               child: Text(
              //                 item.slNo ?? "",
              //               )
              //             );
              //           },
              //           isLoading: controller.isLoadingMore,
              //           hasError: controller.hasError.value,
              //           onNewLoad: (int nextPage) async {
              //             await controller.getBookLedger(page: nextPage, caID: selectedAccount!.id);
              //           },
              //           totalPage: controller
              //               .bookLedgerListResponseModel?.data?.first.data?.lastPage ?? 0,
              //           totalSize:
              //           controller
              //               .bookLedgerListResponseModel?.data?.first.data?.total ??
              //               0,
              //           itemPerPage: 20,
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
            text: "Transfer Money",
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return MoneyTransferBottomSheet();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
