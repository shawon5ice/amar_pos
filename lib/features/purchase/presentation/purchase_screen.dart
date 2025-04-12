import 'package:amar_pos/core/widgets/reusable/filter_bottom_sheet/filter_controller.dart';
import 'package:amar_pos/core/widgets/reusable/filter_bottom_sheet/product_brand_category_warranty_unit_response_model.dart';
import 'package:amar_pos/core/widgets/reusable/filter_bottom_sheet/simple_filter_bottom_sheet_widget.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:amar_pos/features/purchase/presentation/pages/purchase_history_screen.dart';
import 'package:amar_pos/features/purchase/presentation/pages/purchase_products.dart';
import 'package:amar_pos/features/purchase/presentation/pages/purchase_view.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:amar_pos/features/purchase/presentation/widgets/purchase_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/logger/logger.dart';
import '../../../core/data/model/outlet_model.dart';
import '../../../core/responsive/pixel_perfect.dart';
import '../../../permission_manager.dart';
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
      if (_tabController.indexIsChanging) {
        controller.brand = null;
        controller.category = null;
        controller.selectedDateTimeRange.value = null;
        controller.searchProductController.clear();
        FocusScope.of(context).unfocus();
        controller.update(['action_icon']);
      }

      if (_tabController.index != _tabController.previousIndex && _tabController.previousIndex == 0) {
        controller.searchProductController.clear();
        controller.selectedDateTimeRange.value = null;
        FocusScope.of(context).unfocus();

        if (controller.purchaseOrderProducts.isNotEmpty) {
          int newIndex = _tabController.index;

          // Instantly revert without animation to avoid glitch
          _tabController.animateTo(_tabController.previousIndex, duration: Duration.zero);

          bool discard = await showDiscardDialog(context);
          logger.d(discard);

          if (discard) {
            controller.purchaseOrderProducts.clear();
            controller.clearEditing();

            // Animate to new tab after discard confirmation
            _tabController.animateTo(newIndex);
          }
        }

        controller.update(['action_icon']);
      }
    });

    super.initState();
  }


  @override
  void dispose() {
    Get.delete<PurchaseController>();
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
      child: GetBuilder<PurchaseController>(
        id: 'permission_handler_builder',
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title:const Text("Purchase"),
              centerTitle: true,
              leading: DrawerButton(
                onPressed: () async {
                  if (controller.isEditing) {
                    bool discard = await showDiscardDialog(context);
                    logger.d(discard);
                    if(discard){
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
                GetBuilder<PurchaseController>(
                  id: 'action_icon',
                  builder: (controller) => _tabController.index == 0 && controller.purchaseCreateAccess ? GestureDetector(
                    child: SvgPicture.asset(AppAssets.pauseBillingIcon),
                  ): _tabController.index == 2 && controller.productAccess ? IconButton(
                    onPressed: () async {
                      showModalBottomSheet(context: context, builder: (context) => SimpleFilterBottomSheetWidget(
                        selectedBrand: controller.brand,
                        disableOutlet: true,
                        selectedCategory: controller.category,
                        selectedDateTimeRange: controller.selectedDateTimeRange.value,
                        onSubmit: (FilterItem? brand,FilterItem? category,DateTimeRange? dateTimeRange, OutletModel? outlet){
                          controller.brand = brand;
                          controller.category = category;
                          controller.selectedDateTimeRange.value = dateTimeRange;
                          logger.i(controller.brand);
                          logger.i(controller.category?.id);
                          logger.i(controller.selectedDateTimeRange.value);
                          Get.back();
                          if(_tabController.index == 1){
                            controller.getPurchaseHistory();
                          }else{
                            controller.getPurchaseProducts();
                          }
                        },
                      ));
                    },
                    icon: Icon(Icons.filter_alt_outlined, color: (controller.brand != null || controller.category != null || controller.selectedDateTimeRange.value != null) ? AppColors.error : null,),
                  ):  _tabController.index == 1 && controller.historyAccess ? GestureDetector(
                    onTap: () async {
                      DateTimeRange? selectedDate =
                      await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 1000)),
                        lastDate: DateTime.now()
                            .add(const Duration(days: 1000)),
                        initialDateRange:
                        controller.selectedDateTimeRange.value,
                      );
                      if (selectedDate != null) {
                        controller.selectedDateTimeRange.value =
                            selectedDate;
                        controller.getPurchaseHistory();
                      }
                    },
                    child: SvgPicture.asset(AppAssets.calenderIcon),
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
                          text: 'Purchase',
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
                        PurchaseView(onSuccess:  (value){
                          _tabController.animateTo(value);
                        },),
                        PurchaseHistoryScreen(onChange: (value){
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
      ),
    );
  }
}
