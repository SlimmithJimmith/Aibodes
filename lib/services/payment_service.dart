/**
 * Payment service for Aibodes
 * 
 * This service handles payment processing for premium features including:
 * - Premium subscription plans (monthly/yearly)
 * - One-time payments for premium features
 * - Property listing fees for agents
 * - Virtual tour creation fees
 * - Advanced search and analytics access
 * - Priority customer support
 * 
 * The service integrates with Stripe for secure payment processing
 * and includes comprehensive error handling and receipt management.
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

/**
 * Payment service class
 * 
 * Manages all payment-related operations including subscriptions,
 * one-time payments, and payment method management.
 */
class PaymentService {
  /// Singleton instance of the service
  static final PaymentService _instance = PaymentService._internal();
  
  /// Factory constructor to return singleton instance
  factory PaymentService() => _instance;
  
  /// Private constructor for singleton pattern
  PaymentService._internal();

  // ==================== PRIVATE FIELDS ====================
  
  /// Stripe publishable key (in production, this should be from environment)
  static const String _stripePublishableKey = 'pk_test_mock_stripe_key';
  
  /// Stripe secret key (in production, this should be from secure backend)
  static const String _stripeSecretKey = 'sk_test_mock_stripe_key';
  
  /// Base URL for payment API endpoints
  static const String _baseUrl = 'https://api.aibodes.com/payments';
  
  /// HTTP client for API calls
  final http.Client _httpClient = http.Client();
  
  /// Stream controller for payment events
  final StreamController<PaymentEvent> _paymentController = 
      StreamController<PaymentEvent>.broadcast();
  
  /// Current user's payment methods
  List<PaymentMethod> _paymentMethods = [];
  
  /// Current user's subscriptions
  List<Subscription> _subscriptions = [];
  
  /// Current user's payment history
  List<Payment> _paymentHistory = [];

  // ==================== PUBLIC GETTERS ====================
  
  /**
   * Stream of payment events
   * 
   * @return Stream of PaymentEvent objects
   */
  Stream<PaymentEvent> get paymentStream => _paymentController.stream;
  
  /**
   * Current user's payment methods
   * 
   * @return List of PaymentMethod objects
   */
  List<PaymentMethod> get paymentMethods => List.unmodifiable(_paymentMethods);
  
  /**
   * Current user's active subscriptions
   * 
   * @return List of Subscription objects
   */
  List<Subscription> get subscriptions => List.unmodifiable(_subscriptions);
  
  /**
   * Current user's payment history
   * 
   * @return List of Payment objects
   */
  List<Payment> get paymentHistory => List.unmodifiable(_paymentHistory);

  // ==================== SUBSCRIPTION MANAGEMENT ====================
  
