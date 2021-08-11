import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestsHelper {
  static Future<List<T>> get<T>(
    url,
    T Function(Map<String, dynamic> jsonMap) fromMap,
    //{ String token = '' }
  ) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    ); // request
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body)
          .cast<Map<String, dynamic>>(); // parse to json
      return parsed.map<T>((map) => fromMap(map)).toList(); // convert to list
    } else {
      throw Exception('Unable to get data from the API');
    }
  }

  static Future<List<T>> post<T>(
    url,
    T Function(Map<String, dynamic> jsonMap) fromMap, {
    String body = '',
    //String token = ''
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    ); // request
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body)
          .cast<Map<String, dynamic>>(); // parse to json
      return parsed.map<T>((map) => fromMap(map)).toList(); // convert to list
    } else {
      throw Exception('Unable to get data from the API');
    }
  }
}
