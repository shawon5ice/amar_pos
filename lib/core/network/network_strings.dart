class NetWorkStrings{
  static String errorMessage = '';
  static const String baseUrl = "https://amarpos.motionview.com.bd/api";


  static String loginUrl = 'user/login';

  //Brand
  static const String getAllBrands = "brand/get-brands";
  static const String addBrand = "brand/store";
  static const String updateBrand = "brand/update/";
  static const String deleteBrand = "brand/delete/";

  //Category
  static const String getAllCategories = "category/get-categories";
  static const String addCategory = "category/store";
  static const String updateCategory = "category/update/";
  static const String deleteCategory = "category/delete/";

  //Unit
  static const String getAllUnits = "product/get-units";

  //Warranty
  static const String getAllWarranty = "product/get-warranties";

  //Supplier
  static const String getAllSuppliers = "supplier/get-suppliers";
  static const String addSupplier = "supplier/store";
  static const String updateSupplier = "supplier/update/";
  static const String deleteSupplier = "supplier/delete/";
  static const String changeStatusOfSupplier = "supplier/change-status/";

  //Employee
  static const String getAllPermissions = "get-all-permissions";
  static const String getAllEmployees = "business_user/get-users";
  static const String getSingleEmployees = "business_user/get-user/";
  static const String addEmployee = "business_user/store";
  static const String updateEmployee = "business_user/update/";
  static const String deleteEmployee = "business_user/delete/";
  static const String changeStatusOfEmployee = "business_user/change-status/";

  //Outlet
  static const String getAllOutlet = "outlet/get-outlets";
  static const String getOutlet = "outlet/get-outlet/";
  static const String addOutlet = "outlet/store";
  static const String updateOutlet = "outlet/update/";
  static const String deleteOutlet = "outlet/delete/";
  static const String changeStatusOfOutlet = "outlet/change-status/";
}