import 'package:flutter/material.dart';
import 'dart:io';

import 'package:full_screen_image/full_screen_image.dart';

class ImageView extends StatelessWidget {
  final String path;
  const ImageView({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FullScreenWidget(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
