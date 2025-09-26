import 'package:flutter/material.dart';
import '../models/property.dart';
import '../models/user.dart';
import '../models/match.dart';
import '../widgets/swipeable_property_stack.dart';

class AppProvider extends ChangeNotifier {
  List<Property> _availableProperties = [];
  List<Property> _swipedProperties = [];
  List<Property> _likedProperties = [];
  List<Property> _viewedProperties = [];
  List<Match> _matches = [];
  User? _currentUser;
  bool _isLoading = false;

  // Getters
  List<Property> get availableProperties => _availableProperties;
  List<Property> get swipedProperties => _swipedProperties;
  List<Property> get likedProperties => _likedProperties;
  List<Property> get viewedProperties => _viewedProperties;
  List<Match> get matches => _matches;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // Initialize with sample data
  void initializeApp() {
    _isLoading = true;
    notifyListeners();

    // Create sample user
    _currentUser = User(
      id: 'user_1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      type: UserType.buyer,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isVerified: true,
    );

    // Create sample properties
    _availableProperties = _generateSampleProperties();
    
    _isLoading = false;
    notifyListeners();
  }

  void swipeProperty(Property property, SwipeDirection direction) {
    if (_swipedProperties.contains(property)) return;

    _swipedProperties.add(property);
    _availableProperties.remove(property);

    if (direction == SwipeDirection.right) {
      // User liked the property - save it and create a potential match
      _likedProperties.add(property);
      _createMatch(property);
    }

    notifyListeners();
  }

  void viewProperty(Property property) {
    if (!_viewedProperties.contains(property)) {
      _viewedProperties.add(property);
      notifyListeners();
    }
  }

  Future<void> updateUser(User updatedUser) async {
    _currentUser = updatedUser;
    notifyListeners();
    // In a real app, this would make an API call to save the user data
  }

  void _createMatch(Property property) {
    // In a real app, this would make an API call
    final match = Match(
      id: 'match_${DateTime.now().millisecondsSinceEpoch}',
      buyerId: _currentUser!.id,
      sellerId: property.sellerId,
      propertyId: property.id,
      matchedAt: DateTime.now(),
      status: MatchStatus.pending,
    );

    _matches.add(match);
  }

  void removeMatch(Match match) {
    _matches.remove(match);
    notifyListeners();
  }

  void updateMatchStatus(Match match, MatchStatus status) {
    final index = _matches.indexWhere((m) => m.id == match.id);
    if (index != -1) {
      _matches[index] = Match(
        id: match.id,
        buyerId: match.buyerId,
        sellerId: match.sellerId,
        propertyId: match.propertyId,
        matchedAt: match.matchedAt,
        status: status,
        message: match.message,
      );
      notifyListeners();
    }
  }

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

  void resetApp() {
    _availableProperties = _generateSampleProperties();
    _swipedProperties.clear();
    _likedProperties.clear();
    _viewedProperties.clear();
    _matches.clear();
    notifyListeners();
  }
}
