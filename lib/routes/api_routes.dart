class ApiRoutes {
  static const String baseUrl =
      "http://ec2-3-108-18-16.ap-south-1.compute.amazonaws.com:8010";

  //auth
  static const String registerUser = "$baseUrl/user_register/";
  static const String login = "$baseUrl/user_login/";

  //home
  static const String fetchStoreDetails = "$baseUrl/home?user_id=1";

  //products
  static const String getProductsAccToCategory = "$baseUrl/product_list";
  static const String getProductInfo = "$baseUrl/product_info";

  //cart
  static const String getCartProducts = "$baseUrl/product_info_list";
  static const String placeOrder = "$baseUrl/place_order";
}
