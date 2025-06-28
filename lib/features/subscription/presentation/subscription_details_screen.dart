import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_btn.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'subscription_controller.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  static String routeName = '/subscription_details';
  const SubscriptionDetailsScreen({super.key});

  @override
  State<SubscriptionDetailsScreen> createState() => _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  final SubscriptionController controller = Get.find();

  String title = '';

  @override
  void initState() {
    title = Get.arguments[1];
    controller.getPackageDetails(packageId: Get.arguments[0]);
    controller.getSubscriptionPaymentMethods();
    super.initState();
  }

  String selectedPaymentMethodCode = 'BKASH';
  int selectedPaymentMethod = -1;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GetBuilder<SubscriptionController>(
          id: SubscriptionController.packageDetailUIID,
          builder: (controller) {
            final detail = controller.selectedPackageDetail;
            if (controller.isDetailLoading) {
              return Center(child: RandomLottieLoader.lottieLoader());
            }

            if (detail == null) {
              return const Center(child: Text("No subscription detail found."));
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            detail.name ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            detail.description ?? '',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "৳${detail.discountPrice}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "৳${detail.price}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...?detail.details?.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: AppColors.primary, size: 20),
                              addW(8),
                              Expanded(
                                child: Text(item.title ?? '',
                                    style: const TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 16),
                        const Text(
                          "Select Payment Method:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        GetBuilder<SubscriptionController>(
                          id: SubscriptionController.paymentMethodsUIID,
                          builder: (controller) {
                            if (controller.isPaymentLoading) {
                              return const CircularProgressIndicator();
                            }

                            if (controller.paymentMethods.isEmpty) {
                              return const Text("No payment methods found.");
                            }

                            selectedPaymentMethod = controller.paymentMethods.first.id ?? 0;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: controller.paymentMethods.map((method) {
                                logger.i(method.logo);
                                return RadioListTile<String>(
                                  title: Text(method.name ?? ''),
                                  secondary: method.logo != null
                                      ? SvgPicture.network(method.logo!, height: 24)
                                      : null,
                                  dense: true,
                                  value: method.shortCode ?? '',
                                  groupValue: selectedPaymentMethodCode,
                                  onChanged: (val) {
                                    setState(() {
                                      selectedPaymentMethodCode = val!;
                                      selectedPaymentMethod = method.id!;
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomBtn(
                          btnTxt: "Subscribe Now",
                          onPressedFn: (){
                            controller.createSubscriptionOrder(
                                packageId: Get.arguments[0],
                                paymentMethod: selectedPaymentMethod,
                                paymentMethodShortCode:
                                    selectedPaymentMethodCode);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
