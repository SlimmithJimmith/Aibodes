/**
 * Maps Service for Location and Navigation
 * 
 * This service handles all map-related operations including:
 * - Google Maps integration
 * - Location services and geocoding
 * - Property markers and clustering
 * - Route calculation and navigation
 * - Nearby amenities and services
 * 
 * @author Aibodes Team
 * @version 2.0.0
 */

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/property.dart';
import '../models/neighborhood_data.dart';

/**
 * Maps Service Class
 * 
 * Manages all map-related functionality including location services,
 * geocoding, and property visualization on maps.
 */
class MapsService {
  static final MapsService _instance = MapsService._internal();
  factory MapsService() => _instance;
  MapsService._internal();

  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _propertyMarkers = {};
  Set<Circle> _searchRadiusCircles = {};

  /**
   * Get current map controller
   * 
   * @return GoogleMapController or null if not initialized
   */
  GoogleMapController? get mapController => _mapController;

  /**
   * Get current user position
   * 
   * @return Current position or null if not available
   */
  Position? get currentPosition => _currentPosition;

  /**
   * Get property markers
   * 
   * @return Set of property markers
   */
  Set<Marker> get propertyMarkers => _propertyMarkers;

  /**
   * Initialize map controller
   * 
   * @param controller GoogleMapController instance
   */
  void initializeMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  /**
   * Get current user location
   * 
   * @return Current position or null if permission denied
   */
  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return _currentPosition;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  /**
   * Geocode address to coordinates
   * 
   * @param address Address string to geocode
   * @return LatLng coordinates or null if geocoding failed
   */
  Future<LatLng?> geocodeAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        return LatLng(location.latitude, location.longitude);
      }
      return null;
    } catch (e) {
      print('Error geocoding address: $e');
      return null;
    }
  }

  /**
   * Reverse geocode coordinates to address
   * 
   * @param latLng Coordinates to reverse geocode
   * @return Address string or null if reverse geocoding failed
   */
  Future<String?> reverseGeocode(LatLng latLng) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea} ${placemark.postalCode}';
      }
      return null;
    } catch (e) {
      print('Error reverse geocoding: $e');
      return null;
    }
  }

  /**
   * Create property markers from property list
   * 
   * @param properties List of properties to display
   * @return Set of markers for the properties
   */
  Set<Marker> createPropertyMarkers(List<Property> properties) {
    _propertyMarkers.clear();
    
    for (int i = 0; i < properties.length; i++) {
      final property = properties[i];
      final marker = Marker(
        markerId: MarkerId(property.id),
        position: LatLng(property.latitude, property.longitude),
        infoWindow: InfoWindow(
          title: property.title,
          snippet: property.formattedPrice,
        ),
        icon: _getPropertyMarkerIcon(property),
        onTap: () => _onMarkerTapped(property),
      );
      
      _propertyMarkers.add(marker);
    }
    
    return _propertyMarkers;
  }

  /**
   * Create search radius circle
   * 
   * @param center Center point of the circle
   * @param radius Radius in meters
   * @return Circle for search radius visualization
   */
  Circle createSearchRadiusCircle(LatLng center, double radius) {
    final circle = Circle(
      circleId: const CircleId('search_radius'),
      center: center,
      radius: radius,
      fillColor: Colors.blue.withOpacity(0.2),
      strokeColor: Colors.blue,
      strokeWidth: 2,
    );
    
    _searchRadiusCircles.clear();
    _searchRadiusCircles.add(circle);
    
    return circle;
  }

  /**
   * Animate camera to property
   * 
   * @param property Property to focus on
   * @param zoom Zoom level (optional)
   */
  Future<void> animateToProperty(Property property, {double? zoom}) async {
    if (_mapController == null) return;

    final cameraPosition = CameraPosition(
      target: LatLng(property.latitude, property.longitude),
      zoom: zoom ?? 15.0,
    );

    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  /**
   * Animate camera to current location
   * 
   * @param zoom Zoom level (optional)
   */
  Future<void> animateToCurrentLocation({double? zoom}) async {
    if (_mapController == null || _currentPosition == null) return;

    final cameraPosition = CameraPosition(
      target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      zoom: zoom ?? 15.0,
    );

    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  /**
   * Fit camera to show all property markers
   * 
   * @param padding Padding around the bounds (optional)
   */
  Future<void> fitCameraToMarkers({double padding = 50.0}) async {
    if (_mapController == null || _propertyMarkers.isEmpty) return;

    final bounds = _calculateBounds(_propertyMarkers);
    if (bounds != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, padding),
      );
    }
  }

  /**
   * Calculate distance between two points
   * 
   * @param point1 First point
   * @param point2 Second point
   * @return Distance in meters
   */
  double calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  /**
   * Get nearby properties within radius
   * 
   * @param properties List of all properties
   * @param center Center point for search
   * @param radius Radius in meters
   * @return List of properties within radius
   */
  List<Property> getNearbyProperties(
    List<Property> properties,
    LatLng center,
    double radius,
  ) {
    return properties.where((property) {
      final distance = calculateDistance(
        center,
        LatLng(property.latitude, property.longitude),
      );
      return distance <= radius;
    }).toList();
  }

  /**
   * Get property marker icon based on property type and price
   * 
   * @param property Property to get icon for
   * @return BitmapDescriptor for the marker
   */
  BitmapDescriptor _getPropertyMarkerIcon(Property property) {
    // In a real implementation, you would create custom marker icons
    // based on property type, price range, or other criteria
    switch (property.propertyType) {
      case PropertyType.house:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case PropertyType.condo:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case PropertyType.townhouse:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case PropertyType.apartment:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      case PropertyType.studio:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
      case PropertyType.loft:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
      case PropertyType.land:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case PropertyType.commercial:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    }
  }

  /**
   * Handle marker tap events
   * 
   * @param property Property that was tapped
   */
  void _onMarkerTapped(Property property) {
    // This would typically trigger navigation to property details
    // or show a property info window
    print('Marker tapped for property: ${property.title}');
  }

  /**
   * Calculate bounds for a set of markers
   * 
   * @param markers Set of markers
   * @return LatLngBounds or null if no markers
   */
  LatLngBounds? _calculateBounds(Set<Marker> markers) {
    if (markers.isEmpty) return null;

    double minLat = markers.first.position.latitude;
    double maxLat = markers.first.position.latitude;
    double minLng = markers.first.position.longitude;
    double maxLng = markers.first.position.longitude;

    for (final marker in markers) {
      minLat = minLat < marker.position.latitude ? minLat : marker.position.latitude;
      maxLat = maxLat > marker.position.latitude ? maxLat : marker.position.latitude;
      minLng = minLng < marker.position.longitude ? minLng : marker.position.longitude;
      maxLng = maxLng > marker.position.longitude ? maxLng : marker.position.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /**
   * Get directions between two points
   * 
   * @param origin Starting point
   * @param destination Ending point
   * @return List of LatLng points representing the route
   */
  Future<List<LatLng>?> getDirections(LatLng origin, LatLng destination) async {
    try {
      // In a real implementation, you would use Google Directions API
      // or another routing service to get actual directions
      
      // For now, return a simple straight line
      return [origin, destination];
    } catch (e) {
      print('Error getting directions: $e');
      return null;
    }
  }

  /**
   * Get nearby amenities
   * 
   * @param center Center point for search
   * @param radius Search radius in meters
   * @param amenityType Type of amenity to search for
   * @return List of nearby amenities
   */
  Future<List<Amenity>> getNearbyAmenities(
    LatLng center,
    double radius,
    AmenityType amenityType,
  ) async {
    try {
      // In a real implementation, you would use Google Places API
      // or another service to get actual amenity data
      
      // For now, return empty list
      return [];
    } catch (e) {
      print('Error getting nearby amenities: $e');
      return [];
    }
  }

  /**
   * Calculate commute time to destination
   * 
   * @param origin Starting point
   * @param destination Ending point
   * @param travelMode Mode of transportation
   * @return Commute time in minutes or null if calculation failed
   */
  Future<int?> calculateCommuteTime(
    LatLng origin,
    LatLng destination,
    TravelMode travelMode,
  ) async {
    try {
      // In a real implementation, you would use Google Distance Matrix API
      // or another service to get actual commute times
      
      // For now, return a mock value
      return 25; // 25 minutes
    } catch (e) {
      print('Error calculating commute time: $e');
      return null;
    }
  }

  /**
   * Dispose of map resources
   */
  void dispose() {
    _mapController = null;
    _currentPosition = null;
    _propertyMarkers.clear();
    _searchRadiusCircles.clear();
  }
}

/**
 * Travel Mode Enumeration
 * 
 * Represents different modes of transportation for route calculation.
 */
enum TravelMode {
  /// Driving by car
  driving,
  
  /// Walking
  walking,
  
  /// Public transit
  transit,
  
  /// Bicycling
  bicycling,
}
