import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:robo_lab_web/constants/controllers_instance.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/controllers/job_controller.dart';
import 'package:robo_lab_web/helpers/responsivness.dart';
import 'package:robo_lab_web/patterns/custom_text.dart';

class SetJobPage extends StatefulWidget {
  const SetJobPage({Key? key}) : super(key: key);

  @override
  _SetJobPage createState() => _SetJobPage();
}

//zeby byla mozliwosc nawigacji pomiedzy kartami obowiazkowo Obx??
class _SetJobPage extends State<SetJobPage> {
  late Future<ViewJob> futureJob;
  late Future<List<ViewJob>> futureJobs;

  @override
  void initState() {
    super.initState();
    futureJob = fetchJobById(1);
    futureJobs = fetchJobsForDevType('SmartTerra');
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
                    color: darkerSteelBlue),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Table(
          border: TableBorder.symmetric(
              inside: BorderSide(width: 3, color: darkerPeachPuff),
              outside: BorderSide(width: 1, color: peachPuff)),
          defaultColumnWidth: const FlexColumnWidth(100.0),
          //defaultColumnWidth: IntrinsicColumnWidth(),
          children: <TableRow>[
            TableRow(
              decoration: const BoxDecoration(
                color: Color(0xFFfae8ca),
              ),
              children: <Widget>[
                TableCell(
                    child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: CustomText(
                      align: TextAlign.center,
                      text: 'Name',
                      size: 17,
                      weight: FontWeight.bold,
                      color: darkSteelBlue),
                )),
                TableCell(
                    child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: CustomText(
                      align: TextAlign.center,
                      text: 'Description',
                      size: 17,
                      weight: FontWeight.bold,
                      color: darkSteelBlue),
                )),
                TableCell(
                    child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: CustomText(
                      align: TextAlign.center,
                      text: 'Properties',
                      size: 17,
                      weight: FontWeight.bold,
                      color: darkSteelBlue),
                ))
              ],
            ),
            TableRow(
              decoration: const BoxDecoration(
                color: Color(0xFFfff3e0),
              ),
              children: <Widget>[
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.top,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: FutureBuilder<ViewJob>(
                        future: futureJob,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CustomText(
                                text: snapshot.data!.name,
                                size: 17,
                                color: darkSteelBlue);
                          } else if (snapshot.hasError) {
                            return CustomText(
                                text: snapshot.error.toString(),
                                size: 17,
                                weight: FontWeight.bold,
                                color: darkSteelBlue);
                          }
                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        },
                      ),
                    )),
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.top,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: FutureBuilder<ViewJob>(
                        future: futureJob,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CustomText(
                                text: snapshot.data!.description,
                                size: 17,
                                color: darkSteelBlue);
                          } else if (snapshot.hasError) {
                            return CustomText(
                                text: snapshot.error.toString(),
                                size: 17,
                                weight: FontWeight.bold,
                                color: darkSteelBlue);
                          }
                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        },
                      ),
                    )),
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.top,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: FutureBuilder<ViewJob>(
                        future: futureJob,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CustomText(
                                text: snapshot.data!.properties,
                                size: 17,
                                color: darkSteelBlue);
                          } else if (snapshot.hasError) {
                            return CustomText(
                                text: snapshot.error.toString(),
                                size: 17,
                                weight: FontWeight.bold,
                                color: darkSteelBlue);
                          }
                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        },
                      ),
                    ))
              ],
            ),
          ],
        )
      ],
    );
  }
}
