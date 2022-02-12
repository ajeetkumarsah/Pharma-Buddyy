import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularFoodScreen extends StatelessWidget {
  final bool isPopular;
  PopularFoodScreen({@required this.isPopular});

  @override
  Widget build(BuildContext context) {
    if(isPopular) {
      Get.find<ProductController>().getPopularProductList(true);
    }else {
      Get.find<ProductController>().getReviewedProductList(true);
    }

    return Scaffold(
      appBar: CustomAppBar(title: isPopular ? 'popular_foods_nearby'.tr : 'best_reviewed_food'.tr, showCart: true),
      body: Scrollbar(child: SingleChildScrollView(child: Center(child: SizedBox(
        width: Dimensions.WEB_MAX_WIDTH,
        child: GetBuilder<ProductController>(builder: (productController) {
          return ProductView(
            isRestaurant: false, restaurants: null,
            products: isPopular ? productController.popularProductList : productController.reviewedProductList,
          );
        }),
      )))),
    );
  }
}
