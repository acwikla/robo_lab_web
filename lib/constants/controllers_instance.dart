import 'package:robo_lab_web/controllers/home_page_controller.dart';
import 'package:robo_lab_web/controllers/job_controller.dart';
import 'package:robo_lab_web/controllers/menu_controller.dart';
import 'package:robo_lab_web/controllers/navigation_controller.dart';

MenuController menuController = MenuController.instance;
NavigationController navigationController = NavigationController.instance;
HomePageController homePageController = HomePageController.instance;
JobController jobController = JobController.instance;
List<ViewJob> jobData = JobController.jobs2;
