import 'package:amar_pos/features/config/presentation/unit/unit_controller.dart';
import 'package:amar_pos/features/config/presentation/warranty/warranty_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/search_widget.dart';
import '../../../drawer/drawer_menu_controller.dart';

class WarrantyScreen extends StatefulWidget {
  const WarrantyScreen({super.key});

  @override
  State<WarrantyScreen> createState() => _WarrantyScreenState();
}

class _WarrantyScreenState extends State<WarrantyScreen> {
  final DrawerMenuController drawerMenuController = Get.find();
  final WarrantyController _warrantyController = Get.put(WarrantyController());

  @override
  void initState() {
    _warrantyController.getAllWarranty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Warranty"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SearchWidget(
                onChanged: (value){
                  _warrantyController.searchWarranty(search: value);
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
                    child: GetBuilder<WarrantyController>(
                        id: "unit_list",
                        builder: (controller) {
                          if(_warrantyController.warrantyListLoading){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }else if(_warrantyController.warrantyListModelResponse == null){
                            return Center(
                              child: Text(
                                "Something went wrong",
                                style: context.textTheme.titleLarge,
                              ),
                            );
                          }else if (_warrantyController.warrantyList.isEmpty) {
                            return Center(
                              child: Text(
                                "No Units Found",
                                style: context.textTheme.titleLarge,
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: _warrantyController.warrantyList.length,
                            separatorBuilder: (context, index) {
                              if (index == _warrantyController.warrantyList.length - 1) {
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
                                _warrantyController.warrantyList[index].title,
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
              addH(20)
,            ],
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
