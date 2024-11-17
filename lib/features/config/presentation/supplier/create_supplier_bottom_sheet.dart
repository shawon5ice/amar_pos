import 'dart:io';

import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/config/data/model/supplier/supplier_list_response_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/dotted_border_painter.dart';
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
    }
    super.initState();
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        fileName = result.files.single.path;
      });
    }
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
                "Create New Supplier",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              addH(20.h),
              Container(
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
                    ),
                    addH(16.h),
                    const FieldTitle(
                      "Address",
                    ),
                    addH(8.h),
                    CustomTextField(
                      textCon: _addressTextEditingController,
                      hintText: "Type address here...",
                    ),
                    addH(16.h),
                    const FieldTitle(
                      "Opening Balance",
                    ),
                    addH(8.h),
                    CustomTextField(
                      textCon: _openingBalanceTextEditingController,
                      hintText: "Enter opening balance here...",
                      inputType: TextInputType.numberWithOptions(signed: false,decimal: false),
                    ),
                    addH(16.h),
                    const FieldTitle(
                      "Upload Photo",
                    ),
                    addH(8.h),
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      onTap: selectFile,
                      child: CustomPaint(
                        painter: DottedBorderPainter(
                          color: const Color(0xffD8E0EC),
                        ),
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Center(
                            child: fileName == null
                                ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_outlined,
                                    size: 40, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  "Select brand logo",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            )
                                : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: widget.supplier != null && widget.supplier!.photo != null ? Image.network(widget.supplier!.photo!): Image.file(
                                fit: BoxFit.cover,
                                File(fileName!),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: widget.supplier != null ? "Update" :"Add Now",
                onTap: widget.supplier != null ? (){
                  Get.back();
                  _controller.editSupplier(
                    supplier: widget.supplier!,
                    name: _nameTextEditingController.text,
                    phoneNo: _phoneNoTextEditingController.text,
                    balance: _openingBalanceTextEditingController.text,
                    address: _addressTextEditingController.text,
                    supplierLogo: fileName
                  );
                } : (){
                  Get.back();
                  _controller.addNewSupplier(
                    name: _nameTextEditingController.text,
                      phoneNo: _phoneNoTextEditingController.text,
                      balance: _openingBalanceTextEditingController.text.isNotEmpty && _openingBalanceTextEditingController.text.toString().isNum ? num.parse(_openingBalanceTextEditingController.text) : 0,
                      address: _addressTextEditingController.text,
                      supplierLogo: fileName!
                  );
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
