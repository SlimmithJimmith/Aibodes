/**
 * Market Data Model for Real Estate Analytics
 * 
 * This model represents comprehensive market data including:
 * - Price trends and statistics
 * - Market indicators (inventory, days on market)
 * - Comparative market analysis (CMA)
 * - Market forecasts and predictions
 * 
 * @author Aibodes Team
 * @version 2.0.0
 */

import 'package:json_annotation/json_annotation.dart';

part 'market_data.g.dart';

/**
 * Market Data class containing comprehensive real estate market information
 * 
 * Provides insights into local market conditions, price trends,
 * and market indicators for informed decision making.
 */
@JsonSerializable()
class MarketData {
  /// Unique identifier for the market data record
  final String id;
  
  /// Geographic location (city, state, zip code)
  final String location;
  
  /// Market data timestamp
  final DateTime timestamp;
  
  /// Current median home price in the area
  final double medianPrice;
  
  /// Price per square foot
  final double pricePerSqFt;
  
  /// Year-over-year price change percentage
  final double priceChangeYoY;
  
  /// Month-over-month price change percentage
  final double priceChangeMoM;
  
  /// Total number of active listings
  final int activeListings;
  
  /// Average days on market
  final int averageDaysOnMarket;
  
  /// Number of new listings this month
  final int newListings;
  
  /// Number of sold properties this month
  final int soldProperties;
  
  /// Market inventory in months (supply vs demand)
  final double inventoryMonths;
  
  /// Market temperature (hot, warm, cool, cold)
  final MarketTemperature temperature;
  
  /// Price range distribution
  final PriceDistribution priceDistribution;
  
  /// Market forecast for next 12 months
  final MarketForecast forecast;
  
  /// Comparable properties data
  final List<ComparableProperty> comparables;

  /**
   * Constructor for MarketData
   * 
   * @param id Unique identifier
   * @param location Geographic location
   * @param timestamp Data timestamp
   * @param medianPrice Current median home price
   * @param pricePerSqFt Price per square foot
   * @param priceChangeYoY Year-over-year price change
   * @param priceChangeMoM Month-over-month price change
   * @param activeListings Number of active listings
   * @param averageDaysOnMarket Average days on market
   * @param newListings New listings this month
   * @param soldProperties Sold properties this month
   * @param inventoryMonths Inventory in months
   * @param temperature Market temperature
   * @param priceDistribution Price range distribution
   * @param forecast Market forecast
   * @param comparables Comparable properties
   */
  const MarketData({
    required this.id,
    required this.location,
    required this.timestamp,
    required this.medianPrice,
    required this.pricePerSqFt,
    required this.priceChangeYoY,
    required this.priceChangeMoM,
    required this.activeListings,
    required this.averageDaysOnMarket,
    required this.newListings,
    required this.soldProperties,
    required this.inventoryMonths,
    required this.temperature,
    required this.priceDistribution,
    required this.forecast,
    required this.comparables,
  });

  /**
   * Create MarketData from JSON
   * 
   * @param json JSON data
   * @return MarketData instance
   */
  factory MarketData.fromJson(Map<String, dynamic> json) => _$MarketDataFromJson(json);

  /**
   * Convert MarketData to JSON
   * 
   * @return JSON representation
   */
  Map<String, dynamic> toJson() => _$MarketDataToJson(this);

  /**
   * Get formatted median price string
   * 
   * @return Formatted price string (e.g., "$450,000")
   */
  String get formattedMedianPrice {
    return '\$${medianPrice.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  /**
   * Get formatted price change string
   * 
   * @return Formatted change string (e.g., "+5.2%")
   */
  String get formattedPriceChange {
    final change = priceChangeYoY;
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(1)}%';
  }

  /**
   * Get market temperature description
   * 
   * @return Human-readable temperature description
   */
  String get temperatureDescription {
    switch (temperature) {
      case MarketTemperature.hot:
        return 'Hot Market - High demand, low inventory';
      case MarketTemperature.warm:
        return 'Warm Market - Moderate demand and inventory';
      case MarketTemperature.cool:
        return 'Cool Market - Lower demand, higher inventory';
      case MarketTemperature.cold:
        return 'Cold Market - Low demand, high inventory';
    }
  }

  /**
   * Get market health score (0-100)
   * 
   * @return Market health score
   */
  int get marketHealthScore {
    int score = 50; // Base score
    
    // Adjust based on price change
    if (priceChangeYoY > 5) score += 20;
    else if (priceChangeYoY > 0) score += 10;
    else if (priceChangeYoY < -5) score -= 20;
    else if (priceChangeYoY < 0) score -= 10;
    
    // Adjust based on inventory
    if (inventoryMonths < 3) score += 15; // Seller's market
    else if (inventoryMonths > 6) score -= 15; // Buyer's market
    
    // Adjust based on days on market
    if (averageDaysOnMarket < 30) score += 10;
    else if (averageDaysOnMarket > 90) score -= 10;
    
    return score.clamp(0, 100);
  }
}

/**
 * Market Temperature Enumeration
 * 
 * Represents the current state of the real estate market
 * in terms of supply and demand dynamics.
 */
enum MarketTemperature {
  /// Hot market - High demand, low inventory, fast sales
  hot,
  
