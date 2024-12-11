import 'package:amar_pos/core/widgets/pager_list_view.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/search_widget.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductController controller = Get.put(ProductController());

  @override
  void initState() {
    controller.getAllProducts(activeStatus: true, page: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              SearchWidget(
                onChanged: (value) {
                  // _brandController.searchBrand(search: value);
                },
              ),
              addH(16.px),
              Expanded(
                child:GetBuilder<ProductController>(
                        id: 'product_list',
                        builder: (controller) {
                          if(controller.isProductListLoading){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return PagerListView(
                            items: controller.productList,
                            itemBuilder: (_, item) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                height: 200,
                                color: Colors.red,
                                width: 100,
                              );
                            },
                            isLoading: controller.isLoadingMore,
                            hasError: controller.hasError,
                            onNewLoad: (int nextPage) async {
                              await controller.getAllProducts(
                                  activeStatus: true, page: nextPage);
                            },
                            totalPage: controller
                                .productsListResponseModel?.data.meta.lastPage??0,
                            totalSize: controller
                                .productsListResponseModel?.data.meta.total??0,
                            itemPerPage: 4,
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: CustomButton(
      //   text: "Add New Brand",
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
      //         return const CreateBrandBottomSheet();
      //       },
      //     );
      //   },
      // ),
    );
  }
}
