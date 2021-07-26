import 'dart:js';
import 'package:flutter/material.dart';
import 'package:robo_lab_web/pages/home_page/home_page.dart';
import 'package:robo_lab_web/pages/set_job/set_job_page.dart';
import 'package:robo_lab_web/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomePageRoute:
      return _getPageRoute(HomePage());
    case SetJobPageRoute:
      return _getPageRoute(HomePage());
    case DevicePropertiesPageRoute:
      return _getPageRoute(HomePage());
    case DiagramsPageRoute:
      return _getPageRoute(HomePage());
    default:
      return _getPageRoute(HomePage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
