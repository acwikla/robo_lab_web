import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  static NavigationController instance = Get.find();
  final GlobalKey<NavigatorState> navigationKey = GlobalKey();

  Future<dynamic> navigateTo(
    String routeName, {
    Object? arguments,
  }) {
    return navigationKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  goBack() => navigationKey.currentState!.pop();
}
