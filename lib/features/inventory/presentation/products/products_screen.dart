import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/widgets/pager_list_view.dart';
import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/add_product_screen.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/product_list_filter_bottom_sheet.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/product_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/search_widget.dart';

class ProductsScreen extends StatefulWidget {
  static const String routeName = "/products-list-screen";
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with SingleTickerProviderStateMixin {
  final ProductController controller = Get.put(ProductController());
  final DrawerMenuController _menuController = Get.find();

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    controller.getCategoriesBrandWarrantyUnits();
    controller.getAllProducts(activeStatus: true, page: 1);
    _tabController.addListener(() {
      if (_tabController.index != _tabController.previousIndex) {
        controller.getAllProducts(activeStatus: _tabController.index == 0, page: 1);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
        centerTitle: true,
        leading: DrawerButton(
          onPressed: _menuController.openDrawer,
        ),
        actions: [
          IconButton(onPressed: (){
            showModalBottomSheet(context: context, builder: (context){
              return const ProductListFilterBottomSheet();
            });
          }, icon: const Icon(Icons.filter_alt_outlined))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                height: 40.h,
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TabBar(
                  dividerHeight: 0,
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.normal),
                  labelColor: Colors.white,
                  splashBorderRadius: BorderRadius.circular(20),
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(
                      text: 'Active Product',
                    ),
                    Tab(text: 'Inactive Product'),
                  ],
                ),
              ),
              addH(12),
              SearchWidget(
                onChanged: (value) {
                  // _brandController.searchBrand(search: value);
                },
              ),
              addH(16.px),
              Expanded(
                child: GetBuilder<ProductController>(
                  id: 'product_list',
                  builder: (controller) {
                    if (controller.isProductListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return PagerListView(
                      items: controller.productList,
                      itemBuilder: (_, item) {
                        return ProductListItemWidget(productInfo: item);
                      },
                      isLoading: controller.isLoadingMore,
                      hasError: controller.hasError,
                      onNewLoad: (int nextPage) async {
                        await controller.getAllProducts(
                            activeStatus: true, page: nextPage);
                      },
                      totalPage: controller
                              .productsListResponseModel?.data.meta.lastPage ??
                          0,
                      totalSize: controller
                              .productsListResponseModel?.data.meta.total ??
                          0,
                      itemPerPage: 10,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: CustomFloatingButton(
        onTap: (){
          Get.to(AddProductScreen());
        },
      ),
    );
  }
}