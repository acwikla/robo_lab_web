import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:robo_lab_web/constants/style_const.dart';
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
    switch (itemName) {
      case homePageRoute:
        //home_filled
        //roofing_sharp
        return _customIcon(Icons.home_outlined, itemName);
      case setJobPageRoute:
        //auto_fix_high
        //assignment_outlined
        return _customIcon(Icons.assignment_outlined, itemName);
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
    if (isActive(itemName))
      return Icon(icon, size: 22, color: Colors.white /*peachPuff*/);

    //if the icon is inactive, this one will be returned
    return Icon(icon,
        color: isHovering(itemName)
            ? Colors.white
            : Colors.grey); //peachPuff : papayaWhip);
  }
}
