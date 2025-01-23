import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/product_quick_edit.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_product_response_model.dart';
import 'package:amar_pos/features/return/data/models/return_products/return_product_response_model.dart';
import 'package:amar_pos/features/sales/data/models/sold_product/sold_product_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PurchaseProductListItem extends StatelessWidget {
  const PurchaseProductListItem({super.key, required this.productInfo});


  final PurchaseProduct productInfo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=> const ProductQuickViewScreen(), arguments: productInfo);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: const EdgeInsets.only(left: 20, top: 10, bottom: 20, right: 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.r))),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container(
                //   width: 70.w,
                //   height: 70.w,
                //   margin: const EdgeInsets.only(top: 10),
                //   padding: EdgeInsets.all(1.px),
                //   decoration: ShapeDecoration(
                //     color: const Color(0x33BEBEBE).withOpacity(.3),
                //     // image: DecorationImage(image: NetworkImage(controller.supplierList[index].photo!)),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10.r),
                //     ),
                //   ),
                //   child: ClipRRect(
                //       borderRadius: BorderRadius.all(Radius.circular(8.r)),
                //       child: Image.network(
                //         productInfo..toString(),
                //         height: 70.w,
                //         width: 70.w,
                //         fit: BoxFit.cover,
                //       )),
                // ),
                // addW(12.w),
                Expanded(
                  flex: 8,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productInfo.product,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontSize: 13.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        addH(8.h),
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text("Brand"),
                            ),
                            const Text(" : "),
                            Flexible(
                              flex: 8,
                              child: Text(
                                  productInfo.brand),
                            ),
                          ],
                        ),
                        addH(4.h),
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text("Category"),
                            ),
                            const Text(" : "),
                            Flexible(
                              flex: 8,
                              child: Text(productInfo.category),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            addH(12.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    // margin: EdgeInsets.only(right: 20),
                    height: 30.h,
                    decoration: BoxDecoration(
                        color: const Color(0xffFFFBED).withOpacity(.3),
                        borderRadius: BorderRadius.all(Radius.circular(20.r)),
                        border: Border.all(
                            color: const Color(0xffff9000).withOpacity(.3),
                            width: .5)),
                    child: Center(
                        child: Text(
                          "QTY : ${Methods.getFormattedNumber(productInfo.quantity.toDouble())}",
                          style: context.textTheme.titleSmall?.copyWith(
                              color: Color(0xffFF9000),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    height: 30.h,
                    decoration: BoxDecoration(
                        color: Color(0xffF6FFF6),
                        borderRadius: BorderRadius.all(Radius.circular(20.r)),
                        border: Border.all(
                            color: const Color(0xff94DB8C).withOpacity(.3))),
                    child: Center(
                        child: Text(
                          "Sold Price : ${Methods.getFormatedPrice(productInfo.totalPrice.toDouble())}",
                          style: context.textTheme.titleSmall?.copyWith(
                              color: Color(0xff009D5D),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
