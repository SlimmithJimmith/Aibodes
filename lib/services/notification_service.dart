/**
 * Notification service for Aibodes
 * 
 * This service handles push notifications for:
 * - New property listings matching user preferences
 * - Price alerts and market changes
 * - Saved search updates
 * - Mortgage rate changes
 * - Neighborhood data updates
 * 
 * The service integrates with Firebase Cloud Messaging (FCM)
 * and local notifications for offline scenarios.
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/property.dart';
import '../models/market_data.dart';

/**
 * Notification service class
 * 
 * Manages both push notifications and local notifications
 * for real-time property and market updates.
 */
class NotificationService {
  /// Singleton instance of the service
  static final NotificationService _instance = NotificationService._internal();
  
  /// Factory constructor to return singleton instance
  factory NotificationService() => _instance;
  
  /// Private constructor for singleton pattern
  NotificationService._internal();

  // ==================== PRIVATE FIELDS ====================
  
  /// Local notifications plugin instance
  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  
  /// Stream controller for notification events
  final StreamController<NotificationEvent> _notificationController = 
      StreamController<NotificationEvent>.broadcast();
  
  /// Stream controller for permission status changes
  final StreamController<bool> _permissionController = 
      StreamController<bool>.broadcast();
  
  /// Current notification permission status
  bool _hasPermission = false;
  
  /// FCM token for push notifications
  String? _fcmToken;
  
  /// User's notification preferences
  NotificationPreferences _preferences = NotificationPreferences();

  // ==================== PUBLIC GETTERS ====================
  
  /**
   * Stream of notification events
   * 
   * @return Stream of notification events
   */
  Stream<NotificationEvent> get notificationStream => _notificationController.stream;
  
  /**
   * Stream of permission status changes
   * 
   * @return Stream of permission status (true if granted)
   */
  Stream<bool> get permissionStream => _permissionController.stream;
  
  /**
   * Current notification permission status
   * 
   * @return True if notifications are permitted
   */
  bool get hasPermission => _hasPermission;
  
  /**
   * Current FCM token
   * 
   * @return FCM token string or null if not available
   */
  String? get fcmToken => _fcmToken;
  
  /**
   * Current notification preferences
   * 
   * @return NotificationPreferences object
   */
  NotificationPreferences get preferences => _preferences;

  // ==================== INITIALIZATION ====================
  
  /**
   * Initialize the notification service
   * 
   * Sets up local notifications, requests permissions,
   * and configures FCM for push notifications.
   */
  Future<void> initialize() async {
    try {
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      // Request notification permissions
      await _requestPermissions();
      
      // Initialize FCM (if available)
      await _initializeFCM();
      
      print('NotificationService initialized successfully');
    } catch (e) {
      print('Failed to initialize NotificationService: $e');
    }
  }
  
