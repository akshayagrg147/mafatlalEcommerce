// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i27;
import 'package:flutter/material.dart' as _i28;
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_cat_model.dart'
    as _i29;
import 'package:mafatlal_ecommerce/features/admin_category/presentation/admin_category_details.dart'
    as _i1;
import 'package:mafatlal_ecommerce/features/admin_category/presentation/admin_category_screen.dart'
    as _i3;
import 'package:mafatlal_ecommerce/features/admin_category/presentation/admin_organisation_screen.dart'
    as _i8;
import 'package:mafatlal_ecommerce/features/admin_category/presentation/category_list_screen.dart'
    as _i2;
import 'package:mafatlal_ecommerce/features/admin_category/presentation/organisation_list_screen.dart'
    as _i19;
import 'package:mafatlal_ecommerce/features/admin_home/presentation/admin_home.dart'
    as _i5;
import 'package:mafatlal_ecommerce/features/admin_home/presentation/admin_home_screen.dart'
    as _i4;
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/admin_orders_screen.dart'
    as _i7;
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/order_details_screen.dart'
    as _i6;
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/orders_route.dart'
    as _i18;
import 'package:mafatlal_ecommerce/features/admin_products/model/admin_product.dart'
    as _i31;
import 'package:mafatlal_ecommerce/features/admin_products/presentation/product_add_update_screen.dart'
    as _i20;
import 'package:mafatlal_ecommerce/features/admin_products/presentation/product_list_screen.dart'
    as _i22;
import 'package:mafatlal_ecommerce/features/admin_products/presentation/products_home.dart'
    as _i9;
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart'
    as _i14;
import 'package:mafatlal_ecommerce/features/auth/presentaion/sign_up_screen.dart'
    as _i23;
import 'package:mafatlal_ecommerce/features/auth/presentaion/splash_screen.dart'
    as _i25;
import 'package:mafatlal_ecommerce/features/checkout/presentation/checkout_screen.dart'
    as _i12;
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart'
    as _i30;
import 'package:mafatlal_ecommerce/features/home/presentaion/cart_screen.dart'
    as _i10;
import 'package:mafatlal_ecommerce/features/home/presentaion/category_product_screen.dart'
    as _i11;
import 'package:mafatlal_ecommerce/features/home/presentaion/home_screen.dart'
    as _i13;
import 'package:mafatlal_ecommerce/features/home/presentaion/order_details_screen.dart'
    as _i15;
import 'package:mafatlal_ecommerce/features/home/presentaion/order_history.dart'
    as _i17;
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/order_success_widget.dart'
    as _i16;
import 'package:mafatlal_ecommerce/features/home/SubCategory/presentation/subcategory_detail.dart'
    as _i26;
import 'package:mafatlal_ecommerce/features/product_details/presentaion/product_details.dart'
    as _i21;
import 'package:mafatlal_ecommerce/features/search/presentation/search_screen.dart'
    as _i24;

abstract class $MfRouter extends _i27.RootStackRouter {
  $MfRouter({super.navigatorKey});

