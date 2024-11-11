import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/features/category/data/model/category/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'category_controller.dart';

class CreateCategoryBottomSheet extends StatefulWidget {
  const CreateCategoryBottomSheet({super.key, this.category});
  final Category? category;

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
      _textEditingController.text = widget.category!.categoryName;
    }
    super.initState();
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
              const Text(
                "Create New Category",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  labelText: "Category Name",
                  labelStyle: const TextStyle(fontSize: 16),
                  hintText: "Type name here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: widget.category != null ? "Update" :"Add Now",
                onTap: widget.category != null ? (){
                  Get.back();
                  _categoryController.editCategory(category: widget.category! ,categoryName: _textEditingController.text,);
                } : (){
                  Get.back();
                  _categoryController.addNewCategory(categoryName: _textEditingController.text,);
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
