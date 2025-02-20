import 'package:amar_pos/core/widgets/reusable/client_dd/client_dd_controller.dart';
import 'package:amar_pos/core/widgets/reusable/client_dd/client_list_dd_response_model.dart';
import 'package:amar_pos/core/widgets/reusable/outlet_dd/outlet_dd_controller.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/ca_payment_method_dd_controller.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/model/outlet_model.dart';
import '../../methods/field_validator.dart';

class CAPaymentMethodsDropDownWidget extends StatefulWidget {
  const CAPaymentMethodsDropDownWidget({
    super.key,
    required this.onCAPaymentMethodSelection,
    this.initialCAPaymentMethod,
    this.isMandatory,
    this.noTitle,
    this.title,
    this.notFound,
    this.hint,
    this.searchHint,
    this.lastLevelAccount,
    this.height,
  });

  final Function(ChartOfAccountPaymentMethod? caPaymentMethod) onCAPaymentMethodSelection;
  final ChartOfAccountPaymentMethod? initialCAPaymentMethod;
  final bool? isMandatory;
  final bool? noTitle;
  final String? title;
  final String? notFound;
  final String? hint;
  final String? searchHint;
  final bool? lastLevelAccount;
  final int? height;


  @override
  State<CAPaymentMethodsDropDownWidget> createState() => _CAPaymentMethodsDropDownWidgetState();
}

class _CAPaymentMethodsDropDownWidgetState extends State<CAPaymentMethodsDropDownWidget> {
  final CAPaymentMethodDDController controller = Get.find();

  @override
  void initState() {
    controller.getAllPaymentMethods(widget.lastLevelAccount).then((value){
      if(widget.initialCAPaymentMethod != null){
        controller.resetPaymentSelection();
        controller.selectedCAPaymentMethod = controller.paymentList.singleWhere((e) => e.id == widget.initialCAPaymentMethod?.id);
        // controller.selectedClient = widget.initialClientInfo;
      }
      controller.update(['ca_payment_dd']);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CAPaymentMethodsDropDownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialCAPaymentMethod == null) {
     controller.resetPaymentSelection();
    }
  }

  @override
  void dispose() {
    Get.delete<CAPaymentMethodDDController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CAPaymentMethodDDController>(
      id: 'ca_payment_dd',
      builder: (controller) {
        return CustomDropdownWithSearchWidget<ChartOfAccountPaymentMethod>(
          buttonHeight: widget.height ?? 56,
          items: controller.paymentList,
          isMandatory: true,
          noTitle: widget.noTitle != null,
          title: widget.title ?? "Payment Method",
          // noTitle: true,
          itemLabel: (value) => value.name,
          value: controller.selectedCAPaymentMethod,
          onChanged: (value) {
            controller.selectedCAPaymentMethod = value;
            controller.update(['ca_payment_dd']); // Notify UI of the change
            widget.onCAPaymentMethodSelection(value);
          },
          hintText: controller.paymentListLoading
              ? "Loading..."
              : controller.paymentList.isEmpty
              ? widget.notFound ?? "No payment method found..."
              : widget.hint ?? "Select Payment Method",
          searchHintText: widget.searchHint ?? "Search a payment method",
          validator: widget.isMandatory != null ?  (value) =>
              FieldValidator.nonNullableFieldValidator(
                  value?.name, widget.title ?? "Payment Method") : null,
        );
      },
    );
  }
}