  /**
   * Create a new subscription
   * 
   * @param planId ID of the subscription plan
   * @param paymentMethodId ID of the payment method to use
   * @param userId ID of the user creating the subscription
   * @return Created Subscription object
   */
  Future<Subscription> createSubscription({
    required String planId,
    required String paymentMethodId,
    required String userId,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/subscriptions'),
        headers: _getHeaders(),
        body: jsonEncode({
          'planId': planId,
          'paymentMethodId': paymentMethodId,
          'userId': userId,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final subscription = Subscription.fromJson(data);
        
        _subscriptions.add(subscription);
        _paymentController.add(PaymentEvent(
          type: PaymentEventType.subscriptionCreated,
          subscription: subscription,
        ));
        
        print('Subscription created successfully: ${subscription.id}');
        return subscription;
      } else {
        throw PaymentException('Failed to create subscription: ${response.body}');
      }
    } catch (e) {
      print('Error creating subscription: $e');
      _paymentController.add(PaymentEvent(
        type: PaymentEventType.error,
        error: e.toString(),
      ));
      rethrow;
    }
  }
  
  /**
   * Cancel a subscription
   * 
   * @param subscriptionId ID of the subscription to cancel
   * @return Updated Subscription object
   */
  Future<Subscription> cancelSubscription(String subscriptionId) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/subscriptions/$subscriptionId/cancel'),
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedSubscription = Subscription.fromJson(data);
        
        // Update local subscription
        final index = _subscriptions.indexWhere((s) => s.id == subscriptionId);
        if (index != -1) {
          _subscriptions[index] = updatedSubscription;
        }
        
        _paymentController.add(PaymentEvent(
          type: PaymentEventType.subscriptionCancelled,
          subscription: updatedSubscription,
        ));
        
        print('Subscription cancelled successfully: $subscriptionId');
        return updatedSubscription;
      } else {
        throw PaymentException('Failed to cancel subscription: ${response.body}');
      }
    } catch (e) {
      print('Error cancelling subscription: $e');
      _paymentController.add(PaymentEvent(
        type: PaymentEventType.error,
        error: e.toString(),
      ));
      rethrow;
    }
  }
  
  /**
   * Update subscription payment method
   * 
   * @param subscriptionId ID of the subscription to update
   * @param paymentMethodId ID of the new payment method
   * @return Updated Subscription object
   */
  Future<Subscription> updateSubscriptionPaymentMethod({
    required String subscriptionId,
    required String paymentMethodId,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/subscriptions/$subscriptionId/payment-method'),
        headers: _getHeaders(),
        body: jsonEncode({
          'paymentMethodId': paymentMethodId,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedSubscription = Subscription.fromJson(data);
        
        // Update local subscription
        final index = _subscriptions.indexWhere((s) => s.id == subscriptionId);
        if (index != -1) {
          _subscriptions[index] = updatedSubscription;
        }
        
        _paymentController.add(PaymentEvent(
          type: PaymentEventType.subscriptionUpdated,
          subscription: updatedSubscription,
        ));
        
        print('Subscription payment method updated: $subscriptionId');
        return updatedSubscription;
      } else {
        throw PaymentException('Failed to update subscription: ${response.body}');
      }
    } catch (e) {
      print('Error updating subscription: $e');
      _paymentController.add(PaymentEvent(
        type: PaymentEventType.error,
        error: e.toString(),
      ));
      rethrow;
    }
  }

  // ==================== ONE-TIME PAYMENTS ====================
  
  /**
   * Process a one-time payment
   * 
   * @param amount Payment amount in cents
   * @param currency Payment currency (default: USD)
   * @param paymentMethodId ID of the payment method to use
   * @param description Description of the payment
   * @param userId ID of the user making the payment
   * @return Created Payment object
   */
  Future<Payment> processPayment({
    required int amount,
    String currency = 'usd',
    required String paymentMethodId,
    required String description,
    required String userId,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/payments'),
        headers: _getHeaders(),
        body: jsonEncode({
          'amount': amount,
          'currency': currency,
          'paymentMethodId': paymentMethodId,
          'description': description,
          'userId': userId,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final payment = Payment.fromJson(data);
        
        _paymentHistory.add(payment);
        _paymentController.add(PaymentEvent(
          type: PaymentEventType.paymentProcessed,
          payment: payment,
        ));
        
        print('Payment processed successfully: ${payment.id}');
        return payment;
      } else {
        throw PaymentException('Failed to process payment: ${response.body}');
      }
    } catch (e) {
      print('Error processing payment: $e');
      _paymentController.add(PaymentEvent(
        type: PaymentEventType.error,
        error: e.toString(),
      ));
      rethrow;
    }
  }
  
  /**
   * Process property listing fee payment
   * 
   * @param propertyId ID of the property being listed
   * @param paymentMethodId ID of the payment method to use
   * @param userId ID of the user (agent) making the payment
   * @return Created Payment object
   */
  Future<Payment> processListingFee({
    required String propertyId,
    required String paymentMethodId,
    required String userId,
  }) async {
    const listingFeeAmount = 29900; // $299.00 in cents
    
    return await processPayment(
      amount: listingFeeAmount,
      paymentMethodId: paymentMethodId,
      description: 'Property listing fee for property $propertyId',
      userId: userId,
    );
  }
  
  /**
   * Process virtual tour creation fee
   * 
   * @param propertyId ID of the property for the virtual tour
   * @param paymentMethodId ID of the payment method to use
   * @param userId ID of the user making the payment
   * @return Created Payment object
   */
  Future<Payment> processVirtualTourFee({
    required String propertyId,
    required String paymentMethodId,
    required String userId,
  }) async {
    const virtualTourFeeAmount = 19900; // $199.00 in cents
    
    return await processPayment(
      amount: virtualTourFeeAmount,
      paymentMethodId: paymentMethodId,
      description: 'Virtual tour creation for property $propertyId',
      userId: userId,
    );
  }

  // ==================== PAYMENT METHOD MANAGEMENT ====================
  
  /**
   * Add a new payment method
   * 
   * @param cardNumber Credit card number
   * @param expiryMonth Expiry month (1-12)
   * @param expiryYear Expiry year (4 digits)
   * @param cvc Card verification code
   * @param cardholderName Name on the card
   * @param userId ID of the user adding the payment method
   * @return Created PaymentMethod object
   */
  Future<PaymentMethod> addPaymentMethod({
    required String cardNumber,
    required int expiryMonth,
    required int expiryYear,
    required String cvc,
    required String cardholderName,
    required String userId,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/payment-methods'),
        headers: _getHeaders(),
        body: jsonEncode({
          'cardNumber': cardNumber,
          'expiryMonth': expiryMonth,
          'expiryYear': expiryYear,
          'cvc': cvc,
          'cardholderName': cardholderName,
          'userId': userId,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final paymentMethod = PaymentMethod.fromJson(data);
        
        _paymentMethods.add(paymentMethod);
        _paymentController.add(PaymentEvent(
          type: PaymentEventType.paymentMethodAdded,
          paymentMethod: paymentMethod,
        ));
        
        print('Payment method added successfully: ${paymentMethod.id}');
        return paymentMethod;
      } else {
        throw PaymentException('Failed to add payment method: ${response.body}');
      }
    } catch (e) {
      print('Error adding payment method: $e');
      _paymentController.add(PaymentEvent(
        type: PaymentEventType.error,
        error: e.toString(),
      ));
      rethrow;
    }
  }
  
  /**
   * Remove a payment method
   * 
   * @param paymentMethodId ID of the payment method to remove
   * @return True if successfully removed
   */
  Future<bool> removePaymentMethod(String paymentMethodId) async {
    try {
      final response = await _httpClient.delete(
        Uri.parse('$_baseUrl/payment-methods/$paymentMethodId'),
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        _paymentMethods.removeWhere((pm) => pm.id == paymentMethodId);
        _paymentController.add(PaymentEvent(
          type: PaymentEventType.paymentMethodRemoved,
          paymentMethodId: paymentMethodId,
        ));
        
        print('Payment method removed successfully: $paymentMethodId');
        return true;
      } else {
        throw PaymentException('Failed to remove payment method: ${response.body}');
      }
    } catch (e) {
      print('Error removing payment method: $e');
      _paymentController.add(PaymentEvent(
        type: PaymentEventType.error,
        error: e.toString(),
      ));
      rethrow;
    }
  }
  
  /**
   * Set default payment method
   * 
   * @param paymentMethodId ID of the payment method to set as default
   * @return Updated PaymentMethod object
   */
  Future<PaymentMethod> setDefaultPaymentMethod(String paymentMethodId) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/payment-methods/$paymentMethodId/default'),
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedPaymentMethod = PaymentMethod.fromJson(data);
        
        // Update local payment method
        final index = _paymentMethods.indexWhere((pm) => pm.id == paymentMethodId);
        if (index != -1) {
          _paymentMethods[index] = updatedPaymentMethod;
        }
        
        _paymentController.add(PaymentEvent(
          type: PaymentEventType.paymentMethodUpdated,
          paymentMethod: updatedPaymentMethod,
        ));
        
        print('Default payment method set: $paymentMethodId');
        return updatedPaymentMethod;
      } else {
        throw PaymentException('Failed to set default payment method: ${response.body}');
      }
    } catch (e) {
      print('Error setting default payment method: $e');
      _paymentController.add(PaymentEvent(
        type: PaymentEventType.error,
        error: e.toString(),
      ));
      rethrow;
    }
  }

  // ==================== SUBSCRIPTION PLANS ====================
  
  /**
   * Get available subscription plans
   * 
   * @return List of SubscriptionPlan objects
   */
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/plans'),
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final plans = (data['plans'] as List)
            .map((plan) => SubscriptionPlan.fromJson(plan))
            .toList();
        
        print('Retrieved ${plans.length} subscription plans');
        return plans;
      } else {
        throw PaymentException('Failed to get subscription plans: ${response.body}');
      }
    } catch (e) {
      print('Error getting subscription plans: $e');
      rethrow;
    }
  }
  
  /**
   * Get premium features available to user
   * 
   * @param userId ID of the user
   * @return List of PremiumFeature objects
   */
  Future<List<PremiumFeature>> getPremiumFeatures(String userId) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/users/$userId/premium-features'),
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final features = (data['features'] as List)
            .map((feature) => PremiumFeature.fromJson(feature))
            .toList();
        
        print('Retrieved ${features.length} premium features for user $userId');
        return features;
      } else {
        throw PaymentException('Failed to get premium features: ${response.body}');
      }
    } catch (e) {
      print('Error getting premium features: $e');
      rethrow;
    }
  }

  // ==================== PAYMENT HISTORY ====================
  
  /**
   * Get payment history for user
   * 
   * @param userId ID of the user
   * @param limit Maximum number of payments to return
   * @param offset Offset for pagination
   * @return List of Payment objects
   */
  Future<List<Payment>> getPaymentHistory({
    required String userId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/users/$userId/payments?limit=$limit&offset=$offset'),
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final payments = (data['payments'] as List)
            .map((payment) => Payment.fromJson(payment))
            .toList();
        
        _paymentHistory = payments;
        print('Retrieved ${payments.length} payments for user $userId');
        return payments;
      } else {
        throw PaymentException('Failed to get payment history: ${response.body}');
      }
    } catch (e) {
      print('Error getting payment history: $e');
      rethrow;
    }
  }
  
  /**
   * Get payment receipt
   * 
   * @param paymentId ID of the payment
   * @return PaymentReceipt object
   */
  Future<PaymentReceipt> getPaymentReceipt(String paymentId) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/payments/$paymentId/receipt'),
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final receipt = PaymentReceipt.fromJson(data);
        
        print('Retrieved receipt for payment $paymentId');
        return receipt;
      } else {
        throw PaymentException('Failed to get payment receipt: ${response.body}');
      }
    } catch (e) {
      print('Error getting payment receipt: $e');
      rethrow;
    }
  }

  // ==================== UTILITY METHODS ====================
  
  /**
   * Get HTTP headers for API requests
   * 
   * @return Map of HTTP headers
   */
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_stripeSecretKey',
      'User-Agent': 'Aibodes-Mobile/1.0.0',
    };
  }
  
  /**
   * Format amount for display
   * 
   * @param amount Amount in cents
   * @param currency Currency code
   * @return Formatted amount string
   */
  String formatAmount(int amount, String currency) {
    final dollars = amount / 100;
    return '\$${dollars.toStringAsFixed(2)}';
  }
  
  /**
   * Validate credit card number
   * 
   * @param cardNumber Credit card number
   * @return True if valid
   */
  bool validateCardNumber(String cardNumber) {
    // Remove spaces and non-digits
    final cleaned = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // Check length (13-19 digits)
    if (cleaned.length < 13 || cleaned.length > 19) {
      return false;
    }
    
    // Luhn algorithm validation
    int sum = 0;
    bool alternate = false;
    
    for (int i = cleaned.length - 1; i >= 0; i--) {
      int digit = int.parse(cleaned[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    return sum % 10 == 0;
  }
  
  /**
   * Get card type from card number
   * 
   * @param cardNumber Credit card number
   * @return CardType enum value
   */
  CardType getCardType(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleaned.startsWith('4')) {
      return CardType.visa;
    } else if (cleaned.startsWith('5') || cleaned.startsWith('2')) {
      return CardType.mastercard;
    } else if (cleaned.startsWith('3')) {
      return CardType.amex;
    } else if (cleaned.startsWith('6')) {
      return CardType.discover;
    } else {
      return CardType.unknown;
    }
  }
  
  /**
   * Check if user has active premium subscription
   * 
   * @param userId ID of the user
   * @return True if user has active premium subscription
   */
  bool hasActivePremiumSubscription(String userId) {
    return _subscriptions.any((subscription) =>
        subscription.userId == userId &&
        subscription.status == SubscriptionStatus.active &&
        subscription.plan.isPremium);
  }
  
  /**
   * Dispose of resources
   */
  void dispose() {
    _httpClient.close();
    _paymentController.close();
  }
}

// ==================== DATA MODELS ====================

/**
 * Payment event class
 * 
 * Represents a payment-related event that can be streamed to listeners.
 */
class PaymentEvent {
  /// Type of payment event
  final PaymentEventType type;
  
  /// Associated payment (if applicable)
  final Payment? payment;
  
  /// Associated subscription (if applicable)
  final Subscription? subscription;
  
  /// Associated payment method (if applicable)
  final PaymentMethod? paymentMethod;
  
  /// Payment method ID (for removal events)
  final String? paymentMethodId;
  
  /// Error message (if applicable)
  final String? error;
  
  /// Timestamp when the event occurred
  final DateTime timestamp;

  /**
   * Constructor for PaymentEvent
   * 
   * @param type Type of payment event
   * @param payment Associated payment (optional)
   * @param subscription Associated subscription (optional)
   * @param paymentMethod Associated payment method (optional)
   * @param paymentMethodId Payment method ID (optional)
   * @param error Error message (optional)
   */
  PaymentEvent({
    required this.type,
    this.payment,
    this.subscription,
    this.paymentMethod,
    this.paymentMethodId,
    this.error,
  }) : timestamp = DateTime.now();
}

/**
 * Payment event type enumeration
 */
enum PaymentEventType {
  /// Payment was processed successfully
  paymentProcessed,
  
  /// Subscription was created
  subscriptionCreated,
  
  /// Subscription was cancelled
  subscriptionCancelled,
  
  /// Subscription was updated
  subscriptionUpdated,
  
  /// Payment method was added
  paymentMethodAdded,
  
  /// Payment method was removed
  paymentMethodRemoved,
  
  /// Payment method was updated
  paymentMethodUpdated,
  
  /// Payment error occurred
  error,
}

/**
 * Payment class
 * 
 * Represents a payment transaction.
 */
class Payment {
  /// Unique payment ID
  final String id;
  
  /// Payment amount in cents
  final int amount;
  
  /// Payment currency
  final String currency;
  
  /// Payment description
  final String description;
  
  /// Payment status
  final PaymentStatus status;
  
  /// ID of the user who made the payment
  final String userId;
  
  /// ID of the payment method used
  final String paymentMethodId;
  
  /// Timestamp when payment was created
  final DateTime createdAt;
  
  /// Timestamp when payment was updated
  final DateTime updatedAt;

  /**
   * Constructor for Payment
   * 
   * @param id Unique payment ID
   * @param amount Payment amount in cents
   * @param currency Payment currency
   * @param description Payment description
   * @param status Payment status
   * @param userId ID of the user who made the payment
   * @param paymentMethodId ID of the payment method used
   * @param createdAt Timestamp when payment was created
   * @param updatedAt Timestamp when payment was updated
   */
  Payment({
    required this.id,
    required this.amount,
    required this.currency,
    required this.description,
    required this.status,
    required this.userId,
    required this.paymentMethodId,
    required this.createdAt,
    required this.updatedAt,
  });

  /**
   * Create Payment from JSON
   * 
   * @param json JSON data to parse
   * @return Payment object
   */
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      amount: json['amount'] as int,
      currency: json['currency'] as String,
      description: json['description'] as String,
      status: PaymentStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => PaymentStatus.pending,
      ),
      userId: json['userId'] as String,
      paymentMethodId: json['paymentMethodId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /**
   * Convert Payment to JSON
   * 
   * @return JSON representation of Payment
   */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'description': description,
      'status': status.name,
      'userId': userId,
      'paymentMethodId': paymentMethodId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/**
 * Payment status enumeration
 */
enum PaymentStatus {
  /// Payment is pending
  pending,
  
  /// Payment was successful
  succeeded,
  
  /// Payment failed
  failed,
  
  /// Payment was cancelled
  cancelled,
  
  /// Payment was refunded
  refunded,
}

/**
 * Subscription class
 * 
 * Represents a user subscription to a premium plan.
 */
class Subscription {
  /// Unique subscription ID
  final String id;
  
  /// ID of the subscription plan
  final String planId;
  
  /// Subscription plan details
  final SubscriptionPlan plan;
  
  /// Subscription status
  final SubscriptionStatus status;
  
  /// ID of the user who owns the subscription
  final String userId;
  
  /// ID of the payment method used for billing
  final String paymentMethodId;
  
  /// Timestamp when subscription was created
  final DateTime createdAt;
  
  /// Timestamp when subscription starts
  final DateTime startDate;
  
  /// Timestamp when subscription ends
  final DateTime? endDate;
  
  /// Timestamp of next billing date
  final DateTime? nextBillingDate;
  
  /// Timestamp when subscription was cancelled
  final DateTime? cancelledAt;

  /**
   * Constructor for Subscription
   * 
   * @param id Unique subscription ID
   * @param planId ID of the subscription plan
   * @param plan Subscription plan details
   * @param status Subscription status
   * @param userId ID of the user who owns the subscription
   * @param paymentMethodId ID of the payment method used for billing
   * @param createdAt Timestamp when subscription was created
   * @param startDate Timestamp when subscription starts
   * @param endDate Timestamp when subscription ends
   * @param nextBillingDate Timestamp of next billing date
   * @param cancelledAt Timestamp when subscription was cancelled
   */
  Subscription({
    required this.id,
    required this.planId,
    required this.plan,
    required this.status,
    required this.userId,
    required this.paymentMethodId,
    required this.createdAt,
    required this.startDate,
    this.endDate,
    this.nextBillingDate,
    this.cancelledAt,
  });

  /**
   * Create Subscription from JSON
   * 
   * @param json JSON data to parse
   * @return Subscription object
   */
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      planId: json['planId'] as String,
      plan: SubscriptionPlan.fromJson(json['plan'] as Map<String, dynamic>),
      status: SubscriptionStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => SubscriptionStatus.active,
      ),
      userId: json['userId'] as String,
      paymentMethodId: json['paymentMethodId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      nextBillingDate: json['nextBillingDate'] != null ? DateTime.parse(json['nextBillingDate'] as String) : null,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt'] as String) : null,
    );
  }

  /**
   * Convert Subscription to JSON
   * 
   * @return JSON representation of Subscription
   */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planId': planId,
      'plan': plan.toJson(),
      'status': status.name,
      'userId': userId,
      'paymentMethodId': paymentMethodId,
      'createdAt': createdAt.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'nextBillingDate': nextBillingDate?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
    };
  }
}

