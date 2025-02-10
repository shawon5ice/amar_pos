import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/pages/collection_page.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/pages/expense_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/methods/helper_methods.dart';
import '../../../../../core/responsive/pixel_perfect.dart';

class DueCollection extends StatefulWidget {
  static const routeName = '/accounting/due-collection';
  const DueCollection({super.key});

  @override
  State<DueCollection> createState() => _DueCollectionState();
}

class _DueCollectionState extends State<DueCollection> with SingleTickerProviderStateMixin{

  DueCollectionController controller = Get.put(DueCollectionController());


  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener((){
      if(_tabController.indexIsChanging){
        controller.update(['action_button']);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Due Collection"),centerTitle: true,
        actions: [
          GetBuilder<DueCollectionController>(
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
                  // controller.getDueCollections();
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
                    text: 'Collection',
                  ),
                  Tab(text: 'Client Ledger'),
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
                  // controller.getDueCollections();
                }, icon: Icon(Icons.cancel_outlined, size: 18, color: AppColors.error,))
              ],
            );
          }),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: const [
                CollectionPage(),
                CollectionPage(),
                // ExpenseCategoryPage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
