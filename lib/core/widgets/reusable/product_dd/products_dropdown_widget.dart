import 'package:amar_pos/core/data/model/product_model.dart';
import 'package:amar_pos/core/widgets/reusable/product_dd/products_dd_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../methods/field_validator.dart';

class ProductDropDownWidget extends StatefulWidget {
  const ProductDropDownWidget({
    super.key,
    this.initialProductModel,
    required this.onProductSelection,
    this.isMandatory,
  });

  final Function(ProductModel? product) onProductSelection;
  final ProductModel? initialProductModel;
  final bool? isMandatory;

  @override
  State<ProductDropDownWidget> createState() => _ProductDropDownWidgetState();
}

class _ProductDropDownWidgetState extends State<ProductDropDownWidget> {
  final ProductsDDController controller = Get.find();

  @override
  void didUpdateWidget(covariant ProductDropDownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the initialProductModel is null, reset the selection
    if (widget.initialProductModel == null) {
      controller.resetProductSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsDDController>(
      id: 'product_dd',
      builder: (controller) => CustomDropdownWithSearchWidget<ProductModel>(
        items: controller.products,
        isMandatory: true,
        title: "Product",
        noTitle: true,
        itemLabel: (value) => value.name,
        value: controller.selectedProduct,
        onChanged: (value) {
          controller.selectedProduct = value;
          controller.update(['product_dd']); // Notify UI of the change
          widget.onProductSelection(value);
        },
        hintText: controller.productsListLoading
            ? "Loading..."
            : controller.products.isEmpty
            ? "No products found..."
            : "Select product",
        searchHintText: "Search a product",
        validator: widget.isMandatory != null ?  (value) =>
            FieldValidator.nonNullableFieldValidator(
                value?.name, "Product") : null,
      ),
    );
  }
}
