import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/config/data/model/client/client_list_model_response.dart';
import 'package:amar_pos/features/config/data/model/customer/customer_list_model_response.dart';
import 'package:amar_pos/features/config/presentation/client/client_controller.dart';
import 'package:amar_pos/features/config/presentation/client/create_client_bottom_sheet.dart';
import 'package:amar_pos/features/config/presentation/customer/customer_controller.dart';
import 'package:amar_pos/features/config/presentation/outlet/create_outlet_bottom_sheet.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/network_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/search_widget.dart';
import '../supplier/supplier_action_menu_widget.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final CustomerController _controller = Get.put(CustomerController());

  @override
  void initState() {
    _controller.getAllCustomer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer"),
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
                child: GetBuilder<CustomerController>(
                    id: "customer_list",
                    builder: (controller) {
                      if(_controller.customerListLoading){
                        return const Center(child: CircularProgressIndicator(),);
                      }else if(_controller.customerListResponseModel == null){
                        return Center(child: Text(NetWorkStrings.errorMessage, textAlign: TextAlign.center,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),));
                      }else if (_controller.customerList.isEmpty) {
                        return Center(
                          child: Text(
                            "No Customer Found",
                            style: context.textTheme.titleLarge,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: _controller.customerList.length,
                        itemBuilder: (context, index) {
                          Customer customer = controller.customerList[index];
                          return Container(
                          margin: EdgeInsets.symmetric(vertical: 5.h),
                          padding: const EdgeInsets.only(left: 20,top: 10,bottom: 20, right: 0),
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
                                            customer.name,
                                            style: context.textTheme.titleSmall
                                                ?.copyWith(
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          AutoSizeText(
                                            customer.phone,
                                            style: context.textTheme.bodyLarge
                                                ?.copyWith(
                                                color: const Color(0xff7C7C7C),
                                                fontSize: 12.sp),
                                          ),
                                          AutoSizeText(
                                            customer.address,
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
                                  // const Spacer(),
                                  // ActionDropDownWidget(),
                                  // ActionMenu(
                                  //   status: client.status,
                                  //   onSelected: (value) {
                                  //     switch(value){
                                  //       case "edit":
                                  //       showModalBottomSheet(
                                  //         context: context,
                                  //         isScrollControlled: true,
                                  //         shape: const RoundedRectangleBorder(
                                  //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  //         ),
                                  //         builder: (context) {
                                  //           return CreateClientBottomSheet(client: client,);
                                  //         },
                                  //       );
                                  //         break;
                                  //       case "change-status":
                                  //         AwesomeDialog(
                                  //             context: context,
                                  //             dialogType: DialogType.question,
                                  //             title: "Are you sure?",
                                  //             desc: "You are going to ${client.status==1?'Deactivate':'Activate'} your client ${client.name}",
                                  //             btnOkOnPress: (){
                                  //               controller.changeStatusOfClient(client: client);
                                  //             },
                                  //             btnCancelOnPress: (){
                                  //             }
                                  //         ).show();
                                  //       case "delete":
                                  //         AwesomeDialog(
                                  //             context: context,
                                  //             dialogType: DialogType.error,
                                  //             title: "Are you sure?",
                                  //             desc: "You are going to delete your client ${client.name}",
                                  //             btnOkOnPress: (){
                                  //               controller.deleteClient(client: client);
                                  //             },
                                  //             btnCancelOnPress: (){
                                  //             }
                                  //         ).show();
                                  //
                                  //         break;
                                  //     }
                                  //   },
                                  // ),
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
      // bottomNavigationBar: CustomButton(
      //   text: "Add New Client",
      //   marginHorizontal: 20,
      //   marginVertical: 10,
      //   onTap: () {
      //     showModalBottomSheet(
      //       context: context,
      //       isScrollControlled: true,
      //       shape: const RoundedRectangleBorder(
      //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      //       ),
      //       builder: (context) {
      //         return const CreateClientBottomSheet();
      //       },
      //     );
      //   },
      // ),
    );
  }
}