/**
 * Premium Features Screen for Aibodes
 * 
 * This screen displays available premium features and subscription plans,
 * allowing users to upgrade their account and access advanced functionality.
 * 
 * Features include:
 * - Premium subscription plans (monthly/yearly)
 * - One-time payment options for specific features
 * - Feature comparison and benefits
 * - Payment method management
 * - Subscription management
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/payment_service.dart';

/**
 * Premium Features Screen widget
 * 
 * Displays premium features, subscription plans, and payment options
 * for users to upgrade their Aibodes experience.
 */
class PremiumFeaturesScreen extends StatefulWidget {
  /// Constructor for PremiumFeaturesScreen
  const PremiumFeaturesScreen({super.key});

  @override
  State<PremiumFeaturesScreen> createState() => _PremiumFeaturesScreenState();
}

/**
 * State class for PremiumFeaturesScreen
 * 
 * Manages the UI state and user interactions for premium features.
 */
class _PremiumFeaturesScreenState extends State<PremiumFeaturesScreen>
    with TickerProviderStateMixin {
  /// Payment service instance
  final PaymentService _paymentService = PaymentService();
  
  /// Tab controller for feature categories
  late TabController _tabController;
  
  /// List of available subscription plans
  List<SubscriptionPlan> _subscriptionPlans = [];
  
  /// List of available premium features
  List<PremiumFeature> _premiumFeatures = [];
  
  /// User's current payment methods
  List<PaymentMethod> _paymentMethods = [];
  
  /// User's current subscriptions
  List<Subscription> _subscriptions = [];
  
  /// Loading state for data fetching
  bool _isLoading = true;
  
  /// Selected subscription plan
  SubscriptionPlan? _selectedPlan;
  
  /// Selected billing interval
  BillingInterval _selectedInterval = BillingInterval.monthly;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /**
   * Load subscription plans and premium features
   */
  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Load subscription plans
      _subscriptionPlans = await _paymentService.getSubscriptionPlans();
      
      // Load premium features
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final user = appProvider.currentUser;
      if (user != null) {
        _premiumFeatures = await _paymentService.getPremiumFeatures(user.id);
      }
      
      // Load payment methods
      _paymentMethods = _paymentService.paymentMethods;
      
      // Load subscriptions
      _subscriptions = _paymentService.subscriptions;
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading premium features: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Premium Features',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Plans'),
            Tab(text: 'Features'),
            Tab(text: 'Account'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPlansTab(),
                _buildFeaturesTab(),
                _buildAccountTab(),
              ],
            ),
    );
  }

  /**
   * Build subscription plans tab
   * 
   * @return Widget displaying subscription plans
   */
  Widget _buildPlansTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Choose Your Plan',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Unlock premium features and get the most out of Aibodes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          
          // Billing interval selector
          _buildBillingIntervalSelector(),
          const SizedBox(height: 24),
          
          // Subscription plans
          ..._subscriptionPlans.map((plan) => _buildPlanCard(plan)),
          
          const SizedBox(height: 24),
          
          // One-time payment options
          _buildOneTimePayments(),
        ],
      ),
    );
  }

  /**
   * Build billing interval selector
   * 
   * @return Widget for selecting billing interval
   */
  Widget _buildBillingIntervalSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedInterval = BillingInterval.monthly;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedInterval == BillingInterval.monthly
                      ? Colors.blue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Monthly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedInterval == BillingInterval.monthly
                        ? Colors.white
                        : Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedInterval = BillingInterval.yearly;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedInterval == BillingInterval.yearly
                      ? Colors.blue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Yearly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedInterval == BillingInterval.yearly
                        ? Colors.white
                        : Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Build subscription plan card
   * 
   * @param plan Subscription plan to display
   * @return Widget displaying the plan card
   */
  Widget _buildPlanCard(SubscriptionPlan plan) {
    final isSelected = _selectedPlan?.id == plan.id;
    final isPopular = plan.name.toLowerCase().contains('premium');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
        color: isSelected ? Colors.blue[50] : Colors.white,
      ),
      child: Stack(
        children: [
          if (isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: const Text(
                  'POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan name and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plan.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _paymentService.formatAmount(plan.price, plan.currency),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  plan.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Features list
                ...plan.features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )),
                
                const SizedBox(height: 20),
                
                // Subscribe button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedPlan = plan;
                      });
                      _showPaymentMethodDialog(plan);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.blue[700] : Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isSelected ? 'Selected' : 'Subscribe',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Build one-time payment options
   * 
   * @return Widget displaying one-time payment options
   */
  Widget _buildOneTimePayments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'One-Time Payments',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Property listing fee
        _buildOneTimePaymentCard(
          title: 'Property Listing',
          description: 'List your property on Aibodes',
          price: 299.00,
          onTap: () => _showOneTimePaymentDialog('Property Listing', 29900),
        ),
        
        const SizedBox(height: 12),
        
        // Virtual tour creation
        _buildOneTimePaymentCard(
          title: 'Virtual Tour',
          description: 'Create a 360° virtual tour for your property',
          price: 199.00,
          onTap: () => _showOneTimePaymentDialog('Virtual Tour', 19900),
        ),
      ],
    );
  }

  /**
   * Build one-time payment card
   * 
   * @param title Payment title
   * @param description Payment description
   * @param price Payment price
   * @param onTap Callback when card is tapped
   * @return Widget displaying the payment card
   */
  Widget _buildOneTimePaymentCard({
    required String title,
    required String description,
    required double price,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  /**
   * Build premium features tab
   * 
   * @return Widget displaying premium features
   */
  Widget _buildFeaturesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Premium Features',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Unlock advanced features to enhance your property search experience',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          
          // Features by category
          ...FeatureCategory.values.map((category) => _buildFeatureCategory(category)),
        ],
      ),
    );
  }

  /**
   * Build feature category section
   * 
   * @param category Feature category to display
   * @return Widget displaying the feature category
   */
  Widget _buildFeatureCategory(FeatureCategory category) {
    final categoryFeatures = _premiumFeatures
        .where((feature) => feature.category == category)
        .toList();
    
    if (categoryFeatures.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getCategoryTitle(category),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...categoryFeatures.map((feature) => _buildFeatureItem(feature)),
        const SizedBox(height: 24),
      ],
    );
  }

  /**
   * Get category title
   * 
   * @param category Feature category
   * @return Category title string
   */
  String _getCategoryTitle(FeatureCategory category) {
    switch (category) {
      case FeatureCategory.general:
        return 'General Features';
      case FeatureCategory.search:
        return 'Search & Discovery';
      case FeatureCategory.analytics:
        return 'Analytics & Insights';
      case FeatureCategory.support:
        return 'Support & Priority';
      case FeatureCategory.listing:
        return 'Listing & Marketing';
    }
  }

  /**
   * Build feature item
   * 
   * @param feature Premium feature to display
   * @return Widget displaying the feature item
   */
  Widget _buildFeatureItem(PremiumFeature feature) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: feature.isAvailable ? Colors.green[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: feature.isAvailable ? Colors.green[200]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            feature.isAvailable ? Icons.check_circle : Icons.lock,
            color: feature.isAvailable ? Colors.green : Colors.grey,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: feature.isAvailable ? Colors.black : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: feature.isAvailable ? Colors.grey[700] : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Build account tab
   * 
   * @return Widget displaying account information
   */
  Widget _buildAccountTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account & Billing',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Current subscriptions
          if (_subscriptions.isNotEmpty) ...[
            const Text(
              'Current Subscriptions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._subscriptions.map((subscription) => _buildSubscriptionCard(subscription)),
            const SizedBox(height: 24),
          ],
          
          // Payment methods
          const Text(
            'Payment Methods',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ..._paymentMethods.map((paymentMethod) => _buildPaymentMethodCard(paymentMethod)),
          
          const SizedBox(height: 16),
          
          // Add payment method button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showAddPaymentMethodDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Payment Method'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Build subscription card
   * 
   * @param subscription Subscription to display
   * @return Widget displaying the subscription card
   */
  Widget _buildSubscriptionCard(Subscription subscription) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subscription.plan.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: subscription.status == SubscriptionStatus.active
                      ? Colors.green
                      : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  subscription.status.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Next billing: ${subscription.nextBillingDate?.toString().split(' ')[0] ?? 'N/A'}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _cancelSubscription(subscription),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _updateSubscriptionPaymentMethod(subscription),
                  child: const Text('Update Payment'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
   * Build payment method card
   * 
   * @param paymentMethod Payment method to display
   * @return Widget displaying the payment method card
   */
  Widget _buildPaymentMethodCard(PaymentMethod paymentMethod) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            _getCardTypeIcon(paymentMethod.cardType),
            size: 32,
            color: Colors.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _getCardTypeName(paymentMethod.cardType),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (paymentMethod.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'DEFAULT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '•••• •••• •••• ${paymentMethod.last4}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _removePaymentMethod(paymentMethod),
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  /**
   * Get card type icon
   * 
   * @param cardType Card type
   * @return IconData for the card type
   */
  IconData _getCardTypeIcon(CardType cardType) {
    switch (cardType) {
      case CardType.visa:
        return Icons.credit_card;
      case CardType.mastercard:
        return Icons.credit_card;
      case CardType.amex:
        return Icons.credit_card;
      case CardType.discover:
        return Icons.credit_card;
      case CardType.unknown:
        return Icons.credit_card;
    }
  }

  /**
   * Get card type name
   * 
   * @param cardType Card type
   * @return String name of the card type
   */
  String _getCardTypeName(CardType cardType) {
    switch (cardType) {
      case CardType.visa:
        return 'Visa';
      case CardType.mastercard:
        return 'Mastercard';
      case CardType.amex:
        return 'American Express';
      case CardType.discover:
        return 'Discover';
      case CardType.unknown:
        return 'Unknown Card';
    }
  }

  // ==================== DIALOGS AND ACTIONS ====================

  /**
   * Show payment method selection dialog
   * 
   * @param plan Subscription plan to subscribe to
   */
  void _showPaymentMethodDialog(SubscriptionPlan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Subscribe to ${plan.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Price: ${_paymentService.formatAmount(plan.price, plan.currency)}'),
            const SizedBox(height: 16),
            if (_paymentMethods.isEmpty)
              const Text('No payment methods found. Please add a payment method first.')
            else
              ..._paymentMethods.map((paymentMethod) => ListTile(
                leading: Icon(_getCardTypeIcon(paymentMethod.cardType)),
                title: Text('${_getCardTypeName(paymentMethod.cardType)} •••• ${paymentMethod.last4}'),
                subtitle: paymentMethod.isDefault ? const Text('Default') : null,
                onTap: () {
                  Navigator.pop(context);
                  _subscribeToPlan(plan, paymentMethod.id);
                },
              )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          if (_paymentMethods.isEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showAddPaymentMethodDialog();
              },
              child: const Text('Add Payment Method'),
            ),
        ],
      ),
    );
  }

  /**
   * Show one-time payment dialog
   * 
   * @param title Payment title
   * @param amount Payment amount in cents
   */
  void _showOneTimePaymentDialog(String title, int amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Price: ${_paymentService.formatAmount(amount, 'usd')}'),
            const SizedBox(height: 16),
            if (_paymentMethods.isEmpty)
              const Text('No payment methods found. Please add a payment method first.')
            else
              ..._paymentMethods.map((paymentMethod) => ListTile(
                leading: Icon(_getCardTypeIcon(paymentMethod.cardType)),
                title: Text('${_getCardTypeName(paymentMethod.cardType)} •••• ${paymentMethod.last4}'),
                subtitle: paymentMethod.isDefault ? const Text('Default') : null,
                onTap: () {
                  Navigator.pop(context);
                  _processOneTimePayment(title, amount, paymentMethod.id);
                },
              )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          if (_paymentMethods.isEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showAddPaymentMethodDialog();
              },
              child: const Text('Add Payment Method'),
            ),
        ],
      ),
    );
  }

  /**
   * Show add payment method dialog
   */
  void _showAddPaymentMethodDialog() {
    // In a real app, you would show a form to add payment method
    // For now, we'll show a placeholder dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment Method'),
        content: const Text('Payment method form would be shown here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /**
   * Subscribe to a plan
   * 
   * @param plan Subscription plan
   * @param paymentMethodId Payment method ID
   */
  Future<void> _subscribeToPlan(SubscriptionPlan plan, String paymentMethodId) async {
    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final user = appProvider.currentUser;
      
      if (user == null) {
        throw Exception('User not logged in');
      }
      
      final subscription = await _paymentService.createSubscription(
        planId: plan.id,
        paymentMethodId: paymentMethodId,
        userId: user.id,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully subscribed to ${plan.name}!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Refresh data
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error subscribing to plan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /**
   * Process one-time payment
   * 
   * @param title Payment title
   * @param amount Payment amount in cents
   * @param paymentMethodId Payment method ID
   */
  Future<void> _processOneTimePayment(String title, int amount, String paymentMethodId) async {
    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final user = appProvider.currentUser;
      
      if (user == null) {
        throw Exception('User not logged in');
      }
      
      final payment = await _paymentService.processPayment(
        amount: amount,
        paymentMethodId: paymentMethodId,
        description: title,
        userId: user.id,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment successful! Payment ID: ${payment.id}'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Refresh data
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing payment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /**
   * Cancel subscription
   * 
   * @param subscription Subscription to cancel
   */
  Future<void> _cancelSubscription(Subscription subscription) async {
    try {
      await _paymentService.cancelSubscription(subscription.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Subscription ${subscription.plan.name} cancelled'),
            backgroundColor: Colors.orange,
          ),
        );
        
        // Refresh data
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cancelling subscription: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /**
   * Update subscription payment method
   * 
   * @param subscription Subscription to update
   */
  void _updateSubscriptionPaymentMethod(Subscription subscription) {
    // In a real app, you would show a dialog to select new payment method
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment method update feature would be implemented here'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /**
   * Remove payment method
   * 
   * @param paymentMethod Payment method to remove
   */
  Future<void> _removePaymentMethod(PaymentMethod paymentMethod) async {
    try {
      await _paymentService.removePaymentMethod(paymentMethod.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment method removed'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Refresh data
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing payment method: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
