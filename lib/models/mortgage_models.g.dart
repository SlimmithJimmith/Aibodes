// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mortgage_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MortgageRates _$MortgageRatesFromJson(Map<String, dynamic> json) =>
    MortgageRates(
      timestamp: DateTime.parse(json['timestamp'] as String),
      rate30YearFixed: (json['rate30YearFixed'] as num).toDouble(),
      rate15YearFixed: (json['rate15YearFixed'] as num).toDouble(),
      rate5YearARM: (json['rate5YearARM'] as num).toDouble(),
      rate7YearARM: (json['rate7YearARM'] as num).toDouble(),
      rate10YearARM: (json['rate10YearARM'] as num).toDouble(),
      rateFHA30Year: (json['rateFHA30Year'] as num).toDouble(),
      rateVA30Year: (json['rateVA30Year'] as num).toDouble(),
      rateJumbo30Year: (json['rateJumbo30Year'] as num).toDouble(),
      averagePoints30Year: (json['averagePoints30Year'] as num).toDouble(),
      trend: $enumDecode(_$RateTrendEnumMap, json['trend']),
    );

Map<String, dynamic> _$MortgageRatesToJson(MortgageRates instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'rate30YearFixed': instance.rate30YearFixed,
      'rate15YearFixed': instance.rate15YearFixed,
      'rate5YearARM': instance.rate5YearARM,
      'rate7YearARM': instance.rate7YearARM,
      'rate10YearARM': instance.rate10YearARM,
      'rateFHA30Year': instance.rateFHA30Year,
      'rateVA30Year': instance.rateVA30Year,
      'rateJumbo30Year': instance.rateJumbo30Year,
      'averagePoints30Year': instance.averagePoints30Year,
      'trend': _$RateTrendEnumMap[instance.trend]!,
    };

const _$RateTrendEnumMap = {
  RateTrend.rising: 'rising',
  RateTrend.falling: 'falling',
  RateTrend.stable: 'stable',
};

MortgageRequest _$MortgageRequestFromJson(Map<String, dynamic> json) =>
    MortgageRequest(
      loanAmount: (json['loanAmount'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
      termYears: (json['termYears'] as num).toInt(),
      downPayment: (json['downPayment'] as num).toDouble(),
      propertyValue: (json['propertyValue'] as num).toDouble(),
      propertyTax: (json['propertyTax'] as num).toDouble(),
      homeownersInsurance: (json['homeownersInsurance'] as num).toDouble(),
      pmiRate: (json['pmiRate'] as num).toDouble(),
      hoaFees: (json['hoaFees'] as num).toDouble(),
    );

Map<String, dynamic> _$MortgageRequestToJson(MortgageRequest instance) =>
    <String, dynamic>{
      'loanAmount': instance.loanAmount,
      'interestRate': instance.interestRate,
      'termYears': instance.termYears,
      'downPayment': instance.downPayment,
      'propertyValue': instance.propertyValue,
      'propertyTax': instance.propertyTax,
      'homeownersInsurance': instance.homeownersInsurance,
      'pmiRate': instance.pmiRate,
      'hoaFees': instance.hoaFees,
    };

MortgageCalculation _$MortgageCalculationFromJson(Map<String, dynamic> json) =>
    MortgageCalculation(
      monthlyPayment: (json['monthlyPayment'] as num).toDouble(),
      monthlyPropertyTax: (json['monthlyPropertyTax'] as num).toDouble(),
      monthlyInsurance: (json['monthlyInsurance'] as num).toDouble(),
      monthlyPMI: (json['monthlyPMI'] as num).toDouble(),
      monthlyHOA: (json['monthlyHOA'] as num).toDouble(),
      totalMonthlyPayment: (json['totalMonthlyPayment'] as num).toDouble(),
      totalInterest: (json['totalInterest'] as num).toDouble(),
      totalAmountPaid: (json['totalAmountPaid'] as num).toDouble(),
      payoffDate: DateTime.parse(json['payoffDate'] as String),
      amortizationSchedule: (json['amortizationSchedule'] as List<dynamic>)
          .map((e) => AmortizationEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MortgageCalculationToJson(
        MortgageCalculation instance) =>
    <String, dynamic>{
      'monthlyPayment': instance.monthlyPayment,
      'monthlyPropertyTax': instance.monthlyPropertyTax,
      'monthlyInsurance': instance.monthlyInsurance,
      'monthlyPMI': instance.monthlyPMI,
      'monthlyHOA': instance.monthlyHOA,
      'totalMonthlyPayment': instance.totalMonthlyPayment,
      'totalInterest': instance.totalInterest,
      'totalAmountPaid': instance.totalAmountPaid,
      'payoffDate': instance.payoffDate.toIso8601String(),
      'amortizationSchedule': instance.amortizationSchedule,
    };

AmortizationEntry _$AmortizationEntryFromJson(Map<String, dynamic> json) =>
    AmortizationEntry(
      paymentNumber: (json['paymentNumber'] as num).toInt(),
      paymentDate: DateTime.parse(json['paymentDate'] as String),
      principalPayment: (json['principalPayment'] as num).toDouble(),
      interestPayment: (json['interestPayment'] as num).toDouble(),
      totalPayment: (json['totalPayment'] as num).toDouble(),
      remainingBalance: (json['remainingBalance'] as num).toDouble(),
    );

Map<String, dynamic> _$AmortizationEntryToJson(AmortizationEntry instance) =>
    <String, dynamic>{
      'paymentNumber': instance.paymentNumber,
      'paymentDate': instance.paymentDate.toIso8601String(),
      'principalPayment': instance.principalPayment,
      'interestPayment': instance.interestPayment,
      'totalPayment': instance.totalPayment,
      'remainingBalance': instance.remainingBalance,
    };
