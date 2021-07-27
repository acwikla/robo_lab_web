import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:robo_lab_web/constants/controllers_instance.dart';
import 'package:robo_lab_web/controllers/device_controller.dart';
import 'package:robo_lab_web/helpers/responsivness.dart';
import 'package:robo_lab_web/patterns/custom_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<ViewDevice> viewDevice;

  @override
  void initState() {
    super.initState();
    viewDevice = fetchDevice(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                child: CustomText(
                  text: menuController.activeItem.value,
                  size: 24,
                  weight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        Expanded(
            child: Column(children: [
          FutureBuilder<ViewDevice>(
            future: viewDevice,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.name);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          )
        ]))
      ],
    );

    Scaffold(
      body: Center(
        child: FutureBuilder<ViewDevice>(
          future: viewDevice,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.name);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  static Future<ViewDevice> fetchDevice(int userId) async {
    final response = await http
        .get(Uri.parse('https://localhost:5001/api/users/${userId}/devices/1'));

    if (response.statusCode == 200) {
      return ViewDevice.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch device for user with id: ${userId}');
    }
  }
}