/**
 * Subscription status enumeration
 */
enum SubscriptionStatus {
  /// Subscription is active
  active,
  
  /// Subscription is cancelled
  cancelled,
  
  /// Subscription is past due
  pastDue,
  
  /// Subscription is paused
  paused,
  
  /// Subscription is trialing
  trialing,
}

/**
 * Subscription plan class
 * 
 * Represents a subscription plan with pricing and features.
 */
class SubscriptionPlan {
  /// Unique plan ID
  final String id;
  
  /// Plan name
  final String name;
  
  /// Plan description
  final String description;
  
  /// Plan price in cents
  final int price;
  
  /// Plan currency
  final String currency;
  
  /// Billing interval (monthly, yearly)
  final BillingInterval interval;
  
  /// Whether this is a premium plan
  final bool isPremium;
  
  /// List of features included in this plan
  final List<String> features;

  /**
   * Constructor for SubscriptionPlan
   * 
   * @param id Unique plan ID
   * @param name Plan name
   * @param description Plan description
   * @param price Plan price in cents
   * @param currency Plan currency
   * @param interval Billing interval
   * @param isPremium Whether this is a premium plan
   * @param features List of features included in this plan
   */
  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.interval,
    required this.isPremium,
    required this.features,
  });

  /**
   * Create SubscriptionPlan from JSON
   * 
   * @param json JSON data to parse
   * @return SubscriptionPlan object
   */
  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      currency: json['currency'] as String,
      interval: BillingInterval.values.firstWhere(
        (interval) => interval.name == json['interval'],
        orElse: () => BillingInterval.monthly,
      ),
      isPremium: json['isPremium'] as bool,
      features: List<String>.from(json['features'] as List),
    );
  }

  /**
   * Convert SubscriptionPlan to JSON
   * 
   * @return JSON representation of SubscriptionPlan
   */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'interval': interval.name,
      'isPremium': isPremium,
      'features': features,
    };
  }
}

