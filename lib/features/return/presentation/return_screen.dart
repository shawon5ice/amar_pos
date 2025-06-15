import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/features/return/presentation/controller/return_controller.dart';
import 'package:amar_pos/features/return/presentation/page/return_history.dart';
import 'package:amar_pos/features/return/presentation/page/return_page.dart';
import 'package:amar_pos/features/return/presentation/page/return_products.dart';
import 'package:amar_pos/features/return/presentation/widgets/return_history_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/logger/logger.dart';
import '../../drawer/drawer_menu_controller.dart';

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
      if (controller.returnOrderProducts.isNotEmpty && _tabController.previousIndex == 0) {
        // Store the new index
        int newIndex = _tabController.index;

        // Revert the tab index temporarily
        _tabController.index = _tabController.previousIndex;

        // Show the discard dialog
        bool discard = await showDiscardDialog(context);
        logger.d(discard);

        if (discard) {
          controller.clearEditing();
          _tabController.animateTo(newIndex);
        }
      }
      controller.clearFilter();
      controller.update(['action_icon']);
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
    return PopScope(
      canPop: false,
      child: GetBuilder<ReturnController>(
          id: 'permission_handler_builder',
          builder: (controller) {
          return Scaffold(
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
              title: const Text("Return"),
              actions: [
                GetBuilder<ReturnController>(
                  id: 'action_icon',
                  builder: (controller) => _tabController.index == 0? SizedBox(): GestureDetector(
                    onTap: (){
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context, builder:(context) => ReturnHistoryFilterBottomSheet(
                        returnHistory: _tabController.index == 1,
                        selectedBrand: controller.brand,
                        selectedCategory: controller.category,
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
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                          ReturnPage(),
                          ReturnHistoryScreen(
                            onChange: (value){
                              _tabController.index = value;
                            },
                          ),
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
      ),
    );
  }
}
