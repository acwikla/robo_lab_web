import 'package:flutter/material.dart';
import 'package:robo_lab_web/helpers/local_navigator.dart';
import 'package:robo_lab_web/widgets/side_menu.dart';

class LargeScreen extends StatelessWidget {
  const LargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //include side menu:
        Expanded(child: SideMenu()),
        Expanded(
            flex: 4, //kod zajmie 5 "kolumn", ten wyzej 1
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: localNavigator()))
      ],
    );
  }
}
