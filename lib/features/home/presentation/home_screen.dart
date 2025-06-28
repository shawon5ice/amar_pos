import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/accounting/presentation/views/daily_statement/daily_statement.dart';
import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:amar_pos/features/home/data/models/quick_access_item_model.dart';
import 'package:amar_pos/features/home/presentation/home_screen_controller.dart';
import 'package:amar_pos/features/profile/presentation/profile_screen.dart';
import 'package:amar_pos/features/notification/presentation/notification_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../permission_manager.dart';
import '../../auth/data/model/hive/login_data_helper.dart';
import 'widget/bottom_nav_item.dart';
import '../data/models/dashboard_response_model.dart';
import 'widget/sales_summary_card.dart';

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

  int selectedIndex = 0;

  final List<BottomNavItem> items = [
    BottomNavItem(
        label: "Dashboard", icon: Icons.dashboard_outlined, onPress: () {
      Get.offAllNamed(HomeScreen.routeName);
    }),
    BottomNavItem(label: "Day Book", icon: Icons.event_note, onPress: () {
      Get.offAllNamed(DailyStatement.routeName);
    }),
    BottomNavItem(
        label: "Stock List", icon: Icons.inventory_2_outlined, onPress: () {
    }),
    BottomNavItem(
        label: "Profile",
        isProfile: true,
        profileImage: 'assets/profile.jpg',
        onPress: () {
          Get.to(() => ProfileScreen());
        }),
  ];

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
          IconButton(
              onPressed: () => Get.to(() => NotificationScreen()),
              icon: SvgPicture.asset("assets/icon/notification_bell.svg"))
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
            DashboardResponseData? dashboardResponseData =
                controller.dashboardResponseModel?.dashboardResponseData;

            final rows = controller.chunkList(3);

            return RefreshIndicator(
              onRefresh: () async {
                controller.firstTimeLoading = false;
                controller.getDashboardData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addH(10),
                      SalesSummaryCard(
                          isLoading: controller.dashboardDataLoading,
                          retailSale: dashboardResponseData != null
                              ? dashboardResponseData.retailSale.toDouble()
                              : 0,
                          wholeSale: dashboardResponseData != null
                              ? dashboardResponseData.wholeSale.toDouble()
                              : 0,
                          total: dashboardResponseData != null
                              ? (dashboardResponseData.wholeSale +
                                      dashboardResponseData.retailSale)
                                  .toDouble()
                              : 0,
                      ),
                      addH(12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                        decoration: BoxDecoration(
                          color: context.theme.cardColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldTitle(
                              'Today’s Cash Flow',
                              color: AppColors.darkGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                VerticalStatusWidget(
                                  isLoading: controller.dashboardDataLoading,
                                  value: dashboardResponseData?.cashIn
                                          .toDouble() ??
                                      0,
                                  title: "Cash In",
                                  iconData: Icons.arrow_downward,
                                ),
                                Container(
                                  height: 76,
                                  width: .5,
                                  color: Color(0xff7c7c7c),
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                ),
                                VerticalStatusWidget(
                                  isLoading: controller.dashboardDataLoading,
                                  value: dashboardResponseData?.cashOut
                                          .toDouble() ??
                                      0,
                                  title: "Cash Out",
                                  iconData: Icons.arrow_upward,
                                ),
                                Container(
                                  height: 76,
                                  width: .5,
                                  color: Color(0xff7c7c7c),
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                ),
                                VerticalStatusWidget(
                                  isLoading: controller.dashboardDataLoading,
                                  value: dashboardResponseData?.balance
                                          .toDouble() ??
                                      0,
                                  title: "Balance",
                                  asset: AppAssets.collection,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      addH(12),
                      Container(
                        padding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: context.theme.cardColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldTitle(
                              'Today’s Expense & Collection',
                              color: AppColors.darkGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            addH(16),
                            Row(
                              children: [
                                TotalStatusWidget(
                                  hasBorder: true,
                                  title: 'Expense',
                                  value: controller.dashboardResponseModel !=
                                          null
                                      ? Methods.getFormattedNumber(controller
                                          .dashboardResponseModel!
                                          .dashboardResponseData
                                          .expense
                                          .toDouble())
                                      : Methods.getFormattedNumber(0),
                                  isLoading: controller.dashboardDataLoading,
                                  asset: AppAssets.expense,
                                ),
                                addW(16),
                                TotalStatusWidgetLeftIcon(
                                  hasBorder: true,
                                  title: 'Collection',
                                  value: controller.dashboardResponseModel !=
                                          null
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
                      addH(12),
                      if (rows.isNotEmpty)
                        Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: context.theme.cardColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FieldTitle(
                                'Quick Access',
                                color: AppColors.darkGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              addH(16),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: rows
                                    .map((rowItems) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: rowItems
                                                .map((item) =>
                                                    QuickAccessWidget(
                                                        item: item))
                                                .toList(),
                                          ),
                                        ))
                                    .toList(),
                              )
                            ],
                          ),
                        ),
                      addH(12),
                      if (dashboardResponseData != null &&
                          dashboardResponseData.products.isNotEmpty)
                        Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: context.theme.cardColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FieldTitle(
                                'Low Stock Products',
                                color: AppColors.darkGreen,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      dashboardResponseData.products.length,
                                  itemBuilder: (context, index) {
                                    DashBoardProduct product =
                                        dashboardResponseData.products[index];
                                    return Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FieldTitle(
                                              product.name,
                                              fontSize: 12,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                FieldTitle(
                                                  product.sku,
                                                  fontSize: 12,
                                                ),
                                                FieldTitle(
                                                  "Stock: ${product.stock.toString()}",
                                                  fontSize: 12,
                                                  color: Colors.red,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );

                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: ListTile(
                                        visualDensity:
                                            VisualDensity.comfortable,
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
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     border:
      //         Border(top: BorderSide(color: Colors.green.shade200, width: 0.6)),
      //     color: Colors.white,
      //   ),
      //   padding: const EdgeInsets.symmetric(vertical: 8),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: List.generate(items.length, (index) {
      //       final item = items[index];
      //       final isSelected = index == selectedIndex;
      //
      //       return GestureDetector(
      //         onTap: () => setState(() => selectedIndex = index),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             item.isProfile
      //                 ? CircleAvatar(
      //                     radius: 16,
      //                     backgroundImage: AssetImage(),
      //                   )
      //                 : Icon(
      //                     item.icon,
      //                     size: isSelected ? 30 : 28,
      //                     color:
      //                         isSelected ? AppColors.primary : Colors.black54,
      //                   ),
      //             const SizedBox(height: 4),
      //             Text(
      //               item.label,
      //               style: TextStyle(
      //                 fontSize: 13,
      //                 fontWeight:
      //                     isSelected ? FontWeight.w600 : FontWeight.normal,
      //                 color: isSelected ? AppColors.primary : Colors.black54,
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     }),
      //   ),
      // ),
    );
  }
}

class VerticalStatusWidget extends StatelessWidget {
  VerticalStatusWidget({
    super.key,
    required this.isLoading,
    required this.value,
    required this.title,
    this.asset,
    this.iconData,
  });

  final double value;
  final String title;
  final bool isLoading;
  String? asset;
  IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            child: asset != null
                ? SvgPicture.asset(
                    asset!,
                    height: 24,
                    color: Colors.white,
                  )
                : Icon(
                    iconData,
                    size: 24,
                  ),
          ),
          addH(8),
          isLoading
              ? const SizedBox(height: 20, child: CupertinoActivityIndicator())
              : AutoSizeText(
                maxLines: 1,
                  maxFontSize: 14,
                  minFontSize: 8,
                  overflow: TextOverflow.visible,
                  Methods.getFormatedPrice(value),
                  style: const TextStyle(
                      color: Color(0xff333333),
                      fontWeight: FontWeight.w500,),
                ),
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xff666666),
                fontSize: 12),
          )
        ],
      ),
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

class QuickAccessWidget extends StatelessWidget {
  const QuickAccessWidget({
    super.key,
    required this.item,
  });

  final QuickAccessItemModel item;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: item.onPress,
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xffF8FAF9),
              child: SvgPicture.asset(
                item.asset,
                height: 24,
                color: AppColors.primary,
              ),
            ),
            addH(8),
            Text(
              item.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff666666),
                  fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
