import 'package:efood_multivendor/data/model/response/onboarding_model.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get.dart';

class OnBoardingRepo {

  Future<Response> getOnBoardingList() async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(Images.onboard_1, 'on_boarding_1_title'.tr, 'on_boarding_1_description'.tr),
        OnBoardingModel(Images.onboard_2, 'on_boarding_2_title'.tr, 'on_boarding_2_description'.tr),
        OnBoardingModel(Images.onboard_3, 'on_boarding_3_title'.tr, 'on_boarding_3_description'.tr),
      ];

      Response response = Response(body: onBoardingList, statusCode: 200);
      return response;
    } catch (e) {
      return Response(statusCode: 404, statusText: 'Onboarding data not found');
    }
  }
}
