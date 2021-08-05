import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobController extends GetxController {
  static JobController instance = Get.find();
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
    //return ViewJob.fromJson(jsonDecode(response.body));
    return returnList(response);
  } else {
    throw Exception('Failed to fetch jobs for device type: $devTypeName');
  }
}

List<ViewJob> returnList(response) {
  Iterable l = json.decode(response.body);
  List<ViewJob> jobs =
      List<ViewJob>.from(l.map((model) => ViewJob.fromJson(model)));
  return jobs;
}

class ViewJob {
  final int id;
  final String name;
  final String description;
  final String properties;

  ViewJob(
      {required this.id,
      required this.name,
      required this.description,
      required this.properties});

  factory ViewJob.fromJson(Map<String, dynamic> json) {
    return ViewJob(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      properties: json['properties'],
    );
  }
}
