
import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // final ThemeController _themeCon = Get.put(ThemeController());
  // final UserInfoController _userInfoCon = Get.put(UserInfoController());
  // bool isLoggedIn = false;
  // late List<HiveUserModel> userItems;
  // late Box<HiveAddressModel> defaultAddress;
  // late Box<HiveWishModel> wishItems;

  List<String> menuIcons = [
    'assets/icons/campaign.png',
    'assets/icons/trending.png',
    'assets/icons/trending.png',
  ];

  List<String> menuTitles = [
    'Campaign',
    'Trending',
    'Flash Sale',
  ];

  List<VoidCallback> menuOnTapFn = [
    () => {},
    () => {},
    () => {},
    // () => Get.toNamed(TrendingScreen.routeName),
    // () => Get.toNamed(FlashSaleScreen.routeName),
    // () {
    //   final HomeController _homeController = Get.find();
    //   _homeController.showCategory.value = true;
    // },
    // () => Get.toNamed(BrandsScreen.routeName),
    // () => Get.toNamed(OurOutletsScreen.routeName),
    // () => Get.toNamed(ServiceCenterScreen.routeName),
    // () => Get.toNamed(SupportCenterScreen.routeName),
    // () => Get.toNamed(
    //       PolicyScreen.routeName,
    //       arguments: ['warranty', 0],
    //     ),
    // () => Get.toNamed(
    //       PolicyScreen.routeName,
    //       arguments: [ConstantStrings.privacyPolicy, 1],
    //     ),
    // () => Get.toNamed(
    //       PolicyScreen.routeName,
    //       arguments: [ConstantStrings.emiPolicy, 2],
    //     ),
    // () => Get.toNamed(
    //       PolicyScreen.routeName,
    //       arguments: [ConstantStrings.returnAndRefund, 3],
    //     ),
  ];

  @override
  void initState() {
    super.initState();
    // defaultAddress = Boxes.getDefaultAddress();
    // wishItems = Boxes.getWishItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        toolbarHeight: 0,
        elevation: 0,
      ),
      backgroundColor: AppColors.darkGreen,
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: menuIcons.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildMenuItems(
                  icon: menuIcons[index],
                  title: menuTitles[index],
                  onTapFn: menuOnTapFn[index],
                ),
                // addH(12),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildMenuItems({
    required String icon,
    required String title,
    required VoidCallback onTapFn,
  }) {
    return InkWell(
      onTap: onTapFn,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Row(
        children: [
          Icon(Icons.abc),
          // Image.asset(
          //   icon,
          //   height: 30,
          //   width: 30,
          //   fit: BoxFit.contain,
          // ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
