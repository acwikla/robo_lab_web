/*import 'package:flutter/material.dart';
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
  late List<ViewJob> rawJobs;
  //= JobController.jobs2;

  List<ViewJob> jobs = [
    new ViewJob(
        id: 1,
        name: 'testJob1',
        description: 'testDescription1',
        properties: 'testProperties1'),
    new ViewJob(
        id: 2,
        name: 'testJob2',
        description: 'testDescription2',
        properties: 'testProperties2')
  ];
  List<TableRow> tableRows = [];

  @override
  void initState() {
    super.initState();
    futureJob = fetchJobById(1);
    futureJobs = returnFutureList2('SmartTerra');
    //rawJobs =
    fetchJobsForDevType('SmartTerra');
    rawJobs = JobController.jobs2;

    //as List<ViewJob>;

    tableRows.add(TableRow(
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
    ));
    FutureBuilder<List<ViewJob>>(
        future: returnFutureList('SmartTerra'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            Container(
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Text('${snapshot.data![index].name}');
                    }));
          }
          return const CircularProgressIndicator();
        });

    /*for (ViewJob j in rawJobs) {
      tableRows.add(TableRow(
        /*children: [
        Text(j.name),
        Text(j.description),
        Text(j.properties),
      ]*/

        decoration: const BoxDecoration(
          color: Color(0xFFfff3e0),
        ),
        children: <Widget>[
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Container(
                padding: EdgeInsets.all(5.0),
                child:
                    CustomText(text: j.name, size: 17, color: darkSteelBlue)),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Container(
                padding: EdgeInsets.all(5.0),
                child: CustomText(
                    text: j.description, size: 17, color: darkSteelBlue)),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Container(
                padding: EdgeInsets.all(5.0),
                child: CustomText(
                    text: j.properties, size: 17, color: darkSteelBlue)),
          ),
        ],
      ));
    }*/
    tableRows.add(TableRow(
      decoration: const BoxDecoration(
        color: Color(0xFFfff3e0),
      ),
      children: <Widget>[
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: FutureBuilder<List<ViewJob>>(
              future: futureJobs,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  Container(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Text('${snapshot.data![index].name}');
                          }));
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            )),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: FutureBuilder<List<ViewJob>>(
              future: futureJobs,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  Container(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Text('${snapshot.data![index].properties}');
                          }));
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            )),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: FutureBuilder<List<ViewJob>>(
              future: futureJobs,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  Container(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Text('${snapshot.data![index].description}');
                          }));
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            )),
      ],
    ));
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
            //tableRows
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
                        )))
              ],
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Table(
          children: tableRows,
        )
      ],
    );
  }
}
*/