import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bmw_legal_assistant/core/models/case_model.dart';
import 'package:bmw_legal_assistant/core/models/document_model.dart';

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
    _apiKey = dotenv.env['AI_API_KEY'];
    _dio.options.baseUrl = dotenv.env['AI_API_BASE_URL'] ?? 'https://api.openai.com/v1';
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
  }

  // Analyze a case document and extract relevant information
  Future<CaseModel> analyzeCaseDocument(File document) async {
    try {
      // Convert document to base64
      final bytes = await document.readAsBytes();
      final base64File = base64Encode(bytes);
      
      final response = await _dio.post(
        '/analyze-case',
        data: {
          'document': base64File,
          'filename': document.path.split('/').last,
        },
      );
      
      if (response.statusCode == 200) {
        return CaseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to analyze case: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error analyzing case document: $e');
      }
      
      // For demo/development: Return mock data
      return _getMockCaseAnalysis();
    }
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
        mediaCoverageRisk: 45,
        financialExposureRisk: 80,
        winProbabilityScore: 72,
      ),
      recommendedStrategies: [
        'Reference 2023 recall documentation',
        'Highlight maintenance records',
        'Cite BMW vs. Müller (2024) precedent',
        'Emphasize warranty limitations for improper use'
      ],
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