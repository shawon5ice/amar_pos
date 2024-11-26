import 'package:amar_pos/core/widgets/animated_expandable_widget.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/methods/field_validator.dart';
import 'package:amar_pos/features/config/data/model/outlet/outlet_list_model_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/field_title.dart';
import 'outlet_controller.dart';

class CreateOutletBottomSheet extends StatefulWidget {
  const CreateOutletBottomSheet({super.key, this.outlet});

  final Outlet? outlet;

  @override
  State<CreateOutletBottomSheet> createState() =>
      _CreateOutletBottomSheetState();
}

class _CreateOutletBottomSheetState extends State<CreateOutletBottomSheet> {
  String? fileName;
  final OutletController _controller = Get.find();
  final formKey = GlobalKey<FormState>();

  late final TextEditingController outletName;
  late final TextEditingController outletShortCode;
  late final TextEditingController outletPhone;
  late final TextEditingController outletAddress;
  late final TextEditingController outletNagad;
  late final TextEditingController outletBkash;

  bool additionalFieldVisible = false;

  @override
  void initState() {
    outletName = TextEditingController();
    outletShortCode = TextEditingController();
    outletPhone = TextEditingController();
    outletAddress = TextEditingController();
    outletNagad = TextEditingController();
    outletBkash = TextEditingController();

    if (widget.outlet != null) {
      outletName.text = widget.outlet!.name;
      outletShortCode.text = widget.outlet!.code;
      outletPhone.text = widget.outlet!.phone;
      outletAddress.text = widget.outlet!.address;
      outletBkash.text = widget.outlet!.bkash;
      outletNagad.text = widget.outlet!.nagad;
      if (widget.outlet!.bkash.isNotEmpty || widget.outlet!.nagad.isNotEmpty) {
        setState(() {
          additionalFieldVisible = true;
        });
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    outletName.dispose();
    outletShortCode.dispose();
    outletPhone.dispose();
    outletAddress.dispose();
    outletNagad.dispose();
    outletBkash.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom, // Adjusts for keyboard
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                widget.outlet != null ? "Update Outlet" : "Create New Outlet",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.sp))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldTitle(
                        "Outlet Name",
                      ),
                      addH(8.h),
                      CustomTextField(
                        textCon: outletName,
                        hintText: "Type name here...",
                        validator: (value) =>
                            FieldValidator.nonNullableFieldValidator(
                                value, "Outlet name"),
                      ),
                      addH(20.h),
                      const FieldTitle(
                        "Outlet Short Code",
                      ),
                      addH(8.h),
                      CustomTextField(
                        textCon: outletShortCode,
                        hintText: "Type short code here...",
                        validator: (value) =>
                            FieldValidator.nonNullableFieldValidator(
                                value, "Outlet short code"),
                      ),
                      addH(20.h),
                      const FieldTitle(
                        "Phone",
                      ),
                      addH(8.h),
                      CustomTextField(
                        textCon: outletPhone,
                        inputType: TextInputType.phone,
                        hintText: "Type phone number here...",
                        validator: (value) =>
                            FieldValidator.phoneNumberFieldValidator(
                                value, "Outlet phone number", false),
                      ),
                      addH(20.h),
                      const FieldTitle(
                        "Address",
                      ),
                      addH(8.h),
                      CustomTextField(
                        textCon: outletAddress,
                        hintText: "Type address here...",
                        validator: (value) =>
                            FieldValidator.nonNullableFieldValidator(
                                value, "Outlet address"),
                      ),
                      addH(20.h),
                      AnimatedExpandableWidget(
                        isExpanded: additionalFieldVisible,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            addH(20.h),
                            const FieldTitle("Bkash Number"),
                            addH(8.h),
                            CustomTextField(
                              textCon: outletBkash,
                              hintText: "Type bkash number here...",
                              inputType: TextInputType.phone,
                              validator: (value) =>
                                  FieldValidator.phoneNumberFieldValidator(
                                      value, "Bkash", true),
                            ),
                            addH(20.h),
                            const FieldTitle("Nagad Number"),
                            addH(8.h),
                            CustomTextField(
                              textCon: outletNagad,
                              inputType: TextInputType.phone,
                              hintText: "Type nagad number here...",
                              validator: (value) =>
                                  FieldValidator.phoneNumberFieldValidator(
                                      value, "Nagad", true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: widget.outlet != null ? "Update" : "Add Now",
                onTap: widget.outlet != null
                    ? () {
                        if (formKey.currentState!.validate()) {
                          _controller.editOutlet(
                            outlet: widget.outlet!,
                            name: outletName.text,
                            shortCode: outletShortCode.text,
                            address: outletAddress.text,
                            phone: outletPhone.text,
                            bkash: outletBkash.text,
                            nagad: outletNagad.text,
                          );
                        }
                      }
                    : () {
                        if (formKey.currentState!.validate()) {
                          _controller.addNewOutlet(
                            name: outletName.text,
                            shortCode: outletShortCode.text,
                            address: outletAddress.text,
                            phone: outletPhone.text,
                            bkash: outletBkash.text,
                            nagad: outletNagad.text,
                          );
                        }
                      },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
