import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/data/model/response/menu_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/screens/menu/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    double _ratio = ResponsiveHelper.isDesktop(context) ? 1.1 : ResponsiveHelper.isTab(context) ? 1.1 : 1.2;

    final List<MenuModel> _menuList = [
      MenuModel(icon: '', title: 'profile'.tr, backgroundColor: Theme.of(context).primaryColor, route: RouteHelper.getProfileRoute()),
      MenuModel(icon: Images.location, title: 'my_address'.tr, backgroundColor: Color(0xFFF99024), route: RouteHelper.getAddressRoute()),
      MenuModel(icon: Images.language, title: 'language'.tr, backgroundColor: Color(0xFF009A5F), route: RouteHelper.getLanguageRoute('menu')),
      MenuModel(icon: Images.support, title: 'help_support'.tr, backgroundColor: Color(0xFF00C7B2), route: RouteHelper.getSupportRoute()),
      MenuModel(icon: Images.policy, title: 'privacy_policy'.tr, backgroundColor: Color(0xFF6165D7), route: RouteHelper.getHtmlRoute('privacy-policy')),
      MenuModel(icon: Images.about_us, title: 'about_us'.tr, backgroundColor: Color(0xFF6AB5FF), route: RouteHelper.getHtmlRoute('about-us')),
      MenuModel(icon: Images.terms, title: 'terms_conditions'.tr, backgroundColor: Color(0xFFFFC444), route: RouteHelper.getHtmlRoute('terms-and-condition')),
      MenuModel(icon: Images.log_out, title: _isLoggedIn ? 'logout'.tr : 'sign_in'.tr, backgroundColor: Color(0xFFFF3A45), route: ''),
    ];

    return PointerInterceptor(
      child: Container(
        width: Dimensions.WEB_MAX_WIDTH,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Theme.of(context).cardColor,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          InkWell(
            onTap: () => Get.back(),
            child: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8 : ResponsiveHelper.isTab(context) ? 6 : 4,
              childAspectRatio: (1/_ratio),
              crossAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL, mainAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            itemCount: _menuList.length,
            itemBuilder: (context, index) {
              return MenuButton(menu: _menuList[index], isProfile: index == 0, isLogout: index == _menuList.length-1);
            },
          ),
          SizedBox(height: ResponsiveHelper.isMobile(context) ? Dimensions.PADDING_SIZE_SMALL : 0),

        ]),
      ),
    );
  }
}
