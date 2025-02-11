import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_categories_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/expense_voucher_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/create_expense_category_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/widgets/pager_list_view.dart';
import '../../../../data/models/expense_voucher/expense_voucher_response_model.dart';
import '../../widgets/expense_voucher_item.dart';

class ExpenseCategoryPage extends StatefulWidget {
  const ExpenseCategoryPage({super.key});

  @override
  State<ExpenseCategoryPage> createState() => _ExpenseCategoryPageState();
}

class _ExpenseCategoryPageState extends State<ExpenseCategoryPage> {
  ExpenseVoucherController controller = Get.find();

  @override
  void initState() {
    controller.getExpenseCategories();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
          padding: EdgeInsets.all(20),
          child: GetBuilder<ExpenseVoucherController>(
            id: 'expense_vouchers_categories_list',
            builder: (controller) {
              if (controller.isExpenseCategoriesListLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }else if(controller.expenseVoucherResponseModel == null){
                return Center(
                  child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                );
              }else if(controller.expenseCategoriesList.isEmpty){
                return Center(
                  child: Text("No data found", style: context.textTheme.titleLarge,),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  controller.getExpenseCategories(page: 1);
                },
                child: PagerListView<ExpenseCategory>(
                  // scrollController: _scrollController,
                  items: controller.expenseCategoriesList,
                  itemBuilder: (_, item) {
                    int index = controller.expenseCategoriesList.indexOf(item);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            item.name,
                            style: context.textTheme.titleSmall?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                height: (22 / 16)),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  // showModalBottomSheet(
                                  //   context: context,
                                  //   isScrollControlled: true,
                                  //   shape: const RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.vertical(
                                  //         top: Radius.circular(20)),
                                  //   ),
                                  //   builder: (context) {
                                  //     return CreateCategoryBottomSheet(
                                  //       category:
                                  //       _categoryController.categoryList[index],
                                  //     );
                                  //   },
                                  // );
                                },
                                child: SvgPicture.asset(AppAssets.editIcon),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              InkWell(
                                onTap: () {
                                  // _categoryController.deleteCategory(
                                  //     category:
                                  //     _categoryController.categoryList[index]);
                                },
                                child:
                                SvgPicture.asset(AppAssets.deleteIcon),
                              ),
                            ],
                          ),
                        ),
                        index == controller.expenseCategoriesResponseModel!.data.meta!.total-1 ? SizedBox.shrink() : const Divider(
                          color: Color(0xffE0E0E0),
                        ),
                      ],
                    );
                  },
                  isLoading: controller.isLoadingMore,
                  hasError: controller.hasError.value,
                  onNewLoad: (int nextPage) async {
                    await controller.getExpenseCategories(page: nextPage);
                  },
                  totalPage: controller.expenseCategoriesResponseModel?.data.meta?.lastPage ?? 0,
                  totalSize:
                  controller.expenseCategoriesResponseModel?.data.meta?.total ?? 0,
                  itemPerPage: 20,
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10, top: 10),
          child: CustomButton(
            text: "Add New Category",
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20)),
                ),
                builder: (context) {
                  return CreateExpenseCategoryBottomSheet();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