  /**
   * Initialize local notifications plugin
   */
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }
  
  /**
   * Request notification permissions
   */
  Future<void> _requestPermissions() async {
    try {
      // Request notification permission
      final status = await Permission.notification.request();
      _hasPermission = status.isGranted;
      
      // Request additional permissions for Android
      if (defaultTargetPlatform == TargetPlatform.android) {
        await Permission.scheduleExactAlarm.request();
      }
      
      _permissionController.add(_hasPermission);
      
      if (_hasPermission) {
        print('Notification permissions granted');
      } else {
        print('Notification permissions denied');
      }
    } catch (e) {
      print('Error requesting notification permissions: $e');
      _hasPermission = false;
    }
  }
  
  /**
   * Initialize Firebase Cloud Messaging
   * 
   * Note: This is a mock implementation since Firebase was removed
   * In a real app, you would integrate with FCM here.
   */
  Future<void> _initializeFCM() async {
    try {
      // Mock FCM token generation
      _fcmToken = 'mock_fcm_token_${DateTime.now().millisecondsSinceEpoch}';
      
      print('FCM initialized with token: $_fcmToken');
    } catch (e) {
      print('FCM initialization failed: $e');
    }
  }

  // ==================== NOTIFICATION TYPES ====================
  
  /**
   * Show new property listing notification
   * 
   * @param property New property that matches user preferences
   */
  Future<void> showNewListingNotification(Property property) async {
    if (!_hasPermission || !_preferences.newListings) return;
    
    const notificationId = 1001;
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'new_listings',
      'New Property Listings',
      channelDescription: 'Notifications for new property listings',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      notificationId,
      'New Property Available!',
      '${property.title} - \$${property.price.toStringAsFixed(0)}',
      notificationDetails,
      payload: jsonEncode({
        'type': 'new_listing',
        'propertyId': property.id,
        'property': property.toJson(),
      }),
    );
    
    _notificationController.add(NotificationEvent(
      type: NotificationType.newListing,
      title: 'New Property Available!',
      body: '${property.title} - \$${property.price.toStringAsFixed(0)}',
      data: {'propertyId': property.id},
    ));
  }
  
  /**
   * Show price alert notification
   * 
   * @param property Property with price change
   * @param oldPrice Previous price
   * @param newPrice New price
   * @param changePercent Percentage change
   */
  Future<void> showPriceAlertNotification(
    Property property,
    double oldPrice,
    double newPrice,
    double changePercent,
  ) async {
    if (!_hasPermission || !_preferences.priceAlerts) return;
    
    const notificationId = 1002;
    
    final isIncrease = changePercent > 0;
    final changeText = isIncrease ? 'increased' : 'decreased';
    final changeIcon = isIncrease ? '📈' : '📉';
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'price_alerts',
      'Price Alerts',
      channelDescription: 'Notifications for property price changes',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      notificationId,
      '$changeIcon Price Alert',
      '${property.title} $changeText by ${changePercent.abs().toStringAsFixed(1)}%',
      notificationDetails,
      payload: jsonEncode({
        'type': 'price_alert',
        'propertyId': property.id,
        'oldPrice': oldPrice,
        'newPrice': newPrice,
        'changePercent': changePercent,
      }),
    );
    
    _notificationController.add(NotificationEvent(
      type: NotificationType.priceAlert,
      title: '$changeIcon Price Alert',
      body: '${property.title} $changeText by ${changePercent.abs().toStringAsFixed(1)}%',
      data: {
        'propertyId': property.id,
        'oldPrice': oldPrice,
        'newPrice': newPrice,
        'changePercent': changePercent,
      },
    ));
  }
  
  /**
   * Show mortgage rate change notification
   * 
   * @param oldRate Previous mortgage rate
   * @param newRate New mortgage rate
   * @param rateType Type of mortgage rate (30-year, 15-year, etc.)
   */
  Future<void> showMortgageRateNotification(
    double oldRate,
    double newRate,
    String rateType,
  ) async {
    if (!_hasPermission || !_preferences.mortgageRates) return;
    
    const notificationId = 1003;
    
    final change = newRate - oldRate;
    final changeText = change > 0 ? 'increased' : 'decreased';
    final changeIcon = change > 0 ? '📈' : '📉';
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'mortgage_rates',
      'Mortgage Rate Updates',
      channelDescription: 'Notifications for mortgage rate changes',
      importance: Importance.medium,
      priority: Priority.defaultPriority,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      notificationId,
      '$changeIcon Mortgage Rate Update',
      '$rateType rate $changeText to ${newRate.toStringAsFixed(3)}%',
      notificationDetails,
      payload: jsonEncode({
        'type': 'mortgage_rate',
        'rateType': rateType,
        'oldRate': oldRate,
        'newRate': newRate,
      }),
    );
    
    _notificationController.add(NotificationEvent(
      type: NotificationType.mortgageRate,
      title: '$changeIcon Mortgage Rate Update',
      body: '$rateType rate $changeText to ${newRate.toStringAsFixed(3)}%',
      data: {
        'rateType': rateType,
        'oldRate': oldRate,
        'newRate': newRate,
      },
    ));
  }
  
  /**
   * Show market data update notification
   * 
   * @param marketData Updated market data
   */
  Future<void> showMarketDataNotification(MarketData marketData) async {
    if (!_hasPermission || !_preferences.marketUpdates) return;
    
    const notificationId = 1004;
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'market_updates',
      'Market Updates',
      channelDescription: 'Notifications for market data changes',
      importance: Importance.low,
      priority: Priority.low,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: true,
      presentSound: false,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      notificationId,
      'Market Update',
      'Average home price: \$${marketData.averagePrice.toStringAsFixed(0)}',
      notificationDetails,
      payload: jsonEncode({
        'type': 'market_update',
        'marketData': marketData.toJson(),
      }),
    );
    
    _notificationController.add(NotificationEvent(
      type: NotificationType.marketUpdate,
      title: 'Market Update',
      body: 'Average home price: \$${marketData.averagePrice.toStringAsFixed(0)}',
      data: {'marketData': marketData.toJson()},
    ));
  }
  
  /**
   * Show saved search update notification
   * 
   * @param searchName Name of the saved search
   * @param newCount Number of new properties found
   */
  Future<void> showSavedSearchNotification(String searchName, int newCount) async {
    if (!_hasPermission || !_preferences.savedSearches) return;
    
    const notificationId = 1005;
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'saved_searches',
      'Saved Search Updates',
      channelDescription: 'Notifications for saved search results',
      importance: Importance.medium,
      priority: Priority.defaultPriority,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      notificationId,
      'Saved Search Update',
      '$newCount new properties found for "$searchName"',
      notificationDetails,
      payload: jsonEncode({
        'type': 'saved_search',
        'searchName': searchName,
        'newCount': newCount,
      }),
    );
    
    _notificationController.add(NotificationEvent(
      type: NotificationType.savedSearch,
      title: 'Saved Search Update',
      body: '$newCount new properties found for "$searchName"',
      data: {
        'searchName': searchName,
        'newCount': newCount,
      },
    ));
  }

  // ==================== NOTIFICATION HANDLERS ====================
  
  /**
   * Handle notification tap events
   * 
   * @param response Notification response object
   */
  void _onNotificationTapped(NotificationResponse response) {
    try {
      if (response.payload != null) {
        final data = jsonDecode(response.payload!);
        final type = data['type'] as String;
        
        switch (type) {
          case 'new_listing':
            _handleNewListingTap(data);
            break;
          case 'price_alert':
            _handlePriceAlertTap(data);
            break;
          case 'mortgage_rate':
            _handleMortgageRateTap(data);
            break;
          case 'market_update':
            _handleMarketUpdateTap(data);
            break;
          case 'saved_search':
            _handleSavedSearchTap(data);
            break;
        }
      }
    } catch (e) {
      print('Error handling notification tap: $e');
    }
  }
  
  /**
   * Handle new listing notification tap
   */
  void _handleNewListingTap(Map<String, dynamic> data) {
    final propertyId = data['propertyId'] as String;
    print('New listing notification tapped for property: $propertyId');
    
    // In a real app, you would navigate to the property details screen
    _notificationController.add(NotificationEvent(
      type: NotificationType.newListing,
      title: 'Navigation',
      body: 'Navigate to property $propertyId',
      data: {'action': 'navigate', 'propertyId': propertyId},
    ));
  }
  
  /**
   * Handle price alert notification tap
   */
  void _handlePriceAlertTap(Map<String, dynamic> data) {
    final propertyId = data['propertyId'] as String;
    print('Price alert notification tapped for property: $propertyId');
    
    // In a real app, you would navigate to the property details screen
    _notificationController.add(NotificationEvent(
      type: NotificationType.priceAlert,
      title: 'Navigation',
      body: 'Navigate to property $propertyId',
      data: {'action': 'navigate', 'propertyId': propertyId},
    ));
  }
  
  /**
   * Handle mortgage rate notification tap
   */
  void _handleMortgageRateTap(Map<String, dynamic> data) {
    final rateType = data['rateType'] as String;
    print('Mortgage rate notification tapped for rate type: $rateType');
    
    // In a real app, you would navigate to the mortgage calculator
    _notificationController.add(NotificationEvent(
      type: NotificationType.mortgageRate,
      title: 'Navigation',
      body: 'Navigate to mortgage calculator',
      data: {'action': 'navigate', 'screen': 'mortgage_calculator'},
    ));
  }
  
  /**
   * Handle market update notification tap
   */
  void _handleMarketUpdateTap(Map<String, dynamic> data) {
    print('Market update notification tapped');
    
    // In a real app, you would navigate to the market data screen
    _notificationController.add(NotificationEvent(
      type: NotificationType.marketUpdate,
      title: 'Navigation',
      body: 'Navigate to market data',
      data: {'action': 'navigate', 'screen': 'market_data'},
    ));
  }
  
  /**
   * Handle saved search notification tap
   */
  void _handleSavedSearchTap(Map<String, dynamic> data) {
    final searchName = data['searchName'] as String;
    print('Saved search notification tapped for search: $searchName');
    
    // In a real app, you would navigate to the search results
    _notificationController.add(NotificationEvent(
      type: NotificationType.savedSearch,
      title: 'Navigation',
      body: 'Navigate to search results',
      data: {'action': 'navigate', 'searchName': searchName},
    ));
  }

  // ==================== PREFERENCE MANAGEMENT ====================
  
  /**
   * Update notification preferences
   * 
   * @param preferences New notification preferences
   */
  void updatePreferences(NotificationPreferences preferences) {
    _preferences = preferences;
    print('Notification preferences updated');
  }
  
  /**
   * Enable/disable specific notification type
   * 
   * @param type Notification type to toggle
   * @param enabled Whether to enable or disable
   */
  void toggleNotificationType(NotificationType type, bool enabled) {
    switch (type) {
      case NotificationType.newListing:
        _preferences.newListings = enabled;
        break;
      case NotificationType.priceAlert:
        _preferences.priceAlerts = enabled;
        break;
      case NotificationType.mortgageRate:
        _preferences.mortgageRates = enabled;
        break;
      case NotificationType.marketUpdate:
        _preferences.marketUpdates = enabled;
        break;
      case NotificationType.savedSearch:
        _preferences.savedSearches = enabled;
        break;
    }
    
    print('${type.name} notifications ${enabled ? 'enabled' : 'disabled'}');
  }
  
  /**
   * Clear all notifications
   */
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
    print('All notifications cleared');
  }
  
  /**
   * Clear specific notification
   * 
   * @param id Notification ID to clear
   */
  Future<void> clearNotification(int id) async {
    await _localNotifications.cancel(id);
    print('Notification $id cleared');
  }

  // ==================== UTILITY METHODS ====================
  
  /**
   * Check if notifications are enabled for a specific type
   * 
   * @param type Notification type to check
   * @return True if notifications are enabled for this type
   */
  bool isNotificationEnabled(NotificationType type) {
    switch (type) {
      case NotificationType.newListing:
        return _preferences.newListings;
      case NotificationType.priceAlert:
        return _preferences.priceAlerts;
      case NotificationType.mortgageRate:
        return _preferences.mortgageRates;
      case NotificationType.marketUpdate:
        return _preferences.marketUpdates;
      case NotificationType.savedSearch:
        return _preferences.savedSearches;
    }
  }
  
  /**
   * Get notification channel importance for Android
   * 
   * @param type Notification type
   * @return Importance level
   */
  Importance getChannelImportance(NotificationType type) {
    switch (type) {
      case NotificationType.newListing:
      case NotificationType.priceAlert:
        return Importance.high;
      case NotificationType.mortgageRate:
      case NotificationType.savedSearch:
        return Importance.medium;
      case NotificationType.marketUpdate:
        return Importance.low;
    }
  }
  
  /**
   * Dispose of resources
   */
  void dispose() {
    _notificationController.close();
    _permissionController.close();
  }
}

