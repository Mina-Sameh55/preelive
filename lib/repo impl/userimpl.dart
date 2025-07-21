import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled1/model/user%20model.dart';
import 'package:untitled1/repo/user%20repo.dart';


class UserRepositoryImpl implements UserRepository {
  String appId = 'SpzDQ8AKK7WEBVBSUkwU4C9Xsxfyjsboz4PwXyjW';
  String clientKey = '1N9033LOw5A018zPw8p5hY0oeifTMv3a7Oqhgb1r';
  String masterKey = 'lbcdkueIQFQEnm7gM5jj114myeNO8YCsdFVKIxSd';
  String serverUrl = 'https://parseapi.back4app.com';
  @override
  Future<List<UserModel>> getUsers() async {
    final response = await http.get(
      Uri.parse("$serverUrl/classes/_User?limit=2000"),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Client-Key': clientKey,
      },
    );
    print("${response.statusCode}");
    // print("${response.body}");


    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }


  @override
  Future<void> blockUser(String userId, Duration duration) async {
    final blockUntil = DateTime.now().add(duration).toIso8601String();

    final response = await http.put(
      Uri.parse('$serverUrl/users/$userId'),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'isBlocked': true}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to block user');
    }
  }

  @override
  Future<void> banUser(String userId,Duration duration) async {
    final response = await http.put(
      Uri.parse('$serverUrl/users/$userId'),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'isBanned': "true"}),
    );
    print("${response.statusCode}");
    print("${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Failed to ban user');
    }
  }
  @override
  Future<void> createUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse("$serverUrl/users"),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create user: ${response.body}');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    final response = await http.delete(
      Uri.parse('$serverUrl/users/$userId'),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  @override
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    // إزالة الحقول غير القابلة للتحديث
    updates.removeWhere((key, _) => ['objectId', 'createdAt', 'updatedAt'].contains(key));

    final response = await http.put(
      Uri.parse('$serverUrl/users/$userId'),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updates),
    );
    print("${response.body}");
    if (response.statusCode != 200) {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  @override
  Future<void> blockDevice(String userId,String deviceId, Duration duration) async {
    final blockUntil = DateTime.now().add(duration).toIso8601String();

    final response = await http.put(
      Uri.parse('$serverUrl/users/$userId'),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'deviceId': deviceId,
        'blockUntil': blockUntil,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to block device');
    }
  }
  @override
  Future<void> unblockUser(String userId) async {
    final response = await http.put(
      Uri.parse('$serverUrl/users/$userId'),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'isBlocked': false}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unblock user');
    }
  }
  @override
  Future<void> unbanUser(String userId) async {
    final response = await http.put(
      Uri.parse('$serverUrl/users/$userId'),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'isBanned': 'false'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unban user');
    }
  }
  @override
  Future<void> unblockDevice(String userId, String deviceId) async {
    final response = await http.put(
      Uri.parse('$serverUrl/users/$userId'),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'deviceId': deviceId,
        'blockUntil': null,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unblock device');
    }
  }
}
