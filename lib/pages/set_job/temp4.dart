import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class TableModel {
  TableModel(this.headerData, this.rowData);
  List<String> headerData;
  List<List<String>> rowData;

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      json['name'].toList(),
      buildRowData(json),
    );
  }
}

List<List<String>> buildRowData(Map<String, dynamic> json) {
  List<List<String>> rowDataCollection = [];
  json['name'].forEach((rows) {
    rowDataCollection.add(rows['description'].toList());
  });

  return rowDataCollection;
}

//zeby byla mozliwosc nawigacji pomiedzy kartami obowiazkowo Obx??
class _SetJobPage extends State<SetJobPage> {
  final String apiUrl = "http://51.158.163.165/api/jobs?devtype=SmartTerra";

  Future<List<ViewJob>> fetchJobs() async {
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body);
  }

  Future<void> generateList() async {
    //String responseBody = await rootBundle.loadString("assets/data.json");
    //String responseBody =
    //await DefaultAssetBundle.of(context).loadString("assets/data.json");
    final response = await http
        .get(Uri.parse('http://51.158.163.165/api/jobs?devtype=SmartTerra'));
    var list =
        await json.decode(response.toString()).cast<Map<String, dynamic>>();
    return await list
        .map<TableModel>((json) => TableModel.fromJson(json))
        .toList();
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('DataTable'),
            ),
            body: FutureBuilder(
              future: generateList(),
              builder: (context, AsyncSnapshot snapShot) {
                if (snapShot.data == null ||
                    snapShot.connectionState == ConnectionState.waiting ||
                    snapShot.hasError ||
                    snapShot.data.length == 0) {
                  return Container(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapShot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final TableModel table = snapShot.data[index];
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: table.headerData.map<DataColumn>((e) {
                              var columnName = e;
                              TextAlign align;
                              if (columnName.contains('<')) {
                                align = TextAlign.start;
                                columnName = columnName.replaceAll('<', '');
                              } else if (columnName.contains('>')) {
                                align = TextAlign.end;
                                columnName = columnName.replaceAll('>', '');
                              } else {
                                align = TextAlign.center;
                              }

                              return DataColumn(
                                  label: Text(
                                columnName,
                                textAlign: align,
                              ));
                            }).toList(),
                            rows: table.rowData.map<DataRow>((e) {
                              return DataRow(
                                  cells: e
                                      .map<DataCell>((e) => DataCell(Text(e)))
                                      .toList());
                            }).toList(),
                          ),
                        );
                      });
                }
              },
            )));
  }
}
