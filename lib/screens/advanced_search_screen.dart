/**
 * Advanced Search Screen for Property Filtering
 * 
 * This screen provides comprehensive property search functionality including:
 * - Location-based search with map integration
 * - Price range filtering
 * - Property type selection
 * - Bedroom/bathroom requirements
 * - Advanced filters (square footage, lot size, etc.)
 * - Saved search preferences
 * 
 * @author Aibodes Team
 * @version 2.0.0
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/app_provider.dart';
import '../models/property.dart';

/**
 * Advanced Search Screen Widget
 * 
 * Provides a comprehensive interface for users to search and filter
 * properties based on various criteria including location, price,
 * property features, and amenities.
 */
class AdvancedSearchScreen extends StatefulWidget {
  /**
   * Constructor for AdvancedSearchScreen
   */
  const AdvancedSearchScreen({super.key});

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

/**
 * State class for AdvancedSearchScreen
 * 
 * Manages the search form state, map interactions, and filter selections.
 */
class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  final _minSqFtController = TextEditingController();
  final _maxSqFtController = TextEditingController();
  final _lotSizeController = TextEditingController();

  // Search parameters
  String _selectedLocation = '';
  double _minPrice = 0;
  double _maxPrice = 2000000;
  int _minBedrooms = 1;
  int _maxBedrooms = 10;
  int _minBathrooms = 1;
  int _maxBathrooms = 10;
  double _minSquareFeet = 0;
  double _maxSquareFeet = 10000;
  double _lotSize = 0;
  List<PropertyType> _selectedPropertyTypes = [];
  bool _hasGarage = false;
  bool _hasPool = false;
  bool _hasFireplace = false;
  bool _hasGarden = false;
  int _maxDistance = 25; // miles
  String _sortBy = 'price_low_to_high';

  // Map-related variables
  GoogleMapController? _mapController;
  LatLng? _searchCenter;
  Set<Marker> _markers = {};
  Circle? _searchRadiusCircle;

  @override
  void initState() {
    super.initState();
    _initializeSearch();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minSqFtController.dispose();
    _maxSqFtController.dispose();
    _lotSizeController.dispose();
    super.dispose();
  }

