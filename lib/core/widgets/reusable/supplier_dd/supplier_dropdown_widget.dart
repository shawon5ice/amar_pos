import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/model/reusable/supplier_list_response_model.dart';
import '../../methods/field_validator.dart';
import 'supplier_dd_controller.dart';

class SupplierDropDownWidget extends StatefulWidget {
  const SupplierDropDownWidget({
    super.key,
    required this.onSupplierSelection,
    this.initialSupplierInfo,
    this.initialSupplierId,
    this.isMandatory,
  });

  final Function(SupplierInfo? client) onSupplierSelection;
  final SupplierInfo? initialSupplierInfo;
  final int? initialSupplierId;
  final bool? isMandatory;

  @override
  State<SupplierDropDownWidget> createState() => _SupplierDropDownWidgetState();
}

class _SupplierDropDownWidgetState extends State<SupplierDropDownWidget> {
  final SupplierDDController controller = Get.find();

  @override
  void didUpdateWidget(covariant SupplierDropDownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialSupplierInfo == null) {
     controller.resetSupplierSelection();
    }
  }

  @override
  void initState() {
    controller.getAllSuppliers().then((value){
      if(widget.initialSupplierId != null){
        controller.resetSupplierSelection();
        controller.selectedSupplier = controller.suppliers.singleWhere((e) => e.id == widget.initialSupplierId);
        // controller.selectedClient = widget.initialSupplierInfo;
      }
      controller.update(['supplier_dd']);
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<SupplierDDController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupplierDDController>(
      id: 'supplier_dd',
      builder: (controller) {
        return CustomDropdownWithSearchWidget<SupplierInfo>(
          items: controller.suppliers,
          isMandatory: true,
          title: "Supplier",
          // noTitle: true,
          itemLabel: (value) => value.name,
          value: controller.selectedSupplier,
          onChanged: (value) {
            controller.selectedSupplier = value;
            controller.update(['supplier_dd']); // Notify UI of the change
            widget.onSupplierSelection(value);
          },
          hintText: controller.clientListLoading
              ? "Loading..."
              : controller.suppliers.isEmpty
              ? "No Supplier Found..."
              : "Select Supplier",
          searchHintText: "Search a supplier",
          validator: widget.isMandatory != null ?  (value) =>
              FieldValidator.nonNullableFieldValidator(
                  value?.name, "Supplier") : null,
        );
      },
    );
  }
}


