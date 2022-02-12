import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/response/category_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/review_model.dart';
import 'package:efood_multivendor/data/repository/restaurant_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantController extends GetxController implements GetxService {
  final RestaurantRepo restaurantRepo;
  RestaurantController({@required this.restaurantRepo});

  List<Restaurant> _restaurantList;
  List<Restaurant> _popularRestaurantList;
  List<Restaurant> _latestRestaurantList;
  Restaurant _restaurant;
  List<Product> _restaurantProducts;
  int _categoryIndex = 0;
  List<CategoryModel> _categoryList;
  bool _isLoading = false;
  int _pageSize;
  List<String> _offsetList = [];
  int _offset = 1;
  String _restaurantType = 'all';
  List<ReviewModel> _restaurantReviewList;
  bool _foodPaginate = false;
  int _foodPageSize;
  List<int> _foodOffsetList = [];
  int _foodOffset = 1;

  List<Restaurant> get restaurantList => _restaurantList;
  List<Restaurant> get popularRestaurantList => _popularRestaurantList;
  List<Restaurant> get latestRestaurantList => _latestRestaurantList;
  Restaurant get restaurant => _restaurant;
  List<Product> get restaurantProducts => _restaurantProducts;
  int get categoryIndex => _categoryIndex;
  List<CategoryModel> get categoryList => _categoryList;
  bool get isLoading => _isLoading;
  int get popularPageSize => _pageSize;
  int get offset => _offset;
  String get restaurantType => _restaurantType;
  List<ReviewModel> get restaurantReviewList => _restaurantReviewList;
  bool get foodPaginate => _foodPaginate;
  int get foodPageSize => _foodPageSize;
  int get foodOffset => _foodOffset;

  void setOffset(int offset) {
    _offset = offset;
  }

  Future<void> getRestaurantList(String offset, bool reload) async {
    if(offset == '1' || reload) {
      _offsetList = [];
      _offset = 1;
      if(reload) {
        _restaurantList = null;
      }
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      Response response = await restaurantRepo.getRestaurantList(offset, _restaurantType);
      if (response.statusCode == 200) {
        if (offset == '1') {
          _restaurantList = [];
        }
        _restaurantList.addAll(RestaurantModel.fromJson(response.body).restaurants);
        _pageSize = RestaurantModel.fromJson(response.body).totalSize;
        _isLoading = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void setRestaurantType(String type) {
    _restaurantType = type;
    getRestaurantList('1', true);
  }

  Future<void> getPopularRestaurantList(bool reload) async {
    if(_popularRestaurantList == null || reload) {
      Response response = await restaurantRepo.getPopularRestaurantList();
      if (response.statusCode == 200) {
        _popularRestaurantList = [];
        response.body.forEach((restaurant) => _popularRestaurantList.add(Restaurant.fromJson(restaurant)));
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  Future<void> getLatestRestaurantList(bool reload) async {
    if(_latestRestaurantList == null || reload) {
      Response response = await restaurantRepo.getLatestRestaurantList();
      if (response.statusCode == 200) {
        _latestRestaurantList = [];
        response.body.forEach((restaurant) => _latestRestaurantList.add(Restaurant.fromJson(restaurant)));
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void setCategoryList() {
    if(Get.find<CategoryController>().categoryList != null && _restaurant != null) {
      _categoryList = [];
      _categoryList.add(CategoryModel(id: 0, name: 'all'.tr));
      Get.find<CategoryController>().categoryList.forEach((category) {
        if(_restaurant.categoryIds.contains(category.id)) {
          _categoryList.add(category);
        }
      });
    }
  }

  void initCheckoutData(int restaurantID) {
    if(_restaurant == null || _restaurant.id != restaurantID || Get.find<OrderController>().distance == null) {
      Get.find<CouponController>().removeCouponData(false);
      Get.find<OrderController>().clearPrevData();
      Get.find<RestaurantController>().getRestaurantDetails(Restaurant(id: restaurantID));
    }else {
      Get.find<OrderController>().initializeTimeSlot(_restaurant);
    }
  }

  Future<Restaurant> getRestaurantDetails(Restaurant restaurant) async {
    _categoryIndex = 0;
    if(restaurant.name != null) {
      _restaurant = restaurant;
    }else {
      _isLoading = true;
      _restaurant = null;
      Response response = await restaurantRepo.getRestaurantDetails(restaurant.id.toString());
      if (response.statusCode == 200) {
        _restaurant = Restaurant.fromJson(response.body);
        Get.find<OrderController>().initializeTimeSlot(_restaurant);
        Get.find<OrderController>().getDistanceInMeter(
          LatLng(
            double.parse(Get.find<LocationController>().getUserAddress().latitude),
            double.parse(Get.find<LocationController>().getUserAddress().longitude),
          ),
          LatLng(double.parse(_restaurant.latitude), double.parse(_restaurant.longitude)),
        );
      } else {
        ApiChecker.checkApi(response);
      }
      Get.find<OrderController>().setOrderType(
        _restaurant != null ? _restaurant.delivery ? 'delivery' : 'take_away' : 'delivery', notify: false,
      );

      _isLoading = false;
      update();
    }
    return _restaurant;
  }

  Future<void> getRestaurantProductList(int restaurantID, int offset) async {
    _foodOffset = offset;
    if(offset == 1 || _restaurantProducts == null) {
      _foodOffsetList = [];
      _restaurantProducts = null;
      _foodOffset = 1;
    }
    if (!_foodOffsetList.contains(offset)) {
      _foodOffsetList.add(offset);
      Response response = await restaurantRepo.getRestaurantProductList(
        restaurantID, offset,
        (_restaurant != null && _restaurant.categoryIds.length > 0 && _categoryIndex != 0)
            ? _categoryList[_categoryIndex].id : 0,
      );
      if (response.statusCode == 200) {
        if (offset == 1) {
          _restaurantProducts = [];
        }
        _restaurantProducts.addAll(ProductModel.fromJson(response.body).products);
        _foodPageSize = ProductModel.fromJson(response.body).totalSize;
        _foodPaginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if(_foodPaginate) {
        _foodPaginate = false;
        update();
      }
    }
  }

  void showFoodBottomLoader() {
    _foodPaginate = true;
    update();
  }

  void setFoodOffset(int offset) {
    _foodOffset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setCategoryIndex(int index) {
    _categoryIndex = index;
    _restaurantProducts = null;
    getRestaurantProductList(_restaurant.id, _offset);
    update();
  }

  Future<void> getRestaurantReviewList(String restaurantID) async {
    _restaurantReviewList = null;
    Response response = await restaurantRepo.getRestaurantReviewList(restaurantID);
    if (response.statusCode == 200) {
      _restaurantReviewList = [];
      response.body.forEach((review) => _restaurantReviewList.add(ReviewModel.fromJson(review)));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  bool isRestaurantClosed(bool today, bool active, String offDay) {
    offDay = offDay.trim();
    DateTime _date = DateTime.now();
    if(!today) {
      _date = _date.add(Duration(days: 1));
    }
    for(int index=0; index<offDay.length; index++) {
      if(_date.weekday == int.parse(offDay[index])) {
        return true;
      }
    }
    return !active;
  }

}