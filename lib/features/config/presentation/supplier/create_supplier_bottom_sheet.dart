import 'dart:io';

import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/config/data/model/supplier/supplier_list_response_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/dotted_border_painter.dart';
import '../../../../core/widgets/methods/field_validator.dart';
import '../../../../core/widgets/methods/helper_methods.dart';
import '../../../../core/widgets/reusable/upload_photo_widget.dart';
import '../../data/model/category/category_model_response.dart';
import 'supplier_controller.dart';

class CreateSupplierBottomSheet extends StatefulWidget {
  const CreateSupplierBottomSheet({super.key, this.supplier});
  final Supplier? supplier;

  @override
  State<CreateSupplierBottomSheet> createState() => _CreateSupplierBottomSheetState();
}

class _CreateSupplierBottomSheetState extends State<CreateSupplierBottomSheet> {
  final SupplierController _controller = Get.find();
  late TextEditingController _nameTextEditingController;
  late TextEditingController _phoneNoTextEditingController;
  late TextEditingController _addressTextEditingController;
  late TextEditingController _openingBalanceTextEditingController;
  String? fileName;

  @override
  void initState() {
    _nameTextEditingController = TextEditingController();
    _phoneNoTextEditingController = TextEditingController();
    _addressTextEditingController = TextEditingController();
    _openingBalanceTextEditingController = TextEditingController();

    if(widget.supplier != null){
      _nameTextEditingController.text = widget.supplier!.name;
      _phoneNoTextEditingController.text = widget.supplier!.phone ?? '';
      _addressTextEditingController.text = widget.supplier!.address ?? '';
      _openingBalanceTextEditingController.text = widget.supplier!.openingBalance.toString();
      fileName = widget.supplier?.photo;
    }
    super.initState();
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,

    );
    if (result != null) {
      setState(() {
        fileName = result.files.single.path;
      });
    }
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom, // Adjusts for keyboard
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4.h,
                width: 40.w,
                margin: EdgeInsets.only(bottom: 20.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                widget.supplier != null ?"Update Supplier" : "Create New Supplier",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              addH(20.h),
              Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.sp))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldTitle(
                        "Name",
                      ),
                      addH(8.h),
                      CustomTextField(
                        textCon: _nameTextEditingController,
                        hintText: "Type name here...",
                        maxLength: 50,
                        validator: (value) =>
                            FieldValidator.nonNullableFieldValidator(
                                value, "supplier name"),
                      ),
                      addH(16.h),
                      const FieldTitle(
                        "Phone No.",
                      ),
                      addH(8.h),
                      CustomTextField(
                        textCon: _phoneNoTextEditingController,
                        hintText: "Type number here...",
                        inputType: TextInputType.phone,
                        validator: (value) =>
                            FieldValidator.phoneNumberFieldValidator(
                                value, "Supplier phone number", false),
                      ),
                      addH(16.h),
                      const FieldTitle(
                        "Address",
                      ),
                      addH(8.h),
                      CustomTextField(
                        textCon: _addressTextEditingController,
                        hintText: "Type address here...",
                        maxLength: 250,
                      ),
                      addH(16.h),
                      const FieldTitle(
                        "Opening Balance",
                      ),
                      addH(8.h),
                      CustomTextField(
                        textCon: _openingBalanceTextEditingController,
                        hintText: "Enter opening balance here...",
                        enabledFlag: widget.supplier != null && (widget.supplier!.openingBalance! > 0) ? false : true,
                        inputType: const TextInputType.numberWithOptions(signed: false,decimal: false),
                      ),
                      addH(16.h),
                      UploadPhotoWidget(
                        title: "Supplier logo",
                        getFileName: (fn){
                          fileName = fn;
                        },
                        initialPhoto: widget.supplier?.photo,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: widget.supplier != null ? "Update" :"Add Now",
                onTap: () async{
                  if(formKey.currentState!.validate()){
                    if(widget.supplier != null){
                      _controller.editSupplier(
                          supplier: widget.supplier!,
                          name: _nameTextEditingController.text,
                          phoneNo: _phoneNoTextEditingController.text,
                          balance: _openingBalanceTextEditingController.text,
                          address: _addressTextEditingController.text,
                          supplierLogo: fileName??''
                      );
                    }else{
                      _controller.addNewSupplier(
                          name: _nameTextEditingController.text,
                          phoneNo: _phoneNoTextEditingController.text,
                          balance: _openingBalanceTextEditingController.text,
                          address: _addressTextEditingController.text,
                          supplierLogo: fileName
                      );
                    }
                  }
                }
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}