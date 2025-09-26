/**
 * Neighborhood Data Model for Location Intelligence
 * 
 * This model represents comprehensive neighborhood information including:
 * - School ratings and information
 * - Crime statistics and safety data
 * - Local amenities and services
 * - Transportation and commute data
 * - Demographics and lifestyle metrics
 * 
 * @author Aibodes Team
 * @version 2.0.0
 */

import 'package:json_annotation/json_annotation.dart';

part 'neighborhood_data.g.dart';

/**
 * Neighborhood Data class containing comprehensive location information
 * 
 * Provides detailed insights into neighborhood characteristics,
 * amenities, safety, and quality of life factors.
 */
@JsonSerializable()
class NeighborhoodData {
  /// Unique identifier for the neighborhood data
  final String id;
  
  /// Neighborhood name
  final String name;
  
  /// Geographic location (city, state, zip)
  final String location;
  
  /// Data timestamp
  final DateTime timestamp;
  
  /// Overall neighborhood score (0-100)
  final int overallScore;
  
  /// School information and ratings
  final SchoolData schools;
  
  /// Crime statistics and safety data
  final CrimeData crime;
  
  /// Local amenities and services
  final AmenitiesData amenities;
  
  /// Transportation and commute information
  final TransportationData transportation;
  
  /// Demographics and population data
  final DemographicsData demographics;
  
  /// Walkability score (0-100)
  final int walkabilityScore;
  
  /// Bikeability score (0-100)
  final int bikeabilityScore;
  
  /// Transit score (0-100)
  final int transitScore;

  /**
   * Constructor for NeighborhoodData
   * 
   * @param id Unique identifier
   * @param name Neighborhood name
   * @param location Geographic location
   * @param timestamp Data timestamp
   * @param overallScore Overall neighborhood score
   * @param schools School information
   * @param crime Crime statistics
   * @param amenities Local amenities
   * @param transportation Transportation data
   * @param demographics Demographics data
   * @param walkabilityScore Walkability score
   * @param bikeabilityScore Bikeability score
   * @param transitScore Transit score
   */
  const NeighborhoodData({
    required this.id,
    required this.name,
    required this.location,
    required this.timestamp,
    required this.overallScore,
    required this.schools,
    required this.crime,
    required this.amenities,
    required this.transportation,
    required this.demographics,
    required this.walkabilityScore,
    required this.bikeabilityScore,
    required this.transitScore,
  });

  /**
   * Create NeighborhoodData from JSON
   * 
   * @param json JSON data
   * @return NeighborhoodData instance
   */
  factory NeighborhoodData.fromJson(Map<String, dynamic> json) => 
      _$NeighborhoodDataFromJson(json);

  /**
   * Convert NeighborhoodData to JSON
   * 
   * @return JSON representation
   */
  Map<String, dynamic> toJson() => _$NeighborhoodDataToJson(this);

  /**
   * Get overall neighborhood rating description
   * 
   * @return Human-readable rating description
   */
  String get overallRating {
    if (overallScore >= 90) return 'Excellent';
    if (overallScore >= 80) return 'Very Good';
    if (overallScore >= 70) return 'Good';
    if (overallScore >= 60) return 'Average';
    if (overallScore >= 50) return 'Below Average';
    return 'Poor';
  }

  /**
   * Get walkability description
   * 
   * @return Walkability description
   */
  String get walkabilityDescription {
    if (walkabilityScore >= 90) return 'Walker\'s Paradise';
    if (walkabilityScore >= 70) return 'Very Walkable';
    if (walkabilityScore >= 50) return 'Somewhat Walkable';
    if (walkabilityScore >= 25) return 'Car-Dependent';
    return 'Car-Dependent';
  }

  /**
   * Get safety rating based on crime data
   * 
   * @return Safety rating description
   */
  String get safetyRating {
    final crimeScore = crime.overallScore;
    if (crimeScore >= 80) return 'Very Safe';
    if (crimeScore >= 60) return 'Safe';
    if (crimeScore >= 40) return 'Moderately Safe';
    if (crimeScore >= 20) return 'Somewhat Unsafe';
    return 'Unsafe';
  }
}

/**
 * School Data Model
 * 
 * Contains information about schools in the neighborhood
 * including ratings, types, and performance metrics.
 */
@JsonSerializable()
class SchoolData {
  /// Overall school district rating (0-100)
  final int districtRating;
  
  /// List of nearby schools
  final List<School> schools;
  
  /// Average test scores
  final TestScores averageTestScores;
  
  /// Student-to-teacher ratio
  final double studentTeacherRatio;
  
  /// Percentage of students in advanced programs
  final double advancedProgramsPercentage;

  /**
   * Constructor for SchoolData
   */
  const SchoolData({
    required this.districtRating,
    required this.schools,
    required this.averageTestScores,
    required this.studentTeacherRatio,
    required this.advancedProgramsPercentage,
  });

