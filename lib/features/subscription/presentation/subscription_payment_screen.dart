import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:amar_pos/features/subscription/presentation/subscription_controller.dart';
import 'package:amar_pos/features/subscription/presentation/subscription_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../drawer/main_page.dart';
import '../../drawer/model/drawer_items.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  static String routeName = '/subscription_payment_screen';

  const SubscriptionPaymentScreen({super.key});

  @override
  _SubscriptionPaymentScreenState createState() =>
      _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {
  final SubscriptionController subscriptionController = Get.find();
  late WebViewController _webCon;
  late String url;
  bool paymentDone = false;

  // https://amarpos.motionsoft.com.bd/pos/payment/success?success=1&status=failed&message=Transaction%20Canceled
  @override
  void initState() {
    url = Get.arguments;
    _webCon = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {
            RandomLottieLoader.hide();
          },
            onNavigationRequest: (NavigationRequest request) {
              final reqUrl = request.url;
              logger.i("Navigation Request URL: $reqUrl");

              // ✅ Block any URL that contains status (success/fail)
              if (reqUrl.contains("status=")) {
                // ✅ Mark payment as done to control back press
                setState(() => paymentDone = true);

                // ✅ Handle success
                if (reqUrl.contains("status=success")) {
                  Future.microtask(() {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.bottomSlide,
                      title: "Payment Success!",
                      dismissOnBackKeyPress: false,
                      dismissOnTouchOutside: false,
                      btnOkOnPress: () {
                        subscriptionController.fetchSubscriptionDetails();
                        Get.offNamedUntil(
                          SubscriptionScreen.routeName,
                          ModalRoute.withName(MainPage.routeName),
                        );
                        Get.back();
                      },
                      btnOkText: "View Subscription",
                    ).show();
                  });
                } else {
                  // ✅ Handle failure or cancel
                  Future.microtask(() {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.bottomSlide,
                      title: "Payment Failed!",
                      dismissOnBackKeyPress: false,
                      dismissOnTouchOutside: false,
                      btnCancelOnPress: () {
                        Get.offNamedUntil(
                          SubscriptionScreen.routeName,
                          ModalRoute.withName(MainPage.routeName),
                        );
                        Get.back();
                      },
                      btnCancelText: "Back",
                      btnOkOnPress: () {
                        final drawerController = Get.find<DrawerMenuController>();
                        drawerController.selectParent(DrawerItems.overview);
                        Get.offNamedUntil(MainPage.routeName, (route) => false);
                      },
                      btnOkText: "Go Home",
                    ).show();
                  });
                }

                // ✅ Prevent the WebView from loading the URL
                return NavigationDecision.prevent;
              }

              // Allow all other URLs
              return NavigationDecision.navigate;
            }
        ),
      )
      ..loadRequest(Uri.parse(url));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: paymentDone,
      onPopInvoked: (didPop) {
        if (!paymentDone) {
          Future.microtask(() {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.bottomSlide,
              title: "Are you sure?",
              desc: "You have not completed the payment.",
              btnCancelOnPress: () {
                Get.offNamedUntil(
                  SubscriptionScreen.routeName,
                  ModalRoute.withName(MainPage.routeName),
                );
                Get.back();
              },
              btnCancelText: "Back",
              btnOkOnPress: () {
                final drawerController = Get.find<DrawerMenuController>();
                drawerController.selectParent(DrawerItems.overview);
                Get.offNamedUntil(MainPage.routeName, (route) => false);
              },
              btnOkText: "Go Home",
            ).show();
          });
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: WebViewWidget(controller: _webCon),
          ),
        ),
      ),
    );
  }
}
