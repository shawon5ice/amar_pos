import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/widgets/reusable/filter_bottom_sheet/simple_filter_bottom_sheet_widget.dart';
import 'package:amar_pos/features/exchange/exchange_controller.dart';
import 'package:amar_pos/features/exchange/presentation/exchange_products.dart';
import 'package:amar_pos/features/exchange/presentation/exchange_steps/exchange_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/logger/logger.dart';
import '../../core/data/model/outlet_model.dart';
import '../../core/responsive/pixel_perfect.dart';
import '../../core/widgets/reusable/filter_bottom_sheet/product_brand_category_warranty_unit_response_model.dart';
import '../drawer/drawer_menu_controller.dart';
import 'presentation/exchange_history.dart';
import 'presentation/widgets/exchange_filter_widget.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  ExchangeController controller = Get.put(ExchangeController());

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
                controller.clearExchange();
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
      if ((controller.returnOrderProducts.isNotEmpty || controller.exchangeProducts.isNotEmpty) && _tabController.previousIndex == 0) {
        // Store the new index
        int newIndex = _tabController.index;

        // Revert the tab index temporarily
        _tabController.index = _tabController.previousIndex;

        // Show the discard dialog
        bool discard = await showDiscardDialog(context);
        logger.d(discard);

        if (discard) {
          controller.returnOrderProducts.clear();
          controller.exchangeProducts.clear();
          _tabController.animateTo(newIndex);
        }
      }else if(_tabController.index == 2){
        // controller.getExchangeProducts(
        //   productType: 3,
        // );
      }
      controller.clearFilter();
      controller.update(['action_icon']);
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ExchangeController>();
    super.dispose();
  }

  final DrawerMenuController drawerMenuController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: PopScope(
        canPop: false,
        child:GetBuilder<ExchangeController>(
            id: 'permission_handler_builder',
            builder: (controller) {
            return SafeArea(
              child: Scaffold(
                appBar:  AppBar(
                  centerTitle: true,
                  leading: DrawerButton(
                    onPressed: () async {

                      if ((controller.returnOrderProducts.isNotEmpty || controller.exchangeProducts.isNotEmpty) && _tabController.previousIndex == 0) {
                        bool discard = await showDiscardDialog(context);
                        logger.d(discard);
                        if(discard){
                          drawerMenuController.openDrawer();
                        }
                      }else{
                        drawerMenuController.openDrawer();
                      }
                      // if(controller.isEditing){
                      //   bool openDrawer = await showDiscardDialog(context);
                      //   if(openDrawer){
                      //     controller.clearEditing();
                      //     drawerMenuController.openDrawer();
                      //   }
                      // }else{
                      //   drawerMenuController.openDrawer();
                      // }
                    },
                  ),
                  title: const Text("Exchange"),
                  actions: [
                    GetBuilder<ExchangeController>(
                      id: 'action_icon',
                      builder: (controller) => _tabController.index == 0? const SizedBox(): _tabController.index == 2? GestureDetector(
                        onTap: (){
                          showModalBottomSheet(context: context, builder: (context) => SimpleFilterBottomSheetWidget(
                            selectedBrand: controller.brand,
                            disableOutlet: true,
                            selectedCategory: controller.category,
                            selectedDateTimeRange: controller.selectedDateTimeRange.value,
                            onSubmit: (FilterItem? brand,FilterItem? category,DateTimeRange? dateTimeRange, OutletModel? outlet){
                              controller.update(['action_icon']);
                              controller.brand = brand;
                              controller.category = category;
                              controller.selectedDateTimeRange.value = dateTimeRange;
                              // controller.selectedDateTimeRange.value = dateTimeRange;
                              logger.i(controller.brand);
                              logger.i(controller.category?.id);
                              // logger.i(controller.selectedDateTimeRange.value);
                              Get.back();
                              controller.getExchangeProducts();
                            },
                          ));
                        },
                        child: SvgPicture.asset(AppAssets.funnelFilter),
                      ) : GestureDetector(
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
                            controller.getExchangeHistory();
                          }
                        },
                        child: SvgPicture.asset(AppAssets.calenderIcon),
                      ),
                    ),
                    addW(12),
                  ],
                ),
                body: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                            text: 'Exchange',
                          ),
                          Tab(text: 'History'),
                          Tab(text: 'Products'),
                        ],
                      ),
                    ),
                    addH(4),
                    Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [
                        ExchangeView(),
                        ExchangeHistoryScreen(
                          onChange: (value){
                            _tabController.animateTo(value);
                          },
                        ),
                        ExchangeProducts()
                      ]),
                    )
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
