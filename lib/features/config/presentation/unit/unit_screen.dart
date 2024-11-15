import 'package:amar_pos/features/config/presentation/unit/create_unit_bottom_sheet.dart';
import 'package:amar_pos/features/config/presentation/unit/unit_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/search_widget.dart';
import '../../../drawer/drawer_menu_controller.dart';

class UnitScreen extends StatefulWidget {
  const UnitScreen({super.key});

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  final DrawerMenuController drawerMenuController = Get.find();
  final UnitController _unitController = Get.put(UnitController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: DrawerButton(onPressed: drawerMenuController.openDrawer,),
        title: const Text("Unit"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    child: GetBuilder<UnitController>(
                        id: "new_unit_list",
                        builder: (controller) {
                          if (_unitController.units.isEmpty) {
                            return Center(
                              child: Text(
                                "No Units Added",
                                style: context.textTheme.titleLarge,
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: _unitController.units.length,
                            separatorBuilder: (context, index) {
                              if (index == _unitController.units.length - 1) {
                                return const SizedBox.shrink();
                              } else {
                                return const Divider(
                                  color: Colors.grey,
                                );
                              }
                            },
                            itemBuilder: (context, index) => ListTile(
                              enabled: false,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                "${_unitController.units[index].longForm}/${_unitController.units[index].shortForm}",
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
                                          return CreateUnitBottomSheet(
                                            unit:
                                            _unitController.units[index],
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
                                      _unitController.deleteUnit(
                                          unit:
                                          _unitController.units[index]);
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
        text: "Add New Unit",
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
              return const CreateUnitBottomSheet();
            },
          );
        },
      ),
    );
  }
}
