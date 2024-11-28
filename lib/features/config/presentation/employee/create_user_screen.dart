import 'dart:io';

import 'package:amar_pos/features/config/presentation/employee/employee_controller.dart';
import 'package:flutter/material.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/dotted_border_painter.dart';
import '../../../../core/widgets/field_title.dart';

class CreateUserScreen extends GetView<EmployeeController> {
  const CreateUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Employee"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      // Ensures content adjusts with the keyboard
      body: SingleChildScrollView(
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
                    const FieldTitle("Designation"),
                    addH(8.h),
                    CustomTextField(
                      textCon: TextEditingController(),
                      hintText: "Type designation here...",
                    ),
                    addH(20.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldTitle(
                          "Upload Photo",
                        ),
                        addH(8.h),
                        GetBuilder<EmployeeController>(
                          id: 'image_picked',
                          builder: (controller) => InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            onTap: controller.selectFile,
                            child: CustomPaint(
                              painter: DottedBorderPainter(
                                color: const Color(0xffD8E0EC),
                              ),
                              child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Center(
                                  child: controller.fileName == null
                                      ? const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.image_outlined,
                                                size: 40, color: Colors.grey),
                                            SizedBox(height: 8),
                                            Text(
                                              "Select brand logo",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: user != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                  child:
                                                      Image.network(user.logo))
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                  child: Image.file(
                                                    fit: BoxFit.cover,
                                                    File(controller.fileName!),
                                                  ),
                                                ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
