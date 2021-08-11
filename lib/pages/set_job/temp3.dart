import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:robo_lab_web/constants/controllers_instance.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/controllers/job_controller.dart';
import 'package:robo_lab_web/helpers/responsivness.dart';
import 'package:robo_lab_web/patterns/custom_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SetJobPage extends StatefulWidget {
  const SetJobPage({Key? key}) : super(key: key);

  @override
  _SetJobPage createState() => _SetJobPage();
}

//zeby byla mozliwosc nawigacji pomiedzy kartami obowiazkowo Obx??
class _SetJobPage extends State<SetJobPage> {
  /*Future<List<ViewJob>> fetchJobsForDevType2(String devTypeName) async {
    final response = await http.get(
        Uri.parse('http://51.158.163.165/api/jobs?devtype=${devTypeName}'));

    if (response.statusCode == 200) {
      //var responseJson = json.decode(response.body);
      //Future<List<ViewJob>> list =
      //responseJson.map((model) => ViewJob.fromJson(model)).toList();
      //return list;
      //return json.decode(response.body).map((model) => ViewJob.fromJson(model)).toList();
      //return ViewJob.fromJson(jsonDecode(response.body)).toList();
      return returnList2(response);
      //return returnFutureList(response);
      //return response;
    } else {
      throw Exception('Failed to fetch jobs for device type: $devTypeName');
    }
  }

  List<ViewJob> returnList2(response) {
  Iterable l = json.decode(response.body);

  JobController.jobs2 =
      List<ViewJob>.from(l.map((model) => ViewJob.fromJson(model)));
  return JobController.jobs2;
}

  Future<List<dynamic>> fetchJobs() async {
    var result = await http
        .get(Uri.parse('http://51.158.163.165/api/jobs?devtype=SmartTerra'));
    return json.decode(result.body);
  }

  String _name(dynamic job) {
    return job['name'];
  }

  String _description(dynamic job) {
    return job['description'];
  }

  String _properties(dynamic job) {
    return job['properties'];
  }

  late Future<ViewJob> futureJob;
  late Future<List<ViewJob>> futureJobs;
  late List<ViewJob> rawJobs;
  //= JobController.jobs2;

  List<ViewJob> jobs = [
    new ViewJob(
        //id: 1,
        name: 'testJob1',
        description: 'testDescription1',
        properties: 'testProperties1'),
    new ViewJob(
        //id: 2,
        name: 'testJob2',
        description: 'testDescription2',
        properties: 'testProperties2')
  ];
  List<TableRow> tableRows = [];
*/
  final String apiUrl = "http://51.158.163.165/api/jobs?devtype=SmartTerra";

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body);
  }

  String _name(dynamic job) {
    return job['name'];
  }

  String _description(dynamic job) {
    return job['description'];
  }

  String _properties(dynamic job) {
    return job['properties'];
  }

  List<TableRow> tableRows = [];
  @override
  void initState() {
    super.initState();
    //futureJob = fetchJobById(1);
    //futureJobs = returnFutureList2('SmartTerra');
    //rawJobs =
    //fetchJobsForDevType('SmartTerra');
    //futureJobs = returnFutureList('SmartTerra');
    //futureJobs = returnFutureList2('SmartTerra');
    //fetchJobs();
    //rawJobs = JobController.jobs2;
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
                text: '1',
                size: 17,
                weight: FontWeight.bold,
                color: darkSteelBlue),
          ))
        ]));
    FutureBuilder<List<dynamic>>(
      future: fetchUsers(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          //print((snapshot.data[0]));
          return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
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
                      ))
                    ]));
                return Text(_name(snapshot.data[index]));
              });
        } else {
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
                      text: '2',
                      size: 17,
                      weight: FontWeight.bold,
                      color: darkSteelBlue),
                ))
              ]));
          return Center(child: CircularProgressIndicator());
        }
      },
    );
    /*tableRows.add(TableRow(
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
            child: FutureBuilder<List<dynamic>>(
                future: fetchJobsForDevType2('SmartTerra'),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              child: Text(_name(snapshot.data[index])));
                        });
                  } else if (snapshot.hasError) {
                    return Container(child: Text("${snapshot.error}"));
                  }
                  return Container(child: Text("bu"));
                })),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: FutureBuilder<List<dynamic>>(
                future: fetchJobsForDevType2('SmartTerra'),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data[0].toString());
                    return ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              child: Text(_description(snapshot.data[index])));
                        });
                  } else if (snapshot.hasError) {
                    return Container(child: Text("${snapshot.error}"));
                  }
                  return Container(child: Text("bu2"));
                })),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: FutureBuilder<List<dynamic>>(
                future: fetchJobsForDevType2('SmartTerra'),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              child: Text(_properties(snapshot.data[index])));
                        });
                  } else if (snapshot.hasError) {
                    return Container(child: Text("${snapshot.error}"));
                  }
                  return Container(child: Text("bu3"));
                })),
      ],
    ));*/
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          TableCell(
              //child: Container(
              child: FutureBuilder<List<dynamic>>(
            future: fetchUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                //print((snapshot.data[0]));
                return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(child: TableCell(child: Text("bu")));
                    });
              } else {
                return TableCell(child: Text("bu2"));
                //Center(child: CircularProgressIndicator());
              }
            },
          )),
          //)
        ])
      ],
    );
    //]);
    //]);*/
    /*Container(
      child: FutureBuilder<List<dynamic>>(
        future: fetchUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print((snapshot.data[0]));
            return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(_name(snapshot.data[index])),
                          subtitle: Text(_description(snapshot.data[index])),
                          trailing: Text(_properties(snapshot.data[index])),
                        )
                      ],
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
    //]);*/
  }
  /*return Column(
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
            children: tableRows),
        SizedBox(
          height: 30,
        ),
        Table(
        //children: tableRows,
        //)
      ],
    );
  }*/
}
