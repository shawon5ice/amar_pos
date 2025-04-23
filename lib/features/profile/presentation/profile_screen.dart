import 'package:amar_pos/features/profile/presentation/profile_controller.dart';
import 'package:amar_pos/features/profile/presentation/views/change_password.dart';
import 'package:amar_pos/features/profile/presentation/views/profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/responsive/pixel_perfect.dart';
import '../../drawer/drawer_menu_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabKeys = List.generate(2, (index) => GlobalKey());
    _tabController.addListener((){
      if(_tabController.indexIsChanging){
        controller.changePasswordStep.value = ChangePasswordStep.sendOTP;
        _clearTabState(_tabController.index);
      }
    });
    super.initState();
  }


  @override
  void dispose() {
    _tabKeys.clear();
    _tabController.dispose();
    Get.delete<ProfileController>();
    super.dispose();
  }

  List<GlobalKey> _tabKeys = [];

  void _clearTabState(int index) {
    setState(() {
      _tabKeys[index] = GlobalKey(); // Assign a new key to force rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();
    return GetBuilder<ProfileController>(
        id: 'permission_handler_builder',
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title:const Text("Profile"),
              centerTitle: true,
              leading: DrawerButton(
                onPressed: () async {
                  drawerMenuController.openDrawer();
                },
              ),
              // actions: [
              //   GetBuilder<PurchaseController>(
              //       id: 'action_icon',
              //       builder: (controller) => _tabController.index == 0 && controller.purchaseCreateAccess ? GestureDetector(
              //         child: SvgPicture.asset(AppAssets.pauseBillingIcon),
              //       ): _tabController.index == 2 && controller.productAccess ? IconButton(
              //         onPressed: () async {
              //           showModalBottomSheet(context: context, builder: (context) => SimpleFilterBottomSheetWidget(
              //             selectedBrand: controller.brand,
              //             disableOutlet: true,
              //             selectedCategory: controller.category,
              //             selectedDateTimeRange: controller.selectedDateTimeRange.value,
              //             onSubmit: (FilterItem? brand,FilterItem? category,DateTimeRange? dateTimeRange, OutletModel? outlet){
              //               controller.brand = brand;
              //               controller.category = category;
              //               controller.selectedDateTimeRange.value = dateTimeRange;
              //               logger.i(controller.brand);
              //               logger.i(controller.category?.id);
              //               logger.i(controller.selectedDateTimeRange.value);
              //               Get.back();
              //               if(_tabController.index == 1){
              //                 controller.getPurchaseHistory();
              //               }else{
              //                 controller.getPurchaseProducts();
              //               }
              //             },
              //           ));
              //         },
              //         icon: Icon(Icons.filter_alt_outlined, color: (controller.brand != null || controller.category != null || controller.selectedDateTimeRange.value != null) ? AppColors.error : null,),
              //       ):  _tabController.index == 1 && controller.historyAccess ? GestureDetector(
              //         onTap: () async {
              //           DateTimeRange? selectedDate =
              //           await showDateRangePicker(
              //             context: context,
              //             firstDate: DateTime.now()
              //                 .subtract(const Duration(days: 1000)),
              //             lastDate: DateTime.now()
              //                 .add(const Duration(days: 1000)),
              //             initialDateRange:
              //             controller.selectedDateTimeRange.value,
              //           );
              //           if (selectedDate != null) {
              //             controller.selectedDateTimeRange.value =
              //                 selectedDate;
              //             controller.getPurchaseHistory();
              //           }
              //         },
              //         child: SvgPicture.asset(AppAssets.calenderIcon),
              //       ): SizedBox.shrink()
              //   ),
              //   addW(12),
              // ],
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
                          text: 'Personal Info',
                        ),
                        Tab(text: 'Change Password'),
                      ],
                    ),
                  ),
                  addH(12),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        PersonalInfoView(
                          key: _tabKeys[0],
                        ),
                        ChangePassword(
                          key: _tabKeys[1],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}