  /// Warm market - Moderate demand and inventory
  warm,
  
  /// Cool market - Lower demand, higher inventory
  cool,
  
  /// Cold market - Low demand, high inventory, slow sales
  cold,
}

/**
 * Price Distribution Model
 * 
 * Represents the distribution of property prices in a market
 * across different price ranges.
 */
@JsonSerializable()
class PriceDistribution {
  /// Properties under $300k
  final int under300k;
  
  /// Properties $300k-$500k
  final int range300to500k;
  
  /// Properties $500k-$750k
  final int range500to750k;
  
  /// Properties $750k-$1M
  final int range750kto1M;
  
  /// Properties over $1M
  final int over1M;

  /**
   * Constructor for PriceDistribution
   */
  const PriceDistribution({
    required this.under300k,
    required this.range300to500k,
    required this.range500to750k,
    required this.range750kto1M,
    required this.over1M,
  });

  /**
   * Create PriceDistribution from JSON
   */
  factory PriceDistribution.fromJson(Map<String, dynamic> json) => 
      _$PriceDistributionFromJson(json);

  /**
   * Convert PriceDistribution to JSON
   */
  Map<String, dynamic> toJson() => _$PriceDistributionToJson(this);

  /**
   * Get total number of properties
   * 
   * @return Total count
   */
  int get totalProperties => 
      under300k + range300to500k + range500to750k + range750kto1M + over1M;
}

/**
 * Market Forecast Model
 * 
 * Contains predictions and forecasts for market trends
 * over the next 12 months.
 */
@JsonSerializable()
class MarketForecast {
  /// Predicted price change over next 12 months
  final double predictedPriceChange;
  
  /// Confidence level in prediction (0-100)
  final int confidenceLevel;
  
  /// Market trend direction
  final MarketTrend trend;
  
  /// Key factors influencing the forecast
  final List<String> keyFactors;

  /**
   * Constructor for MarketForecast
   */
  const MarketForecast({
    required this.predictedPriceChange,
    required this.confidenceLevel,
    required this.trend,
    required this.keyFactors,
  });

  /**
   * Create MarketForecast from JSON
   */
  factory MarketForecast.fromJson(Map<String, dynamic> json) => 
      _$MarketForecastFromJson(json);

  /**
   * Convert MarketForecast to JSON
   */
  Map<String, dynamic> toJson() => _$MarketForecastToJson(this);
}

/**
 * Market Trend Enumeration
 * 
 * Represents the predicted direction of market movement.
 */
enum MarketTrend {
  /// Market is expected to rise
  rising,
  
  /// Market is expected to fall
  falling,
  
  /// Market is expected to remain stable
  stable,
  
  /// Market trend is uncertain
  uncertain,
}

/**
 * Comparable Property Model
 * 
 * Represents a property used for comparative market analysis (CMA).
 */
@JsonSerializable()
class ComparableProperty {
  /// Property address
  final String address;
  
  /// Sale price
  final double salePrice;
  
  /// Sale date
  final DateTime saleDate;
  
  /// Square footage
  final int squareFeet;
  
  /// Number of bedrooms
  final int bedrooms;
  
  /// Number of bathrooms
  final int bathrooms;
  
  /// Distance from subject property
  final double distanceMiles;

  /**
   * Constructor for ComparableProperty
   */
  const ComparableProperty({
    required this.address,
    required this.salePrice,
    required this.saleDate,
    required this.squareFeet,
    required this.bedrooms,
    required this.bathrooms,
    required this.distanceMiles,
  });

  /**
   * Create ComparableProperty from JSON
   */
  factory ComparableProperty.fromJson(Map<String, dynamic> json) => 
      _$ComparablePropertyFromJson(json);

  /**
   * Convert ComparableProperty to JSON
   */
  Map<String, dynamic> toJson() => _$ComparablePropertyToJson(this);

  /**
   * Get price per square foot
   * 
   * @return Price per square foot
   */
  double get pricePerSqFt => salePrice / squareFeet;
}

/**
 * Price History Model
 * 
 * Represents historical price data for a property.
 */
@JsonSerializable()
class PriceHistory {
  /// Date of price change
  final DateTime date;
  
  /// Price at this date
  final double price;
  
  /// Type of price change (listing, sale, estimate)
  final PriceChangeType type;
  
  /// Source of the price data
  final String source;

  /**
   * Constructor for PriceHistory
   */
  const PriceHistory({
    required this.date,
    required this.price,
    required this.type,
    required this.source,
  });

  /**
   * Create PriceHistory from JSON
   */
  factory PriceHistory.fromJson(Map<String, dynamic> json) => 
      _$PriceHistoryFromJson(json);

  /**
   * Convert PriceHistory to JSON
   */
  Map<String, dynamic> toJson() => _$PriceHistoryToJson(this);
}

/**
 * Price Change Type Enumeration
 * 
 * Represents the type of price change in the history.
 */
enum PriceChangeType {
  /// Initial listing price
  listing,
  
  /// Actual sale price
  sale,
  
  /// Market estimate/valuation
  estimate,
  
  /// Price reduction
  reduction,
  
  /// Price increase
  increase,
}
