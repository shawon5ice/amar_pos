import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/config/data/service/client_service.dart';
import 'package:amar_pos/features/config/presentation/brand/brand_screen.dart';
import 'package:amar_pos/features/config/presentation/category/category_screen.dart';
import 'package:amar_pos/features/config/presentation/client/client_screen.dart';
import 'package:amar_pos/features/config/presentation/customer/customer_screen.dart';
import 'package:amar_pos/features/config/presentation/employee/employee_screen.dart';
import 'package:amar_pos/features/config/presentation/outlet/outlet_screen.dart';
import 'package:amar_pos/features/config/presentation/supplier/supplier_screen.dart';
import 'package:amar_pos/features/config/presentation/unit/unit_screen.dart';
import 'package:amar_pos/features/config/presentation/warranty/warranty_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/search_widget.dart';
import '../../drawer/drawer_menu_controller.dart';
import '../data/model/config_item.dart';
import 'config_item_widget.dart';

class ConfigurationScreen extends StatelessWidget {
  static String routeName = '/configuration_screen';

  ConfigurationScreen({super.key});

  final List<ConfigItem> configItems = [
    ConfigItem(
        title: "Brands",
        asset: AppAssets.brandsIcon,
        onPress: () {
          Get.to(() => BrandScreen());
        }),
    ConfigItem(
        title: "Category",
        asset: AppAssets.categoryIcon,
        onPress: () {
          Get.to(() => CategoryScreen());
        }),
    ConfigItem(
        title: "Unit",
        asset: AppAssets.unitIcon,
        onPress: () {
          Get.to(() => const UnitScreen());
        }),
    ConfigItem(
        title: "Warranty",
        asset: AppAssets.warrantyIcon,
        onPress: () {
          Get.to(() => const WarrantyScreen());
        }),
    ConfigItem(
        title: "Supplier", asset: AppAssets.supplierIcon, onPress: () {
      Get.to(() => const SupplierScreen());
    }),
    ConfigItem(title: "Outlet", asset: AppAssets.outletIcon, onPress: () {
      Get.to(() => const OutletScreen());
    }),
    ConfigItem(
        title: "Employee", asset: AppAssets.employeeIcon, onPress: () {
          Get.to(()=> EmployeeScreen());
    }),
    ConfigItem(title: "Client", asset: AppAssets.clientIcon, onPress: () {
      Get.to(ClientScreen());
    }),
    ConfigItem(
        title: "Customer", asset: AppAssets.customerIcon, onPress: () {
      Get.to(CustomerScreen());
    }),
  ];

  @override
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();
    return Scaffold(
      appBar: AppBar(
        leading: DrawerButton(
          onPressed: drawerMenuController.openDrawer,
        ),
        title: const Text("Configuration"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              SearchWidget(
                onChanged: (value) {
                  // _controller.searchSupplier(search: value);
                },
              ),
              addH(16.h),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   decoration: const BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(20),
              //       )),
              //   child: const TextField(
              //     decoration: InputDecoration(
              //       hintText: 'Search ...',
              //       prefixIcon: Icon(Icons.search),
              //       border: InputBorder.none,
              //       // contentPadding: EdgeInsets.zero
              //       // contentPadding: EdgeInsets.zero
              //     ),
              //   ),
              // ),
              // SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.pw(context),
                    crossAxisSpacing: 20.pw(context),
                    childAspectRatio: 2.28.px,
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
