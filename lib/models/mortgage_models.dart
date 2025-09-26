/**
 * Mortgage Models for Real Estate Financing
 * 
 * This module contains models for mortgage calculations, rates,
 * and financing information including:
 * - Mortgage rate data
 * - Payment calculations
 * - Loan terms and conditions
 * - Amortization schedules
 * 
 * @author Aibodes Team
 * @version 2.0.0
 */

import 'package:json_annotation/json_annotation.dart';

part 'mortgage_models.g.dart';

/**
 * Mortgage Rates Model
 * 
 * Contains current mortgage interest rates for different loan types
 * and terms from various lenders and market sources.
 */
@JsonSerializable()
class MortgageRates {
  /// Data timestamp
  final DateTime timestamp;
  
  /// 30-year fixed rate
  final double rate30YearFixed;
  
  /// 15-year fixed rate
  final double rate15YearFixed;
  
  /// 5/1 ARM rate
  final double rate5YearARM;
  
  /// 7/1 ARM rate
  final double rate7YearARM;
  
  /// 10/1 ARM rate
  final double rate10YearARM;
  
  /// FHA 30-year rate
  final double rateFHA30Year;
  
  /// VA 30-year rate
  final double rateVA30Year;
  
  /// Jumbo loan rate (30-year)
  final double rateJumbo30Year;
  
  /// Average points for 30-year fixed
  final double averagePoints30Year;
  
  /// Market trend (rising, falling, stable)
  final RateTrend trend;

  /**
   * Constructor for MortgageRates
   * 
   * @param timestamp Data timestamp
   * @param rate30YearFixed 30-year fixed mortgage rate
   * @param rate15YearFixed 15-year fixed mortgage rate
   * @param rate5YearARM 5/1 ARM rate
   * @param rate7YearARM 7/1 ARM rate
   * @param rate10YearARM 10/1 ARM rate
   * @param rateFHA30Year FHA 30-year rate
   * @param rateVA30Year VA 30-year rate
   * @param rateJumbo30Year Jumbo 30-year rate
   * @param averagePoints30Year Average points for 30-year fixed
   * @param trend Market trend
   */
  const MortgageRates({
    required this.timestamp,
    required this.rate30YearFixed,
    required this.rate15YearFixed,
    required this.rate5YearARM,
    required this.rate7YearARM,
    required this.rate10YearARM,
    required this.rateFHA30Year,
    required this.rateVA30Year,
    required this.rateJumbo30Year,
    required this.averagePoints30Year,
    required this.trend,
  });

  /**
   * Create MortgageRates from JSON
   * 
   * @param json JSON data
   * @return MortgageRates instance
   */
  factory MortgageRates.fromJson(Map<String, dynamic> json) => 
      _$MortgageRatesFromJson(json);

  /**
   * Convert MortgageRates to JSON
   * 
   * @return JSON representation
   */
  Map<String, dynamic> toJson() => _$MortgageRatesToJson(this);

  /**
   * Get formatted rate string
   * 
   * @param rate Interest rate
   * @return Formatted rate string (e.g., "6.25%")
   */
  String formatRate(double rate) {
    return '${rate.toStringAsFixed(2)}%';
  }

  /**
   * Get trend description
   * 
   * @return Human-readable trend description
   */
  String get trendDescription {
    switch (trend) {
      case RateTrend.rising:
        return 'Rates are rising';
      case RateTrend.falling:
        return 'Rates are falling';
      case RateTrend.stable:
        return 'Rates are stable';
    }
  }
}

/**
 * Rate Trend Enumeration
 * 
 * Represents the direction of mortgage rate movement.
 */
enum RateTrend {
  /// Rates are increasing
  rising,
  
  /// Rates are decreasing
  falling,
  
  /// Rates are stable
  stable,
}

/**
 * Mortgage Request Model
 * 
 * Contains the parameters needed for mortgage payment calculations.
 */
@JsonSerializable()
class MortgageRequest {
  /// Loan amount
  final double loanAmount;
  
  /// Interest rate (annual percentage)
  final double interestRate;
  
  /// Loan term in years
  final int termYears;
  
  /// Down payment amount
  final double downPayment;
  
  /// Property value
  final double propertyValue;
  
  /// Property tax amount (annual)
  final double propertyTax;
  
  /// Homeowner's insurance (annual)
  final double homeownersInsurance;
  
  /// Private mortgage insurance (PMI) rate
  final double pmiRate;
  
  /// HOA fees (monthly)
  final double hoaFees;

  /**
   * Constructor for MortgageRequest
   * 
   * @param loanAmount Loan amount
   * @param interestRate Interest rate
   * @param termYears Loan term in years
   * @param downPayment Down payment amount
   * @param propertyValue Property value
   * @param propertyTax Annual property tax
   * @param homeownersInsurance Annual homeowners insurance
   * @param pmiRate PMI rate
   * @param hoaFees Monthly HOA fees
   */
  const MortgageRequest({
    required this.loanAmount,
    required this.interestRate,
    required this.termYears,
    required this.downPayment,
    required this.propertyValue,
    required this.propertyTax,
    required this.homeownersInsurance,
    required this.pmiRate,
    required this.hoaFees,
  });

