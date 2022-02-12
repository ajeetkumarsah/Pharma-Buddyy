import 'dart:convert';

import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/basic_campaign_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/html_type.dart';
import 'package:efood_multivendor/view/base/not_found.dart';
import 'package:efood_multivendor/view/screens/address/add_address_screen.dart';
import 'package:efood_multivendor/view/screens/address/address_screen.dart';
import 'package:efood_multivendor/view/screens/auth/sign_in_screen.dart';
import 'package:efood_multivendor/view/screens/auth/sign_up_screen.dart';
import 'package:efood_multivendor/view/screens/cart/cart_screen.dart';
import 'package:efood_multivendor/view/screens/category/category_product_screen.dart';
import 'package:efood_multivendor/view/screens/category/category_screen.dart';
import 'package:efood_multivendor/view/screens/checkout/checkout_screen.dart';
import 'package:efood_multivendor/view/screens/checkout/order_successful_screen.dart';
import 'package:efood_multivendor/view/screens/checkout/payment_screen.dart';
import 'package:efood_multivendor/view/screens/coupon/coupon_screen.dart';
import 'package:efood_multivendor/view/screens/dashboard/dashboard_screen.dart';
import 'package:efood_multivendor/view/screens/food/item_campaign_screen.dart';
import 'package:efood_multivendor/view/screens/food/popular_food_screen.dart';
import 'package:efood_multivendor/view/screens/forget/forget_pass_screen.dart';
import 'package:efood_multivendor/view/screens/forget/new_pass_screen.dart';
import 'package:efood_multivendor/view/screens/forget/verification_screen.dart';
import 'package:efood_multivendor/view/screens/html/html_viewer_screen.dart';
import 'package:efood_multivendor/view/screens/interest/interest_screen.dart';
import 'package:efood_multivendor/view/screens/language/language_screen.dart';
import 'package:efood_multivendor/view/screens/location/access_location_screen.dart';
import 'package:efood_multivendor/view/screens/location/map_screen.dart';
import 'package:efood_multivendor/view/screens/location/pick_map_screen.dart';
import 'package:efood_multivendor/view/screens/notification/notification_screen.dart';
import 'package:efood_multivendor/view/screens/onboard/onboarding_screen.dart';
import 'package:efood_multivendor/view/screens/order/order_details_screen.dart';
import 'package:efood_multivendor/view/screens/order/order_tracking_screen.dart';
import 'package:efood_multivendor/view/screens/prescription/prescription_screen.dart';
import 'package:efood_multivendor/view/screens/prescription/widget/image_view.dart';
import 'package:efood_multivendor/view/screens/profile/profile_screen.dart';
import 'package:efood_multivendor/view/screens/profile/update_profile_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/all_restaurant_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/campaign_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/review_screen.dart';
import 'package:efood_multivendor/view/screens/search/search_screen.dart';
import 'package:efood_multivendor/view/screens/splash/splash_screen.dart';
import 'package:efood_multivendor/view/screens/support/support_screen.dart';
import 'package:efood_multivendor/view/screens/update/update_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String language = '/language';
  static const String onBoarding = '/on-boarding';
  static const String imageView = '/imageView';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String verification = '/verification';
  static const String accessLocation = '/access-location';
  static const String pickMap = '/pick-map';
  static const String interest = '/interest';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String search = '/search';
  static const String prescription = '/prescription';
  static const String restaurant = '/restaurant';
  static const String orderDetails = '/order-details';
  static const String profile = '/profile';
  static const String updateProfile = '/update-profile';
  static const String coupon = '/coupon';
  static const String notification = '/notification';
  static const String map = '/map';
  static const String address = '/address';
  static const String orderSuccess = '/order-successful';
  static const String payment = '/payment';
  static const String checkout = '/checkout';
  static const String orderTracking = '/track-order';
  static const String basicCampaign = '/basic-campaign';
  static const String html = '/html';
  static const String categories = '/categories';
  static const String categoryProduct = '/category-product';
  static const String popularFoods = '/popular-foods';
  static const String itemCampaign = '/item-campaign';
  static const String support = '/help-and-support';
  static const String rateReview = '/rate-and-review';
  static const String update = '/update';
  static const String cart = '/cart';
  static const String addAddress = '/add-address';
  static const String restaurantReview = '/restaurant-review';
  static const String allRestaurants = '/restaurants';

  static String getInitialRoute() => '$initial';
  static String getImageViewRoute() => '$imageView';
  static String getSplashRoute(int orderID) => '$splash?id=$orderID';
  static String getLanguageRoute(String page) => '$language?page=$page';
  static String getOnBoardingRoute() => '$onBoarding';
  static String getSignInRoute(String page) => '$signIn?page=$page';
  static String getSignUpRoute() => '$signUp';
  static String getVerificationRoute(
      String number, String token, String page, String pass) {
    return '$verification?page=$page&number=$number&token=$token&pass=$pass';
  }

  static String getAccessLocationRoute(String page) =>
      '$accessLocation?page=$page';
  static String getPickMapRoute(String page, bool canRoute) =>
      '$pickMap?page=$page&route=${canRoute.toString()}';
  static String getInterestRoute() => '$interest';
  static String getMainRoute(String page) => '$main?page=$page';
  static String getForgotPassRoute() => '$forgotPassword';
  static String getResetPasswordRoute(
          String phone, String token, String page) =>
      '$resetPassword?phone=$phone&token=$token&page=$page';
  static String getSearchRoute() => '$search';
  static String getRestaurantRoute(int id) => '$restaurant?id=$id';
  static String getOrderDetailsRoute(int orderID) {
    return '$orderDetails?id=$orderID';
  }

  static String getProfileRoute() => '$profile';
  static String getPrescriptionRoute() => '$prescription';
  static String getUpdateProfileRoute() => '$updateProfile';
  static String getCouponRoute() => '$coupon';
  static String getNotificationRoute() => '$notification';
  static String getMapRoute(AddressModel addressModel, String page) {
    List<int> _encoded = utf8.encode(jsonEncode(addressModel.toJson()));
    String _data = base64Encode(_encoded);
    return '$map?address=$_data&page=$page';
  }

  static String getAddressRoute() => '$address';
  static String getOrderSuccessRoute(String orderID, String status) =>
      '$orderSuccess?id=$orderID&status=$status';
  static String getPaymentRoute(String id, int user) =>
      '$payment?id=$id&user=$user';
  static String getCheckoutRoute(String page) => '$checkout?page=$page';
  static String getOrderTrackingRoute(int id) => '$orderTracking?id=$id';
  static String getBasicCampaignRoute(int id, String title, String image) =>
      '$basicCampaign?id=$id&image=$image&title=$title';
  static String getHtmlRoute(String page) => '$html?page=$page';
  static String getCategoryRoute() => '$categories';
  static String getCategoryProductRoute(int id, String name) {
    List<int> _encoded = utf8.encode(name);
    String _data = base64Encode(_encoded);
    return '$categoryProduct?id=$id&name=$_data';
  }

  static String getPopularFoodRoute(bool isPopular) =>
      '$popularFoods?page=${isPopular ? 'popular' : 'reviewed'}';
  static String getItemCampaignRoute() => '$itemCampaign';
  static String getSupportRoute() => '$support';
  static String getReviewRoute() => '$rateReview';
  static String getUpdateRoute(bool isUpdate) =>
      '$update?update=${isUpdate.toString()}';
  static String getCartRoute() => '$cart';
  static String getAddAddressRoute() => '$addAddress';
  static String getRestaurantReviewRoute(int restaurantID) =>
      '$restaurantReview?id=$restaurantID';
  static String getAllRestaurantRoute(String page) =>
      '$allRestaurants?page=$page';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => getRoute(DashboardScreen(pageIndex: 0))),
    GetPage(name: imageView, page: () => getRoute(ImageView())),
    GetPage(
        name: splash,
        page: () => SplashScreen(
            orderID:
                Get.parameters['id'] == 'null' ? null : Get.parameters['id'])),
    GetPage(
        name: language,
        page: () =>
            ChooseLanguageScreen(fromMenu: Get.parameters['page'] == 'menu')),
    GetPage(name: onBoarding, page: () => OnBoardingScreen()),
    GetPage(
        name: signIn,
        page: () => SignInScreen(
              exitFromApp: Get.parameters['page'] == signUp ||
                  Get.parameters['page'] == splash ||
                  Get.parameters['page'] == onBoarding,
            )),
    GetPage(name: signUp, page: () => SignUpScreen()),
    GetPage(
        name: verification,
        page: () {
          List<int> _decode =
              base64Decode(Get.parameters['pass'].replaceAll(' ', '+'));
          String _data = utf8.decode(_decode);
          return VerificationScreen(
            number: Get.parameters['number'],
            fromSignUp: Get.parameters['page'] == signUp,
            token: Get.parameters['token'],
            password: _data,
          );
        }),
    GetPage(
        name: accessLocation,
        page: () => AccessLocationScreen(
              fromSignUp: Get.parameters['page'] == signUp,
              fromHome: Get.parameters['page'] == 'home',
              route: null,
            )),
    GetPage(
        name: pickMap,
        page: () {
          PickMapScreen _pickMapScreen = Get.arguments;
          bool _fromAddress = Get.parameters['page'] == 'add-address';
          return (_fromAddress && _pickMapScreen == null)
              ? NotFound()
              : _pickMapScreen != null
                  ? _pickMapScreen
                  : PickMapScreen(
                      fromSignUp: Get.parameters['page'] == signUp,
                      fromAddAddress: _fromAddress,
                      route: Get.parameters['page'],
                      canRoute: Get.parameters['route'] == 'true',
                    );
        }),
    GetPage(name: interest, page: () => InterestScreen()),
    GetPage(
        name: main,
        page: () => getRoute(DashboardScreen(
              pageIndex: Get.parameters['page'] == 'home'
                  ? 0
                  : Get.parameters['page'] == 'favourite'
                      ? 1
                      : Get.parameters['page'] == 'cart'
                          ? 2
                          : Get.parameters['page'] == 'order'
                              ? 3
                              : Get.parameters['page'] == 'menu'
                                  ? 4
                                  : 0,
            ))),
    GetPage(name: forgotPassword, page: () => ForgetPassScreen()),
    GetPage(
        name: resetPassword,
        page: () => NewPassScreen(
              resetToken: Get.parameters['token'],
              number: Get.parameters['phone'],
              fromPasswordChange: Get.parameters['page'] == 'password-change',
            )),
    GetPage(name: search, page: () => getRoute(SearchScreen())),
    GetPage(
        name: restaurant,
        page: () {
          return getRoute(Get.arguments != null
              ? Get.arguments
              : RestaurantScreen(
                  restaurant: Restaurant(id: int.parse(Get.parameters['id']))));
        }),
    GetPage(
        name: orderDetails,
        page: () {
          return getRoute(Get.arguments != null
              ? Get.arguments
              : OrderDetailsScreen(
                  orderId: int.parse(Get.parameters['id'] ?? '0'),
                  orderModel: null));
        }),
    GetPage(name: profile, page: () => getRoute(ProfileScreen())),
    GetPage(name: prescription, page: () => getRoute(PrescriptionScreen())),
    GetPage(name: updateProfile, page: () => getRoute(UpdateProfileScreen())),
    GetPage(name: coupon, page: () => getRoute(CouponScreen())),
    GetPage(name: notification, page: () => getRoute(NotificationScreen())),
    GetPage(
        name: map,
        page: () {
          List<int> _decode =
              base64Decode(Get.parameters['address'].replaceAll(' ', '+'));
          AddressModel _data =
              AddressModel.fromJson(jsonDecode(utf8.decode(_decode)));
          return getRoute(MapScreen(
              fromRestaurant: Get.parameters['page'] == 'restaurant',
              address: _data));
        }),
    GetPage(name: address, page: () => getRoute(AddressScreen())),
    GetPage(
        name: orderSuccess,
        page: () => getRoute(OrderSuccessfulScreen(
              orderID: Get.parameters['id'],
              status: Get.parameters['status'].contains('success') ? 1 : 0,
            ))),
    GetPage(
        name: payment,
        page: () => getRoute(PaymentScreen(
            orderModel: OrderModel(
                id: int.parse(Get.parameters['id']),
                userId: int.parse(
                  Get.parameters['user'],
                ))))),
    GetPage(
        name: checkout,
        page: () {
          CheckoutScreen _checkoutScreen = Get.arguments;
          bool _fromCart = Get.parameters['page'] == 'cart';
          return getRoute(_checkoutScreen != null
              ? _checkoutScreen
              : !_fromCart
                  ? NotFound()
                  : CheckoutScreen(
                      cartList: null,
                      fromCart: Get.parameters['page'] == 'cart',
                    ));
        }),
    GetPage(
        name: orderTracking,
        page: () =>
            getRoute(OrderTrackingScreen(orderID: Get.parameters['id']))),
    GetPage(
        name: basicCampaign,
        page: () => getRoute(CampaignScreen(
                campaign: BasicCampaignModel(
              id: int.parse(Get.parameters['id']),
              image: Get.parameters['image'],
              title: Get.parameters['title'],
            )))),
    GetPage(
        name: html,
        page: () => HtmlViewerScreen(
              htmlType: Get.parameters['page'] == 'terms-and-condition'
                  ? HtmlType.TERMS_AND_CONDITION
                  : Get.parameters['page'] == 'privacy-policy'
                      ? HtmlType.PRIVACY_POLICY
                      : HtmlType.ABOUT_US,
            )),
    GetPage(name: categories, page: () => getRoute(CategoryScreen())),
    GetPage(
        name: categoryProduct,
        page: () {
          List<int> _decode =
              base64Decode(Get.parameters['name'].replaceAll(' ', '+'));
          String _data = utf8.decode(_decode);
          return getRoute(CategoryProductScreen(
              categoryID: Get.parameters['id'], categoryName: _data));
        }),
    GetPage(
        name: popularFoods,
        page: () => getRoute(
            PopularFoodScreen(isPopular: Get.parameters['page'] == 'popular'))),
    GetPage(name: itemCampaign, page: () => getRoute(ItemCampaignScreen())),
    GetPage(name: support, page: () => getRoute(SupportScreen())),
    GetPage(
        name: update,
        page: () => UpdateScreen(isUpdate: Get.parameters['update'] == 'true')),
    GetPage(name: cart, page: () => getRoute(CartScreen(fromNav: false))),
    GetPage(name: addAddress, page: () => getRoute(AddAddressScreen())),
    GetPage(
        name: rateReview,
        page: () =>
            getRoute(Get.arguments != null ? Get.arguments : NotFound())),
    GetPage(
        name: restaurantReview,
        page: () => getRoute(ReviewScreen(restaurantID: Get.parameters['id']))),
    GetPage(
        name: allRestaurants,
        page: () => getRoute(AllRestaurantScreen(
            isPopular: Get.parameters['page'] == 'popular'))),
  ];

  static getRoute(Widget navigateTo) {
    int _minimumVersion = 0;
    if (GetPlatform.isAndroid) {
      _minimumVersion =
          Get.find<SplashController>().configModel.appMinimumVersionAndroid;
    } else if (GetPlatform.isIOS) {
      _minimumVersion =
          Get.find<SplashController>().configModel.appMinimumVersionIos;
    }
    return AppConstants.APP_VERSION < _minimumVersion
        ? UpdateScreen(isUpdate: true)
        : Get.find<SplashController>().configModel.maintenanceMode
            ? UpdateScreen(isUpdate: false)
            : Get.find<LocationController>().getUserAddress() != null
                ? navigateTo
                : AccessLocationScreen(
                    fromSignUp: false,
                    fromHome: false,
                    route: Get.currentRoute);
  }
}