/**
 * Billing interval enumeration
 */
enum BillingInterval {
  /// Monthly billing
  monthly,
  
  /// Yearly billing
  yearly,
}

/**
 * Payment method class
 * 
 * Represents a user's payment method (credit card, etc.).
 */
class PaymentMethod {
  /// Unique payment method ID
  final String id;
  
  /// Card type
  final CardType cardType;
  
  /// Last 4 digits of card number
  final String last4;
  
  /// Card expiry month
  final int expiryMonth;
  
  /// Card expiry year
  final int expiryYear;
  
  /// Cardholder name
  final String cardholderName;
  
  /// Whether this is the default payment method
  final bool isDefault;
  
  /// ID of the user who owns this payment method
  final String userId;
  
  /// Timestamp when payment method was created
  final DateTime createdAt;

  /**
   * Constructor for PaymentMethod
   * 
   * @param id Unique payment method ID
   * @param cardType Card type
   * @param last4 Last 4 digits of card number
   * @param expiryMonth Card expiry month
   * @param expiryYear Card expiry year
   * @param cardholderName Cardholder name
   * @param isDefault Whether this is the default payment method
   * @param userId ID of the user who owns this payment method
   * @param createdAt Timestamp when payment method was created
   */
  PaymentMethod({
    required this.id,
    required this.cardType,
    required this.last4,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cardholderName,
    required this.isDefault,
    required this.userId,
    required this.createdAt,
  });

