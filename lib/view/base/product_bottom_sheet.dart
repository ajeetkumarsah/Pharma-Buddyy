import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/quantity_button.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/checkout/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductBottomSheet extends StatefulWidget {
  final Product product;
  final bool isCampaign;
  final CartModel cart;
  final int cartIndex;
  final bool inRestaurantPage;
  ProductBottomSheet({@required this.product, this.isCampaign = false, this.cart, this.cartIndex, this.inRestaurantPage = false});

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {

  @override
  void initState() {
    super.initState();

    Get.find<ProductController>().initData(widget.product, widget.cart);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT, bottom: Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context) ? BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_EXTRA_LARGE))
            : BorderRadius.all(Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
      ),
      child: GetBuilder<ProductController>(builder: (productController) {
        double _startingPrice;
        double _endingPrice;
        if (widget.product.choiceOptions.length != 0) {
          List<double> _priceList = [];
          widget.product.variations.forEach((variation) => _priceList.add(variation.price));
          _priceList.sort((a, b) => a.compareTo(b));
          _startingPrice = _priceList[0];
          if (_priceList[0] < _priceList[_priceList.length - 1]) {
            _endingPrice = _priceList[_priceList.length - 1];
          }
        } else {
          _startingPrice = widget.product.price;
        }

        List<String> _variationList = [];
        for (int index = 0; index < widget.product.choiceOptions.length; index++) {
          _variationList.add(widget.product.choiceOptions[index].options[productController.variationIndex[index]].replaceAll(' ', ''));
        }
        String variationType = '';
        bool isFirst = true;
        _variationList.forEach((variation) {
          if (isFirst) {
            variationType = '$variationType$variation';
            isFirst = false;
          } else {
            variationType = '$variationType-$variation';
          }
        });

        double price = widget.product.price;
        Variation _variation;
        for (Variation variation in widget.product.variations) {
          if (variation.type == variationType) {
            price = variation.price;
            _variation = variation;
            break;
          }
        }

        double _discount = (widget.isCampaign || widget.product.restaurantDiscount == 0) ? widget.product.discount : widget.product.restaurantDiscount;
        String _discountType = (widget.isCampaign || widget.product.restaurantDiscount == 0) ? widget.product.discountType : 'percent';
        double priceWithDiscount = PriceConverter.convertWithDiscount(price, _discount, _discountType);
        double priceWithQuantity = priceWithDiscount * productController.quantity;
        double addonsCost = 0;
        List<AddOn> _addOnIdList = [];
        List<AddOns> _addOnsList = [];
        for (int index = 0; index < widget.product.addOns.length; index++) {
          if (productController.addOnActiveList[index]) {
            addonsCost = addonsCost + (widget.product.addOns[index].price * productController.addOnQtyList[index]);
            _addOnIdList.add(AddOn(id: widget.product.addOns[index].id, quantity: productController.addOnQtyList[index]));
            _addOnsList.add(widget.product.addOns[index]);
          }
        }
        double priceWithAddons = priceWithQuantity + addonsCost;
        bool _isRestAvailable = DateConverter.isAvailable(widget.product.restaurantOpeningTime, widget.product.restaurantClosingTime);
        bool _isFoodAvailable = DateConverter.isAvailable(widget.product.availableTimeStarts, widget.product.availableTimeEnds);
        bool _isAvailable = _isRestAvailable && _isFoodAvailable;

        CartModel _cartModel = CartModel(
          price, priceWithDiscount, _variation != null ? [_variation] : [],
          (price - PriceConverter.convertWithDiscount(price, _discount, _discountType)),
          productController.quantity, _addOnIdList, _addOnsList, widget.isCampaign, widget.product,
        );
        //bool isExistInCart = Get.find<CartController>().isExistInCart(_cartModel, fromCart, cartIndex);

        return SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
            ResponsiveHelper.isDesktop(context) ? InkWell(onTap: () => Get.back(), child: Icon(Icons.close)) : SizedBox(),
            Padding(
              padding: EdgeInsets.only(
                right: Dimensions.PADDING_SIZE_DEFAULT, top: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.PADDING_SIZE_DEFAULT,
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                //Product
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: CustomImage(
                        image: '${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl
                            : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${widget.product.image}',
                        width: ResponsiveHelper.isMobile(context) ? 100 : 140,
                        height: ResponsiveHelper.isMobile(context) ? 100 : 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                    DiscountTag(discount: _discount, discountType: _discountType, fromTop: 20),
                  ]),
                  SizedBox(width: 10),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Expanded(
                          child: Text(
                            widget.product.name, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        widget.isCampaign ? SizedBox() : GetBuilder<WishListController>(builder: (wishList) {
                          return InkWell(
                            onTap: () {
                              if(Get.find<AuthController>().isLoggedIn()) {
                                wishList.wishProductIdList.contains(widget.product.id) ? wishList.removeFromWishList(widget.product.id, false)
                                    : wishList.addToWishList(widget.product, null, false);
                              }else {
                                showCustomSnackBar('you_are_not_logged_in'.tr);
                              }
                            },
                            child: Icon(
                              wishList.wishProductIdList.contains(widget.product.id) ? Icons.favorite : Icons.favorite_border,
                              color: wishList.wishProductIdList.contains(widget.product.id) ? Theme.of(context).primaryColor
                                  : Theme.of(context).disabledColor,
                            ),
                          );
                        }),
                      ]),
                      InkWell(
                        onTap: () {
                          if(widget.inRestaurantPage) {
                            Get.back();
                          }else {
                            Get.offNamed(RouteHelper.getRestaurantRoute(widget.product.restaurantId));
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                          child: Text(
                            widget.product.restaurantName,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      RatingBar(rating: widget.product.avgRating, size: 15, ratingCount: widget.product.ratingCount),
                      SizedBox(height: 5),
                      Text(
                        '${PriceConverter.convertPrice(_startingPrice, discount: _discount, discountType: _discountType)}'
                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice, discount: _discount,
                            discountType: _discountType)}' : ''}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                      SizedBox(height: 5),
                      price > priceWithDiscount ? Text(
                        '${PriceConverter.convertPrice(_startingPrice)}'
                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice)}' : ''}',
                        style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough),
                      ) : SizedBox(),
                    ]),
                  ),
                ]),

                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                (widget.product.description != null && widget.product.description.isNotEmpty) ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('description'.tr, style: robotoMedium),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(widget.product.description, style: robotoRegular),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  ],
                ) : SizedBox(),

                // Variation
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.product.choiceOptions.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(widget.product.choiceOptions[index].title, style: robotoMedium),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isMobile(context) ? 3 : 4,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 10,
                          childAspectRatio: (1 / 0.25),
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.product.choiceOptions[index].options.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              productController.setCartVariationIndex(index, i);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              decoration: BoxDecoration(
                                color:
                                productController.variationIndex[index] != i ? Theme.of(context).backgroundColor : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                border:
                                productController.variationIndex[index] != i ? Border.all(color: Theme.of(context).disabledColor, width: 2) : null,
                              ),
                              child: Text(
                                widget.product.choiceOptions[index].options[i].trim(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: robotoRegular.copyWith(
                                  color: productController.variationIndex[index] != i ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: index != widget.product.choiceOptions.length - 1 ? Dimensions.PADDING_SIZE_LARGE : 0),
                    ]);
                  },
                ),
                widget.product.choiceOptions.length > 0 ? SizedBox(height: Dimensions.PADDING_SIZE_LARGE) : SizedBox(),

                // Quantity
                Row(children: [
                  Text('quantity'.tr, style: robotoMedium),
                  Expanded(child: SizedBox()),
                  Row(children: [
                    QuantityButton(
                      onTap: () {
                        if (productController.quantity > 1) {
                          productController.setQuantity(false);
                        }
                      },
                      isIncrement: false,
                    ),
                    Text(productController.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    QuantityButton(
                      onTap: () => productController.setQuantity(true),
                      isIncrement: true,
                    ),
                  ]),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                // Addons
                widget.product.addOns.length > 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('addons'.tr, style: robotoMedium),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 20, mainAxisSpacing: 10, childAspectRatio: (1 / 1.1),
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.product.addOns.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (!productController.addOnActiveList[index]) {
                            productController.addAddOn(true, index);
                          } else if (productController.addOnQtyList[index] == 1) {
                            productController.addAddOn(false, index);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: productController.addOnActiveList[index] ? 2 : 20),
                          decoration: BoxDecoration(
                            color: productController.addOnActiveList[index] ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            border: productController.addOnActiveList[index] ? null : Border.all(color: Theme.of(context).disabledColor, width: 2),
                            boxShadow: productController.addOnActiveList[index]
                            ? [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)] : null,
                          ),
                          child: Column(children: [
                            Expanded(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text(widget.product.addOns[index].name,
                                  maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                  style: robotoMedium.copyWith(
                                    color: productController.addOnActiveList[index] ? Colors.white : Colors.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  widget.product.addOns[index].price > 0 ? PriceConverter.convertPrice(widget.product.addOns[index].price) : 'free'.tr,
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(
                                    color: productController.addOnActiveList[index] ? Colors.white : Colors.black,
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                  ),
                                ),
                              ]),
                            ),
                            productController.addOnActiveList[index] ? Container(
                              height: 25,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Theme.of(context).cardColor),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (productController.addOnQtyList[index] > 1) {
                                        productController.setAddOnQuantity(false, index);
                                      } else {
                                        productController.addAddOn(false, index);
                                      }
                                    },
                                    child: Center(child: Icon(Icons.remove, size: 15)),
                                  ),
                                ),
                                Text(
                                  productController.addOnQtyList[index].toString(),
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => productController.setAddOnQuantity(true, index),
                                    child: Center(child: Icon(Icons.add, size: 15)),
                                  ),
                                ),
                              ]),
                            )
                                : SizedBox(),
                          ]),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                ]) : SizedBox(),

                Row(children: [
                  Text('${'total_amount'.tr}:', style: robotoMedium),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(PriceConverter.convertPrice(priceWithAddons), style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                //Add to cart Button

                _isAvailable ? SizedBox() : Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  child: !_isRestAvailable ? Text(
                    'restaurant_is_closed_now'.tr, style: robotoMedium.copyWith(
                    color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge,
                  ),
                  ) : Column(children: [
                    Text('not_available_now'.tr, style: robotoMedium.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge,
                    )),
                    Text(
                      '${'available_will_be'.tr} ${DateConverter.convertTimeToTime(widget.product.availableTimeStarts)} '
                          '- ${DateConverter.convertTimeToTime(widget.product.availableTimeEnds)}',
                      style: robotoRegular,
                    ),
                  ]),
                ),

                (!widget.product.scheduleOrder && !_isAvailable) ? SizedBox() : Row(children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50, 50),
                      primary: Theme.of(context).cardColor, shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                    ),
                    ),
                    onPressed: () {
                      if(widget.inRestaurantPage) {
                        Get.back();
                      }else {
                        Get.offNamed(RouteHelper.getRestaurantRoute(widget.product.restaurantId));
                      }
                    },
                    child: Image.asset(Images.house, color: Theme.of(context).primaryColor, height: 30, width: 30),
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Expanded(child: CustomButton(
                    width: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.width / 2.0 : null,
                    /*buttonText: isCampaign ? 'order_now'.tr : isExistInCart ? 'already_added_in_cart'.tr : fromCart
                        ? 'update_in_cart'.tr : 'add_to_cart'.tr,*/
                    buttonText: widget.isCampaign ? 'order_now'.tr : widget.cart != null ? 'update_in_cart'.tr : 'add_to_cart'.tr,
                    onPressed: () {
                      Get.back();
                      if(widget.isCampaign) {
                        Get.toNamed(RouteHelper.getCheckoutRoute('campaign'), arguments: CheckoutScreen(
                          fromCart: false, cartList: [_cartModel],
                        ));
                      }else {
                        if (Get.find<CartController>().existAnotherRestaurantProduct(_cartModel.product.restaurantId)) {
                          Get.dialog(ConfirmationDialog(
                            icon: Images.warning,
                            title: 'are_you_sure_to_reset'.tr,
                            description: 'if_you_continue'.tr,
                            onYesPressed: () {
                              Get.back();
                              Get.find<CartController>().removeAllAndAddToCart(_cartModel);
                              _showCartSnackBar(context);
                            },
                          ), barrierDismissible: false);
                        } else {
                          Get.find<CartController>().addToCart(_cartModel, widget.cartIndex);
                          _showCartSnackBar(context);
                        }
                      }
                    },
                    /*onPressed: (!isExistInCart) ? () {
                      if (!isExistInCart) {
                        Get.back();
                        if(isCampaign) {
                          Get.toNamed(RouteHelper.getCheckoutRoute('campaign'), arguments: CheckoutScreen(
                            fromCart: false, cartList: [_cartModel],
                          ));
                        }else {
                          if (Get.find<CartController>().existAnotherRestaurantProduct(_cartModel.product.restaurantId)) {
                            Get.dialog(ConfirmationDialog(
                              icon: Images.warning,
                              title: 'are_you_sure_to_reset'.tr,
                              description: 'if_you_continue'.tr,
                              onYesPressed: () {
                                Get.back();
                                Get.find<CartController>().removeAllAndAddToCart(_cartModel);
                                _showCartSnackBar(context);
                              },
                            ), barrierDismissible: false);
                          } else {
                            Get.find<CartController>().addToCart(_cartModel, cartIndex);
                            _showCartSnackBar(context);
                          }
                        }
                      }
                    } : null,*/

                  )),
                ]),
              ]),
            ),
          ]),
        );
      }),
    );
  }

  void _showCartSnackBar(BuildContext context) {
    Get.showSnackbar(GetBar(
      backgroundColor: Colors.green,
      message: 'item_added_to_cart'.tr,
      mainButton: TextButton(
        onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
        child: Text('view_cart'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor)),
      ),
      onTap: (_) => Get.toNamed(RouteHelper.getCartRoute()),
      duration: Duration(seconds: 3),
      maxWidth: Dimensions.WEB_MAX_WIDTH,
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      borderRadius: 10,
      isDismissible: true,
      dismissDirection: SnackDismissDirection.HORIZONTAL,
    ));
  }
}