/**
 * Notification event class
 * 
 * Represents a notification event that can be streamed to listeners.
 */
class NotificationEvent {
  /// Type of notification
  final NotificationType type;
  
  /// Notification title
  final String title;
  
  /// Notification body text
  final String body;
  
  /// Additional data associated with the notification
  final Map<String, dynamic> data;
  
  /// Timestamp when the event occurred
  final DateTime timestamp;

  /**
   * Constructor for NotificationEvent
   * 
   * @param type Type of notification
   * @param title Notification title
   * @param body Notification body text
   * @param data Additional data (optional)
   */
  NotificationEvent({
    required this.type,
    required this.title,
    required this.body,
    Map<String, dynamic>? data,
  }) : data = data ?? {},
       timestamp = DateTime.now();
}

/**
 * Notification type enumeration
 */
enum NotificationType {
  /// New property listing notification
  newListing,
  
  /// Price alert notification
  priceAlert,
  
  /// Mortgage rate change notification
  mortgageRate,
  
  /// Market data update notification
  marketUpdate,
  
  /// Saved search update notification
  savedSearch,
}

/**
 * Notification preferences class
 * 
 * Stores user preferences for different types of notifications.
 */
class NotificationPreferences {
  /// Enable new listing notifications
  bool newListings = true;
  
