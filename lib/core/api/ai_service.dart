import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bmw_legal_assistant/core/models/case_model.dart';
import 'package:bmw_legal_assistant/core/models/document_model.dart';
import 'package:claude_dart_flutter/claude_dart_flutter.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  final Dio _dio = Dio();
  String? _apiKey;

  factory AIService() {
    return _instance;
  }

  AIService._internal() {
    _init();
  }

  void _init() {
    _apiKey = dotenv.env['ANTHROPIC_API_KEY'];
    _dio.options.baseUrl = 'https://api.anthropic.com/v1';
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'X-API-Key': _apiKey,
      'Anthropic-Version': '2023-06-01',
    };
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
  }

Future<CaseModel> analyzeCaseDocument(File document) async {
  try {
    final bytes = await document.readAsBytes();
    final base64File = base64Encode(bytes);
    
    final response = await _dio.post(
      '/messages',
      data: {
        'model': 'claude-3-5-sonnet-20241022',
        'max_tokens': 1024,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'document',
                'source': {
                  'type': 'base64',
                  'media_type': 'application/pdf',
                  'data': base64File
                }
              },
              {
                'type': 'text',
                'text': '''Analyze this legal document and provide a JSON with the following fields exactly as specified:
- id: a unique identifier
- title: case title
- description: brief case description
- type: one of these values: vehicle_malfunction, warranty, product_liability, intellectual_property, employment, consumer_rights, environmental_claims, data_privacy, financial_dispute, other
- filing_date: exact filing date of the document (in ISO 8601 format)
- risk_assessment: object with these fields: overall_risk_score, brand_reputation_risk, legal_complexity_risk, financial_exposure_risk, win_probability_score (all integers 0-100)
- litigation_recommendation: strategic advice on whether to:
  * "settle": recommend settling the case out of court
  * "litigate": recommend proceeding to trial
  * "further_investigation": recommend gathering more evidence before deciding
- recommended_strategies: array of string strategies
- similar_cases: array of objects, each with: id, title, description, type, filing_date, outcome, similarity_score

Provide reasoning for the litigation recommendation based on:
- Overall risk score
- Potential financial impact
- Brand reputation considerations
- Probability of winning
- Complexity of legal issues
 
Provide only valid JSON in your response with no additional text or explanations.'''
              }
            ]
          }
        ]
      },
    );
    
    if (kDebugMode) {
      print('Full Claude Response: ${response.data}');
    }
    
    if (response.statusCode == 200) {
      final responseText = response.data['content'][0]['text'];
      
      // Estrai solo la parte JSON dalla risposta
      final jsonPattern = RegExp(r'\{[\s\S]*?\}(?=\s*Note:|$)');
      final match = jsonPattern.firstMatch(responseText);
      
      if (match != null) {
        final jsonString = match.group(0);
        final Map<String, dynamic> claudeData = json.decode(jsonString!);
        
        if (kDebugMode) {
          print("Date fields in response: filing_date=${claudeData['filing_date']}, filing_date=${claudeData['filing_date']}");
        }
        
        // Converti la risposta in un formato compatibile con CaseModel.fromJson
        Map<String, dynamic> formattedData = {
          'id': claudeData['id'],
          'title': claudeData['title'],
          'description': claudeData['description'],
          'type': claudeData['type'],
          'filing_date': claudeData['filing_date'], // Questo è il campo che dobbiamo assicurarci sia corretto
          'risk_assessment': {},
          'recommended_strategies': claudeData['recommended_strategies'],
          'similar_cases': []
        };
        
        // Gestiamo la risk_assessment
        if (claudeData['risk_assessment'] != null) {
          Map<String, dynamic> riskData = claudeData['risk_assessment'];
          formattedData['risk_assessment'] = {
            'overall_risk_score': riskData['overall_risk_score'],
            'brand_reputation_risk': riskData['brand_reputation_risk'],
            'legal_complexity_risk': riskData['legal_complexity_risk'],
            'financial_exposure_risk': riskData['financial_exposure_risk'],
            'win_probability_score': riskData['win_probability_score']
          };
        }
        
        // Gestiamo i similar_cases
        if (claudeData['similar_cases'] != null && claudeData['similar_cases'] is List) {
          List<Map<String, dynamic>> formattedCases = [];
          for (var caseData in claudeData['similar_cases']) {
            Map<String, dynamic> formattedCase = {
              'id': caseData['id'],
              'title': caseData['title'],
              'description': caseData['description'],
              'type': caseData['type'],
              'filing_date': caseData['filing_date'],
              'outcome': caseData['outcome']?.toLowerCase() ?? 'unknown',
              'similarity_score': caseData['similarity_score'] is int 
                  ? (caseData['similarity_score'] / 100) 
                  : caseData['similarity_score'] / 100 // Converti a scala 0-1 se necessario
            };
            formattedCases.add(formattedCase);
          }
          formattedData['similar_cases'] = formattedCases;
        }
        
        // Crea direttamente l'oggetto CaseModel invece di usare fromJson
        return CaseModel(
          id: formattedData['id'],
          title: formattedData['title'],
          description: formattedData['description'],
          type: CaseTypeExtension.fromString(formattedData['type']),
          filingDate: DateTime.parse(formattedData['filing_date']),
          riskAssessment: RiskAssessment(
            overallRiskScore: formattedData['risk_assessment']['overall_risk_score'],
            brandReputationRisk: formattedData['risk_assessment']['brand_reputation_risk'],
            legalComplexityRisk: formattedData['risk_assessment']['legal_complexity_risk'],
            financialExposureRisk: formattedData['risk_assessment']['financial_exposure_risk'],
            winProbabilityScore: formattedData['risk_assessment']['win_probability_score'],
          ),
          litigationRecommendation: claudeData['litigation_recommendation'] ?? 'further_investigation',
          recommendedStrategies: List<String>.from(formattedData['recommended_strategies']),
          similarCases: (formattedData['similar_cases'] as List).map((caseData) => 
            SimilarCase(
              id: caseData['id'],
              title: caseData['title'],
              description: caseData['description'],
              type: CaseTypeExtension.fromString(caseData['type']),
              filingDate: DateTime.parse(caseData['filing_date']),
              outcome: CaseOutcomeExtension.fromString(caseData['outcome']),
              similarityScore: caseData['similarity_score'].toDouble(),
            )
          ).toList(),
        );
      } else {
        throw Exception('Failed to extract JSON from response');
      }
    } else {
      throw Exception('Failed to analyze case: ${response.statusCode}');
    }
  } catch (e) {
    if (e is DioException && e.response != null) {
      print('Error response details: ${e.response?.data}');
    }
    if (kDebugMode) {
      print('Error analyzing case document: $e');
    }
    
    return _getMockCaseAnalysis();
  }
}

