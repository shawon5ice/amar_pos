import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/config/presentation/supplier/create_supplier_bottom_sheet.dart';
import 'package:amar_pos/features/config/presentation/supplier/supplier_action_drop_down_widget.dart';
import 'package:amar_pos/features/config/presentation/supplier/supplier_action_menu_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'supplier_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/search_widget.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final SupplierController _controller = Get.put(SupplierController());

  @override
  void initState() {
    _controller.getAllSupplier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Supplier"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              SearchWidget(
                onChanged: (value) {
                  _controller.searchSupplier(search: value);
                },
              ),
              addH(16.h),
              Expanded(
                child: GetBuilder<SupplierController>(
                  id: "supplier_list",
                  builder: (controller) {
                    if (_controller.supplierListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (_controller.supplierListResponseModel == null) {
                      return Center(
                        child: Text(
                          "Something went wrong",
                          style: context.textTheme.titleLarge,
                        ),
                      );
                    } else if (_controller.supplierList.isEmpty) {
                      return Center(
                        child: Text(
                          "No Supplier Found",
                          style: context.textTheme.titleLarge,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: _controller.supplierList.length,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        padding: EdgeInsets.only(left: 20,top: 10,bottom: 20, right: 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.r))),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 50.w,
                                  height: 50.w,
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.all(2.px),
                                  decoration: ShapeDecoration(
                                    color: const Color(0x33BEBEBE),
                                    // image: DecorationImage(image: NetworkImage(controller.supplierList[index].photo!)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8.r)),
                                      child: Image.network(
                                        controller.supplierList[index].photo
                                            .toString(),
                                        height: 50.w,
                                        width: 50.w,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.supplierList[index].name,
                                          style: context.textTheme.titleSmall
                                              ?.copyWith(
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        AutoSizeText(
                                          controller.supplierList[index].phone!,
                                          style: context.textTheme.bodyLarge
                                              ?.copyWith(
                                                  color: const Color(0xff7C7C7C),
                                                  fontSize: 12.sp),
                                        ),
                                        AutoSizeText(
                                          controller.supplierList[index].address!,
                                          style: context.textTheme.bodyLarge
                                              ?.copyWith(
                                            color: const Color(0xff7C7C7C),
                                          ),
                                          minFontSize: 8,
                                          maxFontSize: 12,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                // ActionDropDownWidget(),
                                ActionMenu(
                                  onSelected: (value) {},
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
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              height: 30.h,
                              decoration: BoxDecoration(
                                  color: Color(0xffF6FBFF),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.r)),
                                  border: Border.all(color: const Color(0xffD3ECFF))),
                              child: Center(
                                  child: Text(
                                "ID : ${controller.supplierList[index].code}",
                                style: context.textTheme.titleSmall,
                              )),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomButton(
        text: "Create Supplier",
        marginHorizontal: 20,
        marginVertical: 10,
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return const CreateSupplierBottomSheet();
            },
          );
        },
      ),
    );
  }
}