  @override
  final Map<String, _i27.PageFactory> pagesMap = {
    AdminCategoryDetailPageRoute.name: (routeData) {
      final args = routeData.argsAs<AdminCategoryDetailPageRouteArgs>();
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AdminCategoryDetailPage(
          key: args.key,
          category: args.category,
        ),
      );
    },
    AdminCategoryListScreenRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AdminCategoryListScreen(),
      );
    },
    AdminCategoryPageRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AdminCategoryPage(),
      );
    },
    AdminDashboardRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.AdminDashboard(),
      );
    },
    AdminHomeRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.AdminHome(),
      );
    },
    AdminOrderDetailsScreenRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AdminOrderDetailsScreenRouteArgs>(
          orElse: () => AdminOrderDetailsScreenRouteArgs(
              orderId: pathParams.getInt('orderId')));
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.AdminOrderDetailsScreen(
          key: args.key,
          orderId: args.orderId,
        ),
      );
    },
    AdminOrdersHistoryScreenRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.AdminOrdersHistoryScreen(),
      );
    },
    AdminOrganisationScreenRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.AdminOrganisationScreen(),
      );
    },
    AdminProductsPageRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.AdminProductsPage(),
      );
    },
    CartScreenRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.CartScreen(),
      );
    },
    CategoryProductScreenRoute.name: (routeData) {
      final args = routeData.argsAs<CategoryProductScreenRouteArgs>();
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.CategoryProductScreen(
          key: args.key,
          category: args.category,
        ),
      );
    },
    CheckoutScreenRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.CheckoutScreen(),
      );
    },
    HomeScreenRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.HomeScreen(),
      );
    },
    LoginScreenRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.LoginScreen(),
      );
    },
    OrderDetailsScreenRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<OrderDetailsScreenRouteArgs>(
          orElse: () => OrderDetailsScreenRouteArgs(
              orderId: pathParams.getInt('orderId')));
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.OrderDetailsScreen(
          key: args.key,
          orderId: args.orderId,
        ),
      );
    },
    OrderSuccessRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.OrderSuccess(),
      );
    },
    OrdersHistoryRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.OrdersHistory(),
      );
    },
    OrdersPageRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i18.OrdersPage(),
      );
    },
    OrganisationListScreenRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i19.OrganisationListScreen(),
      );
    },
    ProductAddUpdateScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ProductAddUpdateScreenRouteArgs>(
          orElse: () => const ProductAddUpdateScreenRouteArgs());
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i20.ProductAddUpdateScreen(
          key: args.key,
          productDetails: args.productDetails,
        ),
      );
    },
    ProductDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProductDetailsRouteArgs>(
          orElse: () => ProductDetailsRouteArgs(
              productId: pathParams.getInt('productId')));
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i21.ProductDetails(
          key: args.key,
          productId: args.productId,
        ),
      );
    },
    ProductListScreenRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i22.ProductListScreen(),
      );
    },
    RegistrationScreenRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i23.RegistrationScreen(),
      );
    },
    SearchScreenRoute.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<SearchScreenRouteArgs>(
          orElse: () => SearchScreenRouteArgs(
              searchText: queryParams.optString('searchText')));
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i24.SearchScreen(
          key: args.key,
          searchText: args.searchText,
        ),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i25.SplashScreen(),
      );
    },
    SubCategoryDetailRoute.name: (routeData) {
      final args = routeData.argsAs<SubCategoryDetailRouteArgs>();
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i26.SubCategoryDetail(
          key: args.key,
          subcategories: args.subcategories,
          selectedName: args.selectedName,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AdminCategoryDetailPage]
class AdminCategoryDetailPageRoute
    extends _i27.PageRouteInfo<AdminCategoryDetailPageRouteArgs> {
  AdminCategoryDetailPageRoute({
    _i28.Key? key,
    required _i29.AdminCategory category,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          AdminCategoryDetailPageRoute.name,
          args: AdminCategoryDetailPageRouteArgs(
            key: key,
            category: category,
          ),
          initialChildren: children,
        );

  static const String name = 'AdminCategoryDetailPageRoute';

  static const _i27.PageInfo<AdminCategoryDetailPageRouteArgs> page =
      _i27.PageInfo<AdminCategoryDetailPageRouteArgs>(name);
}

class AdminCategoryDetailPageRouteArgs {
  const AdminCategoryDetailPageRouteArgs({
    this.key,
    required this.category,
  });

  final _i28.Key? key;

  final _i29.AdminCategory category;

  @override
  String toString() {
    return 'AdminCategoryDetailPageRouteArgs{key: $key, category: $category}';
  }
}

/// generated route for
/// [_i2.AdminCategoryListScreen]
class AdminCategoryListScreenRoute extends _i27.PageRouteInfo<void> {
  const AdminCategoryListScreenRoute({List<_i27.PageRouteInfo>? children})
      : super(
          AdminCategoryListScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdminCategoryListScreenRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i3.AdminCategoryPage]
class AdminCategoryPageRoute extends _i27.PageRouteInfo<void> {
  const AdminCategoryPageRoute({List<_i27.PageRouteInfo>? children})
      : super(
          AdminCategoryPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdminCategoryPageRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i4.AdminDashboard]
class AdminDashboardRoute extends _i27.PageRouteInfo<void> {
  const AdminDashboardRoute({List<_i27.PageRouteInfo>? children})
      : super(
          AdminDashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdminDashboardRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i5.AdminHome]
class AdminHomeRoute extends _i27.PageRouteInfo<void> {
  const AdminHomeRoute({List<_i27.PageRouteInfo>? children})
      : super(
          AdminHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdminHomeRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i6.AdminOrderDetailsScreen]
class AdminOrderDetailsScreenRoute
    extends _i27.PageRouteInfo<AdminOrderDetailsScreenRouteArgs> {
  AdminOrderDetailsScreenRoute({
    _i28.Key? key,
    required int orderId,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          AdminOrderDetailsScreenRoute.name,
          args: AdminOrderDetailsScreenRouteArgs(
            key: key,
            orderId: orderId,
          ),
          rawPathParams: {'orderId': orderId},
          initialChildren: children,
        );

  static const String name = 'AdminOrderDetailsScreenRoute';

  static const _i27.PageInfo<AdminOrderDetailsScreenRouteArgs> page =
      _i27.PageInfo<AdminOrderDetailsScreenRouteArgs>(name);
}

class AdminOrderDetailsScreenRouteArgs {
  const AdminOrderDetailsScreenRouteArgs({
    this.key,
    required this.orderId,
  });

  final _i28.Key? key;

  final int orderId;

  @override
  String toString() {
    return 'AdminOrderDetailsScreenRouteArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [_i7.AdminOrdersHistoryScreen]
class AdminOrdersHistoryScreenRoute extends _i27.PageRouteInfo<void> {
  const AdminOrdersHistoryScreenRoute({List<_i27.PageRouteInfo>? children})
      : super(
          AdminOrdersHistoryScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdminOrdersHistoryScreenRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i8.AdminOrganisationScreen]
class AdminOrganisationScreenRoute extends _i27.PageRouteInfo<void> {
  const AdminOrganisationScreenRoute({List<_i27.PageRouteInfo>? children})
      : super(
          AdminOrganisationScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdminOrganisationScreenRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i9.AdminProductsPage]
class AdminProductsPageRoute extends _i27.PageRouteInfo<void> {
  const AdminProductsPageRoute({List<_i27.PageRouteInfo>? children})
      : super(
          AdminProductsPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdminProductsPageRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i10.CartScreen]
class CartScreenRoute extends _i27.PageRouteInfo<void> {
  const CartScreenRoute({List<_i27.PageRouteInfo>? children})
      : super(
          CartScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartScreenRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i11.CategoryProductScreen]
class CategoryProductScreenRoute
    extends _i27.PageRouteInfo<CategoryProductScreenRouteArgs> {
  CategoryProductScreenRoute({
    _i28.Key? key,
    required _i30.Category_new category,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          CategoryProductScreenRoute.name,
          args: CategoryProductScreenRouteArgs(
            key: key,
            category: category,
          ),
          initialChildren: children,
        );

  static const String name = 'CategoryProductScreenRoute';

  static const _i27.PageInfo<CategoryProductScreenRouteArgs> page =
      _i27.PageInfo<CategoryProductScreenRouteArgs>(name);
}

class CategoryProductScreenRouteArgs {
  const CategoryProductScreenRouteArgs({
    this.key,
    required this.category,
  });

  final _i28.Key? key;

  final _i30.Category_new category;

  @override
  String toString() {
    return 'CategoryProductScreenRouteArgs{key: $key, category: $category}';
  }
}

/// generated route for
/// [_i12.CheckoutScreen]
class CheckoutScreenRoute extends _i27.PageRouteInfo<void> {
  const CheckoutScreenRoute({List<_i27.PageRouteInfo>? children})
      : super(
          CheckoutScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'CheckoutScreenRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i13.HomeScreen]
class HomeScreenRoute extends _i27.PageRouteInfo<void> {
  const HomeScreenRoute({List<_i27.PageRouteInfo>? children})
      : super(
          HomeScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeScreenRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i14.LoginScreen]
class LoginScreenRoute extends _i27.PageRouteInfo<void> {
  const LoginScreenRoute({List<_i27.PageRouteInfo>? children})
      : super(
          LoginScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginScreenRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i15.OrderDetailsScreen]
class OrderDetailsScreenRoute
    extends _i27.PageRouteInfo<OrderDetailsScreenRouteArgs> {
  OrderDetailsScreenRoute({
    _i28.Key? key,
    required int orderId,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          OrderDetailsScreenRoute.name,
          args: OrderDetailsScreenRouteArgs(
            key: key,
            orderId: orderId,
          ),
          rawPathParams: {'orderId': orderId},
          initialChildren: children,
        );

  static const String name = 'OrderDetailsScreenRoute';

  static const _i27.PageInfo<OrderDetailsScreenRouteArgs> page =
      _i27.PageInfo<OrderDetailsScreenRouteArgs>(name);
}

class OrderDetailsScreenRouteArgs {
  const OrderDetailsScreenRouteArgs({
    this.key,
    required this.orderId,
  });

  final _i28.Key? key;

  final int orderId;

  @override
  String toString() {
    return 'OrderDetailsScreenRouteArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [_i16.OrderSuccess]
class OrderSuccessRoute extends _i27.PageRouteInfo<void> {
  const OrderSuccessRoute({List<_i27.PageRouteInfo>? children})
      : super(
          OrderSuccessRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrderSuccessRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i17.OrdersHistory]
class OrdersHistoryRoute extends _i27.PageRouteInfo<void> {
  const OrdersHistoryRoute({List<_i27.PageRouteInfo>? children})
      : super(
          OrdersHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrdersHistoryRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i18.OrdersPage]
class OrdersPageRoute extends _i27.PageRouteInfo<void> {
  const OrdersPageRoute({List<_i27.PageRouteInfo>? children})
      : super(
          OrdersPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrdersPageRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i19.OrganisationListScreen]
class OrganisationListScreenRoute extends _i27.PageRouteInfo<void> {
  const OrganisationListScreenRoute({List<_i27.PageRouteInfo>? children})
      : super(
          OrganisationListScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrganisationListScreenRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i20.ProductAddUpdateScreen]
class ProductAddUpdateScreenRoute
    extends _i27.PageRouteInfo<ProductAddUpdateScreenRouteArgs> {
  ProductAddUpdateScreenRoute({
    _i28.Key? key,
    _i31.AdminProduct? productDetails,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          ProductAddUpdateScreenRoute.name,
          args: ProductAddUpdateScreenRouteArgs(
            key: key,
            productDetails: productDetails,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductAddUpdateScreenRoute';

  static const _i27.PageInfo<ProductAddUpdateScreenRouteArgs> page =
      _i27.PageInfo<ProductAddUpdateScreenRouteArgs>(name);
}

class ProductAddUpdateScreenRouteArgs {
  const ProductAddUpdateScreenRouteArgs({
    this.key,
    this.productDetails,
  });

  final _i28.Key? key;

  final _i31.AdminProduct? productDetails;

  @override
  String toString() {
    return 'ProductAddUpdateScreenRouteArgs{key: $key, productDetails: $productDetails}';
  }
}

/// generated route for
/// [_i21.ProductDetails]
class ProductDetailsRoute extends _i27.PageRouteInfo<ProductDetailsRouteArgs> {
  ProductDetailsRoute({
    _i28.Key? key,
    required int productId,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          ProductDetailsRoute.name,
          args: ProductDetailsRouteArgs(
            key: key,
            productId: productId,
          ),
          rawPathParams: {'productId': productId},
          initialChildren: children,
        );

  static const String name = 'ProductDetailsRoute';

  static const _i27.PageInfo<ProductDetailsRouteArgs> page =
      _i27.PageInfo<ProductDetailsRouteArgs>(name);
}

class ProductDetailsRouteArgs {
  const ProductDetailsRouteArgs({
    this.key,
    required this.productId,
  });

  final _i28.Key? key;

  final int productId;

  @override
  String toString() {
    return 'ProductDetailsRouteArgs{key: $key, productId: $productId}';
  }
}

/// generated route for
/// [_i22.ProductListScreen]
class ProductListScreenRoute extends _i27.PageRouteInfo<void> {
  const ProductListScreenRoute({List<_i27.PageRouteInfo>? children})
      : super(
          ProductListScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductListScreenRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i23.RegistrationScreen]
class RegistrationScreenRoute extends _i27.PageRouteInfo<void> {
  const RegistrationScreenRoute({List<_i27.PageRouteInfo>? children})
      : super(
          RegistrationScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationScreenRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i24.SearchScreen]
class SearchScreenRoute extends _i27.PageRouteInfo<SearchScreenRouteArgs> {
  SearchScreenRoute({
    _i28.Key? key,
    String? searchText,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          SearchScreenRoute.name,
          args: SearchScreenRouteArgs(
            key: key,
            searchText: searchText,
          ),
          rawQueryParams: {'searchText': searchText},
          initialChildren: children,
        );

  static const String name = 'SearchScreenRoute';

  static const _i27.PageInfo<SearchScreenRouteArgs> page =
      _i27.PageInfo<SearchScreenRouteArgs>(name);
}

class SearchScreenRouteArgs {
  const SearchScreenRouteArgs({
    this.key,
    this.searchText,
  });

  final _i28.Key? key;

  final String? searchText;

  @override
  String toString() {
    return 'SearchScreenRouteArgs{key: $key, searchText: $searchText}';
  }
}

/// generated route for
/// [_i25.SplashScreen]
class SplashScreenRoute extends _i27.PageRouteInfo<void> {
  const SplashScreenRoute({List<_i27.PageRouteInfo>? children})
      : super(
          SplashScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreenRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i26.SubCategoryDetail]
class SubCategoryDetailRoute
    extends _i27.PageRouteInfo<SubCategoryDetailRouteArgs> {
  SubCategoryDetailRoute({
    _i28.Key? key,
    required List<_i30.SubCategory_new> subcategories,
    required String selectedName,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          SubCategoryDetailRoute.name,
          args: SubCategoryDetailRouteArgs(
            key: key,
            subcategories: subcategories,
            selectedName: selectedName,
          ),
          rawPathParams: {'selectedName': selectedName},
          initialChildren: children,
        );

  static const String name = 'SubCategoryDetailRoute';

  static const _i27.PageInfo<SubCategoryDetailRouteArgs> page =
      _i27.PageInfo<SubCategoryDetailRouteArgs>(name);
}

class SubCategoryDetailRouteArgs {
  const SubCategoryDetailRouteArgs({
    this.key,
    required this.subcategories,
    required this.selectedName,
  });

  final _i28.Key? key;

  final List<_i30.SubCategory_new> subcategories;

  final String selectedName;

  @override
  String toString() {
    return 'SubCategoryDetailRouteArgs{key: $key, subcategories: $subcategories, selectedName: $selectedName}';
  }
}
