import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/methods/field_validator.dart';
import 'package:amar_pos/features/config/data/model/client/client_list_model_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/field_title.dart';
import 'client_controller.dart';

class CreateClientBottomSheet extends StatefulWidget {
  const CreateClientBottomSheet({super.key, this.client});

  final Client? client;

  @override
  State<CreateClientBottomSheet> createState() =>
      _CreateClientBottomSheetState();
}

class _CreateClientBottomSheetState extends State<CreateClientBottomSheet> {
  String? fileName;
  final ClientController _controller = Get.find();
  final formKey = GlobalKey<FormState>();

  late final TextEditingController outletName;
  late final TextEditingController openingBalance;
  late final TextEditingController outletPhone;
  late final TextEditingController outletAddress;

  bool additionalFieldVisible = false;

  @override
  void initState() {
    outletName = TextEditingController();
    openingBalance = TextEditingController();
    outletPhone = TextEditingController();
    outletAddress = TextEditingController();

    if (widget.client != null) {
      outletName.text = widget.client!.name;
      outletPhone.text = widget.client!.phone;
      outletAddress.text = widget.client!.address;
      openingBalance.text = widget.client!.openingBalance.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    outletName.dispose();
    openingBalance.dispose();
    outletPhone.dispose();
    outletAddress.dispose();
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
                widget.client != null ? "Update Client" : "Create New Client",
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
                                value, "client name"),
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
                                value, "Client address"),
                      ),
                      addH(20.h),
                      const FieldTitle(
                        "Opening Balance",
                      ),
                      addH(8.h),
                      CustomTextField(
                        textCon: openingBalance,
                        hintText: "Type opening balance here...",
                        enabledFlag: widget.client != null && (widget.client!.openingBalance > 0) ? false : null,
                        inputType: const TextInputType.numberWithOptions(signed: false,decimal: false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: widget.client != null ? "Update" : "Add Now",
                onTap: widget.client != null
                    ? () {
                        if (formKey.currentState!.validate()) {
                          _controller.editClient(
                            outlet: widget.client!,
                            name: outletName.text,
                            shortCode: openingBalance.text,
                            address: outletAddress.text,
                            phone: outletPhone.text,
                          );
                        }
                      }
                    : () {
                        if (formKey.currentState!.validate()) {
                          _controller.addNewClient(
                            name: outletName.text,
                            shortCode: openingBalance.text,
                            address: outletAddress.text,
                            phone: outletPhone.text,
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
