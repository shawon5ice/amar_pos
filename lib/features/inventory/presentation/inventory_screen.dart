import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/config/presentation/brand/brand_screen.dart';
import 'package:amar_pos/features/config/presentation/category/category_screen.dart';
import 'package:amar_pos/features/config/presentation/client/client_screen.dart';
import 'package:amar_pos/features/config/presentation/customer/customer_screen.dart';
import 'package:amar_pos/features/config/presentation/employee/employee_screen.dart';
import 'package:amar_pos/features/config/presentation/outlet/outlet_screen.dart';
import 'package:amar_pos/features/config/presentation/supplier/supplier_screen.dart';
import 'package:amar_pos/features/config/presentation/unit/unit_screen.dart';
import 'package:amar_pos/features/config/presentation/warranty/warranty_screen.dart';
import 'package:amar_pos/features/inventory/data/inventory_item_model.dart';
import 'package:amar_pos/features/inventory/presentation/inventory_item_widget.dart';
import 'package:amar_pos/features/inventory/presentation/products/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/search_widget.dart';
import '../../drawer/drawer_menu_controller.dart';

class InventoryScreen extends StatelessWidget {
  static String routeName = '/inventory_screen';

  InventoryScreen({super.key});

  final List<InventoryItem> inventoryItems = [
    InventoryItem(
        title: "Products",
        asset: AppAssets.inventoryMenuIcon,
        onPress: () {
          Get.to(() => ProductsScreen());
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
        title: const Text("Inventory"),
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
                  itemCount: inventoryItems.length,
                  itemBuilder: (context, index) {
                    return InventoryCard(item: inventoryItems[index]);
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
