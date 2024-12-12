import 'dart:io';

import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/config/data/model/supplier/supplier_list_response_model.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListFilterBottomSheet extends StatefulWidget {
  const ProductListFilterBottomSheet({super.key, this.supplier});
  final Supplier? supplier;

  @override
  State<ProductListFilterBottomSheet> createState() => _ProductListFilterBottomSheetState();
}

class _ProductListFilterBottomSheetState extends State<ProductListFilterBottomSheet> {
  final ProductController _controller = Get.find();
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
                "Filter",
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
                    SelectorWidget(title: "Brand", onTap: (){}),
                    Divider(color: Color(0xffE0E0E0),),
                    SelectorWidget(title: "Category", onTap: (){})
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: widget.supplier != null ? "Update" :"Add Now",
                onTap: widget.supplier != null ? (){
                  // _controller.editSupplier(
                  //     supplier: widget.supplier!,
                  //     name: _nameTextEditingController.text,
                  //     phoneNo: _phoneNoTextEditingController.text,
                  //     balance: _openingBalanceTextEditingController.text,
                  //     address: _addressTextEditingController.text,
                  //     supplierLogo: fileName??''
                  // );
                } : (){
                  // _controller.addNewSupplier(
                  //     name: _nameTextEditingController.text,
                  //     phoneNo: _phoneNoTextEditingController.text,
                  //     balance: _openingBalanceTextEditingController.text,
                  //     address: _addressTextEditingController.text,
                  //     supplierLogo: fileName
                  // );
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


class SelectorWidget extends StatelessWidget {
  const SelectorWidget({super.key, required this.title, required this.onTap});

  final String title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
    onTap: onTap,
      child: Row(
        children: [
          FieldTitle(
            title,
          ),
          const Spacer(),
          const Row(
            children: [
              Text("Select", style: TextStyle(color: Color(0xff7C7C7C), fontSize: 14),),
              Icon(Icons.arrow_forward_ios_outlined, size: 16, color: Color(0xff7C7C7C),),
            ],
          )
        ],
      ),
    );
  }
}
