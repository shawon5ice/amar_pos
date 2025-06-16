import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/expense_voucher_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/logger/logger.dart';
import '../../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../../core/widgets/pager_list_view.dart';
import '../../../../../../core/widgets/reusable/forbidden_access_full_screen_widget.dart';
import '../../../../../../core/widgets/search_widget.dart';
import '../../../../data/models/expense_voucher/expense_voucher_response_model.dart';
import '../../widgets/create_expense_voucher_bottom_sheet.dart';
import '../../widgets/expense_voucher_item.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  ExpenseVoucherController controller = Get.find();

  @override
  void initState() {
    search = null;
    if(controller.expenseVoucherListAccess){
      controller.getExpenseVouchers(page: 1);
    }

    super.initState();
  }
  String? search;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpenseVoucherController>(
        id: 'permission_handler_builder',
        builder: (controller) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Scaffold(
              body: !controller.expenseVoucherListAccess
                  ? const ForbiddenAccessFullScreenWidget()
                  : Column(
                children: [
                  SearchWidget(
                    hintText: 'Search expense voucher...',
                    onChanged: (value){
                      search = value;
                      controller.getExpenseVouchers(search: search);
                    },
                  ),
                  addH(8),
                  Expanded(
                    child: GetBuilder<ExpenseVoucherController>(
                      id: 'expense_vouchers_list',
                      builder: (controller) {
                        if (controller.isExpenseVouchersListLoading) {
                          return RandomLottieLoader.lottieLoader();
                        }else if(controller.expenseVoucherResponseModel == null){
                          return Center(
                            child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                          );
                        }else if(controller.expenseVouchersList.isEmpty){
                          return Center(
                            child: Text("No data found", style: context.textTheme.titleLarge,),
                          );
                        }
                        return RefreshIndicator(
                          onRefresh: () async {
                            controller.getExpenseVouchers(page: 1,search: search);
                          },
                          child: PagerListView<TransactionData>(
                            // scrollController: _scrollController,
                            items: controller.expenseVouchersList,
                            itemBuilder: (_, item) {
                              return ExpenseVoucherItem(transactionData: item,);
                            },
                            isLoading: controller.isLoadingMore,
                            hasError: controller.hasError.value,
                            onNewLoad: (int nextPage) async {
                              await controller.getExpenseVouchers(page: nextPage,search: search);
                            },
                            totalPage: controller
                                .expenseVoucherResponseModel?.data?.meta?.lastPage ?? 0,
                            totalSize:
                            controller
                                .expenseVoucherResponseModel?.data?.meta?.total ??
                                0,
                            itemPerPage: 20,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: !controller.expenseVoucherCreateAccess
                  ? null
                  : Padding(
                padding: const EdgeInsets.only(bottom: 10,top: 10),
                child: CustomButton(
                  text: "Create Voucher",
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        return const CreateExpenseVoucherBottomSheet();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
