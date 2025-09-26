// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'neighborhood_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NeighborhoodData _$NeighborhoodDataFromJson(Map<String, dynamic> json) =>
    NeighborhoodData(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      overallScore: (json['overallScore'] as num).toInt(),
      schools: SchoolData.fromJson(json['schools'] as Map<String, dynamic>),
      crime: CrimeData.fromJson(json['crime'] as Map<String, dynamic>),
      amenities:
          AmenitiesData.fromJson(json['amenities'] as Map<String, dynamic>),
      transportation: TransportationData.fromJson(
          json['transportation'] as Map<String, dynamic>),
      demographics: DemographicsData.fromJson(
          json['demographics'] as Map<String, dynamic>),
      walkabilityScore: (json['walkabilityScore'] as num).toInt(),
      bikeabilityScore: (json['bikeabilityScore'] as num).toInt(),
      transitScore: (json['transitScore'] as num).toInt(),
    );

Map<String, dynamic> _$NeighborhoodDataToJson(NeighborhoodData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'timestamp': instance.timestamp.toIso8601String(),
      'overallScore': instance.overallScore,
      'schools': instance.schools,
      'crime': instance.crime,
      'amenities': instance.amenities,
      'transportation': instance.transportation,
      'demographics': instance.demographics,
      'walkabilityScore': instance.walkabilityScore,
      'bikeabilityScore': instance.bikeabilityScore,
      'transitScore': instance.transitScore,
    };

