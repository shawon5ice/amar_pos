import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';

class DailyStatement extends StatelessWidget {
  const DailyStatement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daily Statement"),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldTitle("Select Account"),
                  addH(4),
                  Row(children: [
                    Expanded(child: CustomTextField(textCon: TextEditingController(), hintText: "Select Account")),
                    addW(8),
                    CustomSvgIconButton(
                      bgColor: const Color(0xffEBFFDF),
                      onTap: () {
                        // controller.downloadList(isPdf: false, returnHistory: true);
                        // controller.downloadStockLedgerReport(
                        //     isPdf: false, context: context);
                      },
                      assetPath: AppAssets.excelIcon,
                    ),
                    addW(4),
                    CustomSvgIconButton(
                      bgColor: const Color(0xffE1F2FF),
                      onTap: () {
                        // controller.downloadList(isPdf: true, returnHistory: true);
                      },
                      assetPath: AppAssets.downloadIcon,
                    ),
                    addW(4),
                    CustomSvgIconButton(
                      bgColor: const Color(0xffFFFCF8),
                      onTap: () {},
                      assetPath: AppAssets.printIcon,
                    )
                  ],),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
