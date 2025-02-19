import 'package:amar_pos/features/accounting/presentation/views/money_adjustment/money_adjustment_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/money_adjustment_bottom_sheet.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/money_adjustment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/methods/helper_methods.dart';
import '../../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../core/widgets/pager_list_view.dart';
import '../../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import '../../../../data/models/money_adjustment_list_response_model/money_adjustment_list_response_model.dart';

class AddMoneyAdjustmentPage extends StatefulWidget {
  const AddMoneyAdjustmentPage({super.key, required this.adjustmentType});
  final int adjustmentType;

  @override
  State<AddMoneyAdjustmentPage> createState() => _AddMoneyAdjustmentPageState();
}

class _AddMoneyAdjustmentPageState extends State<AddMoneyAdjustmentPage> with SingleTickerProviderStateMixin{

  MoneyAdjustmentController controller = Get.put(MoneyAdjustmentController());


  @override
  void initState() {
    controller.getMoneyAdjustmentList(type: widget.adjustmentType);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<MoneyAdjustmentController>(
                id: 'money_adjustment_list${widget.adjustmentType}',
                builder: (controller) {
                  if (controller.isMoneyAdjustmentListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }else if(controller.moneyAdjustmentListResponseModel == null){
                    return Center(
                      child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                    );
                  }else if(controller.moneyAdjustmentList.isEmpty){
                    return Center(
                      child: Text("No data found", style: context.textTheme.titleLarge,),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.getMoneyAdjustmentList(page: 1);
                    },
                    child: PagerListView<MoneyAdjustmentData>(
                      // scrollController: _scrollController,
                      items: controller.moneyAdjustmentList,
                      itemBuilder: (_, item) {
                        return MoneyAdjustmentItem(moneyAdjustmentData: item,);
                      },
                      isLoading: controller.isLoadingMore,
                      hasError: controller.hasError.value,
                      onNewLoad: (int nextPage) async {
                        await controller.getMoneyAdjustmentList(page: nextPage);
                      },
                      totalPage: controller
                          .moneyAdjustmentListResponseModel?.data?.meta?.lastPage ?? 0,
                      totalSize:
                      controller
                          .moneyAdjustmentListResponseModel?.data?.meta?.total ??
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: CustomButton(
          text: widget.adjustmentType == 1 ? "Add Money" : "Withdraw Money",
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20)),
              ),
              builder: (context) {
                return MoneyAdjustmentBottomSheet();
              },
            );
          },
        ),
      ),
    );
  }
}
