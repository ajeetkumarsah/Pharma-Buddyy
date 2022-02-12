import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/review_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;
  final bool hasDivider;
  ReviewWidget({@required this.review, @required this.hasDivider});

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Row(children: [

        ClipOval(
          child: CustomImage(
            image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}/${review.customer.image}',
            height: 60, width: 60, fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

        Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

          Text(
            '${review.customer.fName} ${review.customer.lName}', maxLines: 1, overflow: TextOverflow.ellipsis,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),

          RatingBar(rating: review.rating.toDouble(), ratingCount: null, size: 15),

          Text(review.comment, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor)),

        ])),

      ]),

      (hasDivider && ResponsiveHelper.isMobile(context)) ? Padding(
        padding: EdgeInsets.only(left: 70),
        child: Divider(color: Theme.of(context).disabledColor),
      ) : SizedBox(),

    ]);
  }
}
