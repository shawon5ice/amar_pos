import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
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

class SalesScreen extends StatefulWidget {
  static String routeName = '/sales_screen';

  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int _currentIndex = 0;


  SalesController controller = Get.put(SalesController());

  // Future<bool> _onWillPop() async {
  //   if (hasUnsavedChanges) {
  //     return await _showUnsavedChangesDialog();
  //   }
  //   return true;
  // }

  Future<bool> showDiscardDialog(BuildContext context) async {
    bool value = false;
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Warning"),
          content: Text("Do you want to discard your current operation?"),
          actions: [
            TextButton(
              onPressed: () {
                value = false;
                Navigator.of(context).pop(false);
              }, // Return `false` for "No"
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                value = true;
                Navigator.of(context).pop(true);
              }, // Return `true` for "Yes"
              child: Text("Yes"),
            ),
          ],
        );
      },
    ) ?? value;
  }


  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() async {
      if(_tabController.indexIsChanging){
        // controller.brand = null;
        // controller.category = null;
        controller.selectedDateTimeRange.value = null;
        controller.searchProductController.clear();
        FocusScope.of(context).unfocus();
        controller.update(['action_icon']);
      }
      if (_tabController.index != _tabController.previousIndex && _tabController.previousIndex ==0 ) {
        controller.searchProductController.clear();
        controller.selectedDateTimeRange.value = null;
        FocusScope.of(context).unfocus();
        // Check if the user is editing and is leaving the first tab
        if (controller.placeOrderProducts.isNotEmpty) {
          // Store the new index
          int newIndex = _tabController.index;

          // Revert the tab index temporarily
          _tabController.index = _tabController.previousIndex;

          // Show the discard dialog
          bool discard = await showDiscardDialog(context);
          logger.d(discard);

          if (discard) {
            controller.placeOrderProducts.clear();
            _tabController.animateTo(newIndex);
            controller.clearEditing();
          }
        }
        controller.update(['action_icon']); // Update the specific UI element
      }
    });
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
    return PopScope(
      onPopInvoked: (value) async {
        if(controller.isEditing){
          drawerMenuController.closeDrawer();
          bool val = await showDiscardDialog(context);
          if(val){
            controller.clearEditing();
            _tabController.animateTo(1);
          }
        }
      },
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: DrawerButton(
            onPressed: () async {
              if(controller.isEditing){
                bool openDrawer = await showDiscardDialog(context);
                if(openDrawer){
                  controller.clearEditing();
                  drawerMenuController.openDrawer();
                }
              }else{
                drawerMenuController.openDrawer();
              }
            },
          ),
          title: const Text("Sales"),
          actions: [
            GetBuilder<SalesController>(
              id: 'action_icon',
              builder: (controller) => _tabController.index == 0? SizedBox()
              // GestureDetector(
              //   child: SvgPicture.asset(AppAssets.pauseBillingIcon),
              // )
                  :
              GestureDetector(
                onTap: (){
                  showModalBottomSheet(context: context, builder:(context) => SoldHistoryFilterBottomSheet(
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
                        text: 'Place Order',
                      ),
                      Tab(text: 'History'),
                      Tab(text: 'Products'),
                    ],
                  ),
                ),
                addH(12),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      PlaceOrder(),
                      SoldHistory(
                        onChange: (value){
                          _tabController.index = value;
                        },
                      ),
                      SoldProduct(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
