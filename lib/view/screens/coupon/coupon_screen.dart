import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CouponScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn) {
      Get.find<CouponController>().getCouponList();
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'coupon'.tr),
      body: _isLoggedIn ? GetBuilder<CouponController>(builder: (couponController) {
        return couponController.couponList != null ? couponController.couponList.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            await couponController.getCouponList();
          },
          child: Scrollbar(child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: ListView.builder(
              itemCount: couponController.couponList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_LARGE),
                  child: InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: couponController.couponList[index].code));
                      showCustomSnackBar('coupon_code_copied'.tr, isError: false);
                    },
                    child: Stack(children: [

                      Image.asset(
                        Images.coupon_bg,
                        height: 100, width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).primaryColor,
                      ),

                      Container(
                        height: 100,
                        alignment: Alignment.center,
                        child: Row(children: [

                          SizedBox(width: 30),
                          Image.asset(Images.coupon, height: 50, width: 50, color: Theme.of(context).cardColor),

                          SizedBox(width: 50),

                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(
                                couponController.couponList[index].title,
                                style: robotoRegular.copyWith(color: Theme.of(context).cardColor),
                                maxLines: 2, overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Text(
                                '${couponController.couponList[index].discount}${couponController.couponList[index].discountType == 'percent' ? '%'
                                    : Get.find<SplashController>().configModel.currencySymbol} off',
                                style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeLarge),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Text(
                                '${'valid_until'.tr} ${DateConverter.stringToLocalDateOnly(couponController.couponList[index].expireDate)}',
                                style: robotoRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                                maxLines: 2, overflow: TextOverflow.ellipsis,
                              ),
                            ]),
                          ),

                        ]),
                      ),

                    ]),
                  ),
                );
              },
            ))),
          )),
        ) : NoDataScreen(text: 'no_coupon_found'.tr) : Center(child: CircularProgressIndicator());
      }) : NotLoggedInScreen(),
    );
  }
}