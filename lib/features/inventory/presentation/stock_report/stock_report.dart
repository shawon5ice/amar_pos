import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:amar_pos/features/inventory/presentation/stock_report/page/stock_ledger_page.dart';
import 'package:amar_pos/features/inventory/presentation/stock_report/page/stock_report_page.dart';
import 'package:amar_pos/features/inventory/presentation/stock_report/stock_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive/pixel_perfect.dart';

class StockReportScreen extends StatefulWidget {
  static const String routeName = "/stock-report";

  const StockReportScreen({super.key});

  @override
  State<StockReportScreen> createState() => _StockReportScreenState();
}

class _StockReportScreenState extends State<StockReportScreen>
    with SingleTickerProviderStateMixin {
  final StockReportController controller = Get.put(StockReportController());
  final DrawerMenuController _menuController = Get.find();

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    // controller.getStockReportList(page: 1, context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Report"),
        centerTitle: true,
        leading: DrawerButton(
          onPressed: _menuController.openDrawer,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
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
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                      text: 'Stock Report',
                    ),
                    Tab(text: 'Stock Ledger'),
                  ],
                ),
              ),
              addH(12),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: const [
                    StockReportPage(),
                    StockLedgerPage(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