  /**
   * Create MortgageRequest from JSON
   * 
   * @param json JSON data
   * @return MortgageRequest instance
   */
  factory MortgageRequest.fromJson(Map<String, dynamic> json) => 
      _$MortgageRequestFromJson(json);

  /**
   * Convert MortgageRequest to JSON
   * 
   * @return JSON representation
   */
  Map<String, dynamic> toJson() => _$MortgageRequestToJson(this);

  /**
   * Get loan-to-value ratio
   * 
   * @return LTV ratio as percentage
   */
  double get loanToValueRatio => (loanAmount / propertyValue) * 100;

  /**
   * Get down payment percentage
   * 
   * @return Down payment as percentage
   */
  double get downPaymentPercentage => (downPayment / propertyValue) * 100;

  /**
   * Check if PMI is required (typically when LTV > 80%)
   * 
   * @return True if PMI is required
   */
  bool get isPmiRequired => loanToValueRatio > 80;
}

/**
 * Mortgage Calculation Model
 * 
 * Contains the results of mortgage payment calculations including
 * monthly payments, total costs, and amortization information.
 */
@JsonSerializable()
class MortgageCalculation {
  /// Monthly principal and interest payment
  final double monthlyPayment;
  
  /// Monthly property tax payment
  final double monthlyPropertyTax;
  
  /// Monthly homeowners insurance payment
  final double monthlyInsurance;
  
  /// Monthly PMI payment
  final double monthlyPMI;
  
  /// Monthly HOA fees
  final double monthlyHOA;
  
  /// Total monthly payment (PITI + PMI + HOA)
  final double totalMonthlyPayment;
  
  /// Total interest paid over loan term
  final double totalInterest;
  
  /// Total amount paid over loan term
  final double totalAmountPaid;
  
  /// Loan payoff date
  final DateTime payoffDate;
  
  /// Amortization schedule
  final List<AmortizationEntry> amortizationSchedule;

  /**
   * Constructor for MortgageCalculation
   * 
   * @param monthlyPayment Monthly P&I payment
   * @param monthlyPropertyTax Monthly property tax
   * @param monthlyInsurance Monthly insurance
   * @param monthlyPMI Monthly PMI
   * @param monthlyHOA Monthly HOA fees
   * @param totalMonthlyPayment Total monthly payment
   * @param totalInterest Total interest paid
   * @param totalAmountPaid Total amount paid
   * @param payoffDate Loan payoff date
   * @param amortizationSchedule Amortization schedule
   */
  const MortgageCalculation({
    required this.monthlyPayment,
    required this.monthlyPropertyTax,
    required this.monthlyInsurance,
    required this.monthlyPMI,
    required this.monthlyHOA,
    required this.totalMonthlyPayment,
    required this.totalInterest,
    required this.totalAmountPaid,
    required this.payoffDate,
    required this.amortizationSchedule,
  });

  /**
   * Create MortgageCalculation from JSON
   * 
   * @param json JSON data
   * @return MortgageCalculation instance
   */
  factory MortgageCalculation.fromJson(Map<String, dynamic> json) => 
      _$MortgageCalculationFromJson(json);

  /**
   * Convert MortgageCalculation to JSON
   * 
   * @return JSON representation
   */
  Map<String, dynamic> toJson() => _$MortgageCalculationToJson(this);

