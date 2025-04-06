import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/pages/expense_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/methods/helper_methods.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/custom_button.dart';
import 'expense_voucher_controller.dart';
import 'pages/expense_category_page.dart';

class ExpenseVoucher extends StatefulWidget {
  static const routeName = '/accounting/expense-voucher';
  const ExpenseVoucher({super.key});

  @override
  State<ExpenseVoucher> createState() => _ExpenseVoucherState();
}

class _ExpenseVoucherState extends State<ExpenseVoucher> with SingleTickerProviderStateMixin{

  ExpenseVoucherController controller = Get.put(ExpenseVoucherController());


  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener((){
      if(_tabController.indexIsChanging){
        controller.selectedDateTimeRange.value = null;
        controller.update(['action_button']);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expense Voucher"),centerTitle: true,
        actions: [
          GetBuilder<ExpenseVoucherController>(
            id: 'action_button',
            builder: (controller) => _tabController.index == 0? IconButton(
            onPressed: () async {
              DateTimeRange? selectedDate = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now().subtract(const Duration(days: 1000)),
                lastDate: DateTime.now().add(const Duration(days: 1000)),
                initialDateRange: controller.selectedDateTimeRange.value,
              );
              if (selectedDate != null) {
                controller.setSelectedDateRange(selectedDate);
                controller.getExpenseVouchers();
              }
            },
            icon: SvgPicture.asset(AppAssets.calenderIcon),
          ): SizedBox.shrink(),)
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
                TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                    text: 'Expense',
                  ),
                  Tab(text: 'Expense Category'),
                ],
              ),
            ),
          ),
          // addH(12),
          Obx(() {
            return controller.selectedDateTimeRange.value == null ? addH(20): Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${formatDate(controller.selectedDateTimeRange.value!.start)} - ${formatDate(controller.selectedDateTimeRange.value!.end)}", style:const TextStyle(fontSize: 14, color: AppColors.error),),
                addW(16),
                IconButton(onPressed: (){
                  controller.selectedDateTimeRange.value = null;
                  controller.getExpenseVouchers();
                }, icon: Icon(Icons.cancel_outlined, size: 18, color: AppColors.error,))
              ],
            );
          }),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: const [
                ExpensePage(),
                ExpenseCategoryPage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
