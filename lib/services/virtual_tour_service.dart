/**
 * Virtual Tour Service for Aibodes
 * 
 * This service handles 360° virtual property tours and photo galleries,
 * including tour creation, management, and viewing capabilities.
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/**
 * Virtual Tour Service class
 * 
 * Manages virtual tours, photo galleries, and 360° viewing experiences.
 */
class VirtualTourService {
  /// Singleton instance
  static final VirtualTourService _instance = VirtualTourService._internal();
  factory VirtualTourService() => _instance;
  VirtualTourService._internal();

  // ==================== PRIVATE FIELDS ====================
  
  final http.Client _httpClient = http.Client();
  final StreamController<VirtualTourEvent> _tourController = 
      StreamController<VirtualTourEvent>.broadcast();
  
  List<VirtualTour> _tours = [];
  List<PhotoGallery> _galleries = [];

  // ==================== PUBLIC GETTERS ====================
  
  Stream<VirtualTourEvent> get tourStream => _tourController.stream;
  List<VirtualTour> get tours => List.unmodifiable(_tours);
  List<PhotoGallery> get galleries => List.unmodifiable(_galleries);

  // ==================== VIRTUAL TOUR MANAGEMENT ====================
  
  /**
   * Create a new virtual tour
   * 
   * @param propertyId Property ID for the tour
   * @param title Tour title
   * @param description Tour description
   * @param hotspots List of tour hotspots
   * @return Created VirtualTour object
   */
  Future<VirtualTour> createVirtualTour({
    required String propertyId,
    required String title,
    required String description,
    required List<TourHotspot> hotspots,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('https://api.aibodes.com/virtual-tours'),
        headers: _getHeaders(),
        body: jsonEncode({
          'propertyId': propertyId,
          'title': title,
          'description': description,
          'hotspots': hotspots.map((h) => h.toJson()).toList(),
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tour = VirtualTour.fromJson(data);
        
        _tours.add(tour);
        _tourController.add(VirtualTourEvent(
          type: VirtualTourEventType.tourCreated,
          tour: tour,
        ));
        
        print('Virtual tour created: ${tour.id}');
        return tour;
      } else {
        throw VirtualTourException('Failed to create virtual tour: ${response.body}');
      }
    } catch (e) {
      print('Error creating virtual tour: $e');
      _tourController.add(VirtualTourEvent(
        type: VirtualTourEventType.error,
        error: e.toString(),
      ));
      rethrow;
    }
  }
  
  /**
   * Get virtual tours for a property
   * 
   * @param propertyId Property ID
   * @return List of VirtualTour objects
   */
  Future<List<VirtualTour>> getToursForProperty(String propertyId) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('https://api.aibodes.com/virtual-tours/property/$propertyId'),
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tours = (data['tours'] as List)
            .map((tour) => VirtualTour.fromJson(tour))
            .toList();
        
        print('Retrieved ${tours.length} tours for property $propertyId');
        return tours;
      } else {
        throw VirtualTourException('Failed to get tours: ${response.body}');
      }
    } catch (e) {
      print('Error getting tours: $e');
      rethrow;
    }
  }
  
  /**
   * Create photo gallery
   * 
   * @param propertyId Property ID
   * @param title Gallery title
   * @param photos List of photo URLs
   * @return Created PhotoGallery object
   */
  Future<PhotoGallery> createPhotoGallery({
    required String propertyId,
    required String title,
    required List<String> photos,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('https://api.aibodes.com/photo-galleries'),
        headers: _getHeaders(),
        body: jsonEncode({
          'propertyId': propertyId,
          'title': title,
          'photos': photos,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final gallery = PhotoGallery.fromJson(data);
        
        _galleries.add(gallery);
        _tourController.add(VirtualTourEvent(
          type: VirtualTourEventType.galleryCreated,
          gallery: gallery,
        ));
        
        print('Photo gallery created: ${gallery.id}');
        return gallery;
      } else {
        throw VirtualTourException('Failed to create gallery: ${response.body}');
      }
    } catch (e) {
      print('Error creating gallery: $e');
      _tourController.add(VirtualTourEvent(
        type: VirtualTourEventType.error,
        error: e.toString(),
      ));
      rethrow;
    }
  }

  // ==================== UTILITY METHODS ====================
  
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'User-Agent': 'Aibodes-Mobile/1.0.0',
    };
  }
  
  void dispose() {
    _httpClient.close();
    _tourController.close();
  }
}

// ==================== DATA MODELS ====================

/**
 * Virtual Tour Event class
 */
class VirtualTourEvent {
  final VirtualTourEventType type;
  final VirtualTour? tour;
  final PhotoGallery? gallery;
  final String? error;
  final DateTime timestamp;

  VirtualTourEvent({
    required this.type,
    this.tour,
    this.gallery,
    this.error,
  }) : timestamp = DateTime.now();
}

/**
 * Virtual Tour Event Type enumeration
 */
enum VirtualTourEventType {
  tourCreated,
  galleryCreated,
  error,
}

/**
 * Virtual Tour class
 */
class VirtualTour {
  final String id;
  final String propertyId;
  final String title;
  final String description;
  final List<TourHotspot> hotspots;
  final DateTime createdAt;
  final DateTime updatedAt;

  VirtualTour({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.description,
    required this.hotspots,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VirtualTour.fromJson(Map<String, dynamic> json) {
    return VirtualTour(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      hotspots: (json['hotspots'] as List)
          .map((h) => TourHotspot.fromJson(h))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'title': title,
      'description': description,
      'hotspots': hotspots.map((h) => h.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/**
 * Tour Hotspot class
 */
class TourHotspot {
  final String id;
  final String title;
  final String description;
  final double x;
  final double y;
  final String imageUrl;
  final HotspotType type;

  TourHotspot({
    required this.id,
    required this.title,
    required this.description,
    required this.x,
    required this.y,
    required this.imageUrl,
    required this.type,
  });

  factory TourHotspot.fromJson(Map<String, dynamic> json) {
    return TourHotspot(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      type: HotspotType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => HotspotType.info,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'x': x,
      'y': y,
      'imageUrl': imageUrl,
      'type': type.name,
    };
  }
}

/**
 * Hotspot Type enumeration
 */
enum HotspotType {
  info,
  room,
  feature,
  amenity,
}

/**
 * Photo Gallery class
 */
class PhotoGallery {
  final String id;
  final String propertyId;
  final String title;
  final List<String> photos;
  final DateTime createdAt;

  PhotoGallery({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.photos,
    required this.createdAt,
  });

  factory PhotoGallery.fromJson(Map<String, dynamic> json) {
    return PhotoGallery(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String,
      title: json['title'] as String,
      photos: List<String>.from(json['photos'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'title': title,
      'photos': photos,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/**
 * Virtual Tour Exception class
 */
class VirtualTourException implements Exception {
  final String message;
  final String? code;

  VirtualTourException(this.message, [this.code]);

  @override
  String toString() {
    return 'VirtualTourException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}
