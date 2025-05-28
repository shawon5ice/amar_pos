import 'package:amar_pos/core/widgets/reusable/payment_dd/ca_payment_method_dd_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/money_adjustment/pages/add_money_adjustment_page.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/money_adjustment_bottom_sheet.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/money_adjustment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/methods/helper_methods.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/pager_list_view.dart';
import '../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import '../../../data/models/money_adjustment_list_response_model/money_adjustment_list_response_model.dart';
import 'money_adjustment_controller.dart';

class MoneyAdjustment extends StatefulWidget {
  static const routeName = '/accounting/money-adjustment';
  const MoneyAdjustment({super.key});

  @override
  State<MoneyAdjustment> createState() => _MoneyAdjustmentState();
}

class _MoneyAdjustmentState extends State<MoneyAdjustment> with SingleTickerProviderStateMixin{

  MoneyAdjustmentController controller = Get.put(MoneyAdjustmentController());

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener((){
      if(_tabController.indexIsChanging){
        controller.clearFilter();
        FocusScope.of(context).unfocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<CAPaymentMethodDDController>();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Money Adjustment"),centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                DateTimeRange? selectedDate = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(const Duration(days: 1000)),
                  lastDate: DateTime.now().add(const Duration(days: 1000)),
                  initialDateRange: controller.selectedDateTimeRange.value,
                );
                controller.selectedDateTimeRange.value = selectedDate;
                controller.getMoneyAdjustmentList();
              },
              icon: SvgPicture.asset(AppAssets.calenderIcon),
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TabBar(
                  dividerHeight: 0,
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal),
                  labelColor: Colors.white,
                  splashBorderRadius: BorderRadius.circular(20),
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(
                      text: 'Add',
                    ),
                    Tab(text: 'Withdraw'),
                  ],
                ),
              ),
            ),
            addH(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      textCon: controller.searchController,
                      hintText: "Search...",
                      brdrClr: Colors.transparent,
                      txtSize: 12,
                      debounceDuration: const Duration(
                        milliseconds: 300,
                      ),
                      // noInputBorder: true,
                      brdrRadius: 40,
                      prefixWidget: Icon(Icons.search),
                      onChanged: (value){
                        controller.getMoneyAdjustmentList();
                      },
                    ),
                  ),
                  addW(8),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffEBFFDF),
                    onTap: () {
                      controller.downloadList(isPdf: false,type: _tabController.index+1);
                    },
                    assetPath: AppAssets.excelIcon,
                  ),
                  addW(4),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffE1F2FF),
                    onTap: () {
                      controller.downloadList(isPdf: true,type: _tabController.index+1);
                    },
                    assetPath: AppAssets.downloadIcon,
                  ),
                  addW(4),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffFFFCF8),
                    onTap: () {
                      controller.downloadList(isPdf: true, shouldPrint: true,type: _tabController.index+1);
                    },
                    assetPath: AppAssets.printIcon,
                  )
                ],
              ),
            ),
            // addH(8),
            Obx(() {
              return controller.selectedDateTimeRange.value == null ? addH(8) : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${formatDate(controller.selectedDateTimeRange.value!.start)} - ${formatDate(controller.selectedDateTimeRange.value!.end)}", style:const TextStyle(fontSize: 14, color: AppColors.error),),
                  addW(16),
                  IconButton(onPressed: (){
                    controller.selectedDateTimeRange.value = null;
                    controller.getMoneyAdjustmentList();
                  }, icon: const Icon(Icons.cancel_outlined, size: 18, color: AppColors.error,))
                ],
              );
            }),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: const [
                  AddMoneyAdjustmentPage(adjustmentType: 1,),
                  AddMoneyAdjustmentPage(adjustmentType: 2,),
                  // ExpenseCategoryPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
