import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobController extends GetxController {
  static JobController instance = Get.find();
  static late ViewJob fetchedJob = ViewJob(
      id: 0,
      name: 'name',
      description: 'description',
      properties: 'properties');
  static late List<ViewJob> fetchedJobs;
}

Future<ViewJob> fetchJobsForDevType(String devTypeName) async {
  final response = await http
      //.get(Uri.parse('http://51.158.163.165/api/jobs?devtype=${devTypeName}'));
      .get(Uri.parse('http://51.158.163.165/api/jobs/1'));

  JobController.fetchedJob = ViewJob.fromJson(jsonDecode(response.body));
  //JobController.fetchedJobs = ViewJob.fromJson(jsonDecode(response.body));
  if (response.statusCode == 200) {
    return ViewJob.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch jobs for device type: $devTypeName');
  }
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
