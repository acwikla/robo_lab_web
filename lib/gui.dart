import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants/style_const.dart';

class Gui {
  static final textStylePageTitle = TextStyle(
      color: darkerSteelBlue, fontSize: 20, fontWeight: FontWeight.bold);

  static final textStyleParagraph = TextStyle(
      color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w600);

  static final buttonStyleSubmit = ButtonStyle(
      elevation: MaterialStateProperty.all(5),
      backgroundColor: MaterialStateProperty.all(darkSteelBlue),
      overlayColor: MaterialStateProperty.all(lightSteelBlue));

  static InputDecoration inputDecoration(String? labelText) {
    return InputDecoration(
        fillColor: Colors.black26,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black26, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        border: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.teal)),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black38));
  }
}
