import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:robo_lab_web/constants/controllers_instance.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/controllers/home_page_controller.dart';
import 'package:robo_lab_web/helpers/responsivness.dart';
import 'package:robo_lab_web/patterns/custom_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<ViewDevice> dev;

  @override
  void initState() {
    super.initState();
    dev = fetchDevice(1, 1);
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
              ),
            ],
          ),
        ),
        Expanded(
            child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
                height: 50,
                color: papayaWhip,
                child: Center(
                  child: FutureBuilder<ViewDevice>(
                    future: dev,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CustomText(
                            text: snapshot.data!.name.toString(),
                            size: 17,
                            color: steelBlue);
                      } else if (snapshot.hasError) {
                        return CustomText(
                            text: snapshot.error.toString(),
                            size: 17,
                            color: steelBlue);
                      }
                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  ),
                )),
            Container(
                height: 50,
                color: papayaWhip,
                child: Center(
                  child: FutureBuilder<ViewDevice>(
                    future: dev,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CustomText(
                            text: snapshot.data!.deviceTypeName.toString(),
                            size: 17,
                            color: steelBlue);
                      } else if (snapshot.hasError) {
                        return CustomText(
                            text: snapshot.error.toString(),
                            size: 17,
                            color: steelBlue);
                      }

                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  ),
                )),
            Container(
                height: 50,
                color: papayaWhip,
                child: Center(
                  child: FutureBuilder<ViewDevice>(
                    future: dev,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CustomText(
                            text: snapshot.data!.id.toString(),
                            size: 17,
                            color: steelBlue);
                      } else if (snapshot.hasError) {
                        return CustomText(
                            text: '${snapshot.error}',
                            size: 17,
                            color: steelBlue);
                      }

                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  ),
                )),
          ],
        ))
      ],
    );
  }
}
