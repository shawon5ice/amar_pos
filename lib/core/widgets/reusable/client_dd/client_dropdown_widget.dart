import 'package:amar_pos/core/widgets/reusable/client_dd/client_dd_controller.dart';
import 'package:amar_pos/core/widgets/reusable/client_dd/client_list_dd_response_model.dart';
import 'package:amar_pos/core/widgets/reusable/outlet_dd/outlet_dd_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/model/outlet_model.dart';
import '../../methods/field_validator.dart';

class ClientDropDownWidget extends StatefulWidget {
  const ClientDropDownWidget({
    super.key,
    required this.onClientSelection,
    this.initialClientInfo,
    this.isMandatory,
  });

  final Function(ClientInfo? client) onClientSelection;
  final ClientInfo? initialClientInfo;
  final bool? isMandatory;

  @override
  State<ClientDropDownWidget> createState() => _ClientDropDownWidgetState();
}

class _ClientDropDownWidgetState extends State<ClientDropDownWidget> {
  final ClientDDController controller = Get.find();

  @override
  void didUpdateWidget(covariant ClientDropDownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialClientInfo == null) {
     controller.resetClientSelection();
    }
  }

  @override
  void dispose() {
    Get.delete<ClientDDController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientDDController>(
      id: 'client_dd',
      builder: (controller) {
        return CustomDropdownWithSearchWidget<ClientInfo>(
          items: controller.clients,
          isMandatory: false,
          title: "Client",
          noTitle: true,
          itemLabel: (value) => value.name,
          value: controller.selectedClient,
          onChanged: (value) {
            controller.selectedClient = value;
            controller.update(['client_dd']); // Notify UI of the change
            widget.onClientSelection(value);
          },
          hintText: controller.clientListLoading
              ? "Loading..."
              : controller.clients.isEmpty
              ? "No client found..."
              : "Select Client",
          searchHintText: "Search a client",
          validator: widget.isMandatory != null ?  (value) =>
              FieldValidator.nonNullableFieldValidator(
                  value?.name, "Client") : null,
        );
      },
    );
  }
}


