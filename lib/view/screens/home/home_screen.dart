import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/banner_controller.dart';
import 'package:efood_multivendor/controller/campaign_controller.dart';
import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/notification_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/home/web_home_screen.dart';
import 'package:efood_multivendor/view/screens/home/widget/popular_food_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/item_campaign_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/popular_restaurant_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/restaurant_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/banner_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/category_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _loadData(bool reload) async {
    await Get.find<BannerController>().getBannerList(reload);
    await Get.find<CategoryController>().getCategoryList(reload);
    await Get.find<RestaurantController>().getPopularRestaurantList(reload);
    await Get.find<CampaignController>().getItemCampaignList(reload);
    await Get.find<ProductController>().getPopularProductList(reload);
    await Get.find<RestaurantController>().getLatestRestaurantList(reload);
    await Get.find<ProductController>().getReviewedProductList(reload);
    await Get.find<RestaurantController>().getRestaurantList('1', reload);
    if (Get.find<AuthController>().isLoggedIn()) {
      await Get.find<UserController>().getUserInfo();
      await Get.find<NotificationController>().getNotificationList(reload);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    _loadData(false);
    ConfigModel _configModel = Get.find<SplashController>().configModel;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      backgroundColor: ResponsiveHelper.isDesktop(context)
          ? Theme.of(context).cardColor
          : null,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadData(true);
          },
          child: ResponsiveHelper.isDesktop(context)
              ? WebHomeScreen(scrollController: _scrollController)
              : CustomScrollView(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      floating: true,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: ResponsiveHelper.isDesktop(context)
                          ? Colors.transparent
                          : Theme.of(context).backgroundColor,
                      title: Center(
                          child: Container(
                        width: Dimensions.WEB_MAX_WIDTH,
                        height: 50,
                        color: Theme.of(context).backgroundColor,
                        child: Row(children: [
                          Expanded(
                              child: InkWell(
                            onTap: () => Get.toNamed(
                                RouteHelper.getAccessLocationRoute('home')),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_SMALL,
                                horizontal: ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.PADDING_SIZE_SMALL
                                    : 0,
                              ),
                              child: GetBuilder<LocationController>(
                                  builder: (locationController) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      locationController
                                                  .getUserAddress()
                                                  .addressType ==
                                              'home'
                                          ? Icons.home_filled
                                          : locationController
                                                      .getUserAddress()
                                                      .addressType ==
                                                  'office'
                                              ? Icons.work
                                              : Icons.location_on,
                                      size: 20,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        locationController
                                            .getUserAddress()
                                            .address,
                                        style: robotoRegular.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .color,
                                          fontSize: Dimensions.fontSizeSmall,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(Icons.arrow_drop_down,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color),
                                  ],
                                );
                              }),
                            ),
                          )),
                          InkWell(
                            child: GetBuilder<NotificationController>(
                                builder: (notificationController) {
                              bool _hasNewNotification = false;
                              if (notificationController.notificationList !=
                                  null) {
                                _hasNewNotification = notificationController
                                        .notificationList.length !=
                                    notificationController
                                        .getSeenNotificationCount();
                              }
                              return Stack(children: [
                                Icon(Icons.notifications,
                                    size: 25,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color),
                                _hasNewNotification
                                    ? Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .cardColor),
                                          ),
                                        ))
                                    : SizedBox(),
                              ]);
                            }),
                            onTap: () =>
                                Get.toNamed(RouteHelper.getNotificationRoute()),
                          ),
                        ]),
                      )),
                    ),

                    // Search Button
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverDelegate(
                          child: Center(
                              child: Container(
                        height: 50,
                        width: Dimensions.WEB_MAX_WIDTH,
                        color: Theme.of(context).backgroundColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_SMALL),
                        child: InkWell(
                          onTap: () =>
                              Get.toNamed(RouteHelper.getSearchRoute()),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SMALL),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        Colors.grey[Get.isDarkMode ? 800 : 200],
                                    spreadRadius: 1,
                                    blurRadius: 5)
                              ],
                            ),
                            child: Row(children: [
                              Icon(Icons.search,
                                  size: 25,
                                  color: Theme.of(context).primaryColor),
                              SizedBox(
                                  width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Expanded(
                                  child: Text('Search Medicine or Pharmacy'.tr,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).hintColor,
                                      ))),
                            ]),
                          ),
                        ),
                      ))),
                    ),

                    SliverToBoxAdapter(
                      child: Center(
                          child: SizedBox(
                              width: Dimensions.WEB_MAX_WIDTH,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GetBuilder<BannerController>(
                                        builder: (bannerController) {
                                      return bannerController.bannerImageList ==
                                              null
                                          ? BannerView(
                                              bannerController:
                                                  bannerController)
                                          : bannerController
                                                      .bannerImageList.length ==
                                                  0
                                              ? SizedBox()
                                              : BannerView(
                                                  bannerController:
                                                      bannerController);
                                    }),
                                    GetBuilder<CategoryController>(
                                        builder: (categoryController) {
                                      return categoryController.categoryList ==
                                              null
                                          ? CategoryView(
                                              categoryController:
                                                  categoryController)
                                          : categoryController
                                                      .categoryList.length ==
                                                  0
                                              ? SizedBox()
                                              : CategoryView(
                                                  categoryController:
                                                      categoryController);
                                    }),
                                    _configModel.popularRestaurant == 1
                                        ? GetBuilder<RestaurantController>(
                                            builder: (restController) {
                                            return restController
                                                        .popularRestaurantList ==
                                                    null
                                                ? PopularRestaurantView(
                                                    restController:
                                                        restController,
                                                    isPopular: true)
                                                : restController
                                                            .popularRestaurantList
                                                            .length ==
                                                        0
                                                    ? SizedBox()
                                                    : PopularRestaurantView(
                                                        restController:
                                                            restController,
                                                        isPopular: true);
                                          })
                                        : SizedBox(),
                                    GetBuilder<CampaignController>(
                                        builder: (campaignController) {
                                      return campaignController
                                                  .itemCampaignList ==
                                              null
                                          ? ItemCampaignView(
                                              campaignController:
                                                  campaignController)
                                          : campaignController.itemCampaignList
                                                      .length ==
                                                  0
                                              ? SizedBox()
                                              : ItemCampaignView(
                                                  campaignController:
                                                      campaignController);
                                    }),
                                    _configModel.popularFood == 1
                                        ? GetBuilder<ProductController>(
                                            builder: (productController) {
                                            return productController
                                                        .popularProductList ==
                                                    null
                                                ? PopularFoodView(
                                                    productController:
                                                        productController,
                                                    isPopular: true)
                                                : productController
                                                            .popularProductList
                                                            .length ==
                                                        0
                                                    ? SizedBox()
                                                    : PopularFoodView(
                                                        productController:
                                                            productController,
                                                        isPopular: true);
                                          })
                                        : SizedBox(),
                                    _configModel.newRestaurant == 1
                                        ? GetBuilder<RestaurantController>(
                                            builder: (restController) {
                                            return restController
                                                        .latestRestaurantList ==
                                                    null
                                                ? PopularRestaurantView(
                                                    restController:
                                                        restController,
                                                    isPopular: false)
                                                : restController
                                                            .latestRestaurantList
                                                            .length ==
                                                        0
                                                    ? SizedBox()
                                                    : PopularRestaurantView(
                                                        restController:
                                                            restController,
                                                        isPopular: false);
                                          })
                                        : SizedBox(),
                                    _configModel.mostReviewedFoods == 1
                                        ? GetBuilder<ProductController>(
                                            builder: (productController) {
                                            return productController
                                                        .reviewedProductList ==
                                                    null
                                                ? PopularFoodView(
                                                    productController:
                                                        productController,
                                                    isPopular: false)
                                                : productController
                                                            .reviewedProductList
                                                            .length ==
                                                        0
                                                    ? SizedBox()
                                                    : PopularFoodView(
                                                        productController:
                                                            productController,
                                                        isPopular: false);
                                          })
                                        : SizedBox(),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 15, 0, 5),
                                      child: GetBuilder<RestaurantController>(
                                          builder: (restaurantController) {
                                        return Row(children: [
                                          Expanded(
                                              child: Text('all_pharmacies'.tr,
                                                  style: robotoMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeLarge))),
                                          restaurantController.restaurantList !=
                                                  null
                                              ? PopupMenuButton(
                                                  itemBuilder: (context) {
                                                    return [
                                                      PopupMenuItem(
                                                          value: 'all',
                                                          child: Text('all'.tr),
                                                          textStyle:
                                                              robotoMedium
                                                                  .copyWith(
                                                            color: restaurantController
                                                                        .restaurantType ==
                                                                    'all'
                                                                ? Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1
                                                                    .color
                                                                : Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                          )),
                                                      PopupMenuItem(
                                                          value: 'take_away',
                                                          child: Text(
                                                              'take_away'.tr),
                                                          textStyle:
                                                              robotoMedium
                                                                  .copyWith(
                                                            color: restaurantController
                                                                        .restaurantType ==
                                                                    'take_away'
                                                                ? Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1
                                                                    .color
                                                                : Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                          )),
                                                      PopupMenuItem(
                                                          value: 'delivery',
                                                          child: Text(
                                                              'delivery'.tr),
                                                          textStyle:
                                                              robotoMedium
                                                                  .copyWith(
                                                            color: restaurantController
                                                                        .restaurantType ==
                                                                    'delivery'
                                                                ? Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1
                                                                    .color
                                                                : Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                          )),
                                                    ];
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .RADIUS_SMALL)),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .PADDING_SIZE_SMALL),
                                                    child:
                                                        Icon(Icons.filter_list),
                                                  ),
                                                  onSelected: (value) =>
                                                      restaurantController
                                                          .setRestaurantType(
                                                              value),
                                                )
                                              : SizedBox(),
                                        ]);
                                      }),
                                    ),
                                    RestaurantView(
                                        scrollController: _scrollController),
                                  ]))),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
