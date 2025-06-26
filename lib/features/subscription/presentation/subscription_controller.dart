import 'package:amar_pos/features/subscription/data/service/subscription_service.dart';
import 'package:get/get.dart';

import '../../auth/data/model/hive/login_data.dart';
import '../../auth/data/model/hive/login_data_helper.dart';
import '../data/model/subscription_list_response_model.dart';
import '../data/model/subscription_package_details_response_model.dart';
import '../data/model/subscription_payment_method_list_response_model.dart';

class SubscriptionController extends GetxController{

  LoginData? loginData = LoginDataBoxManager().loginData;

  @override
  onReady(){
    getSubscriptionList();
    super.onReady();
  }

  bool isLoading = false;
  List<SubscriptionPackage> packages = [];

  // UI updates with this ID
  static const String subscriptionUIID = 'subscription_list';

  /// Fetch subscription list from API
  Future<void> getSubscriptionList() async {
    isLoading = true;
    update([subscriptionUIID]);

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
      update([subscriptionUIID]);
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
}