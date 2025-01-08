import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/features/sales/presentation/page/place_order.dart';
import 'package:amar_pos/features/sales/presentation/page/sold_history.dart';
import 'package:amar_pos/features/sales/presentation/controller/sales_controller.dart';
import 'package:amar_pos/features/sales/presentation/widgets/sold_history_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../drawer/drawer_menu_controller.dart';
import '../data/models/create_order_model.dart';

class SalesScreen extends StatefulWidget {
  static String routeName = '/sales_screen';

  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  SalesController controller = Get.put(SalesController());

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _tabController.previousIndex) {
        controller.update(['action_icon']);
      }
    });
    controller.getAllServiceStuff();
    controller.getAllClientList();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<SalesController>();
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
        title: const Text("Sales"),
        actions: [
          GetBuilder<SalesController>(
            id: 'action_icon',
            builder: (controller) => _tabController.index == 0? GestureDetector(
              child: SvgPicture.asset(AppAssets.pauseBillingIcon),
            ): GestureDetector(
              onTap: (){
                showModalBottomSheet(context: context, builder:(context) => SoldHistoryFilterBottomSheet());
              },
              child: SvgPicture.asset(AppAssets.filterIcon),
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
                      text: 'Place Order',
                    ),
                    Tab(text: 'Sold History'),
                    Tab(text: 'Sold Products'),
                  ],
                ),
              ),
              addH(12),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    PlaceOrder(),
                    SoldHistory(),
                    Container(),
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
