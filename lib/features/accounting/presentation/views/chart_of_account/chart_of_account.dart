import 'package:amar_pos/core/core.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkPrimary,
      appBar: AppBar(
        title: const Text("Chart Of Account"),
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     DateTime? selectedDate = await showDatePicker(
          //       context: context,
          //       firstDate: DateTime.now().subtract(const Duration(days: 1000)),
          //       lastDate: DateTime.now().add(const Duration(days: 1000)),
          //       initialDate: controller.selectedDateTime.value,
          //     );
          //     controller.selectedDateTime.value = selectedDate;
          //     if (selectedDate != null) {
          //       controller.update(['date_status']);
          //       controller.getBalanceSheet();
          //     }
          //   },
          //   icon: SvgPicture.asset(AppAssets.calenderIcon),
          // )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20, bottom: 20),
          child: GetBuilder<ChartOfAccountController>(
            id: 'chart_of_account_list',
            builder: (controller) {
              if (controller.isChartOfAccountListLoading) {
                return const Center(child: CircularProgressIndicator());
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
      ),
    );
  }

  DataCell _buildDataCell(String data, {int maxLines = 1, bool? alignLeft, bool? isMinus, bool? alignRight,required bool isNumber}) {

    return isNumber && data == "0" ?  DataCell(SizedBox.shrink()) :  DataCell(
        Align(
          alignment: alignLeft == true ? Alignment.centerLeft : alignRight == true?  Alignment.centerRight : Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(isMinus != null && isMinus == true && isNumber == false)AutoSizeText(
                minFontSize: 5,
                maxFontSize: 10,
                maxLines: maxLines,
                "(-) ",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.error,
                ),
              ),
              AutoSizeText(
                minFontSize: 5,
                maxFontSize: 10,
                maxLines: maxLines,
                data,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isMinus == true && isNumber ? AppColors.error : alignLeft == true? Color(0xff7C7C7C) : Colors.black,
                  fontWeight: alignRight == true || isNumber ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        )
    );
  }
}
