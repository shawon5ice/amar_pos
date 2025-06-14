import 'package:amar_pos/core/widgets/reusable/filter_bottom_sheet/filter_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/data/models/create_stock_transfer_request_model.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/pages/stock_transfer_history_screen.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/pages/stock_transfer_view.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/pages/widgets/stock_transfer_filter_widget.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/stock_transfer_controller.dart';
import 'package:amar_pos/features/purchase/presentation/pages/purchase_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/data/model/outlet_model.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/reusable/filter_bottom_sheet/product_brand_category_warranty_unit_response_model.dart';
import '../../../../core/widgets/reusable/filter_bottom_sheet/simple_filter_bottom_sheet_widget.dart';
import '../../../drawer/drawer_menu_controller.dart';

class StockTransferScreen extends StatefulWidget {
  static const String routeName = "/stock-transfer";
  const StockTransferScreen({super.key});

  @override
  State<StockTransferScreen> createState() => _StockTransferScreenState();
}

class _StockTransferScreenState extends State<StockTransferScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final StockTransferController controller = Get.put(StockTransferController());

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() async {
      if(_tabController.indexIsChanging){
        controller.brand = null;
        controller.category = null;
        controller.selectedDateTimeRange.value = null;
        controller.searchProductController.clear();
        controller.clearEditing();
        FocusScope.of(context).unfocus();
        controller.update(['action_icon']);
      }
      if (_tabController.index != _tabController.previousIndex && _tabController.previousIndex ==0 ) {
        controller.searchProductController.clear();
        controller.selectedDateTimeRange.value = null;
        FocusScope.of(context).unfocus();
        // Check if the user is editing and is leaving the first tab
        if (controller.purchaseOrderProducts.isNotEmpty) {
          // Store the new index
          int newIndex = _tabController.index;

          // Revert the tab index temporarily
          _tabController.index = _tabController.previousIndex;

          // Show the discard dialog
          bool discard = await showDiscardDialog(context);
          logger.d(discard);

          if (discard) {
            controller.purchaseOrderProducts.clear();
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
    Get.delete<StockTransferController>();
    Get.delete<ProductController>();
    Get.delete<FilterController>();
    super.dispose();
  }


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
                controller.clearEditing();
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
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title:const Text("Stock Transfer"),
          centerTitle: true,
          leading: DrawerButton(
            onPressed: () async {
              if (controller.createStockTransferRequestModel.products.isNotEmpty) {
                bool discard = await showDiscardDialog(context);
                logger.d(discard);
                if(discard){
                  controller.createStockTransferRequestModel = CreateStockTransferRequestModel.defaultConstructor();
                  controller.purchaseOrderProducts.clear();
                  controller.clearEditing();
                  drawerMenuController.openDrawer();
                }
              }else{
                drawerMenuController.openDrawer();
              }
            },
          ),
          actions: [
            GetBuilder<StockTransferController>(
                id: 'action_icon',
                builder: (controller) => _tabController.index == 1 && controller.historyAccess ? IconButton(
                  onPressed: () async {
                    showModalBottomSheet(context: context, builder: (context) => StockTransferFilterBottomSheetWidget(selectedDateTimeRange: controller.selectedDateTimeRange.value, onSubmit: (){
                      Get.back();
                      controller.getStockTransferHistory();
                    }));
                  },
                  icon: Icon(Icons.filter_alt_outlined, color: (controller.brand != null || controller.category != null || controller.selectedDateTimeRange.value != null) ? AppColors.error : null,),
                ): SizedBox.shrink()
            ),
            addW(12),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
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
                      text: 'Stock Transfer',
                    ),
                    Tab(text: 'Stock Transfer History'),
                  ],
                ),
              ),
              addH(8),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    StockTransferView(onSuccess:  (value){
                      _tabController.animateTo(value);
                    },),
                    StockTransferHistoryScreen(onChange: (value){
                      _tabController.animateTo(value);
                    }),
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
