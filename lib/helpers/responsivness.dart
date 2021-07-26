import 'package:flutter/material.dart';

//constants describing size of all parts of site
const int largeScreenSize = 1366;
const int mediumScreenSize = 768;
const int smallScreenSize = 630;
const int customScreenSize = 1100;

class ResponsiveWidget extends StatelessWidget {
  //declare class properties
  final Widget largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;

  const ResponsiveWidget(
      {Key? key,
      required this.largeScreen,
      this.mediumScreen,
      required this.smallScreen})
      : super(key: key);

  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < mediumScreenSize;

  static bool isMediumScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= mediumScreenSize &&
      MediaQuery.of(context).size.width < largeScreenSize;

  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width > largeScreenSize;

//  static bool isCustomSize(BuildContext context) =>
//      MediaQuery.of(context).size.width <= customScreenSize &&
//      MediaQuery.of(context).size.width >= mediumScreenSize;
  static bool isCustomSize(BuildContext context) {
    return MediaQuery.of(context).size.width <= customScreenSize &&
        MediaQuery.of(context).size.width >= mediumScreenSize;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double _width = constraints.maxWidth;
      if (constraints.maxWidth >= largeScreenSize) {
        return largeScreen;
      } else if (constraints.maxWidth < largeScreenSize &&
          _width >= mediumScreenSize) {
        return mediumScreen ?? largeScreen;
      } else {
        return smallScreen ?? largeScreen;
      }
    });
  }
}
