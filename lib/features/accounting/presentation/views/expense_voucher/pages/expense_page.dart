import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/expense_voucher_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/widgets/pager_list_view.dart';
import '../../../../data/models/expense_voucher/expense_voucher_response_model.dart';
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
    controller.getExpenseVouchers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: GetBuilder<ExpenseVoucherController>(
                  id: 'expense_vouchers_list',
                  builder: (controller) {
                    if (controller.isExpenseVouchersListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }else if(controller.expenseVoucherResponseModel == null){
                      return Center(
                        child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                      );
                    }else if(controller.dailyStatementList.isEmpty){
                      return Center(
                        child: Text("No data found", style: context.textTheme.titleLarge,),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        controller.getExpenseVouchers(page: 1);
                      },
                      child: PagerListView<TransactionData>(
                        // scrollController: _scrollController,
                        items: controller.dailyStatementList,
                        itemBuilder: (_, item) {
                          return ExpenseVoucherItem(transactionData: item,);
                        },
                        isLoading: controller.isLoadingMore,
                        hasError: controller.hasError.value,
                        onNewLoad: (int nextPage) async {
                          await controller.getExpenseVouchers(page: nextPage);
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
        ),
      ),
    );
  }
}
