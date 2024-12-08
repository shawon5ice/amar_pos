import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/config/presentation/category/category_controller.dart';
import 'package:amar_pos/features/config/presentation/category/create_category_bottom_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/search_widget.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController _categoryController = Get.put(CategoryController());

  @override
  void initState() {
    _categoryController.getAllCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
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
                    _categoryController.searchCategory(search: value);
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
                          id: "category_list",
                          builder: (controller) {
                            if (_categoryController.categoryListLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }else if(_categoryController.categoryModelResponse == null){
                              return Center(
                                child: Text(
                                  "Something went wrong",
                                  style: context.textTheme.titleLarge,
                                ),
                              );
                            }else if (_categoryController.categoryList.isEmpty) {
                              return Center(
                                child: Text(
                                  "No Category Found",
                                  style: context.textTheme.titleLarge,
                                ),
                              );
                            }
                            return ListView.separated(
                              itemCount: _categoryController.categoryList.length,
                              separatorBuilder: (context, index) {
                                if (index == _categoryController.categoryList.length - 1) {
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
                                  controller.categoryList[index].name,
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
                                              _categoryController.categoryList[index],
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
                                            _categoryController.categoryList[index]);
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
          text: "Add New Category",
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
      ),
    );
  }
}