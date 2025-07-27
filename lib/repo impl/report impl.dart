import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled1/model/report.dart';

import '../repo/report repo.dart';

class ReportRepositoryImpl implements ReportRepository {
  String appId = 'SpzDQ8AKK7WEBVBSUkwU4C9Xsxfyjsboz4PwXyjW';
  String clientKey = '1N9033LOw5A018zPw8p5hY0oeifTMv3a7Oqhgb1r';
  String masterKey = 'lbcdkueIQFQEnm7gM5jj114myeNO8YCsdFVKIxSd';
  String serverUrl = 'https://parseapi.back4app.com';

  @override
  Future<List<Report>> getReports() async {
    final response = await http.get(
      Uri.parse('$serverUrl?order=-createdAt'),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['results'] as List;
      return data.map((json) => Report.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reports');
    }
  }

  @override
  Future<void> dismissReport(String reportId) async {
    final response = await http.put(
      Uri.parse('$serverUrl/$reportId'),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'isResolved': true}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to dismiss report');
    }
  }
}