import 'dart:io';

import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/dotted_border_painter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/brand/brand_model_response.dart';
import 'brand_controller.dart';

class CreateBrandBottomSheet extends StatefulWidget {
  const CreateBrandBottomSheet({super.key, this.brand});
  final Brand? brand;

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
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  labelText: "Brand Name",
                  labelStyle: TextStyle(fontSize: 16),
                  hintText: "Type name here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Upload Photo",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
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
                                child: widget.brand != null ? Image.network(widget.brand!.logo): Image.file(
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
              const SizedBox(height: 20),
              CustomButton(
                text: widget.brand != null ? "Update" :"Add Now",
                onTap: widget.brand != null ? (){
                  Get.back();
                  _brandController.editBrand(brand: widget.brand! ,brandName: _textEditingController.text, brandLogo: fileName??"");
                } : (){
                  Get.back();
                  _brandController.addNewBrand(brandName: _textEditingController.text, brandLogo: fileName??"");
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
