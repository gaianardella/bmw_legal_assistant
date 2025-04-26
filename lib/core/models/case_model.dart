
class CaseModel {
  final String id;
  final String title;
  final String description;
  final CaseType type;
  final DateTime filingDate;
  final RiskAssessment riskAssessment;
  final String litigationRecommendation;
  final List<String> recommendedStrategies;
  final List<SimilarCase> similarCases;

  
  CaseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.filingDate,
    required this.riskAssessment,
    required this.litigationRecommendation,
    required this.recommendedStrategies,
    required this.similarCases,
    
  });
  
  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: CaseTypeExtension.fromString(json['type'] as String),
      filingDate: DateTime.parse(json['filing_date'] as String),
      riskAssessment: RiskAssessment.fromJson(json['risk_assessment'] as Map<String, dynamic>),
      litigationRecommendation: json['litigation_recommendation'],
      recommendedStrategies: (json['recommended_strategies'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      similarCases: (json['similar_cases'] as List<dynamic>)
          .map((e) => SimilarCase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toShortString(),
      'filing_date': filingDate.toIso8601String(),
      'risk_assessment': riskAssessment.toJson(),
      'litigation_recommendation': litigationRecommendation,
      'recommended_strategies': recommendedStrategies,
      'similar_cases': similarCases.map((e) => e.toJson()).toList(),
    };
  }
}

enum CaseType {
  vehicleMalfunction,
  warranty,
  productLiability,
  intellectualProperty,
  employment,
  consumerRights,
  environmentalClaims,
  dataPrivacy,
  financialDispute,
  other,
}

extension CaseTypeExtension on CaseType {
  String get displayName {
    switch (this) {
      case CaseType.vehicleMalfunction:
        return 'Vehicle Malfunction';
      case CaseType.warranty:
        return 'Warranty Dispute';
      case CaseType.productLiability:
        return 'Product Liability';
      case CaseType.intellectualProperty:
        return 'Intellectual Property';
      case CaseType.employment:
        return 'Employment';
      case CaseType.consumerRights:
        return 'Consumer Rights';
      case CaseType.environmentalClaims:
        return 'Environmental Claims';
      case CaseType.dataPrivacy:
        return 'Data Privacy';
      case CaseType.financialDispute:
        return 'Financial Dispute';
      case CaseType.other:
        return 'Other';
    }
  }
  
  static CaseType fromString(String value) {
    switch (value) {
      case 'vehicle_malfunction':
        return CaseType.vehicleMalfunction;
      case 'warranty':
        return CaseType.warranty;
      case 'product_liability':
        return CaseType.productLiability;
      case 'intellectual_property':
        return CaseType.intellectualProperty;
      case 'employment':
        return CaseType.employment;
      case 'consumer_rights':
        return CaseType.consumerRights;
      case 'environmental_claims':
        return CaseType.environmentalClaims;
      case 'data_privacy':
        return CaseType.dataPrivacy;
      case 'financial_dispute':
        return CaseType.financialDispute;
      default:
        return CaseType.other;
    }
  }
  
  String toShortString() {
    switch (this) {
      case CaseType.vehicleMalfunction:
        return 'vehicle_malfunction';
      case CaseType.warranty:
        return 'warranty';
      case CaseType.productLiability:
        return 'product_liability';
      case CaseType.intellectualProperty:
        return 'intellectual_property';
      case CaseType.employment:
        return 'employment';
      case CaseType.consumerRights:
        return 'consumer_rights';
      case CaseType.environmentalClaims:
        return 'environmental_claims';
      case CaseType.dataPrivacy:
        return 'data_privacy';
      case CaseType.financialDispute:
        return 'financial_dispute';
      case CaseType.other:
        return 'other';
    }
  }
}

class RiskAssessment {
  final int overallRiskScore; // 0-100
  final int brandReputationRisk; // 0-100
  final int legalComplexityRisk; // 0-100
  final int financialExposureRisk; // 0-100
  final int winProbabilityScore; // 0-100
  
  RiskAssessment({
    required this.overallRiskScore,
    required this.brandReputationRisk,
    required this.legalComplexityRisk,
    required this.financialExposureRisk,
    required this.winProbabilityScore,
  });
  
  factory RiskAssessment.fromJson(Map<String, dynamic> json) {
    return RiskAssessment(
      overallRiskScore: json['overall_risk_score'] as int,
      brandReputationRisk: json['brand_reputation_risk'] as int,
      legalComplexityRisk: json['legal_complexity_risk'] as int,
      financialExposureRisk: json['financial_exposure_risk'] as int,
      winProbabilityScore: json['win_probability_score'] as int,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'overall_risk_score': overallRiskScore,
      'brand_reputation_risk': brandReputationRisk,
      'legal_complexity_risk': legalComplexityRisk,
      'financial_exposure_risk': financialExposureRisk,
      'win_probability_score': winProbabilityScore,
    };
  }
  
