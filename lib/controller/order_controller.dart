import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/body/place_order_body.dart';
import 'package:efood_multivendor/data/model/response/distance_model.dart';
import 'package:efood_multivendor/data/model/response/order_details_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/data/model/response/response_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/timeslote_model.dart';
import 'package:efood_multivendor/data/repository/order_repo.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;
  OrderController({@required this.orderRepo});

  List<OrderModel> _runningOrderList;
  List<OrderModel> _historyOrderList;
  List<OrderDetailsModel> _orderDetails;
  int _paymentMethodIndex = 0;
  OrderModel _trackModel;
  ResponseModel _responseModel;
  bool _isLoading = false;
  bool _showCancelled = false;
  String _orderType = 'delivery';
  List<TimeSlotModel> _timeSlots;
  List<TimeSlotModel> _allTimeSlots;
  int _selectedDateSlot = 0;
  int _selectedTimeSlot = 0;
  double _distance;
  bool _runningPaginate = false;
  int _runningPageSize;
  List<int> _runningOffsetList = [];
  int _runningOffset = 1;
  bool _historyPaginate = false;
  int _historyPageSize;
  List<int> _historyOffsetList = [];
  int _historyOffset = 1;

  List<OrderModel> get runningOrderList => _runningOrderList;
  List<OrderModel> get historyOrderList => _historyOrderList;
  List<OrderDetailsModel> get orderDetails => _orderDetails;
  int get paymentMethodIndex => _paymentMethodIndex;
  OrderModel get trackModel => _trackModel;
  ResponseModel get responseModel => _responseModel;
  bool get isLoading => _isLoading;
  bool get showCancelled => _showCancelled;
  String get orderType => _orderType;
  List<TimeSlotModel> get timeSlots => _timeSlots;
  List<TimeSlotModel> get allTimeSlots => _allTimeSlots;
  int get selectedDateSlot => _selectedDateSlot;
  int get selectedTimeSlot => _selectedTimeSlot;
  double get distance => _distance;
  bool get runningPaginate => _runningPaginate;
  int get runningPageSize => _runningPageSize;
  int get runningOffset => _runningOffset;
  bool get historyPaginate => _historyPaginate;
  int get historyPageSize => _historyPageSize;
  int get historyOffset => _historyOffset;

  Future<void> getRunningOrders(int offset) async {
    if(offset == 1) {
      _runningOffsetList = [];
      _runningOffset = 1;
      _runningOrderList = null;
      update();
    }
    if (!_runningOffsetList.contains(offset)) {
      _runningOffsetList.add(offset);
      Response response = await orderRepo.getRunningOrderList(offset);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _runningOrderList = [];
        }
        _runningOrderList.addAll(PaginatedOrderModel.fromJson(response.body).orders);
        _runningPageSize = PaginatedOrderModel.fromJson(response.body).totalSize;
        _runningPaginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if(_runningPaginate) {
        _runningPaginate = false;
        update();
      }
    }
  }

  Future<void> getHistoryOrders(int offset) async {
    print('-----$offset');
    if(offset == 1) {
      _historyOffsetList = [];
      _historyOrderList = null;
      update();
    }
    _historyOffset = offset;
    if (!_historyOffsetList.contains(offset)) {
      _historyOffsetList.add(offset);
      Response response = await orderRepo.getHistoryOrderList(offset);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _historyOrderList = [];
        }
        _historyOrderList.addAll(PaginatedOrderModel.fromJson(response.body).orders);
        _historyPageSize = PaginatedOrderModel.fromJson(response.body).totalSize;
        _historyPaginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if(_historyPaginate) {
        _historyPaginate = false;
        update();
      }
    }
  }

  void showBottomLoader(bool isRunning) {
    if(isRunning) {
      _runningPaginate = true;
    }else {
      _historyPaginate = true;
    }
    update();
  }

  void setOffset(int offset, bool isRunning) {
    if(isRunning) {
      _runningOffset = offset;
    }else {
      _historyOffset = offset;
    }
  }

  Future<List<OrderDetailsModel>> getOrderDetails(String orderID) async {
    _orderDetails = null;
    _isLoading = true;
    _showCancelled = false;

    Response response = await orderRepo.getOrderDetails(orderID);
    _isLoading = false;
    if (response.statusCode == 200) {
      _orderDetails = [];
      response.body.forEach((orderDetail) => _orderDetails.add(OrderDetailsModel.fromJson(orderDetail)));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
    return _orderDetails;
  }

  void setPaymentMethod(int index) {
    _paymentMethodIndex = index;
    update();
  }

  Future<ResponseModel> trackOrder(String orderID, OrderModel orderModel, bool fromTracking) async {
    _trackModel = null;
    _responseModel = null;
    if(!fromTracking) {
      _orderDetails = null;
    }
    _showCancelled = false;
    if(orderModel == null) {
      _isLoading = true;
      Response response = await orderRepo.trackOrder(orderID);
      if (response.statusCode == 200) {
        _trackModel = OrderModel.fromJson(response.body);
        _responseModel = ResponseModel(true, response.body.toString());
      } else {
        _responseModel = ResponseModel(false, response.statusText);
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }else {
      _trackModel = orderModel;
      _responseModel = ResponseModel(true, 'Successful');
    }
    return _responseModel;
  }

  Future<void> placeOrder(PlaceOrderBody placeOrderBody, Function callback) async {
    _isLoading = true;
    update();
    print(placeOrderBody.toJson());
    Response response = await orderRepo.placeOrder(placeOrderBody);
    _isLoading = false;
    if (response.statusCode == 200) {
      String message = response.body['message'];
      String orderID = response.body['order_id'].toString();
      callback(true, message, orderID);
      print('-------- Order placed successfully $orderID ----------');
    } else {
      callback(false, response.statusText, '-1');
    }
    update();
  }

  void stopLoader() {
    _isLoading = false;
    update();
  }

  void clearPrevData() {
    _paymentMethodIndex = 0;
    _selectedDateSlot = 0;
    _selectedTimeSlot = 0;
    _distance = null;
  }

  void cancelOrder(int orderID) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.cancelOrder(orderID.toString());
    _isLoading = false;
    Get.back();
    if (response.statusCode == 200) {
      OrderModel orderModel;
      for(OrderModel order in _runningOrderList) {
        if(order.id == orderID) {
          orderModel = order;
          break;
        }
      }
      _runningOrderList.remove(orderModel);
      _showCancelled = true;
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      print(response.statusText);
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setOrderType(String type, {bool notify = true}) {
    _orderType = type;
    if(notify) {
      update();
    }
  }

  Future<void> initializeTimeSlot(Restaurant restaurant) async {
    DateTime _openTime;
    DateTime _closeTime;
    if(restaurant.openingTime != null) {
      _openTime = DateConverter.convertStringTimeToDate(restaurant.openingTime);
      _closeTime = DateConverter.convertStringTimeToDate(restaurant.closeingTime);
    }else {
      DateTime _now = DateTime.now();
      _openTime = DateTime(_now.year);
      _closeTime = DateTime(_now.year, _now.month, _now.day, 23, 59);
    }
    _timeSlots = [];
    _allTimeSlots = [];
    int _minutes = 0;
    DateTime _now = DateTime.now();
    _openTime = DateTime(_now.year, _now.month, _now.day, _openTime.hour, _openTime.minute);
    _closeTime = DateTime(_now.year, _now.month, _now.day, _closeTime.hour, _closeTime.minute);
    if(_closeTime.isBefore(_openTime)) {
      if(_now.isBefore(_openTime) && _now.isBefore(_closeTime)){
        _openTime = _openTime.add(Duration(days: -1));
      }else {
        _closeTime = _closeTime.add(Duration(days: 1));
      }
    }
    if(_closeTime.difference(_openTime).isNegative) {
      _minutes = _openTime.difference(_closeTime).inMinutes;
    }else {
      _minutes = _closeTime.difference(_openTime).inMinutes;
    }
    if(_minutes > 30) {
      DateTime _time = _openTime;
      for(;;) {
        if(_time.isBefore(_closeTime)) {
          DateTime _start = _time;
          DateTime _end = _start.add(Duration(minutes: 30));
          if(_end.isAfter(_closeTime)) {
            _end = _closeTime;
          }
          _timeSlots.add(TimeSlotModel(startTime: _time, endTime: _time.add(Duration(minutes: 30))));
          _allTimeSlots.add(TimeSlotModel(startTime: _time, endTime: _time.add(Duration(minutes: 30))));
          _time = _time.add(Duration(minutes: 30));
        }else {
          break;
        }
      }
    }
    validateSlot(_allTimeSlots, 0, notify: false);
  }

  void updateTimeSlot(int index) {
    _selectedTimeSlot = index;
    update();
  }

  void updateDateSlot(int index) {
    _selectedDateSlot = index;
    if(_allTimeSlots != null) {
      validateSlot(_allTimeSlots, index);
    }
    update();
  }

  void validateSlot(List<TimeSlotModel> slots, int dateIndex, {bool notify = true}) {
    _timeSlots = [];
    if(dateIndex == 0) {
      slots.forEach((slot) {
        if (slot.endTime.isAfter(DateTime.now())) {
          _timeSlots.add(slot);
        }
      });
    }else {
      _timeSlots.addAll(_allTimeSlots);
    }
    if(notify) {
      update();
    }
  }

  Future<bool> switchToCOD(String orderID) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.switchToCOD(orderID);
    bool _isSuccess;
    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
      showCustomSnackBar(response.body['message'], isError: false);
      _isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }

  Future<double> getDistanceInMeter(LatLng originLatLng, LatLng destinationLatLng) async {
    Response response = await orderRepo.getDistanceInMeter(originLatLng, destinationLatLng);
    try {
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        _distance = DistanceModel.fromJson(response.body).rows[0].elements[0].distance.value / 1000;
      } else {
        _distance = Geolocator.distanceBetween(
          originLatLng.latitude, originLatLng.longitude, destinationLatLng.latitude, destinationLatLng.longitude,
        ) / 1000;
      }
    } catch (e) {
      _distance = Geolocator.distanceBetween(
        originLatLng.latitude, originLatLng.longitude, destinationLatLng.latitude, destinationLatLng.longitude,
      ) / 1000;
    }
    update();
    return _distance;
  }

}