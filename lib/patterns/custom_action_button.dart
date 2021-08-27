import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';

class CustomActionButton extends StatelessWidget {
  final IconData iconData;
  final Color? backgroundColor;
  final double? elevation;
  final Color? hoverColor;
  final String? toolTip;
  final void Function() pressedFunc;

  const CustomActionButton({
    Key? key,
    required this.iconData,
    this.backgroundColor,
    this.elevation,
    this.hoverColor,
    this.toolTip,
    required this.pressedFunc,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Add your onPressed code here!
        pressedFunc();
      },
      child: Icon(
        iconData,
        size: 25,
      ),
      backgroundColor: backgroundColor ?? peachPuff,
      hoverColor: hoverColor ?? lightBlueGrey,
      elevation: elevation ?? 5,
      tooltip: toolTip,
    );
  }
}
