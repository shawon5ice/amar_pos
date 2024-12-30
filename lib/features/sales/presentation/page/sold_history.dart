import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';

class SoldHistory extends StatelessWidget {
  const SoldHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      // showModalBottomSheet(
                      //   context: context,
                      //   builder: (context) =>
                      //       const StockLedgerFilterBottomSheet(),
                      // );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 12, bottom: 12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search),
                          addW(8),
                          const Text("Search"),
                          const Spacer(),
                        ],
                      ),
                    )),
              ),
              addW(8),
              CustomSvgIconButton(
                bgColor: const Color(0xffEBFFDF),
                onTap: () {
                  // controller.downloadStockLedgerReport(
                  //     isPdf: false, context: context);
                },
                assetPath: AppAssets.excelIcon,
              ),
              addW(4),
              CustomSvgIconButton(
                bgColor: const Color(0xffE1F2FF),
                onTap: () {
                  // controller.downloadStockLedgerReport(
                  //     isPdf: true, context: context);
                },
                assetPath: AppAssets.downloadIcon,
              ),
              addW(4),
              CustomSvgIconButton(
                bgColor: const Color(0xffFFFCF8),
                onTap: () {},
                assetPath: AppAssets.printIcon,
              )
            ],
          ),
        ],
      ),
    );
  }
}
