import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/inventory/data/products/product_list_response_model.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/presentation/supplier/supplier_action_menu_widget.dart';

class ProductListItemWidget extends StatelessWidget {
  const ProductListItemWidget({super.key, required this.productInfo});

  final ProductInfo productInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 20, right: 0),
      foregroundDecoration: productInfo.status == 0
          ? BoxDecoration(
              color: Color(0xff7c7c7c).withOpacity(.3),
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
                width: 70.w,
                height: 70.w,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(1.px),
                decoration: ShapeDecoration(
                  color: const Color(0x33BEBEBE).withOpacity(.3),
                  // image: DecorationImage(image: NetworkImage(controller.supplierList[index].photo!)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                    child: Image.network(
                      productInfo.thumbnailImage.toString(),
                      height: 70.w,
                      width: 70.w,
                      fit: BoxFit.cover,
                    )),
              ),
              addW(12.w),
              Expanded(
                flex: 8,
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productInfo.name,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontSize: 13.sp,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8,),
                      Row(children: [
                        Expanded(
                          flex: 2,
                          child: Text("Brand"),),
                        Text(" : "),
                        Flexible(
                          flex: 8,
                          child: Text(productInfo.brand?.name.toString() ?? '--'),),
                      ],),
                      SizedBox(height: 4,),
                      Row(children: [
                        Expanded(
                          flex: 2,
                          child: Text("ID"),),
                        Text(" : "),
                        Flexible(
                          flex: 8,
                          child: Text(productInfo.brand?.id.toString() ?? '--'),),
                      ],),
                      // AutoSizeText(
                      //   productInfo.warranty?.name.toString(),
                      //   style: context.textTheme.bodyLarge
                      //       ?.copyWith(
                      //       color: const Color(0xff7C7C7C),
                      //       fontSize: 12.sp),
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
              const Spacer(),
              // ActionDropDownWidget(),
              ActionMenu(
                status: productInfo.status,
                onSelected: (value) {
                  switch (value) {
                    case "edit":
                      // showModalBottomSheet(
                      //   context: context,
                      //   isScrollControlled: true,
                      //   shape: const RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      //   ),
                      //   builder: (context) {
                      //     return CreateSupplierBottomSheet(supplier: controller.supplierList[index],);
                      //   },
                      // );
                      break;
                    case "change-status":
                    // AwesomeDialog(
                    //     context: context,
                    //     dialogType: DialogType.question,
                    //     title: "Are you sure?",
                    //     desc: "You are going to ${controller.supplierList[index].status==1?'Deactivate':'Activate'} your supplier ${controller.supplierList[index].name}",
                    //     btnOkOnPress: (){
                    //       controller.changeStatusOfSupplier(supplier: controller.supplierList[index]);
                    //     },
                    //     btnCancelOnPress: (){
                    //     }
                    // ).show();
                    case "delete":
                      // AwesomeDialog(
                      //     context: context,
                      //     dialogType: DialogType.error,
                      //     title: "Are you sure?",
                      //     desc: "You are going to delete your supplier ${controller.supplierList[index].name}",
                      //     btnOkOnPress: (){
                      //       controller.deleteSupplier(supplier: controller.supplierList[index]);
                      //     },
                      //     btnCancelOnPress: (){
                      //     }
                      // ).show();

                      break;
                  }
                },
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
          addH(12.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  // margin: EdgeInsets.only(right: 20),
                  height: 30.h,
                  decoration: BoxDecoration(
                      color: Color(0xffFFFBED).withOpacity(.3),
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                      border: Border.all(
                          color: const Color(0xffff9000).withOpacity(.3),
                          width: .5)),
                  child: Center(
                      child: Text(
                    "WSP : ${Methods.getFormatedPrice(productInfo.wholesalePrice.toDouble())}",
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
                    "MRP : ${Methods.getFormatedPrice(productInfo.mrpPrice.toDouble())}",
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
    );
  }
}