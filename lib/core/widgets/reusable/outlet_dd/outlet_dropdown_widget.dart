import 'package:amar_pos/core/widgets/reusable/outlet_dd/outlet_dd_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/model/outlet_model.dart';

class OutletDropDownWidget extends StatelessWidget {
  const OutletDropDownWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OutletDDController>(
      id: 'outlet_dd',
      builder: (controller) => CustomDropdownWithSearchWidget<OutletModel>(
        items: controller.outlets,
        isMandatory: false,
        title: "Outlet",
        noTitle: true,
        itemLabel: (value) {
          return value.name;
        },
        onChanged: (value) {

        },
        hintText: controller.outletListLoading ? "Loading...": controller.outlets.isEmpty ? "No outlets found..." : "Select Outlet",
        searchHintText: "Search an outlet",
      ),
    );
  }
}
