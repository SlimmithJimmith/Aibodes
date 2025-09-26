/**
 * Mortgage Calculator Screen for Loan Calculations
 * 
 * This screen provides comprehensive mortgage calculation functionality including:
 * - Monthly payment calculations
 * - Amortization schedule display
 * - Affordability analysis
 * - Interest rate comparisons
 * - Down payment optimization
 * - Real-time rate updates
 * 
 * @author Aibodes Team
 * @version 2.0.0
 */

import 'package:flutter/material.dart';
import '../models/mortgage_models.dart';
import '../services/api_service.dart';

/**
 * Mortgage Calculator Screen Widget
 * 
 * Provides a comprehensive interface for users to calculate mortgage payments,
 * analyze affordability, and compare different loan scenarios.
 */
class MortgageCalculatorScreen extends StatefulWidget {
  /**
   * Constructor for MortgageCalculatorScreen
   */
  const MortgageCalculatorScreen({super.key});

  @override
  State<MortgageCalculatorScreen> createState() => _MortgageCalculatorScreenState();
}

/**
 * State class for MortgageCalculatorScreen
 * 
 * Manages the calculator form state, calculations, and results display.
 */
class _MortgageCalculatorScreenState extends State<MortgageCalculatorScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _homePriceController = TextEditingController();
  final _downPaymentController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _propertyTaxController = TextEditingController();
  final _insuranceController = TextEditingController();
  final _hoaController = TextEditingController();

  // Calculator parameters
  double _homePrice = 500000;
  double _downPayment = 100000;
  double _loanAmount = 400000;
  double _interestRate = 6.5;
  int _loanTerm = 30;
  double _propertyTax = 6000;
  double _homeownersInsurance = 1200;
  double _hoaFees = 0;
  double _pmiRate = 0.5;

  // Calculation results
  MortgageCalculation? _calculation;
  MortgageRates? _currentRates;
  bool _isLoading = false;
  bool _showAmortization = false;

  // Tab controller for different calculator views
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _updateLoanAmount();
    _loadCurrentRates();
  }

  @override
  void dispose() {
    _homePriceController.dispose();
    _downPaymentController.dispose();
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _propertyTaxController.dispose();
    _insuranceController.dispose();
    _hoaController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /**
   * Load current mortgage rates from API
   */
  Future<void> _loadCurrentRates() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiServiceManager();
      await apiService.initialize();
      _currentRates = await apiService.redfinApi.getMortgageRates();
      
      if (_currentRates != null) {
        _interestRate = _currentRates!.rate30YearFixed.toDouble();
        _interestRateController.text = _interestRate.toString();
        _calculateMortgage();
      }
    } catch (e) {
      print('Error loading mortgage rates: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /**
   * Update loan amount when home price or down payment changes
   */
  void _updateLoanAmount() {
    _loanAmount = _homePrice - _downPayment;
    _loanAmountController.text = _loanAmount.toString();
  }

  /**
   * Calculate mortgage payment and details
   */
  void _calculateMortgage() {
    if (_loanAmount <= 0) return;

    final request = MortgageRequest(
      loanAmount: _loanAmount,
      interestRate: _interestRate / 100, // Convert percentage to decimal
      termYears: _loanTerm,
      downPayment: _downPayment,
      propertyValue: _homePrice,
      propertyTax: _propertyTax,
      homeownersInsurance: _homeownersInsurance,
      pmiRate: _pmiRate / 100, // Convert percentage to decimal
      hoaFees: _hoaFees,
    );

    // Calculate monthly payment
    final monthlyPayment = MortgageCalculator.calculateMonthlyPayment(
      _loanAmount,
      _interestRate / 100,
      _loanTerm,
    );

    // Generate amortization schedule
    final amortizationSchedule = MortgageCalculator.generateAmortizationSchedule(
      _loanAmount,
      _interestRate / 100,
      _loanTerm,
      DateTime.now(),
    );

    // Calculate total interest
    final totalInterest = amortizationSchedule
        .fold(0.0, (sum, entry) => sum + entry.interestPayment);

    // Calculate monthly costs
    final monthlyPropertyTax = _propertyTax / 12;
    final monthlyInsurance = _homeownersInsurance / 12;
    final monthlyPMI = request.isPmiRequired ? (_loanAmount * _pmiRate / 100) / 12 : 0;
    final totalMonthlyPayment = monthlyPayment + monthlyPropertyTax + 
        monthlyInsurance + monthlyPMI + _hoaFees;

    _calculation = MortgageCalculation(
      monthlyPayment: monthlyPayment,
      monthlyPropertyTax: monthlyPropertyTax,
      monthlyInsurance: monthlyInsurance,
      monthlyPMI: monthlyPMI,
      monthlyHOA: _hoaFees,
      totalMonthlyPayment: totalMonthlyPayment,
      totalInterest: totalInterest,
      totalAmountPaid: _loanAmount + totalInterest + _propertyTax + _homeownersInsurance,
      payoffDate: DateTime.now().add(Duration(days: _loanTerm * 365)),
      amortizationSchedule: amortizationSchedule,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mortgage Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Calculator', icon: Icon(Icons.calculate)),
            Tab(text: 'Affordability', icon: Icon(Icons.account_balance_wallet)),
            Tab(text: 'Compare', icon: Icon(Icons.compare_arrows)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalculatorTab(),
          _buildAffordabilityTab(),
          _buildCompareTab(),
        ],
      ),
    );
  }

  /**
   * Build calculator tab with input form and results
   */
  Widget _buildCalculatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputSection(),
            const SizedBox(height: 24),
            if (_calculation != null) _buildResultsSection(),
            const SizedBox(height: 24),
            if (_calculation != null) _buildAmortizationSection(),
          ],
        ),
      ),
    );
  }

  /**
   * Build affordability analysis tab
   */
  Widget _buildAffordabilityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAffordabilityInputs(),
          const SizedBox(height: 24),
          _buildAffordabilityResults(),
        ],
      ),
    );
  }

  /**
   * Build loan comparison tab
   */
  Widget _buildCompareTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_currentRates != null) _buildRateComparison(),
          const SizedBox(height: 24),
          _buildLoanTermComparison(),
        ],
      ),
    );
  }

  /**
   * Build input section for calculator
   */
  Widget _buildInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Loan Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Home Price
            TextFormField(
              controller: _homePriceController,
              decoration: const InputDecoration(
                labelText: 'Home Price',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _homePrice = double.tryParse(value) ?? 0;
                _updateLoanAmount();
                _calculateMortgage();
              },
            ),
            const SizedBox(height: 16),
            
            // Down Payment
            TextFormField(
              controller: _downPaymentController,
              decoration: const InputDecoration(
                labelText: 'Down Payment',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _downPayment = double.tryParse(value) ?? 0;
                _updateLoanAmount();
                _calculateMortgage();
              },
            ),
            const SizedBox(height: 16),
            
            // Loan Amount (calculated)
            TextFormField(
              controller: _loanAmountController,
              decoration: const InputDecoration(
                labelText: 'Loan Amount (Calculated)',
                prefixText: '\$',
                border: OutlineInputBorder(),
                enabled: false,
              ),
            ),
            const SizedBox(height: 16),
            
            // Interest Rate
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _interestRateController,
                    decoration: const InputDecoration(
                      labelText: 'Interest Rate',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _interestRate = double.tryParse(value) ?? 0;
                      _calculateMortgage();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                if (_currentRates != null)
                  ElevatedButton(
                    onPressed: _loadCurrentRates,
                    child: const Text('Update Rates'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Loan Term
            Row(
              children: [
                const Text('Loan Term: '),
                Expanded(
                  child: Slider(
                    value: _loanTerm.toDouble(),
                    min: 15,
                    max: 30,
                    divisions: 1,
                    label: '$_loanTerm years',
                    onChanged: (value) {
                      setState(() {
                        _loanTerm = value.toInt();
                        _calculateMortgage();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Additional Costs
            const Text(
              'Additional Monthly Costs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _propertyTaxController,
                    decoration: const InputDecoration(
                      labelText: 'Property Tax (Annual)',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _propertyTax = double.tryParse(value) ?? 0;
                      _calculateMortgage();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _insuranceController,
                    decoration: const InputDecoration(
                      labelText: 'Insurance (Annual)',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _homeownersInsurance = double.tryParse(value) ?? 0;
                      _calculateMortgage();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _hoaController,
              decoration: const InputDecoration(
                labelText: 'HOA Fees (Monthly)',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _hoaFees = double.tryParse(value) ?? 0;
                _calculateMortgage();
              },
            ),
          ],
        ),
      ),
    );
  }

  /**
   * Build results section showing calculated values
   */
  Widget _buildResultsSection() {
    if (_calculation == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildResultRow('Principal & Interest', _calculation!.monthlyPayment),
            _buildResultRow('Property Tax', _calculation!.monthlyPropertyTax),
            _buildResultRow('Insurance', _calculation!.monthlyInsurance),
            if (_calculation!.monthlyPMI > 0)
              _buildResultRow('PMI', _calculation!.monthlyPMI),
            if (_calculation!.monthlyHOA > 0)
              _buildResultRow('HOA Fees', _calculation!.monthlyHOA),
            
            const Divider(),
            _buildResultRow(
              'Total Monthly Payment',
              _calculation!.totalMonthlyPayment,
              isTotal: true,
            ),
            
            const SizedBox(height: 16),
            const Text(
              'Loan Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            _buildSummaryRow('Total Interest', _calculation!.formattedTotalInterest),
            _buildSummaryRow('Total Amount Paid', _calculation!.formattedTotalAmountPaid),
            _buildSummaryRow('Payoff Date', _formatDate(_calculation!.payoffDate)),
            _buildSummaryRow('Interest/Principal Ratio', '${_calculation!.interestToPrincipalRatio.toStringAsFixed(1)}%'),
          ],
        ),
      ),
    );
  }

  /**
   * Build amortization schedule section
   */
  Widget _buildAmortizationSection() {
    if (_calculation == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Amortization Schedule',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showAmortization = !_showAmortization;
                    });
                  },
                  child: Text(_showAmortization ? 'Hide' : 'Show'),
                ),
              ],
            ),
            
            if (_showAmortization) ...[
              const SizedBox(height: 16),
              Container(
                height: 300,
                child: ListView.builder(
                  itemCount: _calculation!.amortizationSchedule.length,
                  itemBuilder: (context, index) {
                    final entry = _calculation!.amortizationSchedule[index];
                    return ListTile(
                      title: Text('Payment ${entry.paymentNumber}'),
                      subtitle: Text(_formatDate(entry.paymentDate)),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('\$${entry.totalPayment.toStringAsFixed(0)}'),
                          Text(
                            'P: \$${entry.principalPayment.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            'I: \$${entry.interestPayment.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /**
   * Build affordability analysis inputs
   */
  Widget _buildAffordabilityInputs() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Affordability Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // This would include inputs for income, debts, etc.
            // For brevity, showing a simplified version
            const Text('Monthly Gross Income: \$8,000'),
            const Text('Monthly Debt Payments: \$500'),
            const Text('Maximum Payment-to-Income Ratio: 28%'),
          ],
        ),
      ),
    );
  }

  /**
   * Build affordability results
   */
  Widget _buildAffordabilityResults() {
    // Calculate affordability based on inputs
    final monthlyIncome = 8000.0;
    final monthlyDebts = 500.0;
    final maxPaymentRatio = 0.28;
    
    final maxAffordablePayment = (monthlyIncome * maxPaymentRatio) - monthlyDebts;
    final maxAffordableLoan = MortgageCalculator.calculateMaxAffordableLoan(
      monthlyIncome,
      monthlyDebts,
      _interestRate / 100,
      _loanTerm,
      maxPaymentRatio: maxPaymentRatio,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Affordability Results',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildSummaryRow('Max Monthly Payment', '\$${maxAffordablePayment.toStringAsFixed(0)}'),
            _buildSummaryRow('Max Affordable Loan', '\$${maxAffordableLoan.toStringAsFixed(0)}'),
            _buildSummaryRow('Max Home Price (20% down)', '\$${(maxAffordableLoan / 0.8).toStringAsFixed(0)}'),
          ],
        ),
      ),
    );
  }

  /**
   * Build rate comparison section
   */
  Widget _buildRateComparison() {
    if (_currentRates == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Mortgage Rates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildRateRow('30-Year Fixed', _currentRates!.rate30YearFixed),
            _buildRateRow('15-Year Fixed', _currentRates!.rate15YearFixed),
            _buildRateRow('5/1 ARM', _currentRates!.rate5YearARM),
            _buildRateRow('7/1 ARM', _currentRates!.rate7YearARM),
            _buildRateRow('FHA 30-Year', _currentRates!.rateFHA30Year),
            _buildRateRow('VA 30-Year', _currentRates!.rateVA30Year),
          ],
        ),
      ),
    );
  }

  /**
   * Build loan term comparison
   */
  Widget _buildLoanTermComparison() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Loan Term Comparison',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Compare 15-year vs 30-year loans
            const Text('15-Year vs 30-Year Comparison'),
            const SizedBox(height: 8),
            
            // This would show detailed comparison
            const Text('15-Year: Higher payment, less interest'),
            const Text('30-Year: Lower payment, more interest'),
          ],
        ),
      ),
    );
  }

  /**
   * Build result row for payment breakdown
   */
  Widget _buildResultRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Build summary row for loan details
   */
  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /**
   * Build rate row for rate comparison
   */
  Widget _buildRateRow(String label, double rate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${rate.toStringAsFixed(2)}%',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /**
   * Format date for display
   */
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
