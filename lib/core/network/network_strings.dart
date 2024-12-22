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
  static const String getAllOutletsDD = "outlet/get-outlet-list";
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


  //Client
  static const String getAllClient = "client/get-clients";
  static const String getClient = "client/get-client/";
  static const String addClient = "client/store";
  static const String updateClient = "client/update/";
  static const String deleteClient = "client/delete/";
  static const String changeStatusOfClient = "client/change-status/";

  //Client
  static const String getAllCustomer = "customer/get-customers";
  static const String getCustomer = "customer/get-customer";
  static const String addCustomer = "customer/store";
  static const String updateCustomer = "customer/update/";
  static const String deleteCustomer = "customer/delete/";
  static const String changeStatusOfCustomer = "customer/change-status/";



  //Inventory
  //Products
  static const String getAllProducts = "product/get-products";
  static const String addProduct = "product/store";
  static const String updateProduct = "product/update/";
  static const String quickEditProduct = "product/quickEdit/";
  static const String deleteProduct = "product/delete/";
  static const String generateProductBarcode = "product/generate-barcode/";
  static const String changeStatusProduct = "product/change-status/";
  static const String getProductCategoriesBrandsUnitsWarranties = "product/get-categories-brands-units-warranties";

  //stock report
  static const String getStockReportList = "inventory/get-product-stock-report";
}