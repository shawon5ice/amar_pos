// part of 'sales_controller.dart';
//
// class SaleHistory{
//   Future<void> getPaymentMethods() async {
//     try {
//       isPaymentMethodListLoading = true;
//       hasError.value = false;
//       billingPaymentMethods = null;
//       update(['billing_payment_methods']);
//       var response = await SalesService.getBillingPaymentMethods(
//           usrToken: loginData!.token, isRetailSale: isRetailSale);
//
//       if (response != null && response['success']) {
//         billingPaymentMethods = BillingPaymentMethods.fromJson(response);
//       } else {
//         hasError.value = true;
//       }
//     } catch (e) {
//       hasError.value = true;
//       logger.e(e);
//     } finally {
//       isPaymentMethodListLoading = false;
//       update(['billing_payment_methods']);
//     }
//   }
// }