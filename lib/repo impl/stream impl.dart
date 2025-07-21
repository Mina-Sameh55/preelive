import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../model/life streaming model.dart';
import '../repo/stream repo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StreamRepositoryImpl implements StreamRepository {
  final String _baseUrl = 'https://parseapi.back4app.com/classes/Streaming';
  final String _appId = 'SpzDQ8AKK7WEBVBSUkwU4C9Xsxfyjsboz4PwXyjW';
  final String _restKey = '1N9033LOw5A018zPw8p5hY0oeifTMv3a7Oqhgb1r';
  final String _masterKey = 'lbcdkueIQFQEnm7gM5jj114myeNO8YCsdFVKIxSd';

  Map<String, String> get _headers => {
    'X-Parse-Application-Id': _appId,
    'X-Parse-REST-API-Key': _restKey,
    'X-Parse-Master-Key': _masterKey,
    'Content-Type': 'application/json',
  };

  @override
  Future<List<LiveStream>> getActiveStreams({int page = 0, int limit = 20}) async {
    final where = jsonEncode({
      'streaming': true,
    });

    return _fetchStreams(where: where, page: page, limit: limit);
  }

  @override
  Future<List<LiveStream>> getFilteredStreams({
    required String filter,
    int page = 0,
    int limit = 20,
  }) async {
    Map<String, dynamic> where = {'streaming': true};

    switch (filter) {
      case 'battle':
        where['battle_status'] = 'active';
        break;
      case 'private':
        where['private'] = true;
        break;
      case 'audio':
        where['liveType'] = 'audio';
        break;
      case 'video':
        where['liveType'] = 'video';
        break;
      case 'popular':
        where['viewersCountLive'] = {'\$gt': 1000};
        break;
    }

    return _fetchStreams(where: jsonEncode(where), page: page, limit: limit);
  }

  Future<List<LiveStream>> _fetchStreams({
    required String where,
    int page = 0,
    int limit = 20,
  }) async {
    final response = await http.get(
      Uri.parse(_baseUrl).replace(queryParameters: {
        'where': where,
        'order': '-createdAt',
        'limit': limit.toString(),
        'skip': (page * limit).toString(),
        'include': 'Author,privateLivePrice',
      }),
      headers: _headers,
    );
print("${response.body}");
    print("${response.statusCode}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['results'] as List;
      return data.map((json) => LiveStream.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load streams: ${response.statusCode}');
    }
  }

  @override
  Future<void> terminateStream(String streamId) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$streamId'),
      headers: _headers,
      body: jsonEncode({
        'streaming': false,
        'updatedAt': _formatDate(DateTime.now()),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to terminate stream: ${response.statusCode}');
    }
  }

  @override
  Future<LiveStream> updateStreamStats(
      String streamId,
      int newViewers,
      int newDiamonds,
      ) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$streamId'),
      headers: _headers,
      body: jsonEncode({
        'viewersCountLive': newViewers,
        'streaming_diamonds': newDiamonds,
        'updatedAt': _formatDate(DateTime.now()),
      }),
    );

    if (response.statusCode == 200) {
      return LiveStream.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Update failed: ${response.statusCode}');
    }
  }

  @override
  Future<LiveStream> createStream(LiveStream newStream) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: _headers,
      body: jsonEncode({
        'audio_room_title': newStream.title,
        'AuthorId': newStream.hostId,
        'username': newStream.hostName,
        'streaming': true,
        'viewersCountLive': newStream.viewers,
        'streaming_diamonds': newStream.diamonds,
        'battle_status': newStream.battleStatus,
        'liveType': newStream.liveType,
        'private': newStream.isPrivate,
        'hash_tags': newStream.hashtags,
        'number_of_chairs': newStream.numberOfChairs,
        'party_type': newStream.partyType,
        'streaming_channel': newStream.streamingChannel,
        'image': newStream.thumbnailUrl.isNotEmpty ? {
          '__type': 'File',
          'name': 'thumbnail.jpg',
          'url': newStream.thumbnailUrl,
        } : null,
        'createdAt': _formatDate(DateTime.now()),
      }),
    );

    if (response.statusCode == 201) {
      return LiveStream.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Creation failed: ${response.statusCode}');
    }
  }

  @override
  Future<void> updateBattleStatus(
      String streamId,
      String status,
      int myPoints,
      int hisPoints,
      ) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$streamId'),
      headers: _headers,
      body: jsonEncode({
        'battle_status': status,
        'my_points': myPoints,
        'his_points': hisPoints,
        'updatedAt': _formatDate(DateTime.now()),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Battle update failed: ${response.statusCode}');
    }
  }
  @override
  Future<void> deleteStream(String streamId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$streamId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete stream: ${response.statusCode}');
    }
  }
  @override
  Future<List<LiveStream>> searchStreams(String query, {int page = 0, int limit = 20}) async {
    final where = jsonEncode({
      '\$or': [
        {'audio_room_title': {'\$regex': query, '\$options': 'i'}},
        {'username': {'\$regex': query, '\$options': 'i'}},
        {'hash_tags': {'\$regex': query, '\$options': 'i'}},
      ],
      'streaming': true,
    });

    return _fetchStreams(where: where, page: page, limit: limit);
  }

  Map<String, String> _formatDate(DateTime date) {
    return {
      '__type': 'Date',
      'iso': date.toUtc().toIso8601String(),
    };
  }
}