  /**
   * Create PaymentMethod from JSON
   * 
   * @param json JSON data to parse
   * @return PaymentMethod object
   */
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      cardType: CardType.values.firstWhere(
        (type) => type.name == json['cardType'],
        orElse: () => CardType.unknown,
      ),
      last4: json['last4'] as String,
      expiryMonth: json['expiryMonth'] as int,
      expiryYear: json['expiryYear'] as int,
      cardholderName: json['cardholderName'] as String,
      isDefault: json['isDefault'] as bool,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /**
   * Convert PaymentMethod to JSON
   * 
   * @return JSON representation of PaymentMethod
   */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardType': cardType.name,
      'last4': last4,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'cardholderName': cardholderName,
      'isDefault': isDefault,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/**
 * Card type enumeration
 */
enum CardType {
  /// Visa card
  visa,
  
  /// Mastercard
  mastercard,
  
  /// American Express
  amex,
  
  /// Discover card
  discover,
  
  /// Unknown card type
  unknown,
}

/**
 * Premium feature class
 * 
 * Represents a premium feature available to users.
 */
class PremiumFeature {
  /// Feature ID
  final String id;
  
  /// Feature name
  final String name;
  
  /// Feature description
  final String description;
  
  /// Whether feature is available to user
  final bool isAvailable;
  
