import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/features/category/data/model/unit/unit_model.dart';
import 'package:amar_pos/features/category/presentation/unit/unit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUnitBottomSheet extends StatefulWidget {
  const CreateUnitBottomSheet({super.key, this.unit});
  final Unit? unit;

  @override
  State<CreateUnitBottomSheet> createState() => _CreateUnitBottomSheetState();
}

class _CreateUnitBottomSheetState extends State<CreateUnitBottomSheet> {
  final UnitController _unitController = Get.find();
  late TextEditingController _shortFormEditingController;
  late TextEditingController _longFormEditingController;

  @override
  void initState() {
    _shortFormEditingController = TextEditingController();
    _longFormEditingController = TextEditingController();
    if(widget.unit != null){
      _shortFormEditingController.text = widget.unit!.shortForm??"";
      _longFormEditingController.text = widget.unit!.longForm??"";
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
                controller: _shortFormEditingController,
                decoration: InputDecoration(
                  labelText: "Short Form",
                  labelStyle: const TextStyle(fontSize: 16),
                  hintText: "Type short form of the unit(Mandatory)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _longFormEditingController,
                decoration: InputDecoration(
                  labelText: "Long Form",
                  labelStyle: const TextStyle(fontSize: 16),
                  hintText: "Type long form of the unit(Optional)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: widget.unit != null ? "Update" :"Add Now",
                onTap: widget.unit != null ? (){
                  Get.back();
                  _unitController.editUnit(unit: widget.unit! ,shortForm: _shortFormEditingController.text, longForm: _longFormEditingController.text);
                } : (){
                  Get.back();
                  _unitController.addNewUnit(shortForm: _shortFormEditingController.text,longForm: _longFormEditingController.text);
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
