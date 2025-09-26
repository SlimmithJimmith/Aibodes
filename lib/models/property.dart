/**
 * Property model class representing a real estate listing
 * 
 * This class stores all property-related information including:
 * - Basic details (title, description, price, location)
 * - Property specifications (bedrooms, bathrooms, area)
 * - Media (images, property type)
 * - Metadata (seller, creation date, availability)
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
class Property {
  /// Unique identifier for the property (e.g., "prop_123")
  final String id;
  
  /// Property title/name (e.g., "Beautiful Downtown Apartment")
  final String title;
  
  /// Detailed property description
  final String description;
  
  /// Property price in USD (e.g., 450000.0)
  final double price;
  
  /// Property location (e.g., "Downtown, New York")
  final String location;
  
  /// Property address (e.g., "123 Main St, New York, NY 10001")
  final String address;
  
  /// Property latitude for map display
  final double latitude;
  
  /// Property longitude for map display
  final double longitude;
  
  /// Number of bedrooms in the property
  final int bedrooms;
  
  /// Number of bathrooms in the property
  final int bathrooms;
  
  /// Property area in square feet (e.g., 1200.0)
  final double area;
  
  /// Property square footage (alias for area)
  final double squareFeet;
  
  /// List of image URLs for the property
  final List<String> images;
  
  /// Type of property (house, apartment, condo, etc.)
  final PropertyType type;
  
  /// Property type (alias for type)
  final PropertyType propertyType;
  
  /// ID of the seller who owns this property
  final String sellerId;
  
  /// Timestamp when property was added to the app
  final DateTime createdAt;
  
  /// Whether the property is currently available for viewing/swiping
  final bool isAvailable;

  /**
   * Constructor for creating a new Property instance
   * 
   * @param id Required unique identifier
   * @param title Required property title
   * @param description Required property description
   * @param price Required property price in USD
   * @param location Required property location
   * @param bedrooms Required number of bedrooms
   * @param bathrooms Required number of bathrooms
   * @param area Required property area in square feet
   * @param images Required list of image URLs
   * @param type Required property type
   * @param sellerId Required seller ID
   * @param createdAt Required creation timestamp
   * @param isAvailable Optional availability status (defaults to true)
   */
  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.squareFeet,
    required this.images,
    required this.type,
    required this.propertyType,
    required this.sellerId,
    required this.createdAt,
    this.isAvailable = true,
  });

  /**
   * Factory constructor to create Property from JSON data
   * 
   * This method is used when loading property data from:
   * - API responses
   * - Local storage
   * - Database records
   * 
   * @param json Map containing property data in JSON format
   * @return Property instance created from JSON data
   */
  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      // Extract property ID from JSON
      id: json['id'],
      
      // Extract property title
      title: json['title'],
      
      // Extract property description
      description: json['description'],
      
      // Convert price to double (handles both int and double from JSON)
      price: json['price'].toDouble(),
      
      // Extract property location
      location: json['location'],
      
      // Extract number of bedrooms
      bedrooms: json['bedrooms'],
      
      // Extract number of bathrooms
      bathrooms: json['bathrooms'],
      
      // Convert area to double (handles both int and double from JSON)
      area: json['area'].toDouble(),
      
      // Convert images array to List<String>
      images: List<String>.from(json['images']),
      
      // Parse property type from string, default to apartment if not found
      type: PropertyType.values.firstWhere(
        (e) => e.toString() == 'PropertyType.${json['type']}',
        orElse: () => PropertyType.apartment,  // Default to apartment if type not found
      ),
      
      // Extract seller ID
      sellerId: json['sellerId'],
      
      // Parse creation timestamp from ISO string
      createdAt: DateTime.parse(json['createdAt']),
      
      // Extract availability status, default to true if not provided
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  /**
   * Converts Property instance to JSON format for storage/transmission
   * 
   * This method is used when saving property data to:
   * - API requests
   * - Local storage
   * - Database records
   * 
   * @return Map containing property data in JSON format
   */
  Map<String, dynamic> toJson() {
    return {
      'id': id,                                    // Property ID
      'title': title,                              // Property title
      'description': description,                  // Property description
      'price': price,                              // Property price
      'location': location,                        // Property location
      'bedrooms': bedrooms,                        // Number of bedrooms
      'bathrooms': bathrooms,                      // Number of bathrooms
      'area': area,                                // Property area
      'images': images,                            // List of image URLs
      'type': type.toString().split('.').last,     // Property type as string
      'sellerId': sellerId,                        // Seller ID
      'createdAt': createdAt.toIso8601String(),   // Creation timestamp as ISO string
      'isAvailable': isAvailable,                  // Availability status
    };
  }

  /**
   * Returns a formatted price string for display in the UI
   * 
   * This getter formats the price based on its value:
   * - Prices >= $1M: Shows as "$1.2M"
   * - Prices >= $1K: Shows as "$450K"
   * - Prices < $1K: Shows as "$500"
   * 
   * @return String formatted price for display
   */
  String get formattedPrice {
    if (price >= 1000000) {
      // Format millions (e.g., 1200000 -> "$1.2M")
      return '\$${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      // Format thousands (e.g., 450000 -> "$450K")
      return '\$${(price / 1000).toStringAsFixed(0)}K';
    } else {
      // Format regular prices (e.g., 500 -> "$500")
      return '\$${price.toStringAsFixed(0)}';
    }
  }

  /**
   * Returns a formatted string with key property details
   * 
   * This getter creates a summary string showing:
   * - Number of bedrooms
   * - Number of bathrooms  
   * - Property area in square feet
   * 
   * Example: "3 bed • 2 bath • 1200 sq ft"
   * 
   * @return String with formatted property details
   */
  String get propertyDetails {
    return '$bedrooms bed • $bathrooms bath • ${area.toStringAsFixed(0)} sq ft';
  }
}

