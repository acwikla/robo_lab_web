import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/controllers_instance.dart';
import 'package:robo_lab_web/routing/router.dart';
import 'package:robo_lab_web/routing/routes.dart';

Navigator localNavigator() => Navigator(
      key: navigationController.navigationKey,
      onGenerateRoute: generateRoute,
      initialRoute: homePageRoute,
    );
