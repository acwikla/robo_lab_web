/*import 'dart:js_util';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobController extends GetxController {
  static JobController instance = Get.find();
  static List<ViewJob> jobs2 = [];
  static int jobCount = 0;
}

Future<ViewJob> fetchJobById(int id) async {
  final response =
      await http.get(Uri.parse('http://51.158.163.165/api/jobs/$id'));

  if (response.statusCode == 200) {
    return ViewJob.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch jobs for device type: $id');
  }
}

Future<List<ViewJob>> fetchJobsForDevType(String devTypeName) async {
  final response = await http
      .get(Uri.parse('http://51.158.163.165/api/jobs?devtype=${devTypeName}'));

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    Future<List<ViewJob>> list =
        responseJson.map((model) => ViewJob.fromJson(model)).toList();
    return list;
    //return ViewJob.fromJson(jsonDecode(response.body)).toList();
    //return returnList(response);
    //return returnFutureList(response);
    //return response;
  } else {
    throw Exception('Failed to fetch jobs for device type: $devTypeName');
  }
}

Future<List<ViewJob>> returnFutureList(String devTypeName) async {
  final response = await http
      .get(Uri.parse('http://51.158.163.165/api/jobs?devtype=${devTypeName}'));
  var responseJson = json.decode(response.body);
  return (responseJson['name']['description']['properties'] as List)
      .map((p) => ViewJob.fromJson(p))
      .toList();
}

Future<List<ViewJob>> returnFutureList2(String devTypeName) async {
  final response = await http
      .get(Uri.parse('http://51.158.163.165/api/jobs?devtype=$devTypeName'));
  var responseJson = json.decode(response.body);
  return responseJson.map((model) => ViewJob.fromJson(model)).toList();
}

List<ViewJob> returnList(response) {
  Iterable l = json.decode(response.body);

  JobController.jobs2 =
      List<ViewJob>.from(l.map((model) => ViewJob.fromJson(model)));
  return JobController.jobs2;
}

List<List<String>> buildRowData(Map<String, dynamic> json) {
  List<List<String>> rowDataCollection = [];
  json['name'].forEach((rows) {
    rowDataCollection.add(rows['description'].split('´').toList());
  });

  return rowDataCollection;
}

class ViewJob {
  //final int id;
  final String name;
  final String description;
  final String properties;

  ViewJob(
      {
      //required this.id,
      required this.name,
      required this.description,
      required this.properties});

  factory ViewJob.fromJson(Map<String, dynamic> json) {
    return ViewJob(
      //id: json['id'],
      name: json['name'],
      description: json['description'],
      properties: json['properties'],
    );
  }
}
*/