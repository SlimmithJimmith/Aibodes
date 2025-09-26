class User {
  final String id;
  String firstName;
  String lastName;
  String email;
  String? profileImage;
  String? address;
  String? phoneNumber;
  final UserType type;
  final List<String> preferences;
  final DateTime createdAt;
  DateTime updatedAt;
  final bool isVerified;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileImage,
    this.address,
    this.phoneNumber,
    required this.type,
    this.preferences = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'] ?? json['name']?.split(' ').first ?? 'John',
      lastName: json['lastName'] ?? json['name']?.split(' ').skip(1).join(' ') ?? 'Doe',
      email: json['email'],
      profileImage: json['profileImage'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      type: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${json['type']}',
        orElse: () => UserType.buyer,
      ),
      preferences: List<String>.from(json['preferences'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt'] ?? json['createdAt']),
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profileImage': profileImage,
      'address': address,
      'phoneNumber': phoneNumber,
      'type': type.toString().split('.').last,
      'preferences': preferences,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isVerified': isVerified,
    };
  }

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? profileImage,
    String? address,
    String? phoneNumber,
    List<String>? preferences,
  }) {
    return User(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      type: type,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isVerified: isVerified,
    );
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
