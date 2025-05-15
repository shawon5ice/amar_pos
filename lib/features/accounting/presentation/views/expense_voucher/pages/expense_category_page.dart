import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/core/widgets/search_widget.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_categories_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/expense_voucher_controller.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/data/model/category_response_model.dart';
import '../../../../../../core/widgets/pager_list_view.dart';
import '../../../../../config/presentation/category/create_category_bottom_sheet.dart';
import '../../widgets/create_expense_category_bottom_sheet.dart';
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
    search = null;
    controller.getExpenseCategories();
    super.initState();
  }

  String? search;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchWidget(
                hintText: 'Search expense category...',
                onChanged: (value){
                  search = value;
                  controller.getExpenseCategories(search: search);
                },
              ),
            ),
            addH(8),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                margin: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                padding: const EdgeInsets.all(20),
                child: GetBuilder<ExpenseVoucherController>(
                  id: 'expense_vouchers_categories_list',
                  builder: (controller) {
                    if (controller.isExpenseCategoriesListLoading) {
                      return RandomLottieLoader.lottieLoader();
                    }else if(controller.expenseVoucherResponseModel == null){
                      return Center(
                        child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                      );
                    }else if(controller.expenseCategoriesResponseModel!.data.data!.isEmpty){
                      return Center(
                        child: Text("No data found", style: context.textTheme.titleLarge,),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        controller.getExpenseCategories(page: 1,search: search);
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
                                subtitle: item.remarks != null ? Text("Remarks: ${item.remarks}"): null,
                                trailing: !item.isActionable ? SizedBox.shrink(): Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                          ),
                                          builder: (context) {
                                            return CreateCategoryBottomSheet(
                                              category: Category(
                                                id: item.id,
                                                name: item.name,
                                              ),
                                              onTap: (value){
                                                controller.editCategory(
                                                  categoryName: value,
                                                  category: item,
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: SvgPicture.asset(AppAssets.editIcon),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // bool hasPermission = await controller.checkPurchasePermissions("destroy");
                                        // if(!hasPermission) return;
                                        AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            title: "Are you sure?",
                                            desc:
                                            'You are going to delete "${item.name}" expense category',
                                            btnOkOnPress: () {
                                              controller.deleteCategory(id: item.id);
                                            },
                                            btnCancelOnPress: () {})
                                            .show();
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
                          await controller.getExpenseCategories(page: nextPage,search: search);
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
            ),
          ],
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
