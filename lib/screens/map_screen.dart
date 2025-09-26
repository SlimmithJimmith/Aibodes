/**
 * Map Screen for Property Visualization
 * 
 * This screen provides an interactive map interface for viewing properties
 * including:
 * - Google Maps integration with property markers
 * - Property clustering for better performance
 * - Search radius visualization
 * - Property details on marker tap
 * - Navigation to property details
 * 
 * @author Aibodes Team
 * @version 2.0.0
 */

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/property.dart';
import '../services/maps_service.dart';
import '../widgets/swipeable_property_stack.dart';

/**
 * Map Screen Widget
 * 
 * Displays an interactive map with property markers, search functionality,
 * and property details integration.
 */
class MapScreen extends StatefulWidget {
  /**
   * Constructor for MapScreen
   */
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

/**
 * State class for MapScreen
 * 
 * Manages map state, markers, and user interactions.
 */
class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final MapsService _mapsService = MapsService();
  
  Set<Marker> _markers = {};
  Circle? _searchRadiusCircle;
  LatLng? _currentLocation;
  bool _isLoading = true;
  String _selectedPropertyId = '';

  // Map settings
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _mapsService.dispose();
    super.dispose();
  }

  /**
   * Initialize map and load current location
   */
  Future<void> _initializeMap() async {
    try {
      // Get current location
      final position = await _mapsService.getCurrentLocation();
      if (position != null) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
        
        // Move camera to current location
        if (_mapController != null) {
          await _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _currentLocation!,
                zoom: 15,
              ),
            ),
          );
        }
      }
      
      // Load properties and create markers
      await _loadProperties();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing map: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /**
   * Load properties and create map markers
   */
  Future<void> _loadProperties() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final properties = appProvider.availableProperties;
    
    final markers = <Marker>{};
    
    for (int i = 0; i < properties.length; i++) {
      final property = properties[i];
      final marker = Marker(
        markerId: MarkerId(property.id),
        position: LatLng(property.latitude, property.longitude),
        infoWindow: InfoWindow(
          title: property.title,
          snippet: property.formattedPrice,
          onTap: () => _onMarkerTapped(property),
        ),
        icon: _getPropertyMarkerIcon(property),
        onTap: () => _onMarkerTapped(property),
      );
      
      markers.add(marker);
    }
    
    setState(() {
      _markers = markers;
    });
  }

  /**
   * Get marker icon based on property type and price
   */
  BitmapDescriptor _getPropertyMarkerIcon(Property property) {
    // In a real implementation, you would use custom marker icons
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
   */
  void _onMarkerTapped(Property property) {
    setState(() {
      _selectedPropertyId = property.id;
    });
    
    // Show property details bottom sheet
    _showPropertyDetails(property);
  }

  /**
   * Show property details in a bottom sheet
   */
  void _showPropertyDetails(Property property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Property details
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Property image
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(property.images.isNotEmpty 
                                ? property.images.first 
                                : 'https://via.placeholder.com/400x300'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Property title and price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              property.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            property.formattedPrice,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Property address
                      Text(
                        property.address,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Property details
                      Row(
                        children: [
                          _buildDetailChip('${property.bedrooms} bed'),
                          const SizedBox(width: 8),
                          _buildDetailChip('${property.bathrooms} bath'),
                          const SizedBox(width: 8),
                          _buildDetailChip('${property.squareFeet} sq ft'),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Property description
                      Text(
                        property.description,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _navigateToPropertyDetails(property),
                              icon: const Icon(Icons.info_outline),
                              label: const Text('View Details'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _likeProperty(property),
                              icon: const Icon(Icons.favorite_border),
                              label: const Text('Like'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * Build detail chip widget
   */
  Widget _buildDetailChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /**
   * Navigate to property details screen
   */
  void _navigateToPropertyDetails(Property property) {
    Navigator.pop(context); // Close bottom sheet
    Navigator.pushNamed(
      context,
      '/property-details',
      arguments: property,
    );
  }

  /**
   * Like a property
   */
  void _likeProperty(Property property) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.swipeProperty(property, SwipeDirection.right);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${property.title} to your favorites!'),
        backgroundColor: Colors.green,
      ),
    );
    
    Navigator.pop(context); // Close bottom sheet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Property Map',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _centerOnCurrentLocation,
            icon: const Icon(Icons.my_location),
            tooltip: 'Current Location',
          ),
          IconButton(
            onPressed: _fitAllMarkers,
            icon: const Icon(Icons.fit_screen),
            tooltip: 'Fit All Properties',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _mapsService.initializeMapController(controller);
            },
            markers: _markers,
            circles: _searchRadiusCircle != null ? {_searchRadiusCircle!} : {},
            onTap: (LatLng position) {
              // Clear selection when tapping on empty map
              setState(() {
                _selectedPropertyId = '';
              });
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
          ),
          
          // Loading indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          
          // Map controls
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  onPressed: _centerOnCurrentLocation,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.my_location, color: Colors.blue),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  onPressed: _fitAllMarkers,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.fit_screen, color: Colors.blue),
                ),
              ],
            ),
          ),
          
          // Property count indicator
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${_markers.length} properties',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Center map on current location
   */
  Future<void> _centerOnCurrentLocation() async {
    if (_currentLocation != null && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentLocation!,
            zoom: 15,
          ),
        ),
      );
    } else {
      // Get current location if not available
      final position = await _mapsService.getCurrentLocation();
      if (position != null && _mapController != null) {
        final location = LatLng(position.latitude, position.longitude);
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: location,
              zoom: 15,
            ),
          ),
        );
      }
    }
  }

  /**
   * Fit camera to show all property markers
   */
  Future<void> _fitAllMarkers() async {
    if (_markers.isEmpty || _mapController == null) return;
    
    double minLat = _markers.first.position.latitude;
    double maxLat = _markers.first.position.latitude;
    double minLng = _markers.first.position.longitude;
    double maxLng = _markers.first.position.longitude;
    
    for (final marker in _markers) {
      minLat = minLat < marker.position.latitude ? minLat : marker.position.latitude;
      maxLat = maxLat > marker.position.latitude ? maxLat : marker.position.latitude;
      minLng = minLng < marker.position.longitude ? minLng : marker.position.longitude;
      maxLng = maxLng > marker.position.longitude ? maxLng : marker.position.longitude;
    }
    
    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    
    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100),
    );
  }
}