  /**
   * Get formatted monthly payment string
   * 
   * @return Formatted payment string
   */
  String get formattedMonthlyPayment {
    return '\$${totalMonthlyPayment.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  /**
   * Get formatted total interest string
   * 
   * @return Formatted interest string
   */
  String get formattedTotalInterest {
    return '\$${totalInterest.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  /**
   * Get formatted total amount paid string
   * 
   * @return Formatted total amount string
   */
  String get formattedTotalAmountPaid {
    return '\$${totalAmountPaid.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  /**
   * Get interest-to-principal ratio
   * 
   * @return Interest as percentage of total payment
   */
  double get interestToPrincipalRatio {
    return (totalInterest / totalAmountPaid) * 100;
  }
}

/**
 * Amortization Entry Model
 * 
 * Represents a single payment in the amortization schedule.
 */
@JsonSerializable()
class AmortizationEntry {
  /// Payment number
  final int paymentNumber;
  
  /// Payment date
  final DateTime paymentDate;
  
  /// Principal payment amount
  final double principalPayment;
  
  /// Interest payment amount
  final double interestPayment;
  
  /// Total payment amount
  final double totalPayment;
  
  /// Remaining loan balance
  final double remainingBalance;

  /**
   * Constructor for AmortizationEntry
   * 
   * @param paymentNumber Payment number
   * @param paymentDate Payment date
   * @param principalPayment Principal payment
   * @param interestPayment Interest payment
   * @param totalPayment Total payment
   * @param remainingBalance Remaining balance
   */
  const AmortizationEntry({
    required this.paymentNumber,
    required this.paymentDate,
    required this.principalPayment,
    required this.interestPayment,
    required this.totalPayment,
    required this.remainingBalance,
  });

  /**
   * Create AmortizationEntry from JSON
   * 
   * @param json JSON data
   * @return AmortizationEntry instance
   */
  factory AmortizationEntry.fromJson(Map<String, dynamic> json) => 
      _$AmortizationEntryFromJson(json);

  /**
   * Convert AmortizationEntry to JSON
   * 
   * @return JSON representation
   */
  Map<String, dynamic> toJson() => _$AmortizationEntryToJson(this);

  /**
   * Get principal-to-interest ratio for this payment
   * 
   * @return Principal as percentage of total payment
   */
  double get principalRatio {
    return (principalPayment / totalPayment) * 100;
  }
}

/**
 * Mortgage Calculator Utility Class
 * 
 * Provides static methods for mortgage calculations including
 * payment calculations, amortization schedules, and affordability analysis.
 */
class MortgageCalculator {
  /**
   * Calculate monthly mortgage payment using standard formula
   * 
   * @param principal Loan amount
   * @param annualRate Annual interest rate (as decimal)
   * @param years Loan term in years
   * @return Monthly payment amount
   */
  static double calculateMonthlyPayment(
    double principal,
    double annualRate,
    int years,
  ) {
    if (annualRate == 0) {
      // Handle zero interest rate
      return principal / (years * 12);
    }

    final monthlyRate = annualRate / 12;
    final numberOfPayments = years * 12;
    
    return principal * 
        (monthlyRate * _pow(1 + monthlyRate, numberOfPayments)) /
        (_pow(1 + monthlyRate, numberOfPayments) - 1);
  }

  /**
   * Generate amortization schedule
   * 
   * @param principal Loan amount
   * @param annualRate Annual interest rate
   * @param years Loan term in years
   * @param startDate Loan start date
   * @return List of amortization entries
   */
  static List<AmortizationEntry> generateAmortizationSchedule(
    double principal,
    double annualRate,
    int years,
    DateTime startDate,
  ) {
    final monthlyPayment = calculateMonthlyPayment(principal, annualRate, years);
    final monthlyRate = annualRate / 12;
    final numberOfPayments = years * 12;
    
    final schedule = <AmortizationEntry>[];
    double remainingBalance = principal;
    
    for (int i = 1; i <= numberOfPayments; i++) {
      final interestPayment = remainingBalance * monthlyRate;
      final principalPayment = monthlyPayment - interestPayment;
      remainingBalance -= principalPayment;
      
      // Handle final payment adjustment
      if (i == numberOfPayments) {
        final finalPayment = monthlyPayment + remainingBalance;
        schedule.add(AmortizationEntry(
          paymentNumber: i,
          paymentDate: DateTime(
            startDate.year,
            startDate.month + i - 1,
            startDate.day,
          ),
          principalPayment: principalPayment + remainingBalance,
          interestPayment: interestPayment,
          totalPayment: finalPayment,
          remainingBalance: 0,
        ));
      } else {
        schedule.add(AmortizationEntry(
          paymentNumber: i,
          paymentDate: DateTime(
            startDate.year,
            startDate.month + i - 1,
            startDate.day,
          ),
          principalPayment: principalPayment,
          interestPayment: interestPayment,
          totalPayment: monthlyPayment,
          remainingBalance: remainingBalance,
        ));
      }
    }
    
    return schedule;
  }

  /**
   * Calculate maximum affordable loan amount
   * 
   * @param monthlyIncome Monthly gross income
   * @param monthlyDebts Monthly debt payments
   * @param annualRate Annual interest rate
   * @param years Loan term in years
   * @param maxPaymentRatio Maximum payment-to-income ratio (default 28%)
   * @return Maximum affordable loan amount
   */
  static double calculateMaxAffordableLoan(
    double monthlyIncome,
    double monthlyDebts,
    double annualRate,
    int years, {
    double maxPaymentRatio = 0.28,
  }) {
    final maxMonthlyPayment = (monthlyIncome * maxPaymentRatio) - monthlyDebts;
    
    if (maxMonthlyPayment <= 0) return 0;
    
    if (annualRate == 0) {
      return maxMonthlyPayment * years * 12;
    }
    
    final monthlyRate = annualRate / 12;
    final numberOfPayments = years * 12;
    
    return maxMonthlyPayment * 
        (_pow(1 + monthlyRate, numberOfPayments) - 1) /
        (monthlyRate * _pow(1 + monthlyRate, numberOfPayments));
  }

  /**
   * Calculate debt-to-income ratio
   * 
   * @param monthlyDebts Total monthly debt payments
   * @param monthlyIncome Monthly gross income
   * @return Debt-to-income ratio as percentage
   */
  static double calculateDebtToIncomeRatio(
    double monthlyDebts,
    double monthlyIncome,
  ) {
    if (monthlyIncome == 0) return 0;
    return (monthlyDebts / monthlyIncome) * 100;
  }

  /**
   * Power function for calculations
   * 
   * @param base Base number
   * @param exponent Exponent
   * @return Result of base^exponent
   */
  static double _pow(double base, int exponent) {
    double result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}
