import 'package:flutter/material.dart';
import 'package:robo_lab_web/pages/completed_jobs_page/checkboxMultiList.dart';
import 'package:robo_lab_web/pages/completed_jobs_page/completed_jobs_list_page.dart';
import 'package:robo_lab_web/pages/completed_jobs_page/temp.dart';
import 'package:robo_lab_web/pages/diagrams/diagrams_page.dart';
import 'package:robo_lab_web/pages/devices_list_page.dart';
import 'package:robo_lab_web/pages/home_page/home_page.dart';
import 'package:robo_lab_web/pages/set_job/set_job_page.dart';
import 'package:robo_lab_web/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    //case homePageRoute:
    //return _getPageRoute(HomePage());
    case devicesPageRoute:
      return _getPageRoute(DevicesListPage());
    case setJobPageRoute:
      return _getPageRoute(SetJobPage());
    case deviceCompletedJobsPageRoute:
      return _getPageRoute(CompletedJobsListPage());
    case deviceCompletedJobsPageRoute:
      return _getPageRoute(HomePage());
    case diagramsPageRoute:
      return _getPageRoute(MultiSeriesChartJobDetailsPage()
          //TempCompletedJobDetailsPage()
          //DiagramsPage()
          );
    //case exampleTable:
    //return _getPageRoute(ExampleTablePage());
    default:
      return _getPageRoute(HomePage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
