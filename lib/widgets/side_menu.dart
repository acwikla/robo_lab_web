import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/controllers_instance.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/patterns/custom_text.dart';
import 'package:robo_lab_web/routing/routes.dart';
import 'package:robo_lab_web/widgets/side_menu_item.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Container(
      color: lightSteelBlue,
      child: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 15,
              ),
            ],
          ),
          Divider(
            color: lightSteelBlue.withOpacity(.1),
          ),
          Column(
              mainAxisSize: MainAxisSize.min,
              children: sideMenuItems
                  .map((itemName) => SideMenuItem(
                        itemName: itemName == AuthenticationPageRoute
                            ? "Log Out"
                            : itemName,
                        onTap: () {
                          if (itemName == AuthenticationPageRoute) {
                            //TODO :: go to auth page
                          }
                          if (!menuController.isActive(itemName)) {
                            menuController.changeActiveItemTo(itemName);
                          }
                        },
                      ))
                  .toList()),
        ],
      ),
    );
  }
}
