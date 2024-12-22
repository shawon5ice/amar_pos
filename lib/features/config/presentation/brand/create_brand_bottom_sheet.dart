import 'dart:io';

import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/dotted_border_painter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/core.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/field_title.dart';
import '../../data/model/brand/brand_model_response.dart';
import 'brand_controller.dart';

class CreateBrandBottomSheet extends StatefulWidget {
  const CreateBrandBottomSheet({super.key, this.brand});
  final BrandDetails? brand;

  @override
  State<CreateBrandBottomSheet> createState() => _CreateBrandBottomSheetState();
}

class _CreateBrandBottomSheetState extends State<CreateBrandBottomSheet> {
  String? fileName;
  final BrandController _brandController = Get.find();
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    if(widget.brand != null){
      _textEditingController.text = widget.brand!.name;
      fileName = widget.brand!.logo;
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
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 40,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  "Create New Brand",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
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
                        "Brand Name",
                      ),
                      addH(8.h),
                      CustomTextField(
                        textCon: _textEditingController,
                        hintText: "Type name here...",
                        maxLength: 50,
                        validator: (value) =>
                            FieldValidator.nonNullableFieldValidator(
                                value, "brand name"),
                      ),
                      addH(20.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image_outlined,
                                          size: 40, color: Colors.grey),
                                      SizedBox(height: 8),
                                      Text(
                                        "Select employee picture",
                                        style:
                                        TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  )
                                      : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: fileName!.contains('https://') && widget.brand!=null
                                        ? Image.network(
                                        widget.brand!.logo)
                                        : Image.file(
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: widget.brand != null ? "Update" :"Add Now",
                  onTap: widget.brand != null ? (){
                    if(formKey.currentState!.validate()){
                      _brandController.editBrand(brand: widget.brand! ,brandName: _textEditingController.text, brandLogo: fileName);
                    }
                  } : (){
                    if(formKey.currentState!.validate()){
                      _brandController.addNewBrand(brandName: _textEditingController.text, brandLogo: fileName);
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
