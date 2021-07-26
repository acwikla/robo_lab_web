import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:robo_lab_web/constants/controllers_instance.dart';
import 'package:robo_lab_web/patterns/custom_text.dart';

class SetJobPage extends StatefulWidget {
  const SetJobPage({Key? key}) : super(key: key);

  @override
  _SetJobPage createState() => _SetJobPage();
}

//zeby byla mozliwosc nawigacji pomiedzy kartami obowiazkowo Obx
class _SetJobPage extends State<SetJobPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: CustomText(
            text: "Ty",
            size: 25,
            weight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
