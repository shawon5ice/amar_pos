import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/config/presentation/supplier/create_supplier_bottom_sheet.dart';
import 'supplier_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/search_widget.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final SupplierController _controller = Get.put(SupplierController());

  @override
  void initState() {
    _controller.getAllSupplier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Supplier"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              SearchWidget(
                onChanged: (value) {},
              ),
              addH(16.px),
              Expanded(
                child: GetBuilder<SupplierController>(
                  id: "supplier_list",
                  builder: (controller) {
                    if (_controller.supplierListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (_controller.supplierListResponseModel == null) {
                      return Center(
                        child: Text(
                          "Something went wrong",
                          style: context.textTheme.titleLarge,
                        ),
                      );
                    } else if (_controller.supplierList.isEmpty) {
                      return Center(
                        child: Text(
                          "No Supplier Found",
                          style: context.textTheme.titleLarge,
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: _controller.supplierList.length,
                      separatorBuilder: (context, index) {
                        if (index == _controller.supplierList.length - 1) {
                          return const SizedBox.shrink();
                        } else {
                          return const Divider(
                            color: Colors.grey,
                          );
                        }
                      },
                      itemBuilder: (context, index) =>
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.r))
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    color: Color(0xffBFBFBF).withOpacity(.2),
                                    child: Image.network(controller.supplierList[index].photo.toString(), height: 50,width: 50,fit: BoxFit.cover,),
                                  )
                                ),
                                addW(12.w),
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(controller.supplierList[index].name,style: context.textTheme.titleSmall,),
                                      Text(controller.supplierList[index].phone!),
                                      Text(controller.supplierList[index].address!),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                IconButton(onPressed: (){}, icon: Icon(Icons.menu))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomButton(
        text: "Create Supplier",
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
              return const CreateSupplierBottomSheet();
            },
          );
        },
      ),
    );
  }
}
