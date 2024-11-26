import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/config/data/model/outlet/outlet_list_model_response.dart';
import 'package:amar_pos/features/config/presentation/outlet/create_outlet_bottom_sheet.dart';
import 'package:amar_pos/features/config/presentation/outlet/outlet_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/network_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/search_widget.dart';
import '../supplier/supplier_action_menu_widget.dart';

class OutletScreen extends StatefulWidget {
  const OutletScreen({super.key});

  @override
  State<OutletScreen> createState() => _OutletScreenState();
}

class _OutletScreenState extends State<OutletScreen> {
  final OutletController _controller = Get.put(OutletController());

  @override
  void initState() {
    _controller.getAllOutlets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Outlet"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              SearchWidget(
                onChanged: (value){
                  _controller.searchBrand(search: value);
                },
              ),
              addH(16.px),
              Expanded(
                child: GetBuilder<OutletController>(
                    id: "outlet_list",
                    builder: (controller) {
                      if(_controller.outletListLoading){
                        return const Center(child: CircularProgressIndicator(),);
                      }else if(_controller.outletListModelResponse == null){
                        return Center(child: Text(NetWorkStrings.errorMessage, textAlign: TextAlign.center,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),));
                      }else if (_controller.outletList.isEmpty) {
                        return Center(
                          child: Text(
                            "No Brand Added",
                            style: context.textTheme.titleLarge,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: _controller.outletList.length,
                        itemBuilder: (context, index) {
                          Outlet outlet = controller.outletList[index];
                          return Container(
                          margin: EdgeInsets.symmetric(vertical: 5.h),
                          padding: const EdgeInsets.only(left: 20,top: 10,bottom: 20, right: 0),
                          foregroundDecoration: outlet.status == 0 ? BoxDecoration(
                            color: const Color(0xff7c7c7c).withOpacity(.3),
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.r)),
                          ): null,
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
                                            outlet.name,
                                            style: context.textTheme.titleSmall
                                                ?.copyWith(
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          AutoSizeText(
                                            outlet.phone,
                                            style: context.textTheme.bodyLarge
                                                ?.copyWith(
                                                color: const Color(0xff7C7C7C),
                                                fontSize: 12.sp),
                                          ),
                                          AutoSizeText(
                                            outlet.address,
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
                                  const Spacer(),
                                  // ActionDropDownWidget(),
                                  ActionMenu(
                                    status: outlet.status,
                                    onSelected: (value) {
                                      switch(value){
                                        case "edit":
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                          ),
                                          builder: (context) {
                                            return CreateOutletBottomSheet(outlet: outlet,);
                                          },
                                        );
                                          break;
                                        case "change-status":
                                          AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.question,
                                              title: "Are you sure?",
                                              desc: "You are going to ${outlet.status==1?'Deactivate':'Activate'} your outlet ${outlet.name}",
                                              btnOkOnPress: (){
                                                controller.changeStatusOfOutlet(outlet: outlet);
                                              },
                                              btnCancelOnPress: (){
                                              }
                                          ).show();
                                        case "delete":
                                          AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.error,
                                              title: "Are you sure?",
                                              desc: "You are going to delete your supplier ${outlet.name}",
                                              btnOkOnPress: (){
                                                controller.deleteOutlet(outlet: outlet);
                                              },
                                              btnCancelOnPress: (){
                                              }
                                          ).show();

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
                            ],
                          ),
                        );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomButton(
        text: "Add New Brand",
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
              return const CreateOutletBottomSheet();
            },
          );
        },
      ),
    );
  }
}