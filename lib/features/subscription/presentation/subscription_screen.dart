import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/widgets/custom_btn.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/subscription/presentation/change_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../drawer/drawer_menu_controller.dart';
import '../data/model/subscription_model.dart';
import 'subscription_controller.dart';

class SubscriptionScreen extends StatefulWidget {
  static String routeName = '/subscription';

  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionController controller = Get.put(SubscriptionController());


  @override
  void initState() {
    controller.fetchSubscriptionDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();
    return GetBuilder<SubscriptionController>(
      id: SubscriptionController.subscriptionUIID,
      builder: (controller) {
        if (controller.isSubscriptionLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Subscription"),
              centerTitle: true,
              leading: DrawerButton(
                onPressed: () {
                  drawerMenuController.openDrawer();
                },
              ),
            ),
            body: Center(child: RandomLottieLoader.lottieLoader()),
          );
        }

        final isValid = controller.subscription != null && controller.isSubscriptionValid(controller.subscription!);

        return isValid
            ? Scaffold(
          appBar: AppBar(
            title: const Text("Subscription"),
            centerTitle: true,
            leading: DrawerButton(
              onPressed: () {
                drawerMenuController.openDrawer();
              },
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified, color: Colors.green, size: 64),
                  const SizedBox(height: 12),
                  const Text(
                    "You're Subscribed",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Plan: ${controller.subscription!.packageDetails}",
                      style: const TextStyle(fontSize: 16)),
                  Text("Valid until: ${controller.subscription!.endDate}",
                      style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 24),
                  CustomBtn(
                    onPressedFn: () {
                      Get.toNamed(ChangePlanScreen.routeName, arguments: true);
                    },
                    btnTxt: "Manage Plan",
                  ),
                ],
              ),
            ),
          ),
        )
            : const ChangePlanScreen();
      },
    );
  }
}
