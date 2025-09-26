/**
 * API Service for Real Estate Data Integration
 * 
 * This service handles all external API calls to major real estate platforms
 * including Redfin, Zillow, and Realtor.com. It provides a unified interface
 * for fetching property data, market information, and neighborhood insights.
 * 
 * @author Aibodes Team
 * @version 2.0.0
 */

import 'package:dio/dio.dart';
import '../models/property.dart';
import '../models/market_data.dart';
import '../models/neighborhood_data.dart';
import '../models/mortgage_models.dart';

/**
 * Real Estate API Service Interface
 * 
 * Defines the contract for all real estate API operations including:
 * - Property search and filtering
 * - Market data retrieval
 * - Neighborhood information
 * - Agent and MLS data
 */
class RealEstateApiService {
  final Dio _dio;
  final String baseUrl;

  RealEstateApiService(this._dio, {required this.baseUrl});

  /**
   * Search properties with advanced filtering
   * 
   * @param query Search parameters including location, price range, etc.
   * @return List of matching properties
   */
  Future<List<Property>> searchProperties(Map<String, dynamic> query) async {
    try {
      final response = await _dio.get('$baseUrl/properties/search', queryParameters: query);
      return (response.data as List).map((json) => Property.fromJson(json)).toList();
    } catch (e) {
      print('Error searching properties: $e');
      return [];
    }
  }

  /**
   * Get property details by ID
   * 
   * @param propertyId Unique property identifier
   * @return Detailed property information
   */
  Future<Property> getPropertyDetails(String propertyId) async {
    try {
      final response = await _dio.get('$baseUrl/properties/$propertyId');
      return Property.fromJson(response.data);
    } catch (e) {
      print('Error getting property details: $e');
      rethrow;
    }
  }

  /**
   * Get market data for a specific area
   * 
   * @param location Geographic location (city, state, zip)
   * @return Market trends and statistics
   */
  Future<MarketData> getMarketData(String location) async {
    try {
      final response = await _dio.get('$baseUrl/market-data', queryParameters: {'location': location});
      return MarketData.fromJson(response.data);
    } catch (e) {
      print('Error getting market data: $e');
      rethrow;
    }
  }

  /**
   * Get neighborhood insights
   * 
   * @param location Geographic location
   * @return Neighborhood data including schools, crime, amenities
   */
  Future<NeighborhoodData> getNeighborhoodData(String location) async {
    try {
      final response = await _dio.get('$baseUrl/neighborhood', queryParameters: {'location': location});
      return NeighborhoodData.fromJson(response.data);
    } catch (e) {
      print('Error getting neighborhood data: $e');
      rethrow;
    }
  }

  /**
   * Get nearby properties
   * 
   * @param latitude Property latitude
   * @param longitude Property longitude
   * @param radius Search radius in miles
   * @return List of nearby properties
   */
  Future<List<Property>> getNearbyProperties(
    double latitude,
    double longitude,
    double radius,
  ) async {
    try {
      final response = await _dio.get('$baseUrl/properties/nearby', queryParameters: {
        'lat': latitude,
        'lng': longitude,
        'radius': radius,
      });
      return (response.data as List).map((json) => Property.fromJson(json)).toList();
    } catch (e) {
      print('Error getting nearby properties: $e');
      return [];
    }
  }

  /**
   * Get property price history
   * 
   * @param propertyId Property identifier
   * @return Price history data
   */
  Future<List<PriceHistory>> getPriceHistory(String propertyId) async {
    try {
      final response = await _dio.get('$baseUrl/properties/$propertyId/price-history');
      return (response.data as List).map((json) => PriceHistory.fromJson(json)).toList();
    } catch (e) {
      print('Error getting price history: $e');
      return [];
    }
  }

  /**
   * Get mortgage rates
   * 
   * @return Current mortgage interest rates
   */
  Future<MortgageRates> getMortgageRates() async {
    try {
      final response = await _dio.get('$baseUrl/mortgage/rates');
      return MortgageRates.fromJson(response.data);
    } catch (e) {
      print('Error getting mortgage rates: $e');
      rethrow;
    }
  }

  /**
   * Calculate mortgage payment
   * 
   * @param request Mortgage calculation request
   * @return Calculated payment information
   */
  Future<MortgageCalculation> calculateMortgage(MortgageRequest request) async {
    try {
      final response = await _dio.post('$baseUrl/mortgage/calculate', data: request.toJson());
      return MortgageCalculation.fromJson(response.data);
    } catch (e) {
      print('Error calculating mortgage: $e');
      rethrow;
    }
  }
}

