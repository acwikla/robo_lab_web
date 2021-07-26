import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:robo_lab_web/constants/controllers_instance.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/patterns/custom_text.dart';

class VerticalMenuItem extends StatelessWidget {
  final String itemName;
  //powinno byc Fintion zamiast VoidCallback
  //https://stackoverflow.com/questions/64484113/the-argument-type-function-cant-be-assigned-to-the-parameter-type-void-funct
  final VoidCallback onTap;

  const VerticalMenuItem(
      {Key? key, required this.itemName, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onHover: (value) {
        value
            ? menuController.onHover(itemName)
            : menuController.onHover("not hovering");
      },
      child: Obx(() => Container(
            color: menuController.isHovering(itemName)
                ? papayaWhip.withOpacity(.1)
                : Colors.transparent,
            child: Row(
              children: [
                Visibility(
                  visible: menuController.isHovering(itemName) ||
                      menuController.isActive(itemName),
                  child: Container(width: 3, height: 72, color: peachPuff),
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                ),
                Expanded(
                    child: Container(
                        child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: menuController.returnIconFor(itemName),
                    ),
                    if (!menuController.isActive(itemName))
                      Flexible(
                          child: CustomText(
                        text: itemName,
                        color: menuController.isHovering(itemName)
                            ? peachPuff
                            : papayaWhip,
                      ))
                    else
                      Flexible(
                          child: CustomText(
                              text: itemName,
                              color: peachPuff,
                              size: 17,
                              weight: FontWeight.bold))
                  ],
                )))
              ],
            ),
          )),
    );
  }
}
