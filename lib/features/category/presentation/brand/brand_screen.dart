import 'dart:io';

import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/category/presentation/brand/brand_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/search_widget.dart';
import 'create_brand_bottom_sheet.dart';

class BrandScreen extends StatelessWidget {
  BrandScreen({super.key});

  final BrandController _brandController = Get.put(BrandController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Brands"),
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
                    child: GetBuilder<BrandController>(
                        id: "new_brand_list",
                        builder: (controller) {
                          if (_brandController.brands.isEmpty) {
                            return Center(
                              child: Text(
                                "No Brand Added",
                                style: context.textTheme.titleLarge,
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: _brandController.brands.length,
                            separatorBuilder: (context, index) {
                              if (index == _brandController.brands.length - 1) {
                                return const SizedBox.shrink();
                              } else {
                                return const Divider(
                                  color: Colors.grey,
                                );
                              }
                            },
                            itemBuilder: (context, index) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.25),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  // border: Border.all(color: Colors.grey)
                                ),
                                child: Image.file(
                                    File(controller.brands[index].brandLogo)),
                              ),
                              title: Text(
                                controller.brands[index].brandName,
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
                                          return CreateBrandBottomSheet(
                                            brand:
                                                _brandController.brands[index],
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
                                      _brandController.deleteBrand(
                                          brand:
                                              _brandController.brands[index]);
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
              return const CreateBrandBottomSheet();
            },
          );
        },
      ),
    );
  }
}