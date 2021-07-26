import 'package:flutter/material.dart';
import 'package:robo_lab_web/widgets/large_screen.dart';
import 'package:robo_lab_web/widgets/side_menu.dart';
import 'package:robo_lab_web/widgets/small_screen.dart';
import 'package:robo_lab_web/widgets/top_bar.dart';

import 'helpers/responsivness.dart';

class SiteLayout extends StatefulWidget {
  //final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  _SiteLayoutState createState() => _SiteLayoutState();
}

class _SiteLayoutState extends State<SiteLayout> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: topNavigationBar(context, scaffoldKey),
      drawer: Drawer(
        child: SideMenu(),
      ),
      body: ResponsiveWidget(
        largeScreen: LargeScreen(),
        smallScreen: SmallScreen(),
      ),
    );
  }
}
