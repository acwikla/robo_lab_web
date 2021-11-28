import 'package:flutter/material.dart';
import 'package:robo_lab_web/dto/view_device_job_dto.dart';
import 'package:robo_lab_web/pages/add_device/add_device_page.dart';
import 'package:robo_lab_web/pages/add_property/add_property.dart';
import 'package:robo_lab_web/pages/completed_jobs_page/completed_job_details_page.dart';
import 'package:robo_lab_web/pages/completed_jobs_page/completed_jobs_list_page.dart';
import 'package:robo_lab_web/pages/create_device_type/create_device_type_page.dart';
import 'package:robo_lab_web/pages/diagrams/diagrams_page.dart';
import 'package:robo_lab_web/pages/devices_list_page.dart';
import 'package:robo_lab_web/pages/home_page/home_page.dart';
import 'package:robo_lab_web/pages/set_job/set_job_page.dart';
import 'package:robo_lab_web/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var args = settings.arguments;

  switch (settings.name) {
    //case homePageRoute:
    //return _getPageRoute(HomePage());
    case devicesPageRoute:
      return _getPageRoute(DevicesListPage());
    case createDeviceTypePageRoute:
      return _getPageRoute(CreateDeviceTypePage());
    case AddPropertyPageRoute:
      return _getPageRoute(AddPropertyPage());
    case AddDevicePageRoute:
      return _getPageRoute(AddDevicePage());
    case setJobPageRoute:
      return _getPageRoute(SetJobPage());
    case deviceCompletedJobsPageRoute:
      return _getPageRoute(CompletedJobsListPage());
    case completedJobDetailsPageRoute:
      return _getPageRoute(CompletedJobDetailsPage(
        deviceJob: args as ViewDeviceJobDto,
      ));
    case diagramsPageRoute:
      return _getPageRoute(
          //SingleSeriesChartPage()
          //MultipleSeriesChartPage()
          DiagramsPage());
    //case exampleTable:
    //return _getPageRoute(ExampleTablePage());
    default:
      return _getPageRoute(HomePage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
