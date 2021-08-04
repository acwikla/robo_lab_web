import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robo_lab_web/controllers/home_page_controller.dart';
import 'package:robo_lab_web/controllers/menu_controller.dart';
import 'package:robo_lab_web/controllers/navigation_controller.dart';
import 'constants/style_const.dart';
import 'layout.dart';

void main() {
  Get.put(MenuController());
  Get.put(NavigationController());
  Get.put(HomePageController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "ROBOLab",
        theme: ThemeData(
          scaffoldBackgroundColor: floralWhite,
          textTheme: GoogleFonts.ptSansTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.black),
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
          }),
        ),
        home: SiteLayout());
  }
}
