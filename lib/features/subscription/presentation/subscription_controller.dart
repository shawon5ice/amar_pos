import 'dart:convert';

import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/subscription/data/service/subscription_service.dart';
import 'package:amar_pos/features/subscription/presentation/subscription_payment_screen.dart';
import 'package:get/get.dart';

import '../../auth/data/model/hive/login_data.dart';
import '../../auth/data/model/hive/login_data_helper.dart';
import '../data/model/subscription_create_response.dart';
import '../data/model/subscription_model.dart';
import '../data/model/subscription_list_response_model.dart';
import '../data/model/subscription_package_details_response_model.dart';
import '../data/model/subscription_payment_method_list_response_model.dart';

class SubscriptionController extends GetxController{

  LoginData? loginData = LoginDataBoxManager().loginData;


  bool isSubscriptionValid(SubscriptionData sub) {
    final now = DateTime.now();
    final endDate = DateTime.tryParse(sub.endDate ?? '') ?? DateTime(2000);
    return now.isBefore(endDate);
  }

  bool isLoading = false;
  List<SubscriptionPackage> packages = [];

  // UI updates with this ID
  static const String subscriptionUIID = 'subscription_list';
  static const String subscriptionList = 'subscription_list';

  /// Fetch subscription list from API
  Future<void> getSubscriptionList() async {
    isLoading = true;
    packages.clear();
    update([subscriptionList]);

    try {
      final response = await SubscriptionService.getSubscriptionList(usrToken: loginData!.token);

      if (response != null) {
        final model = SubscriptionListResponseModel.fromJson(response);
        packages = model.data;
      } else {
        Get.snackbar("Error", "Failed to fetch subscriptions: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An exception occurred: $e");
    } finally {
      isLoading = false;
      update([subscriptionList]);
    }
  }

  static const String packageDetailUIID = 'subscription_detail';

  bool isDetailLoading = false;
  SubscriptionPackageDetailData? selectedPackageDetail;

  /// Fetches a subscription package detail by ID
  Future<void> getPackageDetails({required int packageId}) async {
    isDetailLoading = true;
    update([packageDetailUIID]);

    try {
      final response = await SubscriptionService.getSubscriptionDetails(usrToken: loginData!.token, id: packageId);

      if (response != null) {
        final model = SubscriptionPackageDetailsResponseModel.fromJson(response);
        selectedPackageDetail = model.data;
      } else {
        Get.snackbar('Error', 'Failed to load package details (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isDetailLoading = false;
      update([packageDetailUIID]);
    }
  }

  static const String paymentMethodsUIID = 'payment_methods';

  bool isPaymentLoading = false;
  List<SubscriptionPaymentMethod> paymentMethods = [];

  /// Fetch available subscription payment methods
  Future<void> getSubscriptionPaymentMethods() async {
    isPaymentLoading = true;
    update([paymentMethodsUIID]);

    try {
      final response = await SubscriptionService.getSubscriptionPaymentMethods(usrToken: loginData!.token);

      if (response != null) {
        final model = SubscriptionPaymentMethodListResponseModel.fromJson(response);
        paymentMethods = model.data ?? [];
      } else {
        Get.snackbar('Error', 'Failed to fetch payment methods (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isPaymentLoading = false;
      update([paymentMethodsUIID]);
    }
  }

  SubscriptionData? subscription;
  bool isSubscriptionLoading = false;

  Future<void> fetchSubscriptionDetails() async {
    try {
      isSubscriptionLoading = true;
      update([subscriptionUIID]); // triggers GetBuilder

      final response = await SubscriptionService.getCurrentSubscriptionDetails(usrToken: loginData!.token);

      if (response != null) {
        final result = SubscriptionResponse.fromJson(response);
        subscription = result.data;
      } else {
        Get.snackbar('Error', 'Failed to load subscription');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isSubscriptionLoading = false;
      update([subscriptionUIID]);
    }
  }


  Future<void> createSubscriptionOrder({required int packageId, required int paymentMethod, required String paymentMethodShortCode}) async {
    try {

      RandomLottieLoader.lottieLoader();
      final response = await SubscriptionService.createSubscriptionOrder(usrToken: loginData!.token, packageId: packageId, paymentMethodId: paymentMethod);

      if (response != null && response['success']) {
        final result = SubscriptionCreateResponse.fromJson(response);
        processPayment(orderNo: result.data.slNo, shortCode: paymentMethodShortCode);
      } else {
        Get.snackbar('Error', 'Failed to create subscription order');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isSubscriptionLoading = false;
      update(); // update UI
    }
  }

  Future<void> processPayment({required String orderNo, required String shortCode}) async {
    try {

      final response = await SubscriptionService.processPayment(usrToken: loginData!.token, orderNo: orderNo, shortCode: shortCode);

      logger.e(response);
      if (response != null) {
        RandomLottieLoader.hide();
        if(shortCode.toLowerCase().contains("bkash")){
          Get.to(SubscriptionPaymentScreen(), arguments: response);
        }else{
          Get.to(SubscriptionPaymentScreen(), arguments: jsonDecode(response)['data']);
        }
      } else {
        Get.snackbar('Error', 'Failed to create subscription order');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isSubscriptionLoading = false;
      update(); // update UI
    }
  }
}