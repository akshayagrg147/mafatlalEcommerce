import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;

  const ResponsiveWidget({
    Key? key,
    required this.largeScreen,
    this.mediumScreen,
    this.smallScreen,
  }) : super(key: key);

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 820;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 800 &&
        MediaQuery.of(context).size.width <= 1200;
  }

  static int getGridCount(BuildContext context) {
    if (isSmallScreen(context)) {
      return 2;
    } else if (isMediumScreen(context)) {
      return 3;
    } else {
      return 3;
    }
  }

  static int getCategoryGridCount(BuildContext context) {
    if (isSmallScreen(context)) {
      return 3;
    } else if (isMediumScreen(context)) {
      return 5;
    } else {
      return 7;
    }
  }

  static int getOrganisationGridCount(BuildContext context) {
    if (isSmallScreen(context)) {
      return 2;
    } else if (isMediumScreen(context)) {
      return 3;
    } else {
      return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return largeScreen;
        } else if (constraints.maxWidth <= 1200 && constraints.maxWidth > 820) {
          return mediumScreen ?? largeScreen;
        } else {
          return smallScreen ?? largeScreen;
        }
      },
    );
  }
}
