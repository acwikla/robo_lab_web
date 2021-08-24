import 'package:flutter/material.dart';
import 'package:robo_lab_web/pages/completed_jobs_page/completed_job_details_page.dart';
import 'package:robo_lab_web/pages/diagrams/diagrams_page.dart';
import 'package:robo_lab_web/pages/example_table_page.dart';
import 'package:robo_lab_web/pages/devices_page.dart';
import 'package:robo_lab_web/pages/home_page/home_page.dart';
import 'package:robo_lab_web/pages/set_job/set_job_page.dart';
import 'package:robo_lab_web/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    //case homePageRoute:
    //return _getPageRoute(HomePage());
    case setJobPageRoute:
      return _getPageRoute(SetJobPage());
    case devicesPageRoute:
      return _getPageRoute(DevicesPage());
    case deviceCompletedJobsPageRoute:
      return _getPageRoute(HomePage());
    case diagramsPageRoute:
      return _getPageRoute(DiagramsPage());
    //case exampleTable:
    //return _getPageRoute(ExampleTablePage());
    default:
      return _getPageRoute(HomePage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
