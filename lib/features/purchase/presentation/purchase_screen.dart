import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/responsive/pixel_perfect.dart';
import '../../drawer/drawer_menu_controller.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final PurchaseController controller = Get.put(PurchaseController());

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
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text("Purchase"),
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
          GetBuilder<PurchaseController>(
            id: 'action_icon',
            builder: (controller) => _tabController.index == 0? GestureDetector(
              child: SvgPicture.asset(AppAssets.pauseBillingIcon),
            ): GestureDetector(
              onTap: (){
                // showModalBottomSheet(context: context, builder:(context) => SoldHistoryFilterBottomSheet(
                //   saleHistory: _tabController.index == 1,
                // ));
              },
              child: SvgPicture.asset(AppAssets.funnelFilter),
            ),
          ),
          addW(12),
        ],
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
