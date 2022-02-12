import 'package:efood_multivendor/controller/banner_controller.dart';
import 'package:efood_multivendor/controller/campaign_controller.dart';
import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/home/web/web_banner_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_popular_food_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_category_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_campaign_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_popular_restaurant_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/restaurant_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebHomeScreen extends StatelessWidget {
  final ScrollController scrollController;
  WebHomeScreen({@required this.scrollController});

  @override
  Widget build(BuildContext context) {
    Get.find<BannerController>().setCurrentIndex(0, false);
    ConfigModel _configModel = Get.find<SplashController>().configModel;

    return CustomScrollView(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [

        SliverToBoxAdapter(child: GetBuilder<BannerController>(builder: (bannerController) {
          return bannerController.bannerImageList == null ? WebBannerView(bannerController: bannerController)
              : bannerController.bannerImageList.length == 0 ? SizedBox() : WebBannerView(bannerController: bannerController);
        })),


        SliverToBoxAdapter(
          child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

            GetBuilder<CategoryController>(builder: (categoryController) {
              return categoryController.categoryList == null ? WebCategoryView(categoryController: categoryController)
                  : categoryController.categoryList.length == 0 ? SizedBox() : WebCategoryView(categoryController: categoryController);
            }),
            SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                _configModel.popularRestaurant == 1 ? GetBuilder<RestaurantController>(builder: (restController) {
                  return restController.popularRestaurantList == null ? WebPopularRestaurantView(restController: restController, isPopular: true)
                      : restController.popularRestaurantList.length == 0 ? SizedBox() : WebPopularRestaurantView(restController: restController, isPopular: true);
                }) : SizedBox(),

                GetBuilder<CampaignController>(builder: (campaignController) {
                  return campaignController.itemCampaignList == null ? WebCampaignView(campaignController: campaignController)
                      : campaignController.itemCampaignList.length == 0 ? SizedBox() : WebCampaignView(campaignController: campaignController);
                }),

                _configModel.popularFood == 1 ? GetBuilder<ProductController>(builder: (productController) {
                  return productController.popularProductList == null ? WebPopularFoodView(productController: productController, isPopular: true)
                      : productController.popularProductList.length == 0 ? SizedBox() : WebPopularFoodView(productController: productController, isPopular: true);
                }) : SizedBox(),

                _configModel.newRestaurant == 1 ? GetBuilder<RestaurantController>(builder: (restController) {
                  return restController.latestRestaurantList == null ? WebPopularRestaurantView(restController: restController, isPopular: false)
                      : restController.latestRestaurantList.length == 0 ? SizedBox() : WebPopularRestaurantView(restController: restController, isPopular: false);
                }) : SizedBox(),

                _configModel.mostReviewedFoods == 1 ? GetBuilder<ProductController>(builder: (productController) {
                  return productController.reviewedProductList == null ? WebPopularFoodView(productController: productController, isPopular: false)
                      : productController.reviewedProductList.length == 0 ? SizedBox() : WebPopularFoodView(productController: productController, isPopular: false);
                }) : SizedBox(),

                Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 0, 5),
                  child: GetBuilder<RestaurantController>(builder: (restaurantController) {
                    return Row(children: [
                      Expanded(child: Text('all_restaurants'.tr, style: robotoMedium.copyWith(fontSize: 24))),
                      restaurantController.restaurantList != null ? PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(value: 'all', child: Text('all'.tr), textStyle: robotoMedium.copyWith(
                              color: restaurantController.restaurantType == 'all'
                                  ? Theme.of(context).textTheme.bodyText1.color : Theme.of(context).disabledColor,
                            )),
                            PopupMenuItem(value: 'take_away', child: Text('take_away'.tr), textStyle: robotoMedium.copyWith(
                              color: restaurantController.restaurantType == 'take_away'
                                  ? Theme.of(context).textTheme.bodyText1.color : Theme.of(context).disabledColor,
                            )),
                            PopupMenuItem(value: 'delivery', child: Text('delivery'.tr), textStyle: robotoMedium.copyWith(
                              color: restaurantController.restaurantType == 'delivery'
                                  ? Theme.of(context).textTheme.bodyText1.color : Theme.of(context).disabledColor,
                            )),
                          ];
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                          child: Icon(Icons.filter_list),
                        ),
                        onSelected: (value) => restaurantController.setRestaurantType(value),
                      ) : SizedBox(),
                    ]);
                  }),
                ),
                RestaurantView(scrollController: scrollController),

              ]),
            ),

          ]))),
        ),
      ],
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}
