import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/inventory/data/stock_report/stock_report_list_reponse_model.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/product_quick_edit.dart';
import 'package:amar_pos/features/inventory/presentation/stock_report/stock_report_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StockReportListItemWidget extends StatelessWidget {
  StockReportListItemWidget({super.key, required this.stockReport});

  final StockReportController controller = Get.find();

  final StockReport stockReport;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      foregroundDecoration: stockReport.status == 0
          ? BoxDecoration(
              color: const Color(0xff7c7c7c).withOpacity(.3),
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
            )
          : null,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r))),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 70,
                height: 70,
                margin: const EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(1.px),
                decoration: ShapeDecoration(
                  color: const Color(0x33BEBEBE).withOpacity(.3),
                  // image: DecorationImage(image: NetworkImage(controller.supplierList[index].photo!)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Image.network(
                      stockReport.thumbnailImage.toString(),
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    )),
              ),
              addW(12),
              Expanded(
                flex: 8,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stockReport.name,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontSize: 13,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      addH(4),
                      Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text("ID"),
                          ),
                          const Text(" : "),
                          Flexible(
                            flex: 8,
                            child: Text(stockReport.sku.toString() ?? '--'),
                          ),
                        ],
                      ),
                      addH(8),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "QTY",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          const Text(" : "),
                          Flexible(
                            flex: 8,
                            child: Text(
                              stockReport.stock.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // AutoSizeText(
                      //   stockReport.warranty?.name.toString(),
                      //   style: context.textTheme.bodyLarge
                      //       ?.copyWith(
                      //       color: const Color(0xff7C7C7C),
                      //       fontSize: 12),
                      // ),
                      // AutoSizeText(
                      //   controller.supplierList[index].address??'--',
                      //   style: context.textTheme.bodyLarge
                      //       ?.copyWith(
                      //     color: const Color(0xff7C7C7C),
                      //   ),
                      //   minFontSize: 8,
                      //   maxFontSize: 12,
                      //   maxLines: 2,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                    ],
                  ),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //
              //   },
              //   child:
              //       SvgPicture.asset(AppAssets.threeDotMenu),
              // )
            ],
          ),
          addH(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleValueWidget(
                title: "COP",
                value: Methods.getFormatedPrice(stockReport.costingPrice.toDouble()),
                bgColor: Colors.deepPurple.withOpacity(.1),
                borderColor: Colors.deepPurple.withOpacity(.3),
                textColor: Colors.deepPurple,
              ),
              addW(4),
              TitleValueWidget(
                title: "WSP",
                value: Methods.getFormatedPrice(
                    stockReport.wholesalePrice.toDouble()),
                textColor: Color(0xffFF9000),
                borderColor: Color(0xffff9000).withOpacity(.3),
                bgColor: Color(0xffFFFBED).withOpacity(.3),
              ),
              addW(4),
              TitleValueWidget(
                title: "MRP",
                // rightMargin: true,
                value: Methods.getFormatedPrice(
                    stockReport.mrpPrice.toDouble()),
                bgColor: Color(0xffF6FFF6),
                borderColor: Color(0xff94DB8C).withOpacity(.3),
                textColor: Color(0xff009D5D),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TitleValueWidget extends StatelessWidget {
  const TitleValueWidget(
      {super.key,
      required this.title,
      required this.value,
      this.textColor,
      this.bgColor,
      this.borderColor,
      this.fontWeight,
      this.fontSize,
      this.rightMargin});

  final String title;
  final String value;
  final Color? textColor;
  final Color? bgColor;
  final Color? borderColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool? rightMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.7,
      padding: const EdgeInsets.all(4),
      margin: rightMargin != null
          ? const EdgeInsets.only(right: 10)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: bgColor ?? const Color(0xffFFFBED),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(
            color: borderColor ?? const Color(0xffff9000), width: .5),
      ),
      child: Center(
        child: AutoSizeText(
          "$title : $value",
          maxLines: 1,
          minFontSize: 4,
          maxFontSize: 14,
          style: context.textTheme.titleSmall?.copyWith(
            color: textColor ?? Colors.black,
            fontWeight: fontWeight ?? FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
