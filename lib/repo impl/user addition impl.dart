import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user model.dart';
import '../repo/users additoin.dart';

class AgentRepositoryImpl implements AgentRepository {
  final String appId = 'SpzDQ8AKK7WEBVBSUkwU4C9Xsxfyjsboz4PwXyjW';
  final String masterKey = 'lbcdkueIQFQEnm7gM5jj114myeNO8YCsdFVKIxSd';
  final String serverUrl = 'https://parseapi.back4app.com';

  @override
  Future<List<UserModel>> getAgents() async {
    final query = {
      "where": jsonEncode({"agency_role": "agent"})
    };
    final uri = Uri.parse("$serverUrl/classes/_User").replace(queryParameters: query);

    final response = await http.get(
      uri,
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['results'];
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load agents: ${response.body}");
    }
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    final uri = Uri.parse('$serverUrl/classes/_User');
    final response = await http.get(
      uri.replace(
        queryParameters: {
          "where": jsonEncode({
            "\$or": [
              {"name": {"\$regex": query, "\$options": "i"}},
              {"email": {"\$regex": query, "\$options": "i"}},
              {"username": {"\$regex": query, "\$options": "i"}},
              {"uid": {"\$regex": query, "\$options": "i"}},

            ]
          }),
          "limit": "2000",
        },
      ),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['results'];
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to search users: ${response.body}");
    }
  }

  @override
  Future<void> assignAgentRole(String userId) async {
    final response = await http.put(
      Uri.parse('$serverUrl/users/$userId'),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'agency_role': 'agent'}),
    );
print("${response.body}");
    print("${response.statusCode}");

    if (response.statusCode != 200) {
      throw Exception('Failed to assign agent role: ${response.body}');
    }
  }
  @override
  Future<void> removeAgentRole(String userId) async {
    final response = await http.put(
      Uri.parse('$serverUrl/users/$userId'),
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'agency_role': 'client'}),
    );
    print("${response.body}");
    print("${response.statusCode}");

    if (response.statusCode != 200) {
      throw Exception('Failed to assign agent role: ${response.body}');
    }
  }
}