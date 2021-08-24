import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';

class CustomSummaryCard extends StatelessWidget {
  final String? titleText;
  final String subtitleText;
  final double? titleSize;
  final double? subtitleSize;
  final Color? color;
  final double? elevation;
  final FontStyle? fontSubtitleStyle;
  final FontStyle? fontTitleStyle;
  final Icon? icon;

  const CustomSummaryCard(
      {Key? key,
      this.titleText,
      required this.subtitleText,
      this.titleSize,
      this.subtitleSize,
      this.color,
      this.elevation,
      this.fontSubtitleStyle,
      this.fontTitleStyle,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: elevation ?? 5,
        child: ListTile(
            leading: icon ??
                Icon(Icons.message_outlined, color: peachPuff, size: 25),
            title: Text(titleText ?? 'Summary',
                style: TextStyle(
                    fontStyle: fontSubtitleStyle ?? FontStyle.normal,
                    fontSize: titleSize ?? 17)),
            subtitle: Text(subtitleText,
                style: TextStyle(
                    fontStyle: fontSubtitleStyle ?? FontStyle.italic,
                    fontSize: subtitleSize ?? 16))));
  }
}
