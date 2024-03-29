import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/pages/devices_list_page.dart';
import 'package:robo_lab_web/routing/routes.dart';

class MenuController extends GetxController {
  static MenuController instance = Get.find();
  var activeItem = homePageRoute.obs;
  var hoverItem = "".obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  isActive(String itemName) => activeItem.value == itemName;

  isHovering(String itemName) => hoverItem.value == itemName;

  Widget returnIconFor(String itemName) {
    //reply_outlined
    //toys
    //add_task_outlined
    switch (itemName) {
      case homePageRoute:
        return _customIcon(Icons.home_outlined, itemName);
      case devicesPageRoute:
        return _customIcon(Icons.precision_manufacturing, itemName);
      case createDeviceTypePageRoute:
        return _customIcon(Icons.data_saver_on_outlined, itemName);
      case AddDevicePageRoute:
        return _customIcon(Icons.add_circle_outlined, itemName);
      case setJobPageRoute:
        //post_add_outlined
        //play_circle
        return _customIcon(Icons.add_task_outlined, itemName);
      case deviceCompletedJobsPageRoute:
        return _customIcon(Icons.check_box_outlined, itemName);
      case devicePendingsJobsPageRoute:
        return _customIcon(Icons.pending_actions, itemName);
      case devicePropertiesPageRoute:
        //filter_vintage_outlined
        //grass_sharp
        //yard_outlined
        //yard_sharp
        return _customIcon(Icons.yard_outlined, itemName);
      case diagramsPageRoute:
        //auto_graph_sharp
        //bar_chart_sharp
        return _customIcon(Icons.bar_chart_sharp, itemName);
      case authenticationPageRoute:
        return _customIcon(Icons.logout_sharp, itemName);
      default:
        return _customIcon(Icons.logout_sharp, itemName);
    }
  }

  //method changes if the icon is active
  //if the icon is active, it is dark and bigger than the others
  Widget _customIcon(IconData icon, String itemName) {
    if (isActive(itemName)) return Icon(icon, size: 22, color: peachPuff);

    //if the icon is inactive, this one will be returned
    return Icon(icon, color: isHovering(itemName) ? peachPuff : papayaWhip);
  }
}
