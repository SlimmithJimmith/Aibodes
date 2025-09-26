/**
 * Match model class representing a connection between a buyer and property
 * 
 * This class stores match-related information including:
 * - Participant IDs (buyer, seller, property)
 * - Match metadata (timestamp, status, message)
 * - Match lifecycle management (pending, accepted, declined, expired)
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
class Match {
  /// Unique identifier for the match (e.g., "match_123")
  final String id;
  
  /// ID of the buyer who liked the property
  final String buyerId;
  
  /// ID of the seller who owns the property
  final String sellerId;
  
  /// ID of the property that was liked
  final String propertyId;
  
  /// Timestamp when the match was created
  final DateTime matchedAt;
  
  /// Current status of the match (pending, accepted, declined, expired)
  final MatchStatus status;
  
  /// Optional message from buyer to seller (nullable)
  final String? message;

  /**
   * Constructor for creating a new Match instance
   * 
   * @param id Required unique identifier
   * @param buyerId Required ID of the buyer
   * @param sellerId Required ID of the seller
   * @param propertyId Required ID of the property
   * @param matchedAt Required timestamp when match was created
   * @param status Required current match status
   * @param message Optional message from buyer to seller
   */
  Match({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.propertyId,
    required this.matchedAt,
    required this.status,
    this.message,
  });

  /**
   * Factory constructor to create Match from JSON data
   * 
   * This method is used when loading match data from:
   * - API responses
   * - Local storage
   * - Database records
   * 
   * @param json Map containing match data in JSON format
   * @return Match instance created from JSON data
   */
  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      // Extract match ID from JSON
      id: json['id'],
      
      // Extract buyer ID
      buyerId: json['buyerId'],
      
      // Extract seller ID
      sellerId: json['sellerId'],
      
      // Extract property ID
      propertyId: json['propertyId'],
      
      // Parse match timestamp from ISO string
      matchedAt: DateTime.parse(json['matchedAt']),
      
      // Parse match status from string, default to pending if not found
      status: MatchStatus.values.firstWhere(
        (e) => e.toString() == 'MatchStatus.${json['status']}',
        orElse: () => MatchStatus.pending,  // Default to pending if status not found
      ),
      
      // Extract optional message
      message: json['message'],
    );
  }

  /**
   * Converts Match instance to JSON format for storage/transmission
   * 
   * This method is used when saving match data to:
   * - API requests
   * - Local storage
   * - Database records
   * 
   * @return Map containing match data in JSON format
   */
  Map<String, dynamic> toJson() {
    return {
      'id': id,                                    // Match ID
      'buyerId': buyerId,                          // Buyer ID
      'sellerId': sellerId,                        // Seller ID
      'propertyId': propertyId,                    // Property ID
      'matchedAt': matchedAt.toIso8601String(),   // Match timestamp as ISO string
      'status': status.toString().split('.').last, // Match status as string
      'message': message,                          // Optional message (nullable)
    };
  }
}

/**
 * Enumeration representing different statuses of a match
 * 
 * This enum defines the four possible match statuses:
 * - pending: Match created but seller hasn't responded yet
 * - accepted: Seller accepted the buyer's interest
 * - declined: Seller declined the buyer's interest
 * - expired: Match expired due to time limit or other conditions
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
enum MatchStatus {
  /// Match created but seller hasn't responded yet
  pending,
  
  /// Seller accepted the buyer's interest
  accepted,
  
  /// Seller declined the buyer's interest
  declined,
  
  /// Match expired due to time limit or other conditions
  expired,
}

/**
 * Extension on MatchStatus enum to provide additional functionality
 * 
 * This extension adds methods to the MatchStatus enum for:
 * - Converting enum values to human-readable display names
 * - Future extensibility for additional match status functionality
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
extension MatchStatusExtension on MatchStatus {
  /**
   * Returns a human-readable display name for the match status
   * 
   * This getter converts the enum value to a user-friendly string
   * that can be displayed in the UI
   * 
   * @return String representation of the match status for display
   */
  String get displayName {
    switch (this) {
      case MatchStatus.pending:
        return 'Pending';                // Display as "Pending"
      case MatchStatus.accepted:
        return 'Accepted';               // Display as "Accepted"
      case MatchStatus.declined:
        return 'Declined';               // Display as "Declined"
      case MatchStatus.expired:
        return 'Expired';                // Display as "Expired"
    }
  }
}
