import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:amar_pos/features/home/presentation/home_screen_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../permission_manager.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home_screen";
  const HomeScreen({super.key,});

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
    await controller.getPermissions();
    if(controller.permissionApiResponse?.success == true){
      await PermissionManager.loadPermissions();
    }
  }
  @override
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      // drawer: CustomDrawer(),
      appBar: AppBar(
        leading: DrawerMenuWidget(onClicked: drawerMenuController.openDrawer),
        title: const Text("H O M E"),
        actions: [
          IconButton(onPressed: (){
            Get.changeThemeMode(Get.isDarkMode? ThemeMode.light : ThemeMode.dark);
          }, icon: Get.isDarkMode? Icon(Icons.sunny): Icon(Icons.nightlight))
        ],
      ),
      body: Column(
        children: [
          GetBuilder<HomeScreenController>(
              id: 'dashboard_data',
              builder: (controller){
            if(controller.dashboardDataLoading){
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }else if(controller.dashboardResponseModel == null){
              return Text("No data found");
            }else{
              return Text("GOT DATA");
            }
          })
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
