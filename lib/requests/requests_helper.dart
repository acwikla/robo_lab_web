import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestsHelper {
  static Future<T> get<T>(
    url,
    T Function(Map<String, dynamic> jsonMap) fromMap, {
    String body = '',
    //String token = ''
  }) async {
    return _postBase<T, T>(url, fromMap, body: body);
  }

  static Future<List<T>> getReturnList<T>(
    url,
    T Function(Map<String, dynamic> jsonMap) fromMap, {
    String body = '',
    //String token = ''
  }) async {
    return _getBase<List<T>, T>(url, fromMap);
  }

  static Future<T> post<T>(
    url,
    T Function(Map<String, dynamic> jsonMap) fromMap, {
    String body = '',
    //String token = ''
  }) async {
    return _postBase<T, T>(url, fromMap, body: body);
  }

  static Future<List<T>> postReturnList<T>(
    url,
    T Function(Map<String, dynamic> jsonMap) fromMap, {
    String body = '',
    //String token = ''
  }) async {
    return _postBase<List<T>, T>(url, fromMap, body: body);
  }

  /// If T is a List, K is the subtype of the list.
  static Future<T> _getBase<T, K>(
      url, K Function(Map<String, dynamic> jsonMap) fromMap
      //,{String token = ''}
      ) async {
    final response = await http.get(Uri.parse(url),
        headers: {"Content-Type": "application/json"}); // request
    if (response.statusCode == 200) {
      return _fromJson<T, K>(response.body, fromMap);
    } else {
      throw Exception('Unable to get data from the API');
    }
  }

  /// If T is a List, K is the subtype of the list.
  static Future<T> _postBase<T, K>(
    url,
    K Function(Map<String, dynamic> jsonMap) fromMap, {
    String body = '',
    //String token = ''
  }) async {
    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body); // request
    if (response.statusCode == 200) {
      return _fromJson<T, K>(response.body, fromMap);
    } else {
      throw Exception('Unable to get data from the API');
    }
  }

  /// If T is a List, K is the subtype of the list.
  static T _fromJson<T, K>(
      dynamic json, K Function(Map<String, dynamic> jsonMap) fromMap) {
    final parsed = jsonDecode(json);
    if (parsed is Iterable) {
      return parsed.map<K>((map) => fromMap(map)).toList() as T;
    } else {
      return fromMap(parsed) as T;
    }
  }
}