  /**
   * Create SchoolData from JSON
   */
  factory SchoolData.fromJson(Map<String, dynamic> json) => 
      _$SchoolDataFromJson(json);

  /**
   * Convert SchoolData to JSON
   */
  Map<String, dynamic> toJson() => _$SchoolDataToJson(this);

  /**
   * Get district rating description
   * 
   * @return District rating description
   */
  String get districtRatingDescription {
    if (districtRating >= 90) return 'Excellent';
    if (districtRating >= 80) return 'Very Good';
    if (districtRating >= 70) return 'Good';
    if (districtRating >= 60) return 'Average';
    if (districtRating >= 50) return 'Below Average';
    return 'Poor';
  }
}

/**
 * Individual School Model
 * 
 * Represents a single school with its details and ratings.
 */
@JsonSerializable()
class School {
  /// School name
  final String name;
  
  /// School type (elementary, middle, high)
  final SchoolType type;
  
  /// School rating (0-100)
  final int rating;
  
  /// Distance from neighborhood center in miles
  final double distanceMiles;
  
  /// Number of students
  final int studentCount;
  
  /// School address
  final String address;

  /**
   * Constructor for School
   */
  const School({
    required this.name,
    required this.type,
    required this.rating,
    required this.distanceMiles,
    required this.studentCount,
    required this.address,
  });

  /**
   * Create School from JSON
   */
  factory School.fromJson(Map<String, dynamic> json) => _$SchoolFromJson(json);

  /**
   * Convert School to JSON
   */
  Map<String, dynamic> toJson() => _$SchoolToJson(this);
}

/**
 * School Type Enumeration
 * 
 * Represents different types of educational institutions.
 */
enum SchoolType {
  /// Elementary school (K-5)
  elementary,
  
  /// Middle school (6-8)
  middle,
  
  /// High school (9-12)
  high,
  
  /// Private school
  private,
  
  /// Charter school
  charter,
  
  /// University/College
  university,
}

/**
 * Test Scores Model
 * 
 * Contains standardized test score information.
 */
@JsonSerializable()
class TestScores {
  /// Average SAT score
  final int averageSAT;
  
  /// Average ACT score
  final int averageACT;
  
  /// Percentage of students proficient in math
  final double mathProficiency;
  
  /// Percentage of students proficient in reading
  final double readingProficiency;

  /**
   * Constructor for TestScores
   */
  const TestScores({
    required this.averageSAT,
    required this.averageACT,
    required this.mathProficiency,
    required this.readingProficiency,
  });

  /**
   * Create TestScores from JSON
   */
  factory TestScores.fromJson(Map<String, dynamic> json) => 
      _$TestScoresFromJson(json);

  /**
   * Convert TestScores to JSON
   */
  Map<String, dynamic> toJson() => _$TestScoresToJson(this);
}

/**
 * Crime Data Model
 * 
 * Contains crime statistics and safety information.
 */
@JsonSerializable()
class CrimeData {
  /// Overall crime score (0-100, higher is safer)
  final int overallScore;
  
  /// Violent crime rate per 1000 residents
  final double violentCrimeRate;
  
  /// Property crime rate per 1000 residents
  final double propertyCrimeRate;
  
  /// Crime trend (increasing, decreasing, stable)
  final CrimeTrend trend;
  
  /// Safety rating compared to national average
  final SafetyComparison safetyComparison;

  /**
   * Constructor for CrimeData
   */
  const CrimeData({
    required this.overallScore,
    required this.violentCrimeRate,
    required this.propertyCrimeRate,
    required this.trend,
    required this.safetyComparison,
  });

  /**
   * Create CrimeData from JSON
   */
  factory CrimeData.fromJson(Map<String, dynamic> json) => 
      _$CrimeDataFromJson(json);

  /**
   * Convert CrimeData to JSON
   */
  Map<String, dynamic> toJson() => _$CrimeDataToJson(this);
}

/**
 * Crime Trend Enumeration
 * 
 * Represents the direction of crime statistics.
 */
enum CrimeTrend {
  /// Crime is increasing
  increasing,
  
  /// Crime is decreasing
  decreasing,
  
  /// Crime is stable
  stable,
  
  /// Trend is unknown
  unknown,
}

/**
 * Safety Comparison Enumeration
 * 
 * Compares local safety to national averages.
 */
enum SafetyComparison {
  /// Much safer than average
  muchSafer,
  
  /// Safer than average
  safer,
  
  /// About average
  average,
  
  /// Less safe than average
  lessSafe,
  
  /// Much less safe than average
  muchLessSafe,
}

/**
 * Amenities Data Model
 * 
 * Contains information about local amenities and services.
 */
