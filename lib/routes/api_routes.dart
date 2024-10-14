class ApiRoutes {
  // static const String baseUrl =
  //     "http://ec2-3-108-18-16.ap-south-1.compute.amazonaws.com/";
  static const String baseUrl = "https://eapi.vridhee.com";

  //auth
  static const String registerUser = "$baseUrl/user_register/";
  static const String login = "$baseUrl/user_login/";
  static const String getCurrentUser = "$baseUrl/user_info";

  //home
  static const String fetchStoreDetails = "$baseUrl/home";
  static const String search = "$baseUrl/search";

  //products
  static const String getProductsAccToCategory = "$baseUrl/product_list";
  static const String getProductInfo = "$baseUrl/product_info";

  //cart
  static const String getCartProducts = "$baseUrl/product_info_list";
  static const String placeOrder = "$baseUrl/place_order";
  static const String verifyPayment = "$baseUrl/verify_payment";
  static const String get_all_state = "$baseUrl/get_all_state";
  static const String get_district = "$baseUrl/get_district";

  //order history
  static const String orderHistory = "$baseUrl/order_history";
  static const String getorgainzation = "$baseUrl/get_organizations";

  //address
  static const String address = "$baseUrl/address";

  //admin
  static const String adminOrderStats = "$baseUrl/order_stats";
  static const String adminOrderList = "$baseUrl/order_list";
  static const String adminhomegraph = "$baseUrl/order_stats";
  static const String getOrderDetails = "$baseUrl/order_details";
  static const String updateOrderStatus = "$baseUrl/order_status_update";
  static const String crudOrganisationList =
      "$baseUrl/admin_action/organization/";

  static const String crudSubCategoryList =
      "$baseUrl/admin_action/sub_category/";
  static const String crudCategoryList = "$baseUrl/admin_action/category/";

  static const String crudProductList = "$baseUrl/admin_action/products/";

  static const String uploadImage = "$baseUrl/photo_upload";
}
