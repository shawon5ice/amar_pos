import 'package:amar_pos/features/config/presentation/unit/unit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive/pixel_perfect.dart';
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
  void initState() {
    _unitController.getAllUnits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  _unitController.searchCategory(search: value);
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
                        id: "unit_list",
                        builder: (controller) {
                          if(_unitController.unitListLoading){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }else if(_unitController.unitListModelResponse == null){
                            return Center(
                              child: Text(
                                "Something went wrong.",
                                style: context.textTheme.titleLarge,
                              ),
                            );
                          }else if (_unitController.unitList.isEmpty) {
                            return Center(
                              child: Text(
                                "No Units Found.",
                                style: context.textTheme.titleLarge,
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: _unitController.unitList.length,
                            separatorBuilder: (context, index) {
                              if (index == _unitController.unitList.length - 1) {
                                return const SizedBox.shrink();
                              } else {
                                return const Divider(
                                  height: 0,
                                  color: Colors.grey,
                                );
                              }
                            },
                            itemBuilder: (context, index) => ListTile(
                              enabled: false,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                _unitController.unitList[index].name,
                                style: context.textTheme.titleSmall?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    // fontSize: 16.px,
                                    height: (22 / 16).px),
                              ),
                            ),
                          );
                        })),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: CustomButton(
      //   text: "Add New Unit",
      //   marginHorizontal: 20,
      //   marginVertical: 10,
      //   onTap: () {
      //     showModalBottomSheet(
      //       context: context,
      //       isScrollControlled: true,
      //       shape: const RoundedRectangleBorder(
      //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      //       ),
      //       builder: (context) {
      //         return const CreateUnitBottomSheet();
      //       },
      //     );
      //   },
      // ),
    );
  }
}
