import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/presentation/views/chart_of_account/chart_of_account_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/methods/helper_methods.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import '../../../../../core/widgets/search_widget.dart';
import 'chart_node.dart';
import 'chart_tree_view.dart';

class ChartOfAccountScreen extends StatefulWidget {
  static const routeName = '/accounting/chart-of-account';

  const ChartOfAccountScreen({super.key});

  @override
  State<ChartOfAccountScreen> createState() => _ChartOfAccountScreenState();
}

class _ChartOfAccountScreenState extends State<ChartOfAccountScreen>
    with SingleTickerProviderStateMixin {
  ChartOfAccountController controller = Get.find();


  @override
  void initState() {
    controller.getChartOfAccountList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chart Of Account"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20, bottom: 20),
          child: Column(
            children: [
              SearchWidget(
                onChanged: (value) => controller.getChartOfAccountList(search: value),
              ),
              addH(12),
              Expanded(
                child: GetBuilder<ChartOfAccountController>(
                  id: 'chart_of_account_list',
                  builder: (controller) {
                    if (controller.isChartOfAccountListLoading) {
                      return Center(child: RandomLottieLoader.lottieLoader(),);
                    } else if (controller.chartOfAccountListResponseModel == null ) {
                      return const Center(child: Text("Something went wrong"));
                    } else if (controller.chartOfAccountList.isEmpty) {
                      return const Center(child: Text("No data found"));
                    }
                    return ChartTreeView(
                      nodes: buildChartTree(controller.chartOfAccountList),
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