  /// Feature category
  final FeatureCategory category;

  /**
   * Constructor for PremiumFeature
   * 
   * @param id Feature ID
   * @param name Feature name
   * @param description Feature description
   * @param isAvailable Whether feature is available to user
   * @param category Feature category
   */
  PremiumFeature({
    required this.id,
    required this.name,
    required this.description,
    required this.isAvailable,
    required this.category,
  });

  /**
   * Create PremiumFeature from JSON
   * 
   * @param json JSON data to parse
   * @return PremiumFeature object
   */
  factory PremiumFeature.fromJson(Map<String, dynamic> json) {
    return PremiumFeature(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      isAvailable: json['isAvailable'] as bool,
      category: FeatureCategory.values.firstWhere(
        (category) => category.name == json['category'],
        orElse: () => FeatureCategory.general,
      ),
    );
  }

  /**
   * Convert PremiumFeature to JSON
   * 
   * @return JSON representation of PremiumFeature
   */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isAvailable': isAvailable,
      'category': category.name,
    };
  }
}

/**
 * Feature category enumeration
 */
enum FeatureCategory {
  /// General features
  general,
  
  /// Search features
  search,
  
  /// Analytics features
  analytics,
  
  /// Support features
  support,
  
  /// Listing features
  listing,
}

/**
 * Payment receipt class
 * 
 * Represents a payment receipt for a transaction.
 */
