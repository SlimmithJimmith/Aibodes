// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketData _$MarketDataFromJson(Map<String, dynamic> json) => MarketData(
      id: json['id'] as String,
      location: json['location'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      medianPrice: (json['medianPrice'] as num).toDouble(),
      pricePerSqFt: (json['pricePerSqFt'] as num).toDouble(),
      priceChangeYoY: (json['priceChangeYoY'] as num).toDouble(),
      priceChangeMoM: (json['priceChangeMoM'] as num).toDouble(),
      activeListings: (json['activeListings'] as num).toInt(),
      averageDaysOnMarket: (json['averageDaysOnMarket'] as num).toInt(),
      newListings: (json['newListings'] as num).toInt(),
      soldProperties: (json['soldProperties'] as num).toInt(),
      inventoryMonths: (json['inventoryMonths'] as num).toDouble(),
      temperature: $enumDecode(_$MarketTemperatureEnumMap, json['temperature']),
      priceDistribution: PriceDistribution.fromJson(
          json['priceDistribution'] as Map<String, dynamic>),
      forecast:
          MarketForecast.fromJson(json['forecast'] as Map<String, dynamic>),
      comparables: (json['comparables'] as List<dynamic>)
          .map((e) => ComparableProperty.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MarketDataToJson(MarketData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'timestamp': instance.timestamp.toIso8601String(),
      'medianPrice': instance.medianPrice,
      'pricePerSqFt': instance.pricePerSqFt,
      'priceChangeYoY': instance.priceChangeYoY,
      'priceChangeMoM': instance.priceChangeMoM,
      'activeListings': instance.activeListings,
      'averageDaysOnMarket': instance.averageDaysOnMarket,
      'newListings': instance.newListings,
      'soldProperties': instance.soldProperties,
      'inventoryMonths': instance.inventoryMonths,
      'temperature': _$MarketTemperatureEnumMap[instance.temperature]!,
      'priceDistribution': instance.priceDistribution,
      'forecast': instance.forecast,
      'comparables': instance.comparables,
    };

const _$MarketTemperatureEnumMap = {
  MarketTemperature.hot: 'hot',
  MarketTemperature.warm: 'warm',
  MarketTemperature.cool: 'cool',
  MarketTemperature.cold: 'cold',
};

PriceDistribution _$PriceDistributionFromJson(Map<String, dynamic> json) =>
    PriceDistribution(
      under300k: (json['under300k'] as num).toInt(),
      range300to500k: (json['range300to500k'] as num).toInt(),
      range500to750k: (json['range500to750k'] as num).toInt(),
      range750kto1M: (json['range750kto1M'] as num).toInt(),
      over1M: (json['over1M'] as num).toInt(),
    );

Map<String, dynamic> _$PriceDistributionToJson(PriceDistribution instance) =>
    <String, dynamic>{
      'under300k': instance.under300k,
      'range300to500k': instance.range300to500k,
      'range500to750k': instance.range500to750k,
      'range750kto1M': instance.range750kto1M,
      'over1M': instance.over1M,
    };

MarketForecast _$MarketForecastFromJson(Map<String, dynamic> json) =>
    MarketForecast(
      predictedPriceChange: (json['predictedPriceChange'] as num).toDouble(),
      confidenceLevel: (json['confidenceLevel'] as num).toInt(),
      trend: $enumDecode(_$MarketTrendEnumMap, json['trend']),
      keyFactors: (json['keyFactors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MarketForecastToJson(MarketForecast instance) =>
    <String, dynamic>{
      'predictedPriceChange': instance.predictedPriceChange,
      'confidenceLevel': instance.confidenceLevel,
      'trend': _$MarketTrendEnumMap[instance.trend]!,
      'keyFactors': instance.keyFactors,
    };

const _$MarketTrendEnumMap = {
  MarketTrend.rising: 'rising',
  MarketTrend.falling: 'falling',
  MarketTrend.stable: 'stable',
  MarketTrend.uncertain: 'uncertain',
};

ComparableProperty _$ComparablePropertyFromJson(Map<String, dynamic> json) =>
    ComparableProperty(
      address: json['address'] as String,
      salePrice: (json['salePrice'] as num).toDouble(),
      saleDate: DateTime.parse(json['saleDate'] as String),
      squareFeet: (json['squareFeet'] as num).toInt(),
      bedrooms: (json['bedrooms'] as num).toInt(),
      bathrooms: (json['bathrooms'] as num).toInt(),
      distanceMiles: (json['distanceMiles'] as num).toDouble(),
    );

Map<String, dynamic> _$ComparablePropertyToJson(ComparableProperty instance) =>
    <String, dynamic>{
      'address': instance.address,
      'salePrice': instance.salePrice,
      'saleDate': instance.saleDate.toIso8601String(),
      'squareFeet': instance.squareFeet,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'distanceMiles': instance.distanceMiles,
    };

PriceHistory _$PriceHistoryFromJson(Map<String, dynamic> json) => PriceHistory(
      date: DateTime.parse(json['date'] as String),
      price: (json['price'] as num).toDouble(),
      type: $enumDecode(_$PriceChangeTypeEnumMap, json['type']),
      source: json['source'] as String,
    );

Map<String, dynamic> _$PriceHistoryToJson(PriceHistory instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'price': instance.price,
      'type': _$PriceChangeTypeEnumMap[instance.type]!,
      'source': instance.source,
    };

const _$PriceChangeTypeEnumMap = {
  PriceChangeType.listing: 'listing',
  PriceChangeType.sale: 'sale',
  PriceChangeType.estimate: 'estimate',
  PriceChangeType.reduction: 'reduction',
  PriceChangeType.increase: 'increase',
};
