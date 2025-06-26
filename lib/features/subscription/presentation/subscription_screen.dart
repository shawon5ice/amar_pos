import 'dart:ui';

import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/subscription/data/service/subscription_service.dart';
import 'package:amar_pos/features/subscription/presentation/subscription_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../drawer/drawer_menu_controller.dart';
import '../data/model/subscription_list_response_model.dart';
import 'subscription_controller.dart';

class SubscriptionScreen extends StatefulWidget {
  static String routeName = '/subscription';
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {

  final Duration animationDuration = const Duration(milliseconds: 300);
  late PageController _pageController;

  SubscriptionController controller = Get.put(SubscriptionController());

  int? _calculateDiscount(int original, int discounted) {
    if (original <= discounted) return null;
    final diff = original - discounted;
    final percent = (diff / original * 100).round();
    return percent;
  }



  int selectedIndex = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text("Subscription"),
        centerTitle: true,
        leading: DrawerButton(
          onPressed: () async {
            drawerMenuController.openDrawer();
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
      ),
      body: SafeArea(
        child: GetBuilder<SubscriptionController>(
          id: SubscriptionController.subscriptionUIID,
          builder: (controller) {
            if (controller.isLoading) {
              return Center(child: RandomLottieLoader.lottieLoader());
            }
        
            if (controller.packages.isEmpty) {
              return const Center(child: Text("No subscriptions available"));
            }
        
            return Column(
              children: [
                // Features + Header in scrollable view
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                            children: [
                              TextSpan(text: "Unlock "),
                              TextSpan(text: "Pro", style: TextStyle(color: AppColors.error,fontSize: 38,fontWeight: FontWeight.bold)),
                              TextSpan(text: " Features!"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Sliding Feature Section
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: controller.packages.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final pkg = controller.packages[index];
                              return ListView(
                                children: pkg.details.map((feature) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(feature.title, style: const TextStyle(fontSize: 14)),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        
                // Fixed bottom pricing selector + button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          children: [
                            TextSpan(text: "Choose your"),
                            TextSpan(text: " "),
                            TextSpan(text: "plan", style: TextStyle(color: AppColors.primary,fontSize: 20,fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      addH(16),
                      // Tabbar-style package selector
                      ...controller.packages.asMap().entries.map((entry) {
                        final index = entry.key;
                        final pkg = entry.value;
                        final isSelected = index == selectedIndex; // mark first selected, or use your own state
        
                        final discountPercent = _calculateDiscount(pkg.price, pkg.discountPrice);
        
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedIndex = index;
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? Colors.black : Colors.blue.shade100,
                                width: isSelected ? 2 : 1,
                              ),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text(pkg.name, style: const TextStyle(fontSize: 16))),
                                if (discountPercent != null)
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "-$discountPercent%",
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                Text(
                                  "৳${pkg.discountPrice}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "৳${pkg.price}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final selectedPkg = controller.packages[selectedIndex];
                            Get.to(()=> SubscriptionDetailsScreen(),arguments: [selectedPkg.id, selectedPkg.name]);
                            // Get.closeAllSnackbars();
                            // Get.snackbar("Selected", "You chose ${selectedPkg.name}");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Get Started", style: TextStyle(fontSize: 16,color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),

    );
  }
}
