import 'dart:math';

import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/pager_list_view.dart';
import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/add_product_screen.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/product_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/core.dart';
import '../../../../core/data/model/outlet_model.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import '../../../../core/widgets/reusable/filter_bottom_sheet/product_brand_category_warranty_unit_response_model.dart' show FilterItem;
import '../../../../core/widgets/reusable/filter_bottom_sheet/simple_filter_bottom_sheet_widget.dart';

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

  late TextEditingController searchController;

  late TabController _tabController;

  @override
  void initState() {
    searchController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
    controller.getAllProducts(activeStatus: true, page: 1);
    // if (!_tabController.indexIsChanging && _tabController.index != _tabController.previousIndex) {
    //   search = "";
    //   searchController.clear();
    //   controller.getAllProducts(
    //       activeStatus: _tabController.index == 0, page: 1,);
    // }
    _tabController.addListener(() {
      if (_tabController.index != _tabController.previousIndex && !_tabController.indexIsChanging) {
        search = "";
        controller.brand = null;
        controller.category = null;
        searchController.clear();
        controller.update(['action_icon']);
        controller.getAllProducts(activeStatus: _tabController.index == 0, page: 1);
      }
    });
    super.initState();
  }


  @override
  void dispose() {
    Get.delete<ProductController>();
    super.dispose();
  }

  String search = "";

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
          GetBuilder<ProductController>(
            id: 'action_icon',
            builder: (controller) => IconButton(
              onPressed: (){
                showModalBottomSheet(context: context, builder: (context) => SimpleFilterBottomSheetWidget(
                  selectedBrand: controller.brand,
                  disableDateTime: true,
                  selectedCategory: controller.category,
                  selectedDateTimeRange: null,
                  onSubmit: (FilterItem? brand,FilterItem? category,DateTimeRange? dateTimeRange, OutletModel? outlet){
                    controller.update(['action_icon']);
                    controller.brand = brand;
                    controller.category = category;
                    // controller.selectedDateTimeRange.value = dateTimeRange;
                    logger.i(controller.brand);
                    logger.i(controller.category?.id);
                    // logger.i(controller.selectedDateTimeRange.value);
                    Get.back();
                    controller.getAllProducts(activeStatus: _tabController.index == 0);
                  },
                ));
              },
              icon: Icon(Icons.filter_alt_outlined, color: (controller.brand != null || controller.category != null) ? AppColors.error : null,),
            ),
          ),
          addW(12),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.getAllProducts(
                activeStatus: _tabController.index == 0, page: 1, search: search,);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  height: 40,
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TabBar(
                    dividerHeight: 0,
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                addH(8),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        textCon: searchController,
                        hintText: "Search...",
                        brdrClr: Colors.transparent,
                        txtSize: 12.sp,
                        debounceDuration: const Duration(
                          milliseconds: 300,
                        ),
                        // noInputBorder: true,
                        brdrRadius: 40.r,
                        prefixWidget: Icon(Icons.search),
                        onChanged: (value){
                          controller.getAllProducts(activeStatus: _tabController.index == 0, page: 1, search: value);
                        },
                      ),
                    ),
                    addW(8),
                    CustomSvgIconButton(
                      bgColor: const Color(0xffEBFFDF),
                      onTap: () {
                        controller.downloadList(isPdf: false, activeStatus: _tabController.index == 0,search: searchController.text);
                      },
                      assetPath: AppAssets.excelIcon,
                    ),
                    addW(4),
                    CustomSvgIconButton(
                      bgColor: const Color(0xffE1F2FF),
                      onTap: () {
                        controller.downloadList(isPdf: true, activeStatus: _tabController.index == 0, search: searchController.text);
                      },
                      assetPath: AppAssets.downloadIcon,
                    ),
                    addW(4),
                    CustomSvgIconButton(
                      bgColor: const Color(0xffFFFCF8),
                      onTap: () {
                        controller.downloadList(isPdf: true, activeStatus: _tabController.index == 0, shouldPrint: true, search: searchController.text);
                      },
                      assetPath: AppAssets.printIcon,
                    )
                  ],
                ),
                // CustomTextField(
                //   textCon: searchController,
                //   hintText: "Search Here",
                //   onChanged: (value){
                //     if(value == ""){
                //       search = "";
                //       controller.getAllProducts(activeStatus: _tabController.index == 0, page: 1, search: search);
                //     }
                //   },
                //   onSubmitted: (value) {
                //     search = value;
                //     controller.getAllProducts(activeStatus: _tabController.index == 0, page: 1, search: search);
                //   },
                //   brdrClr: Colors.transparent,
                //   brdrRadius: 20,
                //   prefixWidget: const Icon(Icons.search),
                // ),
                // SearchWidget(
                //   onChanged: (value) {
                //     controller.getAllProducts(activeStatus: _tabController.index == 0, page: 1, search: value);
                //   },
                // ),
                addH(8),
                Expanded(
                  child: GetBuilder<ProductController>(
                    id: 'product_list',
                    builder: (controller) {
                      if (controller.isProductListLoading) {
                        return Center(
                          child: Lottie.asset(
                            AppAssets.lottieFiles[Random().nextInt(AppAssets.lottieFiles.length)],
                            width: 150,
                            height: 150,
                          ),
                        );
                      }else if(controller.productList.isEmpty){
                        return Center(
                          child: Text("No product found!"),
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
                              activeStatus: _tabController.index == 0,
                              page: nextPage, search: search);
                        },
                        totalPage: controller.productsListResponseModel?.data
                                .meta.lastPage ??
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: CustomFloatingButton(
        onTap: () {
          Get.to(AddProductScreen(),arguments: true);
        },
      ),
    );
  }
}
