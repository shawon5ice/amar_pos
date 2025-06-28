import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/widgets/custom_btn.dart';
import '../../../core/responsive/pixel_perfect.dart';
import '../../drawer/drawer_menu_controller.dart';
import 'subscription_controller.dart';
import 'subscription_details_screen.dart';

class ChangePlanScreen extends StatefulWidget {
  static String routeName = '/change_subscription_plan';
  const ChangePlanScreen({super.key});

  @override
  State<ChangePlanScreen> createState() => _ChangePlanScreenState();
}

class _ChangePlanScreenState extends State<ChangePlanScreen> {
  int selectedIndex = 0;
  late PageController _pageController;
  final SubscriptionController controller = Get.find();

  int? _calculateDiscount(int original, int discounted) {
    if (original <= discounted) return null;
    final diff = original - discounted;
    final percent = (diff / original * 100).round();
    return percent;
  }

  bool isSubscribedUser = false;

  @override
  void initState() {
    super.initState();
    isSubscribedUser = Get.arguments ?? false;
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSubscriptionList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription"),
        centerTitle: true,
        leading: isSubscribedUser? null : DrawerButton(
          onPressed: () {
            drawerMenuController.openDrawer();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GetBuilder<SubscriptionController>(
            id: SubscriptionController.subscriptionList,
            builder: (controller) {
              if (controller.isLoading) {
                return Center(child: RandomLottieLoader.lottieLoader());
              }
              if (controller.packages.isEmpty) {
                return const Center(child: Text("No plans available."));
              } else {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        children: [
                          TextSpan(text: "Unlock "),
                          TextSpan(
                            text: "Pro",
                            style: TextStyle(
                                color: AppColors.error,
                                fontSize: 38,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: " Features!"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        itemCount: controller.packages.length,
                        onPageChanged: (index) => setState(() => selectedIndex = index),
                        itemBuilder: (context, index) {
                          final pkg = controller.packages[index];
                          return ListView(
                            children: pkg.details.map((feature) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: AppColors.primary, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        feature.title,
                                        style: const TextStyle(fontSize: 14),
                                      ),
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
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: GetBuilder<SubscriptionController>(
        id: SubscriptionController.subscriptionList,
        builder: (controller) {
          if (controller.packages.isEmpty) return const SizedBox();

          final selectedPkg = controller.packages[selectedIndex];
          final sub = controller.subscription;

          String btnTxt = "Purchase Now";
          bool isSubscribed = false;

          if (sub != null && controller.isSubscriptionValid(sub)) {
            isSubscribed = true;
            if (selectedPkg.id == sub.packageId) {
              btnTxt = "Purchase Again";
            } else if (selectedPkg.id > sub.packageId) {
              btnTxt = "Upgrade Now";
            } else {
              btnTxt = "Downgrade Now";
            }
          }


          return Container(
            padding: const EdgeInsets.only(top: 20, bottom: 40, left: 20, right: 20),
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
                      TextSpan(text: "Choose your "),
                      TextSpan(
                          text: "plan",
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                addH(16),
                ...controller.packages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final pkg = entry.value;
                  final isSelected = index == selectedIndex;
                  final discountPercent = _calculateDiscount(pkg.price, pkg.discountPrice);

                  return GestureDetector(
                    onTap: () {
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
                        color: isSelected
                            ? Colors.green.shade50
                            : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(pkg.name, style: const TextStyle(fontSize: 16)),
                                if (isSubscribed && controller.subscription?.packageId == pkg.id)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.verified, color: Colors.green, size: 16),
                                        addW(12),
                                        const Text("( Current )", style: TextStyle(fontSize: 10)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
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
                CustomBtn(
                  onPressedFn: () {
                    Get.toNamed(SubscriptionDetailsScreen.routeName, arguments: [selectedPkg.id, selectedPkg.name]);
                  },
                  btnTxt: btnTxt,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
