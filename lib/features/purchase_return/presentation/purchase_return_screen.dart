import 'package:amar_pos/features/purchase/presentation/pages/purchase_history_screen.dart';
import 'package:amar_pos/features/purchase/presentation/pages/purchase_products.dart';
import 'package:amar_pos/features/purchase/presentation/pages/purchase_view.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:amar_pos/features/purchase/presentation/widgets/purchase_filter_bottom_sheet.dart';
import 'package:amar_pos/features/purchase_return/presentation/pages/purchase_history_screen.dart';
import 'package:amar_pos/features/purchase_return/presentation/pages/purchase_return_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/responsive/pixel_perfect.dart';
import '../../drawer/drawer_menu_controller.dart';
import 'purchase_return_controller.dart';

class PurchaseReturnScreen extends StatefulWidget {
  const PurchaseReturnScreen({super.key});

  @override
  State<PurchaseReturnScreen> createState() => _PurchaseReturnScreenState();
}

class _PurchaseReturnScreenState extends State<PurchaseReturnScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final PurchaseReturnController controller = Get.put(PurchaseReturnController());

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() async {
      if (_tabController.index != _tabController.previousIndex) {
        // controller.searchProductController.clear();

        // Check if the user is editing and is leaving the first tab
        // if (controller.isEditing && _tabController.previousIndex == 0) {
        //   // Store the new index
        //   int newIndex = _tabController.index;
        //
        //   // Revert the tab index temporarily
        //   _tabController.index = _tabController.previousIndex;
        //
        //   // Show the discard dialog
        //   bool discard = await showDiscardDialog(context);
        //   logger.d(discard);
        //
        //   if (discard) {
        //     controller.clearEditing();
        //     _tabController.animateTo(newIndex);
        //   }
        // }
        controller.update(['action_icon']); // Update the specific UI element
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<PurchaseReturnController>();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text("Purchase Return"),
        centerTitle: true,
        leading: DrawerButton(
          onPressed: () async {
            // if (controller.isEditing) {
            //   bool openDrawer = await showDiscardDialog(context);
            //   if (openDrawer) {
            //     controller.clearEditing();
            //     drawerMenuController.openDrawer();
            //   }
            // } else {
            //   drawerMenuController.openDrawer();
            // }
            drawerMenuController.openDrawer();
          },
        ),
        actions: [
          GetBuilder<PurchaseReturnController>(
            id: 'action_icon',
            builder: (controller) => _tabController.index == 0? GestureDetector(
              child: SvgPicture.asset(AppAssets.pauseBillingIcon),
            ): GestureDetector(
              onTap: (){
                showModalBottomSheet(context: context, builder:(context) => PurchaseFilterBottomSheet(
                  purchaseHistory: _tabController.index == 1,
                ));
              },
              child: SvgPicture.asset(AppAssets.funnelFilter),
            ),
          ),
          addW(12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
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
                  Tab(text: 'History'),
                  Tab(text: 'Products'),
                ],
              ),
            ),
            addH(12),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  PurchaseReturnView(),
                  PurchaseReturnHistoryScreen(onChange: (value){
                    _tabController.animateTo(value);
                  }),
                  PurchaseProducts(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
