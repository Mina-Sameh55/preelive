import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../model/user model.dart';
import '../repo/usershipping repo.dart';

class ShippingAgentRepositoryImpl implements ShippingAgentRepository {
  final String appId = 'SpzDQ8AKK7WEBVBSUkwU4C9Xsxfyjsboz4PwXyjW';
  final String masterKey = 'lbcdkueIQFQEnm7gM5jj114myeNO8YCsdFVKIxSd';
  final String serverUrl = 'https://parseapi.back4app.com';
  @override
  Future<List<UserModel>> getUsersWithPoints() async {
    final filter = {
      "\$or": [
        // {"agency_role": "agent"},
        {"myAgentId": 1},
      ]
    };

    final userUri = Uri.parse("$serverUrl/classes/_User").replace(
      queryParameters: {
        "where": jsonEncode(filter),
        "limit": "2000"
      },
    );

    final userResponse = await http.get(
      userUri,
      headers: {
        'X-Parse-Application-Id': appId,
        'X-Parse-Master-Key': masterKey,
      },
    );
print("${userResponse.body}");
    if (userResponse.statusCode != 200) {
      throw Exception("Failed to load users");
    }

    final List userData = json.decode(userResponse.body)['results'];

    List<UserModel> usersWithPoints = [];

    for (final userJson in userData) {
      final userId = userJson['objectId'];

      // جلب نقاط الوكيل من جدول Agency
      final agencyQuery = {
        "where": jsonEncode({
          "user": {
            "__type": "Pointer",
            "className": "_User",
            "objectId": userId
          }
        })
      };

      final agencyUri = Uri.parse('$serverUrl/classes/Agency')
          .replace(queryParameters: agencyQuery);

      final agencyResponse = await http.get(
        agencyUri,
        headers: {
          'X-Parse-Application-Id': appId,
          'X-Parse-Master-Key': masterKey,
        },
      );

      int points = 0;

      if (agencyResponse.statusCode == 200) {
        final List agencyResults =
        json.decode(agencyResponse.body)['results'];
        if (agencyResults.isNotEmpty) {
          points = agencyResults.first['points'] ?? 0;
        }
      }

      final user = UserModel.fromJson(userJson);
      usersWithPoints.add(user.copyWith(userPoints: points));
    }

    return usersWithPoints;
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
              {"objectId": {"\$regex": query, "\$options": "i"}},

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
  Future<void> updateUserPoints({
    required String userId,
    required int points,
  }) async {
    try {
      // 1. ابحث عن الـ Agency المرتبطة بالـ user
      final query = QueryBuilder(ParseObject('Agency'))
        ..whereEqualTo('user', ParseObject('_User')..objectId = userId);

      final response = await query.query();

      ParseObject agency;

      if (!response.success) {
        throw Exception('Query failed for Agency');
      }

      if (response.results == null || response.results!.isEmpty) {
        // ✅ لو مفيش agency اعمل واحدة جديدة
        final newAgency = ParseObject('Agency')
          ..set('points', points)
          ..set('user', ParseObject('_User')..objectId = userId);

        final createResponse = await newAgency.save();

        if (!createResponse.success) {
          throw Exception('Failed to create new Agency');
        }

        agency = newAgency;
      } else {
        // ✅ لو موجودة استعملها
        agency = response.results!.first as ParseObject;

        // حدّث النقاط
        agency.set('points', points);
        final updateAgency = await agency.save();

        if (!updateAgency.success) {
          throw Exception('Failed to update agency points');
        }
      }

      // 2. عدل قيمة myAgentId في جدول _User
      final user = ParseObject('_User')..objectId = userId;
      user.set('myAgentId', 1);
      final updateUser = await user.save();

      if (!updateUser.success) {
        throw Exception('Failed to update user myAgentId');
      }

      print('✅ تم التحديث بنجاح');
    } catch (e) {
      print('❌ Error in updateUserPoints: $e');
      rethrow;
    }
  }}
//   @override
//   Future<void> updateUserPoints({
//     required String userId,
//     required int points,
//   }) async {
//     // 1. إنشاء أو تحديث كلاس Agency بالنقاط وربطه بالمستخدم
//     final agencyUri = Uri.parse('$serverUrl/classes/Agency/$userId');
//
//     final agencyBody = {
//       "points": points,
//       "user": {
//         "__type": "Pointer",
//         "className": "_User",
//         "objectId": userId,
//       }
//     };
//
//     final agencyResponse = await http.put(
//       agencyUri,
//       headers: {
//         'X-Parse-Application-Id': appId,
//         'X-Parse-Master-Key': masterKey,
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(agencyBody),
//     );
// print("${agencyResponse.body}");
//     if (agencyResponse.statusCode != 201) {
//       throw Exception('Failed to update agency points: ${agencyResponse.body}');
//     }
//
//     final userUri = Uri.parse('$serverUrl/classes/_User/$userId');
//
//     final userBody = {
//       "myAgentId": "1",
//     };
//
//     final userResponse = await http.put(
//       userUri,
//       headers: {
//         'X-Parse-Application-Id': appId,
//         'X-Parse-Master-Key': masterKey,
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(userBody),
//     );
//
//     if (userResponse.statusCode != 200) {
//       throw Exception('Failed to update user myAgentId: ${userResponse.body}');
//     }
//   }
// }