  RiskLevel get overallRiskLevel {
    if (overallRiskScore >= 70) return RiskLevel.high;
    if (overallRiskScore >= 40) return RiskLevel.medium;
    return RiskLevel.low;
  }
  
  RiskLevel get brandReputationRiskLevel {
    if (brandReputationRisk >= 70) return RiskLevel.high;
    if (brandReputationRisk >= 40) return RiskLevel.medium;
    return RiskLevel.low;
  }
  
  RiskLevel get LegalComplexityRiskLevel {
    if (legalComplexityRisk >= 70) return RiskLevel.high;
    if (legalComplexityRisk >= 40) return RiskLevel.medium;
    return RiskLevel.low;
  }
  
  RiskLevel get financialExposureRiskLevel {
    if (financialExposureRisk >= 70) return RiskLevel.high;
    if (financialExposureRisk >= 40) return RiskLevel.medium;
    return RiskLevel.low;
  }
  
  WinProbability get winProbabilityLevel {
    if (winProbabilityScore >= 70) return WinProbability.high;
    if (winProbabilityScore >= 40) return WinProbability.medium;
    return WinProbability.low;
  }
}

enum RiskLevel {
  low,
  medium,
  high,
}

extension RiskLevelExtension on RiskLevel {
  String get displayName {
    switch (this) {
      case RiskLevel.low:
        return 'Low Risk';
      case RiskLevel.medium:
        return 'Medium Risk';
      case RiskLevel.high:
        return 'High Risk';
    }
  }
}

enum WinProbability {
  low,
  medium,
  high,
}

extension WinProbabilityExtension on WinProbability {
  String get displayName {
    switch (this) {
      case WinProbability.low:
        return 'Low Probability';
      case WinProbability.medium:
        return 'Medium Probability';
      case WinProbability.high:
        return 'High Probability';
    }
  }
}

class SimilarCase {
  final String id;
  final String title;
  final String description;
  final CaseType type;
  final DateTime filingDate;
  final DateTime? closingDate;
  final CaseOutcome outcome;
  final double similarityScore; // 0-1, how similar to the current case
  final String? pdfLink; // Add this line
  
  SimilarCase({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.filingDate,
    this.closingDate,
    required this.outcome,
    required this.similarityScore,
    this.pdfLink,
  });
  
  factory SimilarCase.fromJson(Map<String, dynamic> json) {
    return SimilarCase(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: CaseTypeExtension.fromString(json['type'] as String),
      filingDate: DateTime.parse(json['filing_date'] as String),
      closingDate: json['closing_date'] != null
          ? DateTime.parse(json['closing_date'] as String)
          : null,
      outcome: CaseOutcomeExtension.fromString(json['outcome'] as String),
      similarityScore: json['similarity_score'] as double,
      pdfLink: json['pdf_link'] as String?, // Add this line
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString(),
      'filing_date': filingDate.toIso8601String(),
      'closing_date': closingDate?.toIso8601String(),
      'outcome': outcome.toShortString(),
      'similarity_score': similarityScore,
    };
  }
  
  bool get isClosed => closingDate != null;
}

enum CaseOutcome {
  won,
  lost,
  settled,
  dismissed,
  pending,
  unknown,
}

extension CaseOutcomeExtension on CaseOutcome {
  String get displayName {
    switch (this) {
      case CaseOutcome.won:
        return 'Won';
      case CaseOutcome.lost:
        return 'Lost';
      case CaseOutcome.settled:
        return 'Settled';
      case CaseOutcome.dismissed:
        return 'Dismissed';
      case CaseOutcome.pending:
        return 'Pending';
      case CaseOutcome.unknown:
        return 'Unknown';
    }
  }
  
  static CaseOutcome fromString(String value) {
    switch (value) {
      case 'won':
        return CaseOutcome.won;
      case 'lost':
        return CaseOutcome.lost;
      case 'settled':
        return CaseOutcome.settled;
      case 'dismissed':
        return CaseOutcome.dismissed;
      case 'pending':
        return CaseOutcome.pending;
      default:
        return CaseOutcome.unknown;
    }
  }
  
  String toShortString() {
    switch (this) {
      case CaseOutcome.won:
        return 'won';
      case CaseOutcome.lost:
        return 'lost';
      case CaseOutcome.settled:
        return 'settled';
      case CaseOutcome.dismissed:
        return 'dismissed';
      case CaseOutcome.pending:
        return 'pending';
      case CaseOutcome.unknown:
        return 'unknown';
    }
  }
}