// Funzione per trasformare la risposta di Claude nel formato atteso dal modello
Map<String, dynamic> _transformClaudeResponse(Map<String, dynamic> claudeData) {
  // Estrai e normalizza le informazioni sul rischio
  final riskData = claudeData['riskAssessment'] as Map<String, dynamic>? ?? {};
  
  // Estrai le informazioni sui casi simili e trasformale nel formato corretto
  final similarCasesRaw = claudeData['similarCases'] as List<dynamic>? ?? [];
  final List<Map<String, dynamic>> transformedSimilarCases = [];
  
  for (var caseItem in similarCasesRaw) {
    // Se è solo una stringa (titolo del caso)
    if (caseItem is String) {
      transformedSimilarCases.add({
        'id': 'auto-${DateTime.now().millisecondsSinceEpoch}-${similarCasesRaw.indexOf(caseItem)}',
        'title': caseItem,
        'description': 'Similar case referenced by Claude',
        'type': 'other',
        'filing_date': DateTime.now().subtract(const Duration(days: 365)).toIso8601String(),
        'outcome': 'unknown',
        'similarity_score': 0.7,
      });
    } 
    // Se è già un oggetto completo
    else if (caseItem is Map<String, dynamic>) {
      transformedSimilarCases.add({
        'id': caseItem['id'] ?? 'unknown',
        'title': caseItem['title'] ?? 'Unknown Case',
        'description': caseItem['description'] ?? '',
        'type': _normalizeCaseType(caseItem['type']),
        'filing_date': caseItem['filing_date'] ?? DateTime.now().toIso8601String(),
        'outcome': caseItem['outcome'] ?? 'unknown',
        'similarity_score': (caseItem['similarityScore'] ?? 0.7) as double,
      });
    }
  }
  
  // Crea il nuovo oggetto JSON nel formato atteso
  return {
    'id': claudeData['id'] ?? 'unknown',
    'title': claudeData['title'] ?? 'Unknown Case',
    'description': claudeData['description'] ?? '',
    'type': _normalizeCaseType(claudeData['type']),
    'filing_date': claudeData['filing_date'] ?? DateTime.now().toIso8601String(),
    'risk_assessment': {
      'overall_risk_score': _getIntValue(riskData, 'overall') ?? 
                          _getIntValue(riskData, 'overallRisk') ?? 50,
      'brand_reputation_risk': _getIntValue(riskData, 'reputationalRisk') ?? 
                             _getIntValue(riskData, 'brandReputationRisk') ?? 50,
      'legal_complexity_risk': _getIntValue(riskData, 'legalComplexityRisk') ?? 50,
      'financial_exposure_risk': _getIntValue(riskData, 'financialRisk') ?? 
                               _getIntValue(riskData, 'financialExposureRisk') ?? 50,
      'win_probability_score': _getIntValue(riskData, 'legalRisk') ?? 
                             _getIntValue(riskData, 'winProbabilityScore') ?? 50,
    },
    'recommended_strategies': (claudeData['recommendedStrategies'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ?? [],
    'similar_cases': transformedSimilarCases,
  };
}

// Helper per normalizzare il tipo del caso
String _normalizeCaseType(dynamic typeValue) {
  if (typeValue == null) return 'other';
  
  String typeStr = typeValue.toString().toLowerCase();
  
  // Mappa i possibili valori restituiti da Claude ai valori attesi
  switch (typeStr) {
    case 'consumer_protection':
    case 'consumerprotection':
      return 'consumer_rights';
    case 'vehicle_malfunction':
    case 'vehiclemalfunction':
      return 'vehicle_malfunction';
    // Aggiungi altri casi secondo necessità...
    default:
      if (typeStr.contains('warranty')) return 'warranty';
      if (typeStr.contains('intellectual')) return 'intellectual_property';
      if (typeStr.contains('consumer')) return 'consumer_rights';
      if (typeStr.contains('environment')) return 'environmental_claims';
      if (typeStr.contains('data')) return 'data_privacy';
      if (typeStr.contains('financial')) return 'financial_dispute';
      if (typeStr.contains('product')) return 'product_liability';
      if (typeStr.contains('employment')) return 'employment';
      
      return 'other';
  }
}

// Helper per estrarre valori int in modo sicuro
int? _getIntValue(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}
  
  // Generate a document draft based on case details
  Future<DocumentModel> generateDocumentDraft(String caseId, DocumentType documentType) async {
    try {
      final response = await _dio.post(
        '/generate-document',
        data: {
          'case_id': caseId,
          'document_type': documentType.toShortString(),
        },
      );
      
      if (response.statusCode == 200) {
        return DocumentModel.fromJson(response.data);
      } else {
        throw Exception('Failed to generate document: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error generating document draft: $e');
      }
      
      // For demo/development: Return mock data
      return _getMockDocument(documentType);
    }
  }
  
  // Analyze an existing document and provide feedback
  Future<DocumentAnalysis> analyzeDocument(File document, String caseId) async {
    try {
      final bytes = await document.readAsBytes();
      final base64File = base64Encode(bytes);
      
      final response = await _dio.post(
        '/analyze-document',
        data: {
          'document': base64File,
          'filename': document.path.split('/').last,
          'case_id': caseId,
        },
      );
      
      if (response.statusCode == 200) {
        return DocumentAnalysis.fromJson(response.data);
      } else {
        throw Exception('Failed to analyze document: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error analyzing document: $e');
      }
      
      // For demo/development: Return mock data
      return _getMockDocumentAnalysis();
    }
  }
  
  // Get suggestions for improving a document
  Future<List<DocumentFeedback>> getDocumentSuggestions(String documentId, String content) async {
    try {
      final response = await _dio.post(
        '/document-suggestions',
        data: {
          'document_id': documentId,
          'content': content,
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> feedbackList = response.data['feedback'];
        return feedbackList
            .map((item) => DocumentFeedback.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to get document suggestions: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting document suggestions: $e');
      }
      
      // For demo/development: Return mock data
      return _getMockDocumentFeedback();
    }
  }
  
  // Update document and recalculate score
  Future<DocumentAnalysis> updateDocumentAnalysis(String documentId, String updatedContent) async {
    try {
      final response = await _dio.post(
        '/update-document-analysis',
        data: {
          'document_id': documentId,
          'content': updatedContent,
        },
      );
      
      if (response.statusCode == 200) {
        return DocumentAnalysis.fromJson(response.data);
      } else {
        throw Exception('Failed to update document analysis: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating document analysis: $e');
      }
      
      // For demo/development: Return mock data with slightly improved scores
      return _getMockDocumentAnalysis(improved: true);
    }
  }
  
  // For demo and development purposes
  CaseModel _getMockCaseAnalysis() {
    return CaseModel(
      id: 'BMW-L-2025-1842',
      title: 'Schmidt vs. BMW AG',
      description: 'Customer claims vehicle experienced unexpected engine failure despite recent service.',
      type: CaseType.vehicleMalfunction,
      filingDate: DateTime.now().subtract(const Duration(days: 5)),
      riskAssessment: RiskAssessment(
        overallRiskScore: 65,
        brandReputationRisk: 70,
        legalComplexityRisk: 45,
        financialExposureRisk: 80,
        winProbabilityScore: 72,
      ),
      recommendedStrategies: [
        'Reference 2023 recall documentation',
        'Highlight maintenance records',
        'Cite BMW vs. Müller (2024) precedent',
        'Emphasize warranty limitations for improper use'
      ],
      litigationRecommendation: "Settle",

      similarCases: [
        SimilarCase(
          id: 'BMW-L-2023-0721',
          title: 'BMW vs. Schmidt (2023)',
          description: 'Engine failure claim related to maintenance issues.',
          type: CaseType.vehicleMalfunction,
          filingDate: DateTime.now().subtract(const Duration(days: 500)),
          closingDate: DateTime.now().subtract(const Duration(days: 250)),
          outcome: CaseOutcome.won,
          similarityScore: 0.85,
        ),
        SimilarCase(
          id: 'BMW-L-2024-0122',
          title: 'BMW vs. Mueller (2024)',
          description: 'Warranty dispute over engine performance.',
          type: CaseType.warranty,
          filingDate: DateTime.now().subtract(const Duration(days: 300)),
          closingDate: DateTime.now().subtract(const Duration(days: 120)),
          outcome: CaseOutcome.won,
          similarityScore: 0.72,
        ),
        SimilarCase(
          id: 'BMW-L-2022-1105',
          title: 'BMW vs. Wagner (2022)',
          description: 'Emission control system failure after software update.',
          type: CaseType.vehicleMalfunction,
          filingDate: DateTime.now().subtract(const Duration(days: 800)),
          closingDate: DateTime.now().subtract(const Duration(days: 650)),
          outcome: CaseOutcome.lost,
          similarityScore: 0.65,
        ),
      ],
    );
  }
  
  DocumentModel _getMockDocument(DocumentType type) {
    return DocumentModel(
      id: 'DOC-2025-${DateTime.now().millisecondsSinceEpoch}',
      title: '${type.displayName} - Draft',
      fileName: '${type.toShortString()}_draft.docx',
      type: type,
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      content: 'This is a mock document content that would be generated by the AI.',
      analysis: _getMockDocumentAnalysis(),
    );
  }
  
  DocumentAnalysis _getMockDocumentAnalysis({bool improved = false}) {
    // If improved is true, return slightly better scores to simulate document improvements
    final baseScore = improved ? 10 : 0;
    
    return DocumentAnalysis(
      alignmentScore: 65 + baseScore,
      completenessScore: 70 + baseScore,
      strengthScore: 60 + baseScore,
      feedback: _getMockDocumentFeedback(),
    );
  }
  
  List<DocumentFeedback> _getMockDocumentFeedback() {
    return [
      DocumentFeedback(
        type: FeedbackType.strength,
        content: 'Strong opening statement that clearly outlines BMW\'s position.',
        startOffset: 0,
        endOffset: 150,
      ),
      DocumentFeedback(
        type: FeedbackType.weakness,
        content: 'The argument regarding maintenance requirements lacks specific references to the manual.',
        suggestion: 'Add specific citations to the vehicle\'s maintenance manual, particularly pages 45-48 regarding engine maintenance requirements.',
        startOffset: 300,
        endOffset: 450,
      ),
      DocumentFeedback(
        type: FeedbackType.improvement,
        content: 'Consider strengthening your position by citing the precedent case BMW vs. Mueller (2024).',
        suggestion: 'Insert reference to BMW vs. Mueller (2024) where the court ruled in favor of BMW in a similar engine failure case.',
        startOffset: 600,
        endOffset: 750,
      ),
      DocumentFeedback(
        type: FeedbackType.missing,
        content: 'Document does not address the warranty expiration date which is a crucial element.',
        suggestion: 'Add a section detailing the exact date of warranty expiration and the specific provisions that apply.',
      ),
      DocumentFeedback(
        type: FeedbackType.legal,
        content: 'The document needs to reference the specific German statute regarding product liability.',
        suggestion: 'Include reference to Section 823 BGB (German Civil Code) to strengthen the legal foundation.',
      ),
    ];
  }
}