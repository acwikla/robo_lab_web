import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:robo_lab_web/constants/controllers_instance.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/helpers/responsivness.dart';
import 'package:robo_lab_web/routing/routes.dart';
import 'package:robo_lab_web/widgets/side_menu_item.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //double _width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          //BoxShadow(
          //blurRadius: 8.0, color: Colors.black, offset: Offset(0, -16)),
          BoxShadow(
              blurRadius: 6.0,
              color: Colors.grey.shade700,
              offset: Offset(0, 10)),
        ],
        border: Border(
          top: BorderSide(
            color: leftMenuColor.withOpacity(.6),
            width: 1.5,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.1, 0.5, 0.9,
            //0.9
          ],
          colors: [
            topPanelColor,
            leftMenuColor,
            lighterleftMenuColor,
            //lightBlueGrey
          ],
        ),
      ),
      child: ListView(
        children: [
          //Divider(
          //color: /*lightSteelBlue*/ leftMenuColor.withOpacity(.9),
          //),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 15,
              ),
            ],
          ),
          Column(
              mainAxisSize: MainAxisSize.min,
              children: sideMenuItems
                  .map((itemName) => SideMenuItem(
                        itemName: itemName == authenticationPageRoute
                            ? "Log Out"
                            : itemName,
                        onTap: () {
                          if (itemName == authenticationPageRoute) {
                            //TODO :: go to auth page
                          }
                          if (!menuController.isActive(itemName)) {
                            menuController.changeActiveItemTo(itemName);
                            if (ResponsiveWidget.isSmallScreen(context))
                              Get.back();
                            navigationController.navigateTo(itemName);
                          }
                        },
                      ))
                  .toList())
        ],
      ),
    );
  }
}