/**
 * API Service Manager
 * 
 * Manages multiple API endpoints and handles authentication,
 * rate limiting, and error handling for all real estate APIs.
 */
class ApiServiceManager {
  static final ApiServiceManager _instance = ApiServiceManager._internal();
  factory ApiServiceManager() => _instance;
  ApiServiceManager._internal();

  late Dio _dio;
  late RealEstateApiService _redfinApi;
  late RealEstateApiService _zillowApi;
  late RealEstateApiService _realtorApi;

  /**
   * Initialize API services with authentication and configuration
   */
  Future<void> initialize() async {
    _dio = Dio();
    
    // Configure interceptors for logging and error handling
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) => print('API: $object'),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add API keys and authentication headers
        options.headers['Authorization'] = 'Bearer ${_getApiKey()}';
        options.headers['Content-Type'] = 'application/json';
        options.headers['User-Agent'] = 'Aibodes/2.0.0';
        handler.next(options);
      },
      onError: (error, handler) {
        // Handle API errors and rate limiting
        _handleApiError(error);
        handler.next(error);
      },
    ));

    // Initialize API services for different platforms
    _redfinApi = RealEstateApiService(_dio, baseUrl: 'https://api.redfin.com/v1');
    _zillowApi = RealEstateApiService(_dio, baseUrl: 'https://api.zillow.com/v1');
    _realtorApi = RealEstateApiService(_dio, baseUrl: 'https://api.realtor.com/v1');
  }

  /**
   * Get Redfin API service
   */
  RealEstateApiService get redfinApi => _redfinApi;

  /**
   * Get Zillow API service
   */
  RealEstateApiService get zillowApi => _zillowApi;

  /**
   * Get Realtor.com API service
   */
  RealEstateApiService get realtorApi => _realtorApi;

  /**
   * Search properties across all platforms
   * 
   * @param query Search parameters
   * @return Combined results from all APIs
   */
  Future<List<Property>> searchAllProperties(Map<String, dynamic> query) async {
    try {
      // Search across all platforms in parallel
      final results = await Future.wait([
        _redfinApi.searchProperties(query),
        _zillowApi.searchProperties(query),
        _realtorApi.searchProperties(query),
      ]);

      // Combine and deduplicate results
      final allProperties = <Property>[];
      for (final properties in results) {
        allProperties.addAll(properties);
      }

      return _deduplicateProperties(allProperties);
    } catch (e) {
      print('Error searching properties: $e');
      return [];
    }
  }

  /**
   * Get comprehensive property details from all sources
   * 
   * @param propertyId Property identifier
   * @return Enriched property data
   */
  Future<Property?> getComprehensivePropertyDetails(String propertyId) async {
    try {
      // Try to get details from all sources
      final results = await Future.wait([
        _redfinApi.getPropertyDetails(propertyId).catchError((_) => null),
        _zillowApi.getPropertyDetails(propertyId).catchError((_) => null),
        _realtorApi.getPropertyDetails(propertyId).catchError((_) => null),
      ]);

      // Find the first non-null result
      for (final property in results) {
        if (property != null) return property;
      }

      return null;
    } catch (e) {
      print('Error getting property details: $e');
      return null;
    }
  }

  /**
   * Get API key from secure storage
   */
  String _getApiKey() {
    // In production, this would retrieve from secure storage
    // For now, return placeholder - will be configured in environment
    return 'your-api-key-here';
  }

  /**
   * Handle API errors and rate limiting
   */
  void _handleApiError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        print('Connection timeout - check internet connection');
        break;
      case DioExceptionType.receiveTimeout:
        print('Receive timeout - server is slow');
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 429) {
          print('Rate limit exceeded - waiting before retry');
        } else if (statusCode == 401) {
          print('Unauthorized - check API key');
        } else if (statusCode == 403) {
          print('Forbidden - insufficient permissions');
        }
        break;
      default:
        print('API Error: ${error.message}');
    }
  }

  /**
   * Remove duplicate properties based on address and price
   * 
   * @param properties List of properties to deduplicate
   * @return Deduplicated list
   */
  List<Property> _deduplicateProperties(List<Property> properties) {
    final seen = <String>{};
    return properties.where((property) {
      final key = '${property.address.toLowerCase()}_${property.price}';
      if (seen.contains(key)) {
        return false;
      }
      seen.add(key);
      return true;
    }).toList();
  }
}