class PaymentReceipt {
  /// Receipt ID
  final String id;
  
  /// Associated payment ID
  final String paymentId;
  
  /// Receipt number
  final String receiptNumber;
  
  /// Receipt URL
  final String receiptUrl;
  
  /// Timestamp when receipt was generated
  final DateTime generatedAt;

  /**
   * Constructor for PaymentReceipt
   * 
   * @param id Receipt ID
   * @param paymentId Associated payment ID
   * @param receiptNumber Receipt number
   * @param receiptUrl Receipt URL
   * @param generatedAt Timestamp when receipt was generated
   */
  PaymentReceipt({
    required this.id,
    required this.paymentId,
    required this.receiptNumber,
    required this.receiptUrl,
    required this.generatedAt,
  });

  /**
   * Create PaymentReceipt from JSON
   * 
   * @param json JSON data to parse
   * @return PaymentReceipt object
   */
  factory PaymentReceipt.fromJson(Map<String, dynamic> json) {
    return PaymentReceipt(
      id: json['id'] as String,
      paymentId: json['paymentId'] as String,
      receiptNumber: json['receiptNumber'] as String,
      receiptUrl: json['receiptUrl'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );
  }

  /**
   * Convert PaymentReceipt to JSON
   * 
   * @return JSON representation of PaymentReceipt
   */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentId': paymentId,
      'receiptNumber': receiptNumber,
      'receiptUrl': receiptUrl,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }
}

/**
 * Payment exception class
 * 
 * Custom exception for payment-related errors.
 */
class PaymentException implements Exception {
  /// Error message
  final String message;
  
  /// Error code (optional)
  final String? code;

  /**
   * Constructor for PaymentException
   * 
   * @param message Error message
   * @param code Error code (optional)
   */
  PaymentException(this.message, [this.code]);

  @override
  String toString() {
    return 'PaymentException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}
