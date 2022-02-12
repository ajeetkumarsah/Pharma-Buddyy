import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/data/model/body/review_body.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ProductRepo extends GetxService {
  final ApiClient apiClient;
  ProductRepo({@required this.apiClient});

  Future<Response> getPopularProductList() async {
    return await apiClient.getData(AppConstants.POPULAR_PRODUCT_URI);
  }

  Future<Response> getReviewedProductList() async {
    return await apiClient.getData(AppConstants.REVIEWED_PRODUCT_URI);
  }

  Future<Response> searchProduct(String productId) async {
    return await apiClient.getData('${AppConstants.SEARCH_PRODUCT_URI}$productId');
  }

  Future<Response> submitReview(ReviewBody reviewBody) async {
    return await apiClient.postData(AppConstants.REVIEW_URI, reviewBody.toJson());
  }

  Future<Response> submitDeliveryManReview(ReviewBody reviewBody) async {
    return await apiClient.postData(AppConstants.DELIVER_MAN_REVIEW_URI, reviewBody.toJson());
  }
}
