import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/setting_cubit.dart';
import '../repo/setting repo.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  String appId = 'SpzDQ8AKK7WEBVBSUkwU4C9Xsxfyjsboz4PwXyjW';
  String clientKey = '1N9033LOw5A018zPw8p5hY0oeifTMv3a7Oqhgb1r';
  String masterKey = 'lbcdkueIQFQEnm7gM5jj114myeNO8YCsdFVKIxSd';
  String serverUrl = 'https://parseapi.back4app.com';
  @override
  Future<AppSettings> getSettings() async {
    final response = await http.get(
      Uri.parse(serverUrl),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AppSettings.fromJson(data);
    } else {
      throw Exception('Failed to load settings');
    }
  }

  @override
  Future<void> updateSettings(AppSettings settings) async {
    final response = await http.put(
      Uri.parse(serverUrl),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(settings.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update settings');
    }
  }
}