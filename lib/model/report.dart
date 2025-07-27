class Report {
  final String id;
  final String type;
  final String reason;
  final String reporterId;
  final String reporterName;
  final String targetId;
  final String targetType;
  final DateTime createdAt;
  final bool isResolved;

  Report({
    required this.id,
    required this.type,
    required this.reason,
    required this.reporterId,
    required this.reporterName,
    required this.targetId,
    required this.targetType,
    required this.createdAt,
    required this.isResolved,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['objectId'],
      type: json['type'] ?? 'Other',
      reason: json['reason'] ?? '',
      reporterId: json['reporter']['objectId'],
      reporterName: json['reporter']['name'] ?? 'Anonymous',
      targetId: json['targetId'],
      targetType: json['targetType'] ?? 'User',
      createdAt: DateTime.parse(json['createdAt']),
      isResolved: json['isResolved'] ?? false,
    );
  }
}