@JsonSerializable()
class AmenitiesData {
  /// List of nearby restaurants
  final List<Amenity> restaurants;
  
  /// List of nearby shopping centers
  final List<Amenity> shopping;
  
  /// List of nearby parks and recreation
  final List<Amenity> parks;
  
  /// List of nearby healthcare facilities
  final List<Amenity> healthcare;
  
  /// List of nearby entertainment venues
  final List<Amenity> entertainment;
  
  /// Number of grocery stores within 1 mile
  final int groceryStores;
  
  /// Number of gas stations within 1 mile
  final int gasStations;

  /**
   * Constructor for AmenitiesData
   */
  const AmenitiesData({
    required this.restaurants,
    required this.shopping,
    required this.parks,
    required this.healthcare,
    required this.entertainment,
    required this.groceryStores,
    required this.gasStations,
  });

  /**
   * Create AmenitiesData from JSON
   */
  factory AmenitiesData.fromJson(Map<String, dynamic> json) => 
      _$AmenitiesDataFromJson(json);

  /**
   * Convert AmenitiesData to JSON
   */
  Map<String, dynamic> toJson() => _$AmenitiesDataToJson(this);
}

/**
 * Amenity Model
 * 
 * Represents a single amenity or service.
 */
@JsonSerializable()
class Amenity {
  /// Amenity name
  final String name;
  
  /// Amenity type
  final AmenityType type;
  
  /// Distance from neighborhood center in miles
  final double distanceMiles;
  
  /// Rating (0-5 stars)
  final double rating;
  
  /// Address
  final String address;

  /**
   * Constructor for Amenity
   */
  const Amenity({
    required this.name,
    required this.type,
    required this.distanceMiles,
    required this.rating,
    required this.address,
  });

  /**
   * Create Amenity from JSON
   */
  factory Amenity.fromJson(Map<String, dynamic> json) => _$AmenityFromJson(json);

  /**
   * Convert Amenity to JSON
   */
  Map<String, dynamic> toJson() => _$AmenityToJson(this);
}

/**
 * Amenity Type Enumeration
 * 
 * Represents different types of amenities.
 */
enum AmenityType {
  /// Restaurant or food service
  restaurant,
  
  /// Shopping center or store
  shopping,
  
  /// Park or recreational area
  park,
  
  /// Healthcare facility
  healthcare,
  
  /// Entertainment venue
  entertainment,
  
  /// Grocery store
  grocery,
  
  /// Gas station
  gasStation,
}

/**
 * Transportation Data Model
 * 
 * Contains transportation and commute information.
 */
@JsonSerializable()
class TransportationData {
  /// Average commute time to downtown in minutes
  final int averageCommuteTime;
  
  /// Public transportation score (0-100)
  final int publicTransitScore;
  
  /// Number of nearby bus stops
  final int busStops;
  
  /// Number of nearby train stations
  final int trainStations;
  
  /// Distance to nearest airport in miles
  final double airportDistance;
  
  /// Major highways nearby
  final List<String> nearbyHighways;

  /**
   * Constructor for TransportationData
   */
  const TransportationData({
    required this.averageCommuteTime,
    required this.publicTransitScore,
    required this.busStops,
    required this.trainStations,
    required this.airportDistance,
    required this.nearbyHighways,
  });

  /**
   * Create TransportationData from JSON
   */
  factory TransportationData.fromJson(Map<String, dynamic> json) => 
      _$TransportationDataFromJson(json);

  /**
   * Convert TransportationData to JSON
   */
  Map<String, dynamic> toJson() => _$TransportationDataToJson(this);
}

/**
 * Demographics Data Model
 * 
 * Contains demographic and population information.
 */
@JsonSerializable()
class DemographicsData {
  /// Total population
  final int population;
  
  /// Median age
  final double medianAge;
  
  /// Median household income
  final double medianIncome;
  
  /// Percentage of population with college degree
  final double collegeEducationPercentage;
  
  /// Percentage of families with children
  final double familiesWithChildrenPercentage;
  
  /// Racial/ethnic diversity index (0-100)
  final double diversityIndex;

  /**
   * Constructor for DemographicsData
   */
  const DemographicsData({
    required this.population,
    required this.medianAge,
    required this.medianIncome,
    required this.collegeEducationPercentage,
    required this.familiesWithChildrenPercentage,
    required this.diversityIndex,
  });

  /**
   * Create DemographicsData from JSON
   */
  factory DemographicsData.fromJson(Map<String, dynamic> json) => 
      _$DemographicsDataFromJson(json);

  /**
   * Convert DemographicsData to JSON
   */
  Map<String, dynamic> toJson() => _$DemographicsDataToJson(this);

  /**
   * Get formatted median income string
   * 
   * @return Formatted income string
   */
  String get formattedMedianIncome {
    return '\$${medianIncome.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }
}
