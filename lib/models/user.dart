/**
 * User model class representing a PropertySwipe app user
 * 
 * This class stores all user-related information including:
 * - Personal details (name, email, phone, address)
 * - Profile information (photo, preferences)
 * - Account metadata (creation date, verification status)
 * - User type (buyer, seller, or both)
 * 
 * @author PropertySwipe Team
 * @version 1.0.0
 */
class User {
  /// Unique identifier for the user (e.g., "user_123")
  final String id;
  
  /// User's first name (editable)
  String firstName;
  
  /// User's last name (editable)
  String lastName;
  
  /// User's email address (editable, must be valid format)
  String email;
  
  /// Path to user's profile image file (optional, nullable)
  String? profileImage;
  
  /// User's physical address (optional, nullable)
  String? address;
  
  /// User's phone number (optional, nullable)
  String? phoneNumber;
  
  /// Type of user: buyer, seller, or both (immutable)
  final UserType type;
  
  /// List of user's property preferences (e.g., ["modern", "downtown"])
  final List<String> preferences;
  
  /// Timestamp when user account was created (immutable)
  final DateTime createdAt;
  
  /// Timestamp when user profile was last updated (mutable)
  DateTime updatedAt;
  
  /// Whether the user account is verified (immutable)
  final bool isVerified;

  /**
   * Constructor for creating a new User instance
   * 
   * @param id Required unique identifier
   * @param firstName Required first name
   * @param lastName Required last name
   * @param email Required email address
   * @param profileImage Optional profile image file path
   * @param address Optional physical address
   * @param phoneNumber Optional phone number
   * @param type Required user type (buyer/seller/both)
   * @param preferences Optional list of property preferences
   * @param createdAt Required account creation timestamp
   * @param updatedAt Required last update timestamp
   * @param isVerified Optional verification status (defaults to false)
   */
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

  /**
   * Getter that combines first and last name into full name
   * 
   * @return String containing "firstName lastName"
   */
  String get fullName => '$firstName $lastName';

  /**
   * Factory constructor to create User from JSON data
   * 
   * This method is used when loading user data from:
   * - Local storage (SharedPreferences)
   * - API responses
   * - Database records
   * 
   * Handles backward compatibility by supporting both old "name" field
   * and new "firstName"/"lastName" fields
   * 
   * @param json Map containing user data in JSON format
   * @return User instance created from JSON data
   */
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // Extract user ID from JSON
      id: json['id'],
      
      // Handle both new firstName field and legacy name field
      // If firstName exists, use it; otherwise split name field; fallback to 'John'
      firstName: json['firstName'] ?? json['name']?.split(' ').first ?? 'John',
      
      // Handle both new lastName field and legacy name field
      // If lastName exists, use it; otherwise use rest of name field; fallback to 'Doe'
      lastName: json['lastName'] ?? json['name']?.split(' ').skip(1).join(' ') ?? 'Doe',
      
      // Extract email (required field)
      email: json['email'],
      
      // Extract optional profile image path
      profileImage: json['profileImage'],
      
      // Extract optional address
      address: json['address'],
      
      // Extract optional phone number
      phoneNumber: json['phoneNumber'],
      
      // Parse user type from string, default to buyer if not found
      type: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${json['type']}',
        orElse: () => UserType.buyer,  // Default to buyer if type not found
      ),
      
      // Convert preferences list from JSON, default to empty list
      preferences: List<String>.from(json['preferences'] ?? []),
      
      // Parse creation timestamp from ISO string
      createdAt: DateTime.parse(json['createdAt']),
      
      // Parse update timestamp, fallback to createdAt if not provided
      updatedAt: DateTime.parse(json['updatedAt'] ?? json['createdAt']),
      
      // Extract verification status, default to false
      isVerified: json['isVerified'] ?? false,
    );
  }

  /**
   * Converts User instance to JSON format for storage/transmission
   * 
   * This method is used when saving user data to:
   * - Local storage (SharedPreferences)
   * - API requests
   * - Database records
   * 
   * @return Map containing user data in JSON format
   */
  Map<String, dynamic> toJson() {
    return {
      'id': id,                                    // User ID
      'firstName': firstName,                      // First name
      'lastName': lastName,                        // Last name
      'email': email,                              // Email address
      'profileImage': profileImage,                // Profile image path (nullable)
      'address': address,                          // Physical address (nullable)
      'phoneNumber': phoneNumber,                  // Phone number (nullable)
      'type': type.toString().split('.').last,     // User type as string
      'preferences': preferences,                  // Property preferences list
      'createdAt': createdAt.toIso8601String(),   // Creation timestamp as ISO string
      'updatedAt': updatedAt.toIso8601String(),   // Update timestamp as ISO string
      'isVerified': isVerified,                    // Verification status
    };
  }

  /**
   * Creates a new User instance with some fields updated
   * 
   * This method is used for updating user profile information.
   * It creates a new User instance with the same data as the current instance,
   * but with specified fields updated. The updatedAt timestamp is automatically
   * set to the current time.
   * 
   * @param firstName Optional new first name
   * @param lastName Optional new last name
   * @param email Optional new email address
   * @param profileImage Optional new profile image path
   * @param address Optional new address
   * @param phoneNumber Optional new phone number
   * @param preferences Optional new preferences list
   * @return New User instance with updated fields
   */
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
      id: id,                                    // Keep same ID
      firstName: firstName ?? this.firstName,    // Use new value or keep current
      lastName: lastName ?? this.lastName,       // Use new value or keep current
      email: email ?? this.email,                // Use new value or keep current
      profileImage: profileImage ?? this.profileImage,  // Use new value or keep current
      address: address ?? this.address,          // Use new value or keep current
      phoneNumber: phoneNumber ?? this.phoneNumber,  // Use new value or keep current
      type: type,                                // Keep same type (immutable)
      preferences: preferences ?? this.preferences,  // Use new value or keep current
      createdAt: createdAt,                      // Keep same creation time (immutable)
      updatedAt: DateTime.now(),                 // Set to current time
      isVerified: isVerified,                    // Keep same verification status (immutable)
    );
  }
}

/**
 * Enumeration representing different types of users in the PropertySwipe app
 * 
 * This enum defines the three possible user types:
 * - buyer: User who is looking to purchase properties
 * - seller: User who is looking to sell properties  
 * - both: User who can both buy and sell properties
 * 
 * @author PropertySwipe Team
 * @version 1.0.0
 */
enum UserType {
  /// User who is looking to purchase properties
  buyer,
  
  /// User who is looking to sell properties
  seller,
  
  /// User who can both buy and sell properties
  both,
}

/**
 * Extension on UserType enum to provide additional functionality
 * 
 * This extension adds methods to the UserType enum for:
 * - Converting enum values to human-readable display names
 * - Future extensibility for additional user type functionality
 * 
 * @author PropertySwipe Team
 * @version 1.0.0
 */
extension UserTypeExtension on UserType {
  /**
   * Returns a human-readable display name for the user type
   * 
   * This getter converts the enum value to a user-friendly string
   * that can be displayed in the UI
   * 
   * @return String representation of the user type for display
   */
  String get displayName {
    switch (this) {
      case UserType.buyer:
        return 'Buyer';                    // Display as "Buyer"
      case UserType.seller:
        return 'Seller';                   // Display as "Seller"
      case UserType.both:
        return 'Buyer & Seller';           // Display as "Buyer & Seller"
    }
  }
}
