import 'package:amar_pos/core/widgets/reusable/outlet_dd/outlet_dd_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/model/outlet_model.dart';
import '../../methods/field_validator.dart';

class OutletDropDownWidget extends StatefulWidget {
  const OutletDropDownWidget({
    super.key,
    required this.onOutletSelection,
    this.initialOutletModel,
    this.isMandatory,
  });

  final Function(OutletModel? outlet) onOutletSelection;
  final OutletModel? initialOutletModel;
  final bool? isMandatory;

  @override
  State<OutletDropDownWidget> createState() => _OutletDropDownWidgetState();
}

class _OutletDropDownWidgetState extends State<OutletDropDownWidget> {
  final OutletDDController controller = Get.find();

  @override
  void didUpdateWidget(covariant OutletDropDownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialOutletModel == null) {
     controller.resetOutletSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OutletDDController>(
      id: 'outlet_dd',
      builder: (controller) {
        return CustomDropdownWithSearchWidget<OutletModel>(
          items: controller.outlets,
          isMandatory: false,
          title: "Outlet",
          noTitle: true,
          itemLabel: (value) => value.name,
          value: controller.selectedOutlet,
          onChanged: (value) {
            controller.selectedOutlet = value;
            controller.update(['outlet_dd']); // Notify UI of the change
            widget.onOutletSelection(value);
          },
          hintText: controller.outletListLoading
              ? "Loading..."
              : controller.outlets.isEmpty
              ? "No outlets found..."
              : "Select Outlet",
          searchHintText: "Search an outlet",
          validator: widget.isMandatory != null ?  (value) =>
              FieldValidator.nonNullableFieldValidator(
                  value?.name, "Outlet") : null,
        );
      },
    );
  }
}