SchoolData _$SchoolDataFromJson(Map<String, dynamic> json) => SchoolData(
      districtRating: (json['districtRating'] as num).toInt(),
      schools: (json['schools'] as List<dynamic>)
          .map((e) => School.fromJson(e as Map<String, dynamic>))
          .toList(),
      averageTestScores: TestScores.fromJson(
          json['averageTestScores'] as Map<String, dynamic>),
      studentTeacherRatio: (json['studentTeacherRatio'] as num).toDouble(),
      advancedProgramsPercentage:
          (json['advancedProgramsPercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$SchoolDataToJson(SchoolData instance) =>
    <String, dynamic>{
      'districtRating': instance.districtRating,
      'schools': instance.schools,
      'averageTestScores': instance.averageTestScores,
      'studentTeacherRatio': instance.studentTeacherRatio,
      'advancedProgramsPercentage': instance.advancedProgramsPercentage,
    };

School _$SchoolFromJson(Map<String, dynamic> json) => School(
      name: json['name'] as String,
      type: $enumDecode(_$SchoolTypeEnumMap, json['type']),
      rating: (json['rating'] as num).toInt(),
      distanceMiles: (json['distanceMiles'] as num).toDouble(),
      studentCount: (json['studentCount'] as num).toInt(),
      address: json['address'] as String,
    );

Map<String, dynamic> _$SchoolToJson(School instance) => <String, dynamic>{
      'name': instance.name,
      'type': _$SchoolTypeEnumMap[instance.type]!,
      'rating': instance.rating,
      'distanceMiles': instance.distanceMiles,
      'studentCount': instance.studentCount,
      'address': instance.address,
    };

const _$SchoolTypeEnumMap = {
  SchoolType.elementary: 'elementary',
  SchoolType.middle: 'middle',
  SchoolType.high: 'high',
  SchoolType.private: 'private',
  SchoolType.charter: 'charter',
  SchoolType.university: 'university',
};

TestScores _$TestScoresFromJson(Map<String, dynamic> json) => TestScores(
      averageSAT: (json['averageSAT'] as num).toInt(),
      averageACT: (json['averageACT'] as num).toInt(),
      mathProficiency: (json['mathProficiency'] as num).toDouble(),
      readingProficiency: (json['readingProficiency'] as num).toDouble(),
    );

Map<String, dynamic> _$TestScoresToJson(TestScores instance) =>
    <String, dynamic>{
      'averageSAT': instance.averageSAT,
      'averageACT': instance.averageACT,
      'mathProficiency': instance.mathProficiency,
      'readingProficiency': instance.readingProficiency,
    };

CrimeData _$CrimeDataFromJson(Map<String, dynamic> json) => CrimeData(
      overallScore: (json['overallScore'] as num).toInt(),
      violentCrimeRate: (json['violentCrimeRate'] as num).toDouble(),
      propertyCrimeRate: (json['propertyCrimeRate'] as num).toDouble(),
      trend: $enumDecode(_$CrimeTrendEnumMap, json['trend']),
      safetyComparison:
          $enumDecode(_$SafetyComparisonEnumMap, json['safetyComparison']),
    );

Map<String, dynamic> _$CrimeDataToJson(CrimeData instance) => <String, dynamic>{
      'overallScore': instance.overallScore,
      'violentCrimeRate': instance.violentCrimeRate,
      'propertyCrimeRate': instance.propertyCrimeRate,
      'trend': _$CrimeTrendEnumMap[instance.trend]!,
      'safetyComparison': _$SafetyComparisonEnumMap[instance.safetyComparison]!,
    };

const _$CrimeTrendEnumMap = {
  CrimeTrend.increasing: 'increasing',
  CrimeTrend.decreasing: 'decreasing',
  CrimeTrend.stable: 'stable',
  CrimeTrend.unknown: 'unknown',
};

const _$SafetyComparisonEnumMap = {
  SafetyComparison.muchSafer: 'muchSafer',
  SafetyComparison.safer: 'safer',
  SafetyComparison.average: 'average',
  SafetyComparison.lessSafe: 'lessSafe',
  SafetyComparison.muchLessSafe: 'muchLessSafe',
};

AmenitiesData _$AmenitiesDataFromJson(Map<String, dynamic> json) =>
    AmenitiesData(
      restaurants: (json['restaurants'] as List<dynamic>)
          .map((e) => Amenity.fromJson(e as Map<String, dynamic>))
          .toList(),
      shopping: (json['shopping'] as List<dynamic>)
          .map((e) => Amenity.fromJson(e as Map<String, dynamic>))
          .toList(),
      parks: (json['parks'] as List<dynamic>)
          .map((e) => Amenity.fromJson(e as Map<String, dynamic>))
          .toList(),
      healthcare: (json['healthcare'] as List<dynamic>)
          .map((e) => Amenity.fromJson(e as Map<String, dynamic>))
          .toList(),
      entertainment: (json['entertainment'] as List<dynamic>)
          .map((e) => Amenity.fromJson(e as Map<String, dynamic>))
          .toList(),
      groceryStores: (json['groceryStores'] as num).toInt(),
      gasStations: (json['gasStations'] as num).toInt(),
    );

Map<String, dynamic> _$AmenitiesDataToJson(AmenitiesData instance) =>
    <String, dynamic>{
      'restaurants': instance.restaurants,
      'shopping': instance.shopping,
      'parks': instance.parks,
      'healthcare': instance.healthcare,
      'entertainment': instance.entertainment,
      'groceryStores': instance.groceryStores,
      'gasStations': instance.gasStations,
    };

Amenity _$AmenityFromJson(Map<String, dynamic> json) => Amenity(
      name: json['name'] as String,
      type: $enumDecode(_$AmenityTypeEnumMap, json['type']),
      distanceMiles: (json['distanceMiles'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      address: json['address'] as String,
    );

Map<String, dynamic> _$AmenityToJson(Amenity instance) => <String, dynamic>{
      'name': instance.name,
      'type': _$AmenityTypeEnumMap[instance.type]!,
      'distanceMiles': instance.distanceMiles,
      'rating': instance.rating,
      'address': instance.address,
    };

const _$AmenityTypeEnumMap = {
  AmenityType.restaurant: 'restaurant',
  AmenityType.shopping: 'shopping',
  AmenityType.park: 'park',
  AmenityType.healthcare: 'healthcare',
  AmenityType.entertainment: 'entertainment',
  AmenityType.grocery: 'grocery',
  AmenityType.gasStation: 'gasStation',
};

TransportationData _$TransportationDataFromJson(Map<String, dynamic> json) =>
    TransportationData(
      averageCommuteTime: (json['averageCommuteTime'] as num).toInt(),
      publicTransitScore: (json['publicTransitScore'] as num).toInt(),
      busStops: (json['busStops'] as num).toInt(),
      trainStations: (json['trainStations'] as num).toInt(),
      airportDistance: (json['airportDistance'] as num).toDouble(),
      nearbyHighways: (json['nearbyHighways'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TransportationDataToJson(TransportationData instance) =>
    <String, dynamic>{
      'averageCommuteTime': instance.averageCommuteTime,
      'publicTransitScore': instance.publicTransitScore,
      'busStops': instance.busStops,
      'trainStations': instance.trainStations,
      'airportDistance': instance.airportDistance,
      'nearbyHighways': instance.nearbyHighways,
    };

DemographicsData _$DemographicsDataFromJson(Map<String, dynamic> json) =>
    DemographicsData(
      population: (json['population'] as num).toInt(),
      medianAge: (json['medianAge'] as num).toDouble(),
      medianIncome: (json['medianIncome'] as num).toDouble(),
      collegeEducationPercentage:
          (json['collegeEducationPercentage'] as num).toDouble(),
      familiesWithChildrenPercentage:
          (json['familiesWithChildrenPercentage'] as num).toDouble(),
      diversityIndex: (json['diversityIndex'] as num).toDouble(),
    );

Map<String, dynamic> _$DemographicsDataToJson(DemographicsData instance) =>
    <String, dynamic>{
      'population': instance.population,
      'medianAge': instance.medianAge,
      'medianIncome': instance.medianIncome,
      'collegeEducationPercentage': instance.collegeEducationPercentage,
      'familiesWithChildrenPercentage': instance.familiesWithChildrenPercentage,
      'diversityIndex': instance.diversityIndex,
    };
