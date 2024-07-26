import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizeConfig {
  static double _screenWidth = 0;
  static double _screenHeight = 0;
  // ignore: unused_field
  static double _blockSizeHorizontal = 0;
  // ignore: unused_field
  static double _blockSizeVertical = 0;

  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;
  static double heightMultiplier = 0;
  static double widthMultiplier = 0;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  static double get screenWidth => _screenWidth;

  static double get screenHeight => _screenHeight;
  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockSizeHorizontal = screenWidth / 100;
    _blockSizeVertical = screenHeight / 100;

    textMultiplier = 1.sp;
    imageSizeMultiplier = 1;
    heightMultiplier = 1.h;
    widthMultiplier = 1.w;
  }

  static double getMaxWidth() {
    if (screenWidth <= 600) {
      return double.maxFinite;
    } else {
      return 300 * widthMultiplier;
    }
  }

  static Size screenSize(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      // Mobile
      return const Size(360, 800);
    } else {
      // Large Desktop
      return const Size(1000, 1280);
    }
  }
}
