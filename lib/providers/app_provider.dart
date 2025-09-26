// Import Flutter's material design components
import 'package:flutter/material.dart';
// Import our custom models
import '../models/property.dart';
import '../models/user.dart';
import '../models/match.dart';
// Import custom widgets
import '../widgets/swipeable_property_stack.dart';

/**
 * AppProvider class for managing global application state
 * 
 * This class extends ChangeNotifier to provide reactive state management
 * for the entire Aibodes application. It manages:
 * - Available properties for swiping
 * - User interactions (swiped, liked, viewed properties)
 * - Match creation and management
 * - Current user profile data
 * - Loading states
 * 
 * The provider pattern allows any widget in the app to access and modify
 * the app state by listening to changes and updating the UI accordingly.
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
class AppProvider extends ChangeNotifier {
  /// List of properties available for swiping (not yet interacted with)
  List<Property> _availableProperties = [];
  
  /// List of properties the user has swiped (both left and right)
  List<Property> _swipedProperties = [];
  
  /// List of properties the user has liked (swiped right)
  List<Property> _likedProperties = [];
  
  /// List of properties the user has viewed (tapped for details)
  List<Property> _viewedProperties = [];
  
  /// List of all matches created from user interactions
  List<Match> _matches = [];
  
  /// Current logged-in user (null if not logged in)
  User? _currentUser;
  
  /// Loading state indicator for async operations
  bool _isLoading = false;

  // ==================== GETTERS ====================
  
  /**
   * Getter for available properties list
   * @return List of properties available for swiping
   */
  List<Property> get availableProperties => _availableProperties;
  
  /**
   * Getter for swiped properties list
   * @return List of properties the user has swiped
   */
  List<Property> get swipedProperties => _swipedProperties;
  
  /**
   * Getter for liked properties list
   * @return List of properties the user has liked
   */
  List<Property> get likedProperties => _likedProperties;
  
  /**
   * Getter for viewed properties list
   * @return List of properties the user has viewed
   */
  List<Property> get viewedProperties => _viewedProperties;
  
  /**
   * Getter for matches list
   * @return List of all matches
   */
  List<Match> get matches => _matches;
  
  /**
   * Getter for current user
   * @return Current user instance or null if not logged in
   */
  User? get currentUser => _currentUser;
  
  /**
   * Getter for loading state
   * @return True if app is currently loading, false otherwise
   */
  bool get isLoading => _isLoading;

  // ==================== INITIALIZATION ====================
  
  /**
   * Initializes the app with sample data
   * 
   * This method sets up the app with:
   * - A sample user account
   * - Sample properties for swiping
   * - Loading state management
   * 
   * In a production app, this would typically:
   * - Load user data from local storage or API
   * - Fetch properties from a backend service
   * - Handle authentication state
   */
  void initializeApp() {
    // Set loading state to true and notify listeners
    _isLoading = true;
    notifyListeners();

    // Create a sample user for demonstration purposes
    _currentUser = User(
      id: 'user_1',                    // Unique user ID
      firstName: 'John',               // First name
      lastName: 'Doe',                 // Last name
      email: 'john@example.com',       // Email address
      type: UserType.buyer,            // User type (buyer)
      createdAt: DateTime.now(),       // Account creation time
      updatedAt: DateTime.now(),       // Last update time
      isVerified: true,                // Account verification status
    );

    // Generate and load sample properties
    _availableProperties = _generateSampleProperties();
    
    // Set loading state to false and notify listeners
    _isLoading = false;
    notifyListeners();
  }

  // ==================== USER INTERACTIONS ====================
  
  /**
   * Handles property swiping interactions
   * 
   * This method processes when a user swipes left (pass) or right (like) on a property:
   * - Removes property from available list
   * - Adds to swiped properties list
   * - If swiped right, adds to liked properties and creates a match
   * - Prevents duplicate swipes on the same property
   * 
   * @param property The property being swiped
   * @param direction The swipe direction (left = pass, right = like)
   */
  void swipeProperty(Property property, SwipeDirection direction) {
    // Prevent duplicate swipes on the same property
    if (_swipedProperties.contains(property)) return;

    // Move property from available to swiped list
    _swipedProperties.add(property);
    _availableProperties.remove(property);

    // If user liked the property (swiped right)
    if (direction == SwipeDirection.right) {
      // Add to liked properties list for later viewing
      _likedProperties.add(property);
      
      // Create a potential match with the seller
      _createMatch(property);
    }

    // Notify all listening widgets of the state change
    notifyListeners();
  }

  /**
   * Tracks when a user views property details
   * 
   * This method adds a property to the viewed properties list
   * when the user taps on it to see more details. This helps
   * track user engagement and can be used for analytics.
   * 
   * @param property The property being viewed
   */
  void viewProperty(Property property) {
    // Only add if not already viewed to prevent duplicates
    if (!_viewedProperties.contains(property)) {
      _viewedProperties.add(property);
      
      // Notify all listening widgets of the state change
      notifyListeners();
    }
  }

  // ==================== USER MANAGEMENT ====================
  
  /**
   * Updates the current user's profile information
   * 
   * This method updates the current user with new profile data
   * and notifies listeners of the change. In a production app,
   * this would typically make an API call to persist the changes.
   * 
   * @param updatedUser The updated user object with new information
   */
  Future<void> updateUser(User updatedUser) async {
    // Update the current user reference
    _currentUser = updatedUser;
    
    // Notify all listening widgets of the state change
    notifyListeners();
    
    // TODO: In a real app, this would make an API call to save the user data
    // Example: await userService.updateUser(updatedUser);
  }

  // ==================== MATCH MANAGEMENT ====================
  
  /**
   * Creates a new match when a user likes a property
   * 
   * This private method is called internally when a user swipes right
   * on a property. It creates a match record that can be used for
   * seller notifications and match management.
   * 
   * @param property The property that was liked
   */
  void _createMatch(Property property) {
    // TODO: In a real app, this would make an API call to create the match
    // on the backend and potentially notify the seller
    
    final match = Match(
      id: 'match_${DateTime.now().millisecondsSinceEpoch}',  // Unique match ID
      buyerId: _currentUser!.id,                             // Current user's ID
      sellerId: property.sellerId,                           // Property owner's ID
      propertyId: property.id,                               // Property ID
      matchedAt: DateTime.now(),                             // Match creation time
      status: MatchStatus.pending,                           // Initial status
    );

    // Add the new match to the matches list
    _matches.add(match);
  }

  /**
   * Removes a match from the matches list
   * 
   * This method is used when a user wants to remove a match,
   * such as when they no longer want to be connected to a seller.
   * 
   * @param match The match to remove
   */
  void removeMatch(Match match) {
    // Remove the match from the list
    _matches.remove(match);
    
    // Notify all listening widgets of the state change
    notifyListeners();
  }

  /**
   * Updates the status of an existing match
   * 
   * This method allows changing the match status (pending, accepted, declined, expired).
   * It's typically used when a seller responds to a buyer's interest.
   * 
   * @param match The match to update
   * @param status The new status for the match
   */
  void updateMatchStatus(Match match, MatchStatus status) {
    // Find the match in the list by ID
    final index = _matches.indexWhere((m) => m.id == match.id);
    
    if (index != -1) {
      // Create a new match object with the updated status
      _matches[index] = Match(
        id: match.id,                    // Keep same ID
        buyerId: match.buyerId,          // Keep same buyer ID
        sellerId: match.sellerId,        // Keep same seller ID
        propertyId: match.propertyId,    // Keep same property ID
        matchedAt: match.matchedAt,      // Keep same match time
        status: status,                  // Update the status
        message: match.message,          // Keep same message
      );
      
      // Notify all listening widgets of the state change
      notifyListeners();
    }
  }

  // ==================== SAMPLE DATA GENERATION ====================
  
  /**
   * Generates sample properties for demonstration purposes
   * 
   * This method creates a comprehensive list of 20+ sample properties
   * with diverse characteristics including:
   * - Different property types (apartment, house, condo, etc.)
   * - Various price ranges and locations
   * - Different bedroom/bathroom configurations
   * - High-quality images from Unsplash
   * - Realistic property descriptions
   * 
   * In a production app, this data would come from:
   * - API calls to a backend service
   * - Database queries
   * - Real estate listing services
   * 
   * @return List of sample Property objects for swiping
   */
  List<Property> _generateSampleProperties() {
    return [
      Property(
        id: 'prop_1',
        title: 'Modern Downtown Apartment',
        description: 'Beautiful modern apartment in the heart of downtown with stunning city views.',
        price: 450000,
        location: 'Downtown, New York',
        bedrooms: 2,
        bathrooms: 2,
        area: 1200,
        images: [
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800',
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        ],
        type: PropertyType.apartment,
        sellerId: 'seller_1',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Property(
        id: 'prop_2',
        title: 'Cozy Family House',
        description: 'Perfect family home with a large backyard and modern amenities.',
        price: 650000,
        location: 'Suburbs, California',
        bedrooms: 4,
        bathrooms: 3,
        area: 2500,
        images: [
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800',
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800',
        ],
        type: PropertyType.house,
        sellerId: 'seller_2',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Property(
        id: 'prop_3',
        title: 'Luxury Penthouse',
        description: 'Stunning penthouse with panoramic views and premium finishes.',
        price: 1200000,
        location: 'Manhattan, New York',
        bedrooms: 3,
        bathrooms: 3,
        area: 2000,
        images: [
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
        ],
        type: PropertyType.condo,
        sellerId: 'seller_3',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      Property(
        id: 'prop_4',
        title: 'Charming Studio',
        description: 'Perfect starter home in a vibrant neighborhood.',
        price: 280000,
        location: 'Brooklyn, New York',
        bedrooms: 1,
        bathrooms: 1,
        area: 600,
        images: [
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
          'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
        ],
        type: PropertyType.studio,
        sellerId: 'seller_4',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      Property(
        id: 'prop_5',
        title: 'Spacious Townhouse',
        description: 'Beautiful townhouse with modern design and great location.',
        price: 750000,
        location: 'Boston, Massachusetts',
        bedrooms: 3,
        bathrooms: 2,
        area: 1800,
        images: [
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
          'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?w=800',
        ],
        type: PropertyType.townhouse,
        sellerId: 'seller_5',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      Property(
        id: 'prop_6',
        title: 'Beachfront Villa',
        description: 'Stunning beachfront villa with private access to pristine beaches.',
        price: 2500000,
        location: 'Malibu, California',
        bedrooms: 5,
        bathrooms: 4,
        area: 3500,
        images: [
          'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
          'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
        ],
        type: PropertyType.house,
        sellerId: 'seller_6',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Property(
        id: 'prop_7',
        title: 'Urban Loft',
        description: 'Industrial-style loft with exposed brick and high ceilings.',
        price: 380000,
        location: 'SoHo, New York',
        bedrooms: 2,
        bathrooms: 1,
        area: 1000,
        images: [
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        ],
        type: PropertyType.loft,
        sellerId: 'seller_7',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Property(
        id: 'prop_8',
        title: 'Mountain Cabin',
        description: 'Cozy cabin retreat in the mountains with breathtaking views.',
        price: 420000,
        location: 'Aspen, Colorado',
        bedrooms: 3,
        bathrooms: 2,
        area: 1400,
        images: [
          'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800',
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
        ],
        type: PropertyType.house,
        sellerId: 'seller_8',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      Property(
        id: 'prop_9',
        title: 'Historic Brownstone',
        description: 'Charming historic brownstone with original details and modern updates.',
        price: 850000,
        location: 'Brooklyn Heights, New York',
        bedrooms: 4,
        bathrooms: 3,
        area: 2200,
        images: [
          'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?w=800',
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
        ],
        type: PropertyType.house,
        sellerId: 'seller_9',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      Property(
        id: 'prop_10',
        title: 'Modern Condo',
        description: 'Sleek modern condo with floor-to-ceiling windows and city views.',
        price: 520000,
        location: 'Chicago, Illinois',
        bedrooms: 2,
        bathrooms: 2,
        area: 1100,
        images: [
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
        ],
        type: PropertyType.condo,
        sellerId: 'seller_10',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      Property(
        id: 'prop_11',
        title: 'Garden Apartment',
        description: 'Ground-floor apartment with private garden and outdoor space.',
        price: 320000,
        location: 'Portland, Oregon',
        bedrooms: 2,
        bathrooms: 1,
        area: 900,
        images: [
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
          'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
        ],
        type: PropertyType.apartment,
        sellerId: 'seller_11',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      Property(
        id: 'prop_12',
        title: 'Luxury Townhouse',
        description: 'High-end townhouse with premium finishes and private garage.',
        price: 950000,
        location: 'Georgetown, Washington DC',
        bedrooms: 4,
        bathrooms: 3,
        area: 2400,
        images: [
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
          'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?w=800',
        ],
        type: PropertyType.townhouse,
        sellerId: 'seller_12',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      Property(
        id: 'prop_13',
        title: 'Minimalist Studio',
        description: 'Clean, minimalist studio perfect for urban living.',
        price: 240000,
        location: 'Seattle, Washington',
        bedrooms: 1,
        bathrooms: 1,
        area: 500,
        images: [
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
          'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
        ],
        type: PropertyType.studio,
        sellerId: 'seller_13',
        createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      Property(
        id: 'prop_14',
        title: 'Ranch Style Home',
        description: 'Single-story ranch home with open floor plan and large lot.',
        price: 480000,
        location: 'Austin, Texas',
        bedrooms: 3,
        bathrooms: 2,
        area: 1600,
        images: [
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800',
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800',
        ],
        type: PropertyType.house,
        sellerId: 'seller_14',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Property(
        id: 'prop_15',
        title: 'Waterfront Condo',
        description: 'Luxury waterfront condo with marina access and boat slip.',
        price: 1800000,
        location: 'Miami, Florida',
        bedrooms: 3,
        bathrooms: 3,
        area: 1800,
        images: [
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
        ],
        type: PropertyType.condo,
        sellerId: 'seller_15',
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      Property(
        id: 'prop_16',
        title: 'Victorian House',
        description: 'Beautiful Victorian house with original architectural details.',
        price: 720000,
        location: 'San Francisco, California',
        bedrooms: 4,
        bathrooms: 2,
        area: 2000,
        images: [
          'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?w=800',
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
        ],
        type: PropertyType.house,
        sellerId: 'seller_16',
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      Property(
        id: 'prop_17',
        title: 'Modern Apartment',
        description: 'Contemporary apartment with smart home features and city views.',
        price: 410000,
        location: 'Denver, Colorado',
        bedrooms: 2,
        bathrooms: 2,
        area: 1000,
        images: [
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800',
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        ],
        type: PropertyType.apartment,
        sellerId: 'seller_17',
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      Property(
        id: 'prop_18',
        title: 'Penthouse Suite',
        description: 'Exclusive penthouse with private terrace and panoramic city views.',
        price: 2200000,
        location: 'Las Vegas, Nevada',
        bedrooms: 4,
        bathrooms: 4,
        area: 2800,
        images: [
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
        ],
        type: PropertyType.condo,
        sellerId: 'seller_18',
        createdAt: DateTime.now().subtract(const Duration(seconds: 30)),
      ),
      Property(
        id: 'prop_19',
        title: 'Cottage Style Home',
        description: 'Charming cottage with English garden and cozy interiors.',
        price: 380000,
        location: 'Charleston, South Carolina',
        bedrooms: 3,
        bathrooms: 2,
        area: 1400,
        images: [
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800',
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800',
        ],
        type: PropertyType.house,
        sellerId: 'seller_19',
        createdAt: DateTime.now().subtract(const Duration(seconds: 15)),
      ),
      Property(
        id: 'prop_20',
        title: 'Contemporary Loft',
        description: 'Spacious loft with industrial design and modern amenities.',
        price: 550000,
        location: 'Minneapolis, Minnesota',
        bedrooms: 2,
        bathrooms: 2,
        area: 1300,
        images: [
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        ],
        type: PropertyType.loft,
        sellerId: 'seller_20',
        createdAt: DateTime.now(),
      ),
    ];
  }

  // ==================== APP RESET ====================
  
  /**
   * Resets the app to its initial state
   * 
   * This method is useful for:
   * - Testing purposes
   * - Allowing users to start over
   * - Clearing all user interactions
   * 
   * It regenerates the sample properties and clears all user interaction lists:
   * - Resets available properties to full sample list
   * - Clears all swiped properties
   * - Clears all liked properties
   * - Clears all viewed properties
   * - Clears all matches
   * 
   * Note: This does NOT reset the current user profile
   */
  void resetApp() {
    // Regenerate the full list of available properties
    _availableProperties = _generateSampleProperties();
    
    // Clear all user interaction lists
    _swipedProperties.clear();    // Clear swiped properties
    _likedProperties.clear();     // Clear liked properties
    _viewedProperties.clear();    // Clear viewed properties
    _matches.clear();             // Clear all matches
    
    // Notify all listening widgets of the state change
    notifyListeners();
  }
}
