import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/pages/client_ledger_page.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/pages/collection_page.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/pages/expense_page.dart';
import 'package:amar_pos/features/accounting/presentation/views/supplier_payment/pages/supplier_ledger_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import 'pages/payment_page.dart';
import 'supplier_payment_controller.dart';

class SupplierPayment extends StatefulWidget {
  static const routeName = '/accounting/supplier-payment';
  const SupplierPayment({super.key});

  @override
  State<SupplierPayment> createState() => _SupplierPaymentState();
}

class _SupplierPaymentState extends State<SupplierPayment> with SingleTickerProviderStateMixin{

  SupplierPaymentController controller = Get.put(SupplierPaymentController());


  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener((){
      if(_tabController.indexIsChanging){
        controller.clearFilter();
        FocusScope.of(context).unfocus();
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Supplier Payment"),centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              DateTimeRange? selectedDate = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now().subtract(const Duration(days: 1000)),
                lastDate: DateTime.now().add(const Duration(days: 1000)),
                initialDateRange: controller.selectedDateTimeRange.value,
              );
              if (selectedDate != null) {
                controller.setSelectedDateRange(selectedDate);
                if(_tabController.index == 0){
                  controller.getSupplierPaymentList();
                }else{
                  controller.getSupplierLedger();
                }
              }
            },
            icon: SvgPicture.asset(AppAssets.calenderIcon),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 40,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: TabBar(
                dividerHeight: 0,
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal),
                labelColor: Colors.white,
                splashBorderRadius: BorderRadius.circular(20),
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(
                    text: 'Payment',
                  ),
                  Tab(text: 'Supplier Ledger'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: const [
                PaymentPage(),
                SupplierLedgerPage(),
                // ExpenseCategoryPage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
