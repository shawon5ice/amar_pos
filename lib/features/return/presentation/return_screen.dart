import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/features/return/presentation/controller/return_controller.dart';
import 'package:amar_pos/features/return/presentation/page/return_history.dart';
import 'package:amar_pos/features/return/presentation/page/return_page.dart';
import 'package:amar_pos/features/return/presentation/page/return_products.dart';
import 'package:amar_pos/features/return/presentation/widgets/return_history_filter_widget.dart';
import 'package:amar_pos/features/sales/presentation/page/place_order.dart';
import 'package:amar_pos/features/sales/presentation/page/sold_history.dart';
import 'package:amar_pos/features/sales/presentation/controller/sales_controller.dart';
import 'package:amar_pos/features/sales/presentation/page/sold_products.dart';
import 'package:amar_pos/features/sales/presentation/widgets/sold_history_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../drawer/drawer_menu_controller.dart';
import '../data/models/create_return_order_model.dart';

class ReturnScreen extends StatefulWidget {
  static String routeName = '/sales_screen';

  const ReturnScreen({super.key});

  @override
  State<ReturnScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<ReturnScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  ReturnController controller = Get.put(ReturnController());

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _tabController.previousIndex) {
        controller.searchProductController.clear();
        controller.update(['action_icon']);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ReturnController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: DrawerButton(
          onPressed: drawerMenuController.openDrawer,
        ),
        title: const Text("Return"),
        actions: [
          GetBuilder<ReturnController>(
            id: 'action_icon',
            builder: (controller) => _tabController.index == 0? SizedBox(): GestureDetector(
              onTap: (){
                showModalBottomSheet(context: context, builder:(context) => ReturnHistoryFilterBottomSheet(
                  saleHistory: _tabController.index == 1,
                ));
              },
              child: SvgPicture.asset(AppAssets.funnelFilter),
            ),
          ),
          addW(12),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Container(
                height: 40.h,
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
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
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
                      text: 'Return',
                    ),
                    Tab(text: 'Return History'),
                    Tab(text: 'Return Products'),
                  ],
                ),
              ),
              addH(12),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    ReturnPage(),
                    ReturnHistoryScreen(),
                    ReturnProducts(),
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