  /// Enable price alert notifications
  bool priceAlerts = true;
  
  /// Enable mortgage rate notifications
  bool mortgageRates = true;
  
  /// Enable market update notifications
  bool marketUpdates = false;
  
  /// Enable saved search notifications
  bool savedSearches = true;
  
  /// Enable sound for notifications
  bool soundEnabled = true;
  
  /// Enable vibration for notifications
  bool vibrationEnabled = true;
  
  /// Quiet hours start time (24-hour format)
  int quietHoursStart = 22; // 10 PM
  
  /// Quiet hours end time (24-hour format)
  int quietHoursEnd = 8; // 8 AM
  
  /**
   * Check if current time is within quiet hours
   * 
   * @return True if current time is within quiet hours
   */
  bool get isQuietHours {
    final now = DateTime.now();
    final currentHour = now.hour;
    
    if (quietHoursStart > quietHoursEnd) {
      // Quiet hours span midnight (e.g., 10 PM to 8 AM)
      return currentHour >= quietHoursStart || currentHour < quietHoursEnd;
    } else {
      // Quiet hours within same day (e.g., 10 PM to 11 PM)
      return currentHour >= quietHoursStart && currentHour < quietHoursEnd;
    }
  }
  
  /**
   * Convert to JSON for storage
   * 
   * @return JSON representation of preferences
   */
  Map<String, dynamic> toJson() {
    return {
      'newListings': newListings,
      'priceAlerts': priceAlerts,
      'mortgageRates': mortgageRates,
      'marketUpdates': marketUpdates,
      'savedSearches': savedSearches,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
    };
  }
  
  /**
   * Create from JSON
   * 
   * @param json JSON data to parse
   * @return NotificationPreferences instance
   */
  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    final preferences = NotificationPreferences();
    preferences.newListings = json['newListings'] ?? true;
    preferences.priceAlerts = json['priceAlerts'] ?? true;
    preferences.mortgageRates = json['mortgageRates'] ?? true;
    preferences.marketUpdates = json['marketUpdates'] ?? false;
    preferences.savedSearches = json['savedSearches'] ?? true;
    preferences.soundEnabled = json['soundEnabled'] ?? true;
    preferences.vibrationEnabled = json['vibrationEnabled'] ?? true;
    preferences.quietHoursStart = json['quietHoursStart'] ?? 22;
    preferences.quietHoursEnd = json['quietHoursEnd'] ?? 8;
    return preferences;
  }
}
