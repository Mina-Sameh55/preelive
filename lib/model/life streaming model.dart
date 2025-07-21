class LiveStream {
  final String id;
  final String title;
  final String hostId;
  final String hostName;
  final int viewers;
  final DateTime startTime;
  final String thumbnailUrl;
  final bool isActive;
  final int diamonds;
  final String battleStatus;
  final String liveType;
  final bool isPrivate;
  final List<dynamic> hashtags;
  final int numberOfChairs;
  final String partyType;
  final String streamingChannel;

  LiveStream({
    required this.id,
    required this.title,
    required this.hostId,
    required this.hostName,
    required this.viewers,
    required this.startTime,
    required this.thumbnailUrl,
    required this.isActive,
    required this.diamonds,
    required this.battleStatus,
    required this.liveType,
    required this.isPrivate,
    required this.hashtags,
    required this.numberOfChairs,
    required this.partyType,
    required this.streamingChannel,
  });

  factory LiveStream.fromJson(Map<String, dynamic> json) {
    // Handle nested Author object
    final author = json['Author'] is Map ? json['Author'] : null;
    final image = json['image'] is Map ? json['image'] : null;

    // Handle Parse date format
    DateTime parseDate(dynamic dateField) {
      if (dateField is Map && dateField['__type'] == 'Date') {
        return DateTime.parse(dateField['iso']);
      } else if (dateField is String) {
        return DateTime.parse(dateField);
      }
      return DateTime.now();
    }

    return LiveStream(
      id: json['objectId'] ?? '',
      title: json['audio_room_title'] ?? 'No Title',
      hostId: author != null ? author['objectId'] : json['AuthorId'] ?? '',
      hostName: author != null
          ? (author['username'] ?? author['displayName'] ?? 'Anonymous')
          : json['username'] ?? 'Anonymous',
      viewers: json['viewersCountLive'] is int
          ? json['viewersCountLive']
          : 0,
      startTime: parseDate(json['createdAt']),
      thumbnailUrl: image != null
          ? (image['url'] ?? '')
          : '',
      isActive: json['streaming'] is bool
          ? json['streaming']
          : false,
      diamonds: json['streaming_diamonds'] is int
          ? json['streaming_diamonds']
          : 0,
      battleStatus: json['battle_status'] is String
          ? json['battle_status']
          : 'inactive',
      liveType: json['liveType'] is String
          ? json['liveType']
          : 'normal',
      isPrivate: json['private'] is bool
          ? json['private']
          : false,
      hashtags: json['hash_tags'] is List
          ? json['hash_tags']
          : [],
      numberOfChairs: json['number_of_chairs'] is int
          ? json['number_of_chairs']
          : 0,
      partyType: json['party_type'] is String
          ? json['party_type']
          : '',
      streamingChannel: json['streaming_channel'] is String
          ? json['streaming_channel']
          : '',
    );
  }
}