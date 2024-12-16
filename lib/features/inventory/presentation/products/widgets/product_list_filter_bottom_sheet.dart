import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/dashed_line.dart';
import 'package:amar_pos/core/widgets/divider_heading.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/config/data/model/supplier/supplier_list_response_model.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';

import '../../../../../core/widgets/search_widget.dart';

class ProductListFilterBottomSheet extends StatefulWidget {
  const ProductListFilterBottomSheet({super.key, this.supplier});

  final Supplier? supplier;

  @override
  State<ProductListFilterBottomSheet> createState() =>
      _ProductListFilterBottomSheetState();
}

class _ProductListFilterBottomSheetState
    extends State<ProductListFilterBottomSheet> {
  String? selectedBrand;
  String? selectedCategory;


  ProductController controller = Get.find();

  // Function to show secondary bottom sheet
  void _showSelectionSheet({
    required String title,
    required List<String> items,
    required List<String> selectedItems,
    required Function(List<String>) onSelectionDone,
  }) {
    GlobalKey key = GlobalKey();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return GetBuilder<ProductController>(
          id: 'filter_list',
          builder: (controller)=> StatefulBuilder(
            builder: (context, setSheetState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.arrow_back)),
                            Text(
                              "Select $title",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.close)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SearchWidget(
                          onChanged: (value) {
                            setState(() {
                              items = controller.filterItems(isBrand: title.toLowerCase() == "brand", search: value);
                              logger.i(items);
                            });
                            controller.update(['filter_list']);
                          },
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListView.separated(
                              key: key,
                              separatorBuilder: (context, index) {
                                return Divider(
                                  color: Color(0xffe0e0e0),
                                  height: 5,
                                );
                              },
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return CheckboxListTile(
                                  title: Text(item),
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  value: selectedItems.contains(item),
                                  onChanged: (bool? isSelected) {
                                    setSheetState(() {
                                      if (isSelected == true) {
                                        selectedItems.add(item);
                                      } else {
                                        selectedItems.remove(item);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        addH(10),
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: [
                              Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(Colors.grey)
                                    ),
                                      onPressed: () {
                                        setState(() {
                                          controller.deleteFilterItem(selectedItems);
                                          selectedItems.clear();
                                        });
                                      },
                                      child: Text("Clear Filter"))),
                              addW(10),
                              Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                                        backgroundColor: WidgetStatePropertyAll(AppColors.primary)),
                                      onPressed: () {
                                        onSelectionDone(selectedItems);
                                        Navigator.pop(context);
                                        setState(() {

                                        });
                                      }, child: Text("Apply",))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
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
                "Filter",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GetBuilder<ProductController>(
                  id: 'filter_count',
                  builder: (controller) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectorWidget(
                        title: "Brand",
                        selectedItems: controller.selectedBrands,
                        onTap: () {
                          _showSelectionSheet(
                            title: "Brand",
                            items: controller.brands,
                            selectedItems: controller.selectedBrands,
                            onSelectionDone: (selected) {
                              controller.selectedBrands = selected;
                              controller.addFilterItem(selected);
                            },
                          );
                        },
                      ),
                      const Divider(color: Color(0xffE0E0E0)),
                      SelectorWidget(
                        title: "Category",
                        selectedItems: controller.selectedCategories,
                        onTap: () {
                          _showSelectionSheet(
                            title: "Category",
                            items: controller.categories,
                            selectedItems: controller.selectedCategories,
                            onSelectionDone: (selected) {
                              controller.selectedCategories = selected;
                              controller.addFilterItem(selected);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
             GetBuilder<ProductController>(
                 id: 'filter_list',
                 builder: (controller){
                   if(controller.selectedFilterItems.isNotEmpty) {
                     return Column(
                       children: [
                         DashedLine(
                           color: Color(0xff7C7C7C),
                         ),
                         addH(8),
                         Wrap(
                           runSpacing: 4,
                           spacing: 4,
                           children: controller.selectedFilterItems.map((e) => Container(
                             // height: 32,
                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                             decoration: const BoxDecoration(
                               borderRadius: BorderRadius.all(Radius.circular(20)),
                               color: AppColors.primary,
                             ),
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                               Text(e, style: const TextStyle(color: Colors.white, fontSize: 12, ),),
                                 addW(8),
                                 InkWell(
                                     onTap: (){
                                       controller.deleteFilterItem([e]);
                                     },
                                     child: const Icon(Icons.close, color: Colors.white,size: 18,))
                             ],),
                           )).toList(),
                         )
                       ],
                     );
                   }
                   return SizedBox.shrink();
                 }),
              addH(12),
              CustomButton(
                text: "Apply Filters",
                onTap: () {

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
  const SelectorWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.selectedItems,
  });

  final String title;
  final void Function()? onTap;
  final List<String> selectedItems;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          FieldTitle(title),
          const Spacer(),
          Row(
            children: [
              Text(
                selectedItems.isEmpty
                    ? "Select"
                    : "${selectedItems.length} selected",
                style: const TextStyle(
                  color: Color(0xff7C7C7C),
                  fontSize: 14,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16,
                color: Color(0xff7C7C7C),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
