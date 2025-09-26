class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final UserType type;
  final List<String> preferences;
  final DateTime createdAt;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.type,
    this.preferences = const [],
    required this.createdAt,
    this.isVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      type: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${json['type']}',
        orElse: () => UserType.buyer,
      ),
      preferences: List<String>.from(json['preferences'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'type': type.toString().split('.').last,
      'preferences': preferences,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
    };
  }
}

enum UserType {
  buyer,
  seller,
  both,
}

extension UserTypeExtension on UserType {
  String get displayName {
    switch (this) {
      case UserType.buyer:
        return 'Buyer';
      case UserType.seller:
        return 'Seller';
      case UserType.both:
        return 'Buyer & Seller';
    }
  }
}
