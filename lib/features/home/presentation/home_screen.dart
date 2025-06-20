import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/methods/helper_methods.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:amar_pos/features/drawer/model/menu_selection.dart';
import 'package:amar_pos/features/home/presentation/home_screen_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/add_product_screen.dart';
import 'package:amar_pos/features/inventory/presentation/products/products_screen.dart';
import 'package:amar_pos/features/sales/presentation/sales_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../permission_manager.dart';
import '../../auth/data/model/hive/login_data_helper.dart';
import '../../drawer/model/drawer_items.dart';
import '../data/models/dashboard_response_model.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home_screen";

  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  HomeScreenController controller = Get.put(HomeScreenController());

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initializePermissions();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      initializePermissions();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void initializePermissions() async {
    await controller.getDashboardData();
    await controller.getPermissions();
    if (controller.permissionApiResponse?.success == true) {
      await PermissionManager.loadPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      // drawer: CustomDrawer(),
      appBar: AppBar(
        leading: DrawerMenuWidget(onClicked: drawerMenuController.openDrawer),
        title: Text(LoginDataBoxManager().loginData!.business.name),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: SvgPicture.asset("assets/icon/notification_bell.svg"))
          // IconButton(
          //     onPressed: () {
          //       drawerMenuController.selectMenuItem(MenuSelection(parent: DrawerItems.returnAndExchange,child: 'Return'));
          //       // drawerMenuController.selectMenuItem(DrawerItems.overview)
          //       // Get.changeThemeMode(
          //       //     Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
          //     },
          //     icon: Get.isDarkMode ? Icon(Icons.sunny) : Icon(Icons.nightlight)),
        ],
      ),
      body: GetBuilder<HomeScreenController>(
          id: 'dashboard_data',
          builder: (controller) {
            return RefreshIndicator(
              onRefresh: () async{
                controller.firstTimeLoading = false;
                controller.getDashboardData();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addH(10),
                      Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: context.theme.cardColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FieldTitle(
                                  'Today’s Cash Flow',
                                  color: AppColors.accent,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                FieldTitle(
                                  formatDate(DateTime.now()),
                                  color: AppColors.accent,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isSmallScreen = constraints.maxWidth <= 240;

                                return Flex(
                                  direction: isSmallScreen
                                      ? Axis.vertical
                                      : Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: isSmallScreen
                                          ? double.infinity
                                          : constraints.maxWidth * 0.5,
                                      height: isSmallScreen ? null : 180.h,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TotalStatusWidgetWithoutExpanded(
                                            asset: AppAssets.cashInIcon,
                                            title: 'Cash In',
                                            value: controller
                                                        .dashboardResponseModel !=
                                                    null
                                                ? Methods.getFormattedNumber(
                                                    controller
                                                        .dashboardResponseModel!
                                                        .dashboardResponseData
                                                        .cashIn
                                                        .toDouble())
                                                : Methods.getFormattedNumber(0),
                                            isLoading:
                                                controller.dashboardDataLoading,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w),
                                            child: const Divider(
                                                color: Color(0xff999999)),
                                          ),
                                          TotalStatusWidgetWithoutExpanded(
                                            asset: AppAssets.cashOutIcon,
                                            title: 'Cash Out',
                                            value: controller
                                                        .dashboardResponseModel !=
                                                    null
                                                ? Methods.getFormattedNumber(
                                                    controller
                                                        .dashboardResponseModel!
                                                        .dashboardResponseData
                                                        .cashOut
                                                        .toDouble())
                                                : Methods.getFormattedNumber(0),
                                            isLoading:
                                                controller.dashboardDataLoading,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        width: isSmallScreen ? 0 : 24.w,
                                        height: isSmallScreen ? 24.h : 0),
                                    Flexible(
                                      flex: 0,
                                      child: SizedBox(
                                        width: 140.w,
                                        height: 140.w,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            CircularProgressIndicator(
                                              value: 1,
                                              strokeWidth: 10.w,
                                              strokeCap: StrokeCap.round,
                                              color: const Color(0xffCC4100),
                                            ),
                                            Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  AutoSizeText(
                                                    controller.dashboardResponseModel !=
                                                            null
                                                        ? Methods.getFormattedNumber(
                                                            controller
                                                                .dashboardResponseModel!
                                                                .dashboardResponseData
                                                                .balance
                                                                .toDouble())
                                                        : Methods
                                                            .getFormattedNumber(
                                                                0),
                                                    maxFontSize: 18.sp,
                                                    minFontSize: 10.sp,
                                                    style: TextStyle(
                                                      // color: Colors.black,
                                                      fontWeight: FontWeight.w600,
                                                      height: 1.5.sp,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Balance",
                                                    style: TextStyle(
                                                      color:
                                                          const Color(0xffA2A2A2),
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      addH(24),
                      Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: context.theme.cardColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FieldTitle(
                              'Daily Summary',
                              color: AppColors.accent,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                TotalStatusWidget(
                                  title: 'Retail Sale',
                                  asset: AppAssets.invoiceIcon,
                                  value: controller.dashboardResponseModel != null
                                      ? Methods.getFormattedNumber(controller
                                          .dashboardResponseModel!
                                          .dashboardResponseData
                                          .retailSale
                                          .toDouble())
                                      : Methods.getFormattedNumber(0),
                                  isLoading: controller.dashboardDataLoading,
                                ),
                                Container(
                                    width: 0.5,
                                    height: 80,
                                    color: Color(0xff999999)),
                                TotalStatusWidgetLeftIcon(
                                  title: 'Whole Sale',
                                  asset: AppAssets.invoiceIcon,
                                  value: controller.dashboardResponseModel != null
                                      ? Methods.getFormattedNumber(controller
                                          .dashboardResponseModel!
                                          .dashboardResponseData
                                          .wholeSale
                                          .toDouble())
                                      : Methods.getFormattedNumber(0),
                                  isLoading: controller.dashboardDataLoading,
                                ),
                              ],
                            ),
                            Divider(
                              color: Color(0xff999999),
                              height: 0,
                              thickness: .5,
                            ),
                            Row(
                              children: [
                                TotalStatusWidget(
                                  title: 'Expense',
                                  value: controller.dashboardResponseModel != null
                                      ? Methods.getFormattedNumber(controller
                                          .dashboardResponseModel!
                                          .dashboardResponseData
                                          .expense
                                          .toDouble())
                                      : Methods.getFormattedNumber(0),
                                  isLoading: controller.dashboardDataLoading,
                                  asset: AppAssets.expense,
                                ),
                                Container(
                                    width: 0.5,
                                    height: 80,
                                    color: Color(0xff999999)),
                                TotalStatusWidgetLeftIcon(
                                  title: 'Collection',
                                  value: controller.dashboardResponseModel != null
                                      ? Methods.getFormattedNumber(controller
                                          .dashboardResponseModel!
                                          .dashboardResponseData
                                          .collection
                                          .toDouble())
                                      : Methods.getFormattedNumber(0),
                                  isLoading: controller.dashboardDataLoading,
                                  asset: AppAssets.collection,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      // const FieldTitle(
                      //   'Today’s Cash Flow',
                      //   color: AppColors.accent,
                      //   fontSize: 16,
                      //   fontWeight: FontWeight.bold,
                      // ),
                      // addH(4),
                      // Row(
                      //   children: [
                      //     TotalStatusWidget(
                      //       asset: AppAssets.cashInIcon,
                      //       title: 'Cash In',
                      //       value: controller.dashboardResponseModel != null
                      //           ? Methods.getFormattedNumber(controller
                      //               .dashboardResponseModel!
                      //               .dashboardResponseData
                      //               .cashIn
                      //               .toDouble())
                      //           : Methods.getFormattedNumber(0),
                      //       isLoading: controller.dashboardDataLoading,
                      //     ),
                      //     addW(8),
                      //     TotalStatusWidget(
                      //       asset: AppAssets.cashOutIcon,
                      //       title: 'Cash Out',
                      //       value: controller.dashboardResponseModel != null
                      //           ? Methods.getFormattedNumber(controller
                      //               .dashboardResponseModel!
                      //               .dashboardResponseData
                      //               .cashOut
                      //               .toDouble())
                      //           : Methods.getFormattedNumber(0),
                      //       isLoading: controller.dashboardDataLoading,
                      //     ),
                      //     addW(8),
                      //     TotalStatusWidget(
                      //       asset: AppAssets.cashIcon,
                      //       title: 'Balance',
                      //       value: controller.dashboardResponseModel != null
                      //           ? Methods.getFormattedNumber(controller
                      //               .dashboardResponseModel!
                      //               .dashboardResponseData
                      //               .balance
                      //               .toDouble())
                      //           : Methods.getFormattedNumber(0),
                      //       isLoading: controller.dashboardDataLoading,
                      //     ),
                      //   ],
                      // ),
                      // addH(20),
                      // const FieldTitle(
                      //   'Daily Summary',
                      //   color: AppColors.accent,
                      //   fontSize: 16,
                      //   fontWeight: FontWeight.bold,
                      // ),
                      // addH(4),
                      // Row(
                      //   children: [
                      //     TotalStatusWidget(
                      //       title: 'Retail Sale',
                      //       asset: AppAssets.invoiceIcon,
                      //       value: controller.dashboardResponseModel != null
                      //           ? Methods.getFormattedNumber(controller
                      //               .dashboardResponseModel!
                      //               .dashboardResponseData
                      //               .retailSale
                      //               .toDouble())
                      //           : Methods.getFormattedNumber(0),
                      //       isLoading: controller.dashboardDataLoading,
                      //     ),
                      //     addW(8),
                      //     TotalStatusWidget(
                      //       title: 'Whole Sale',
                      //       asset: AppAssets.invoiceIcon,
                      //       value: controller.dashboardResponseModel != null
                      //           ? Methods.getFormattedNumber(controller
                      //               .dashboardResponseModel!
                      //               .dashboardResponseData
                      //               .wholeSale
                      //               .toDouble())
                      //           : Methods.getFormattedNumber(0),
                      //       isLoading: controller.dashboardDataLoading,
                      //     ),
                      //   ],
                      // ),
                      // addH(8),
                      // Row(
                      //   children: [
                      //     TotalStatusWidget(
                      //       title: 'Expense',
                      //       value: controller.dashboardResponseModel != null
                      //           ? Methods.getFormattedNumber(controller
                      //               .dashboardResponseModel!
                      //               .dashboardResponseData
                      //               .expense
                      //               .toDouble())
                      //           : Methods.getFormattedNumber(0),
                      //       isLoading: controller.dashboardDataLoading,
                      //       asset: AppAssets.expense,
                      //     ),
                      //     addW(8),
                      //     TotalStatusWidget(
                      //       title: 'Collection',
                      //       value: controller.dashboardResponseModel != null
                      //           ? Methods.getFormattedNumber(controller
                      //               .dashboardResponseModel!
                      //               .dashboardResponseData
                      //               .collection
                      //               .toDouble())
                      //           : Methods.getFormattedNumber(0),
                      //       isLoading: controller.dashboardDataLoading,
                      //       asset: AppAssets.collection,
                      //     ),
                      //   ],
                      // )
                      addH(24),
                      Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: context.theme.cardColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FieldTitle(
                              'Low Stock Products',
                              color: AppColors.accent,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.dashboardResponseModel != null? controller.dashboardResponseModel!.dashboardResponseData.products.length : 0,
                                itemBuilder: (context, index) {
                                  DashBoardProduct product = controller
                                      .dashboardResponseModel!
                                      .dashboardResponseData
                                      .products[index];
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FieldTitle(product.name,fontSize: 12,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              FieldTitle(product.sku,fontSize: 12,),
                                              FieldTitle(

                                                  "Stock: ${product.stock.toString()}",fontSize: 12,color: Colors.red,),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: ListTile(
                                      visualDensity: VisualDensity.comfortable,
                                      tileColor: Colors.white,
                                      title: Text(product.name),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FieldTitle(product.sku),
                                          FieldTitle(
                                              "Stock: ${product.stock.toString()}"),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class DrawerMenuWidget extends StatelessWidget {
  const DrawerMenuWidget({super.key, required this.onClicked});

  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onClicked, icon: const Icon(Icons.menu));
  }
}
