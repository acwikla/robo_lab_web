import 'package:flutter/material.dart';
import 'package:robo_lab_web/pages/get_devices.dart';
import 'package:robo_lab_web/pages/home_page/home_page.dart';
import 'package:robo_lab_web/pages/set_job/set_job_page.dart';
import 'package:robo_lab_web/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    //case homePageRoute:
    //return _getPageRoute(HomePage());
    case setJobPageRoute:
      return _getPageRoute(SetJobPage());
    case devices:
      return _getPageRoute(DevicesPage());
    case diagramsPageRoute:
      return _getPageRoute(HomePage());
    default:
      return _getPageRoute(HomePage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
