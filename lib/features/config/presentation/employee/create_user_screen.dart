import 'package:amar_pos/features/config/presentation/employee/employee_controller.dart';
import 'package:flutter/material.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/config/presentation/employee/permission_header.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/field_title.dart';

class CreateUserScreen extends GetView<EmployeeController> {
  const CreateUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Employee"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true, // Ensures content adjusts with the keyboard
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldTitle("Name"),
                            addH(8.h),
                            CustomTextField(
                              textCon: TextEditingController(),
                              hintText: "Type name here...",
                            ),
                            addH(16.h),
                            const FieldTitle("Phone No."),
                            addH(8.h),
                            CustomTextField(
                              textCon: TextEditingController(),
                              hintText: "Type number here...",
                              inputType: TextInputType.phone,
                            ),
                            addH(16.h),
                            const FieldTitle("Address"),
                            addH(8.h),
                            CustomTextField(
                              textCon: TextEditingController(),
                              hintText: "Type address here...",
                            ),
                            addH(16.h),
                            const FieldTitle("Opening Balance"),
                            addH(8.h),
                          ],
                        ),
                      ),
                      const PermissionsHeader(),
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldTitle("Name"),
                            addH(8.h),
                            CustomTextField(
                              textCon: TextEditingController(),
                              hintText: "Type name here...",
                            ),
                            addH(16.h),
                            const FieldTitle("Phone No."),
                            addH(8.h),
                            CustomTextField(
                              textCon: TextEditingController(),
                              hintText: "Type number here...",
                              inputType: TextInputType.phone,
                            ),
                            addH(16.h),
                            const FieldTitle("Address"),
                            addH(8.h),
                            CustomTextField(
                              textCon: TextEditingController(),
                              hintText: "Type address here...",
                            ),
                            addH(16.h),
                            const FieldTitle("Opening Balance"),
                            SizedBox(
                              height: 100,
                              child: ListView(
                                shrinkWrap: true,
                                children: controller.loginData!.permissions.where((e) => e.toLowerCase().contains("user")).map((t) => Text(t)).toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomButton(
        text: "Add Now",
        marginHorizontal: 20,
        marginVertical: 10,
        onTap: () {
          // Add logic here
        },
      ),
    );
  }
}
