import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/config/presentation/employee/create_user_screen.dart';
import 'package:amar_pos/features/config/presentation/employee/employee_controller.dart';
import 'package:amar_pos/features/config/presentation/supplier/create_supplier_bottom_sheet.dart';
import 'package:amar_pos/features/config/presentation/supplier/supplier_action_menu_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/search_widget.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final EmployeeController _controller = Get.put(EmployeeController());

  @override
  void initState() {
    _controller.getAllEmployee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee"),
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
                child: GetBuilder<EmployeeController>(
                  id: "employee_list",
                  builder: (controller) {
                    if (_controller.employeeListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (_controller.employeeListModelResponse == null) {
                      return Center(
                        child: Text(
                          "Something went wrong",
                          style: context.textTheme.titleLarge,
                        ),
                      );
                    } else if (_controller.employeeList.isEmpty) {
                      return Center(
                        child: Text(
                          "No Employee Found",
                          style: context.textTheme.titleLarge,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: _controller.employeeList.length,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        padding: const EdgeInsets.only(left: 20,top: 10,bottom: 20, right: 0),
                        foregroundDecoration: controller.employeeList[index].status == 0 ? BoxDecoration(
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
                                Container(
                                  width: 50.w,
                                  height: 50.w,
                                  margin: const EdgeInsets.only(top: 10),
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
                                        controller.employeeList[index].photo
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
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.employeeList[index].name,
                                          style: context.textTheme.titleSmall
                                              ?.copyWith(
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        AutoSizeText(
                                          controller.employeeList[index].phone!,
                                          style: context.textTheme.bodyLarge
                                              ?.copyWith(
                                                  color: const Color(0xff7C7C7C),
                                                  fontSize: 12.sp),
                                        ),
                                        AutoSizeText(
                                          controller.employeeList[index].address??'--',
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
                                  status: controller.employeeList[index].status,
                                  onSelected: (value) {
                                    switch(value){
                                      case "edit":
                                        // showModalBottomSheet(
                                        //   context: context,
                                        //   isScrollControlled: true,
                                        //   shape: const RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                        //   ),
                                        //   builder: (context) {
                                        //     return CreateSupplierBottomSheet(supplier: controller.employeeList[index],);
                                        //   },
                                        // );
                                        break;
                                      case "change-status":
                                        AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.question,
                                            title: "Are you sure?",
                                            desc: "You are going to ${controller.employeeList[index].status==1?'Deactivate':'Activate'} your supplier ${controller.employeeList[index].name}",
                                            btnOkOnPress: (){
                                              controller.changeStatusOfSupplier(supplier: controller.employeeList[index]);
                                            },
                                            btnCancelOnPress: (){
                                            }
                                        ).show();
                                      case "delete":
                                        AwesomeDialog(
                                            context: context,
                                          dialogType: DialogType.error,
                                          title: "Are you sure?",
                                          desc: "You are going to delete your supplier ${controller.employeeList[index].name}",
                                          btnOkOnPress: (){
                                            controller.deleteEmployee(employee: controller.employeeList[index]);
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
        text: "Create User",
        marginHorizontal: 20,
        marginVertical: 10,
        onTap: () {
          Get.to(() => CreateUserScreen(), transition: Transition.zoom);
        },
      ),
    );
  }
}
