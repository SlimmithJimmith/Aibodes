class Match {
  final String id;
  final String buyerId;
  final String sellerId;
  final String propertyId;
  final DateTime matchedAt;
  final MatchStatus status;
  final String? message;

  Match({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.propertyId,
    required this.matchedAt,
    required this.status,
    this.message,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      buyerId: json['buyerId'],
      sellerId: json['sellerId'],
      propertyId: json['propertyId'],
      matchedAt: DateTime.parse(json['matchedAt']),
      status: MatchStatus.values.firstWhere(
        (e) => e.toString() == 'MatchStatus.${json['status']}',
        orElse: () => MatchStatus.pending,
      ),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'propertyId': propertyId,
      'matchedAt': matchedAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'message': message,
    };
  }
}

enum MatchStatus {
  pending,
  accepted,
  declined,
  expired,
}

extension MatchStatusExtension on MatchStatus {
  String get displayName {
    switch (this) {
      case MatchStatus.pending:
        return 'Pending';
      case MatchStatus.accepted:
        return 'Accepted';
      case MatchStatus.declined:
        return 'Declined';
      case MatchStatus.expired:
        return 'Expired';
    }
  }
}
