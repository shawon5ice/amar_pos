import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../data/model/config_item.dart';
import 'config_item_widget.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  final List<ConfigItem> configItems = [
    ConfigItem(title: "Brands", asset: AppAssets.brandsIcon),
    ConfigItem(title: "Category", asset: AppAssets.categoryIcon),
    ConfigItem(title: "Unit", asset: AppAssets.unitIcon),
    ConfigItem(title: "Warranty", asset: AppAssets.warrantyIcon),
    ConfigItem(title: "Supplier", asset: AppAssets.supplierIcon),
    ConfigItem(title: "Outlet", asset: AppAssets.outletIcon),
    ConfigItem(title: "Employee", asset: AppAssets.employeeIcon),
    ConfigItem(title: "Client", asset: AppAssets.clientIcon),
    ConfigItem(title: "Customer", asset: AppAssets.customerIcon),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuration"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search ...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0.px),
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
                    childAspectRatio: ((context.width / 2 - 80) / 72).px,
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
