import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/category/presentation/brand/brand_screen.dart';
import 'package:amar_pos/features/category/presentation/category/category_screen.dart';
import 'package:amar_pos/features/category/presentation/unit/unit_screen.dart';
import 'package:amar_pos/features/drawer/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../drawer/drawer_menu_controller.dart';
import '../data/model/config_item.dart';
import 'config_item_widget.dart';

class ConfigurationScreen extends StatelessWidget {
  static String routeName = '/configuration_screen';
  ConfigurationScreen({super.key});

  final List<ConfigItem> configItems = [
    ConfigItem(title: "Brands", asset: AppAssets.brandsIcon, onPress: () {
      Get.to(BrandScreen());
    }),
    ConfigItem(
        title: "Category", asset: AppAssets.categoryIcon, onPress: () {
      Get.to(CategoryScreen());
    }),
    ConfigItem(title: "Unit", asset: AppAssets.unitIcon, onPress: () {
      Get.to(UnitScreen());
    }),
    ConfigItem(
        title: "Warranty", asset: AppAssets.warrantyIcon, onPress: () {}),
    ConfigItem(
        title: "Supplier", asset: AppAssets.supplierIcon, onPress: () {}),
    ConfigItem(title: "Outlet", asset: AppAssets.outletIcon, onPress: () {}),
    ConfigItem(
        title: "Employee", asset: AppAssets.employeeIcon, onPress: () {}),
    ConfigItem(title: "Client", asset: AppAssets.clientIcon, onPress: () {}),
    ConfigItem(
        title: "Customer", asset: AppAssets.customerIcon, onPress: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();
    return Scaffold(
      appBar: AppBar(
        leading: DrawerButton(onPressed: drawerMenuController.openDrawer,),
        title: const Text("Configuration"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20),)
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search ...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    // contentPadding: EdgeInsets.zero
                    // contentPadding: EdgeInsets.zero
                  ),
                ),
              ),
              SizedBox(height: 16.px),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.px,
                    crossAxisSpacing: 20.px,
                    childAspectRatio: 2.3.px,
                  ),
                  itemCount: configItems.length,
                  itemBuilder: (context, index) {
                    return ConfigCard(item: configItems[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}