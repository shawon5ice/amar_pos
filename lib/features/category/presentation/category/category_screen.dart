import 'dart:io';

import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/category/presentation/category/category_controller.dart';
import 'package:amar_pos/features/category/presentation/category/create_category_bottom_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/search_widget.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  final CategoryController _categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              SearchWidget(
                onChanged: (value){

                },
              ),
              addH(16.px),
              Expanded(
                child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: GetBuilder<CategoryController>(
                        id: "new_category_list",
                        builder: (controller) {
                          if (_categoryController.categories.isEmpty) {
                            return Center(
                              child: Text(
                                "No Category Added",
                                style: context.textTheme.titleLarge,
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: _categoryController.categories.length,
                            separatorBuilder: (context, index) {
                              if (index == _categoryController.categories.length - 1) {
                                return const SizedBox.shrink();
                              } else {
                                return const Divider(
                                  color: Colors.grey,
                                );
                              }
                            },
                            itemBuilder: (context, index) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                controller.categories[index].categoryName,
                                style: context.textTheme.titleSmall?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.px,
                                    height: (22 / 16).px),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        builder: (context) {
                                          return CreateCategoryBottomSheet(
                                            category:
                                            _categoryController.categories[index],
                                          );
                                        },
                                      );
                                    },
                                    child: SvgPicture.asset(AppAssets.editIcon),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _categoryController.deleteCategory(
                                          category:
                                          _categoryController.categories[index]);
                                    },
                                    child:
                                    SvgPicture.asset(AppAssets.deleteIcon),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomButton(
        text: "Add New Brand",
        marginHorizontal: 20,
        marginVertical: 10,
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return const CreateCategoryBottomSheet();
            },
          );
        },
      ),
    );
  }
}