/**
 * Enumeration representing different types of properties
 * 
 * This enum defines the six possible property types:
 * - apartment: Multi-unit residential building
 * - house: Single-family detached home
 * - condo: Condominium unit
 * - townhouse: Multi-story attached home
 * - studio: Single-room living space
 * - loft: Open-plan living space, often converted
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
enum PropertyType {
  /// Multi-unit residential building
  apartment,
  
  /// Single-family detached home
  house,
  
  /// Condominium unit
  condo,
  
  /// Multi-story attached home
  townhouse,
  
  /// Single-room living space
  studio,
  
  /// Open-plan living space, often converted from commercial
  loft,
  
  /// Vacant land for development
  land,
  
  /// Commercial property (office, retail, etc.)
  commercial,
}

/**
 * Extension on PropertyType enum to provide additional functionality
 * 
 * This extension adds methods to the PropertyType enum for:
 * - Converting enum values to human-readable display names
 * - Future extensibility for additional property type functionality
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
extension PropertyTypeExtension on PropertyType {
  /**
   * Returns a human-readable display name for the property type
   * 
   * This getter converts the enum value to a user-friendly string
   * that can be displayed in the UI
   * 
   * @return String representation of the property type for display
   */
  String get displayName {
    switch (this) {
      case PropertyType.apartment:
        return 'Apartment';              // Display as "Apartment"
      case PropertyType.house:
        return 'House';                  // Display as "House"
      case PropertyType.condo:
        return 'Condo';                  // Display as "Condo"
      case PropertyType.townhouse:
        return 'Townhouse';              // Display as "Townhouse"
      case PropertyType.studio:
        return 'Studio';                 // Display as "Studio"
      case PropertyType.loft:
        return 'Loft';                   // Display as "Loft"
      case PropertyType.land:
        return 'Land';                   // Display as "Land"
      case PropertyType.commercial:
        return 'Commercial';             // Display as "Commercial"
    }
  }
}
