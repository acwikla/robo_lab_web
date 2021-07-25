import 'package:flutter/material.dart';
import 'package:robo_lab_web/widgets/top_bar.dart';

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
      drawer: Drawer(),
    );
  }
}