  /**
   * Initialize search with default values
   */
  void _initializeSearch() {
    // Initialize with default values since User model doesn't have preferences yet
    _selectedLocation = 'New York, NY';
    _minPrice = 100000;
    _maxPrice = 1000000;
    _minBedrooms = 1;
    _minBathrooms = 1;
    _selectedPropertyTypes = [PropertyType.house, PropertyType.apartment];
    _maxDistance = 10;
    
    _locationController.text = _selectedLocation;
    _minPriceController.text = _minPrice.toString();
    _maxPriceController.text = _maxPrice.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Advanced Search',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _clearAllFilters,
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Search Results Header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search Results: ${_getSearchResultsCount()} properties',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _sortBy,
                    items: const [
                      DropdownMenuItem(
                        value: 'price_low_to_high',
                        child: Text('Price: Low to High'),
                      ),
                      DropdownMenuItem(
                        value: 'price_high_to_low',
                        child: Text('Price: High to Low'),
                      ),
                      DropdownMenuItem(
                        value: 'newest',
                        child: Text('Newest First'),
                      ),
                      DropdownMenuItem(
                        value: 'largest',
                        child: Text('Largest First'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                      });
                      _performSearch();
                    },
                  ),
                ],
              ),
            ),
            
            // Search Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLocationSection(),
                    const SizedBox(height: 24),
                    _buildPriceSection(),
                    const SizedBox(height: 24),
                    _buildPropertyTypeSection(),
                    const SizedBox(height: 24),
                    _buildBedroomBathroomSection(),
                    const SizedBox(height: 24),
                    _buildSquareFootageSection(),
                    const SizedBox(height: 24),
                    _buildAmenitiesSection(),
                    const SizedBox(height: 24),
                    _buildAdvancedFiltersSection(),
                    const SizedBox(height: 24),
                    _buildMapSection(),
                    const SizedBox(height: 100), // Space for floating button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _performSearch,
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.search, color: Colors.white),
        label: const Text(
          'Search Properties',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /**
   * Build location search section
   */
  Widget _buildLocationSection() {
    return _buildSection(
      title: 'Location',
      child: Column(
        children: [
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'City, State, or ZIP Code',
              prefixIcon: Icon(Icons.location_on),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _selectedLocation = value;
              });
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text('Search Radius: ${_maxDistance} miles'),
              ),
              Expanded(
                child: Slider(
                  value: _maxDistance.toDouble(),
                  min: 1,
                  max: 100,
                  divisions: 99,
                  onChanged: (value) {
                    setState(() {
                      _maxDistance = value.toInt();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
   * Build price range section
   */
  Widget _buildPriceSection() {
    return _buildSection(
      title: 'Price Range',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _minPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Min Price',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _minPrice = double.tryParse(value) ?? 0;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _maxPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Max Price',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _maxPrice = double.tryParse(value) ?? 2000000;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0,
            max: 5000000,
            divisions: 100,
            onChanged: (values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
                _minPriceController.text = _minPrice.toString();
                _maxPriceController.text = _maxPrice.toString();
              });
            },
          ),
        ],
      ),
    );
  }

  /**
   * Build property type selection section
   */
  Widget _buildPropertyTypeSection() {
    return _buildSection(
      title: 'Property Type',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: PropertyType.values.map((type) {
          final isSelected = _selectedPropertyTypes.contains(type);
          return FilterChip(
            label: Text(type.displayName),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _selectedPropertyTypes.add(type);
                } else {
                  _selectedPropertyTypes.remove(type);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  /**
   * Build bedroom and bathroom section
   */
  Widget _buildBedroomBathroomSection() {
    return _buildSection(
      title: 'Bedrooms & Bathrooms',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bedrooms'),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _minBedrooms.toDouble(),
                            min: 1,
                            max: 10,
                            divisions: 9,
                            onChanged: (value) {
                              setState(() {
                                _minBedrooms = value.toInt();
                              });
                            },
                          ),
                        ),
                        Text('$_minBedrooms+'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bathrooms'),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _minBathrooms.toDouble(),
                            min: 1,
                            max: 10,
                            divisions: 9,
                            onChanged: (value) {
                              setState(() {
                                _minBathrooms = value.toInt();
                              });
                            },
                          ),
                        ),
                        Text('$_minBathrooms+'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
   * Build square footage section
   */
  Widget _buildSquareFootageSection() {
    return _buildSection(
      title: 'Square Footage',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _minSqFtController,
                  decoration: const InputDecoration(
                    labelText: 'Min Sq Ft',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _minSquareFeet = double.tryParse(value) ?? 0;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _maxSqFtController,
                  decoration: const InputDecoration(
                    labelText: 'Max Sq Ft',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _maxSquareFeet = double.tryParse(value) ?? 10000;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
   * Build amenities section
   */
  Widget _buildAmenitiesSection() {
    return _buildSection(
      title: 'Amenities',
      child: Column(
        children: [
          _buildAmenityChip('Garage', _hasGarage, (value) => _hasGarage = value),
          _buildAmenityChip('Pool', _hasPool, (value) => _hasPool = value),
          _buildAmenityChip('Fireplace', _hasFireplace, (value) => _hasFireplace = value),
          _buildAmenityChip('Garden', _hasGarden, (value) => _hasGarden = value),
        ],
      ),
    );
  }

  /**
   * Build advanced filters section
   */
  Widget _buildAdvancedFiltersSection() {
    return _buildSection(
      title: 'Advanced Filters',
      child: Column(
        children: [
          TextFormField(
            controller: _lotSizeController,
            decoration: const InputDecoration(
              labelText: 'Lot Size (acres)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _lotSize = double.tryParse(value) ?? 0;
            },
          ),
        ],
      ),
    );
  }

  /**
   * Build map section for location visualization
   */
  Widget _buildMapSection() {
    return _buildSection(
      title: 'Search Area',
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7749, -122.4194), // San Francisco
              zoom: 10,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: _markers,
            circles: _searchRadiusCircle != null ? {_searchRadiusCircle!} : {},
            onTap: (LatLng position) {
              _onMapTapped(position);
            },
          ),
        ),
      ),
    );
  }

  /**
   * Build a section with title and content
   */
  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  /**
   * Build amenity chip widget
   */
  Widget _buildAmenityChip(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (newValue) {
              setState(() {
                onChanged(newValue ?? false);
              });
            },
          ),
          Text(label),
        ],
      ),
    );
  }

  /**
   * Handle map tap events
   */
  void _onMapTapped(LatLng position) {
    setState(() {
      _searchCenter = position;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('search_center'),
          position: position,
          infoWindow: const InfoWindow(title: 'Search Center'),
        ),
      );
      
      if (_maxDistance > 0) {
        _searchRadiusCircle = Circle(
          circleId: const CircleId('search_radius'),
          center: position,
          radius: _maxDistance * 1609.34, // Convert miles to meters
          fillColor: Colors.blue.withOpacity(0.2),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        );
      }
    });
  }

  /**
   * Perform property search with current filters
   */
  void _performSearch() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    // Create search parameters
    final searchParams = {
      'location': _selectedLocation,
      'minPrice': _minPrice,
      'maxPrice': _maxPrice,
      'minBedrooms': _minBedrooms,
      'minBathrooms': _minBathrooms,
      'minSquareFeet': _minSquareFeet,
      'maxSquareFeet': _maxSquareFeet,
      'propertyTypes': _selectedPropertyTypes,
      'hasGarage': _hasGarage,
      'hasPool': _hasPool,
      'hasFireplace': _hasFireplace,
      'hasGarden': _hasGarden,
      'maxDistance': _maxDistance,
      'sortBy': _sortBy,
    };

    // Perform search (this would integrate with the API service)
    appProvider.searchProperties(searchParams);
    
    // Show results
    Navigator.pop(context);
  }

  /**
   * Clear all search filters
   */
  void _clearAllFilters() {
    setState(() {
      _locationController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      _minSqFtController.clear();
      _maxSqFtController.clear();
      _lotSizeController.clear();
      
      _selectedLocation = '';
      _minPrice = 0;
      _maxPrice = 2000000;
      _minBedrooms = 1;
      _minBathrooms = 1;
      _minSquareFeet = 0;
      _maxSquareFeet = 10000;
      _lotSize = 0;
      _selectedPropertyTypes.clear();
      _hasGarage = false;
      _hasPool = false;
      _hasFireplace = false;
      _hasGarden = false;
      _maxDistance = 25;
      _sortBy = 'price_low_to_high';
      
      _markers.clear();
      _searchRadiusCircle = null;
      _searchCenter = null;
    });
  }

  /**
   * Get search results count (mock implementation)
   */
  int _getSearchResultsCount() {
    // In a real implementation, this would return the actual count
    // from the search results
    return 0;
  }
}
