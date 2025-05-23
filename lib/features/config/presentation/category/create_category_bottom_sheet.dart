import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';
import 'category_controller.dart';

class CreateCategoryBottomSheet extends StatefulWidget {
  const CreateCategoryBottomSheet({super.key, this.category, this.onTap});
  final Category? category;
  final Function(String)? onTap;

  @override
  State<CreateCategoryBottomSheet> createState() => _CreateCategoryBottomSheetState();
}

class _CreateCategoryBottomSheetState extends State<CreateCategoryBottomSheet> {
  final CategoryController _categoryController = Get.find();
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    if(widget.category != null){
      _textEditingController.text = widget.category!.name;
    }
    super.initState();
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
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  widget.category != null ? "Update Category": "Create New Category",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding:const  EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const FieldTitle("Category Name",),
                    addH(8),
                    CustomTextField(
                      textCon: _textEditingController,
                      hintText: "Type name here...",
                      maxLength: 50,
                      validator: (value) =>
                          FieldValidator.nonNullableFieldValidator(
                              value, "category name"),
                    ),
                  ],),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: widget.category != null ? "Update" :"Add Now",
                  onTap: widget.onTap != null ? () {
                    if(formKey.currentState!.validate()){
                      Get.back();
                      widget.onTap!(_textEditingController.text);
                    }
                  } : widget.category != null ? (){
                    if(formKey.currentState!.validate()){
                      Get.back();
                      _categoryController.editCategory(category: widget.category! ,categoryName: _textEditingController.text,);
                    }
                  } : (){
                    if(formKey.currentState!.validate()){
                      Get.back();
                      _categoryController.addNewCategory(categoryName: _textEditingController.text,);
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
