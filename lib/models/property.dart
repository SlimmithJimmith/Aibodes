class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String location;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final List<String> images;
  final PropertyType type;
  final String sellerId;
  final DateTime createdAt;
  final bool isAvailable;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.images,
    required this.type,
    required this.sellerId,
    required this.createdAt,
    this.isAvailable = true,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      location: json['location'],
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      area: json['area'].toDouble(),
      images: List<String>.from(json['images']),
      type: PropertyType.values.firstWhere(
        (e) => e.toString() == 'PropertyType.${json['type']}',
        orElse: () => PropertyType.apartment,
      ),
      sellerId: json['sellerId'],
      createdAt: DateTime.parse(json['createdAt']),
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'images': images,
      'type': type.toString().split('.').last,
      'sellerId': sellerId,
      'createdAt': createdAt.toIso8601String(),
      'isAvailable': isAvailable,
    };
  }

  String get formattedPrice {
    if (price >= 1000000) {
      return '\$${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '\$${(price / 1000).toStringAsFixed(0)}K';
    } else {
      return '\$${price.toStringAsFixed(0)}';
    }
  }

  String get propertyDetails {
    return '$bedrooms bed • $bathrooms bath • ${area.toStringAsFixed(0)} sq ft';
  }
}

enum PropertyType {
  apartment,
  house,
  condo,
  townhouse,
  studio,
  loft,
}

extension PropertyTypeExtension on PropertyType {
  String get displayName {
    switch (this) {
      case PropertyType.apartment:
        return 'Apartment';
      case PropertyType.house:
        return 'House';
      case PropertyType.condo:
        return 'Condo';
      case PropertyType.townhouse:
        return 'Townhouse';
      case PropertyType.studio:
        return 'Studio';
      case PropertyType.loft:
        return 'Loft';
    }
  }
}
