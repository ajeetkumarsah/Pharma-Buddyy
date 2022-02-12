import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final String title;
  final bool value;
  final Function onClick;
  CustomCheckBox({@required this.title, @required this.value, @required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Row(children: [
        Checkbox(
          value: value,
          onChanged: (bool isActive) => onClick(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), side: BorderSide.none),
        ),
        Text(title, style: robotoRegular),
      ]),
    );
  }
}
