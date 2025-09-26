import 'package:flutter/material.dart';
import '../models/property.dart';
import '../models/user.dart';
import '../models/match.dart';
import '../widgets/swipeable_property_stack.dart';

class AppProvider extends ChangeNotifier {
  List<Property> _availableProperties = [];
  List<Property> _swipedProperties = [];
  List<Match> _matches = [];
  User? _currentUser;
  bool _isLoading = false;

  // Getters
  List<Property> get availableProperties => _availableProperties;
  List<Property> get swipedProperties => _swipedProperties;
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
      name: 'John Doe',
      email: 'john@example.com',
      type: UserType.buyer,
      createdAt: DateTime.now(),
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
      // User liked the property - create a potential match
      _createMatch(property);
    }

    notifyListeners();
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
    ];
  }

  void resetApp() {
    _availableProperties = _generateSampleProperties();
    _swipedProperties.clear();
    _matches.clear();
    notifyListeners();
  }
}
