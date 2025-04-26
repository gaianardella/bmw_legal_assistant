import 'package:flutter/material.dart';

class DocumentModel {
  final String id;
  final String title;
  final String fileName;
  final DocumentType type;
  final DateTime createdAt;
  final DateTime lastModified;
  final String? content; // Might be null if we're just displaying metadata
  final DocumentAnalysis? analysis; // Might be null if the document hasn't been analyzed yet
  
  DocumentModel({
    required this.id,
    required this.title,
    required this.fileName,
    required this.type,
    required this.createdAt,
    required this.lastModified,
    this.content,
    this.analysis,
  });
  
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      fileName: json['file_name'] as String,
      type: DocumentTypeExtension.fromString(json['type'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      lastModified: DateTime.parse(json['last_modified'] as String),
      content: json['content'] as String?,
      analysis: json['analysis'] != null
          ? DocumentAnalysis.fromJson(json['analysis'] as Map<String, dynamic>)
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'file_name': fileName,
      'type': type.toShortString(),
      'created_at': createdAt.toIso8601String(),
      'last_modified': lastModified.toIso8601String(),
      'content': content,
      'analysis': analysis?.toJson(),
    };
  }
}

enum DocumentType {
  statementOfDefense, // Statement of defense
  internalMemo,
  evidence,
  settlement,
}

extension DocumentTypeExtension on DocumentType {
  String get displayName {
    switch (this) {
      case DocumentType.statementOfDefense:
        return 'Statement of Defense';
      case DocumentType.internalMemo:
        return 'Internal Memo';
      case DocumentType.evidence:
        return 'Evidence';
      case DocumentType.settlement:
        return 'Settlement';
      default:
        return toString().split('.').last;
    }
  }
  
  static DocumentType fromString(String value) {
    switch (value) {
      case 'statement_of_defence':
        return DocumentType.statementOfDefense;
      case 'internal_memo':
        return DocumentType.internalMemo;
      case 'evidence':
        return DocumentType.evidence;
      case 'settlement':
        return DocumentType.settlement;
      default:
        // Return a default value or throw an exception for unrecognized values
        return DocumentType.statementOfDefense; // Using statement of defense as default
    }
  }
  
  String toShortString() {
    switch (this) {
      case DocumentType.statementOfDefense:
        return 'statement_of_defence';
      case DocumentType.internalMemo:
        return 'internal_memo';
      case DocumentType.evidence:
        return 'evidence';
      case DocumentType.settlement:
        return 'settlement';
    }
  }
}

class DocumentAnalysis {
  final int alignmentScore; // 0-100, how well aligned with BMW's legal standards
  final int completenessScore; // 0-100, how complete the document is
  final int strengthScore; // 0-100, how strong the legal arguments are
  final List<DocumentFeedback> feedback; // Specific feedback items
  
  DocumentAnalysis({
    required this.alignmentScore,
    required this.completenessScore,
    required this.strengthScore,
    required this.feedback,
  });
  
  factory DocumentAnalysis.fromJson(Map<String, dynamic> json) {
    return DocumentAnalysis(
      alignmentScore: json['alignment_score'] as int,
      completenessScore: json['completeness_score'] as int,
      strengthScore: json['strength_score'] as int,
      feedback: (json['feedback'] as List<dynamic>)
          .map((e) => DocumentFeedback.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'alignment_score': alignmentScore,
      'completeness_score': completenessScore,
      'strength_score': strengthScore,
      'feedback': feedback.map((e) => e.toJson()).toList(),
    };
  }
  
  int get overallScore {
    return (alignmentScore + completenessScore + strengthScore) ~/ 3;
  }
  
  DocumentQuality get quality {
    if (overallScore >= 80) return DocumentQuality.excellent;
    if (overallScore >= 60) return DocumentQuality.good;
    if (overallScore >= 40) return DocumentQuality.fair;
    return DocumentQuality.poor;
  }
}

enum DocumentQuality {
  excellent,
  good,
  fair,
  poor,
}

extension DocumentQualityExtension on DocumentQuality {
  String get displayName {
    switch (this) {
      case DocumentQuality.excellent:
        return 'Excellent';
      case DocumentQuality.good:
        return 'Good';
      case DocumentQuality.fair:
        return 'Fair';
      case DocumentQuality.poor:
        return 'Needs Improvement';
    }
  }
  
  Color get color {
    switch (this) {
      case DocumentQuality.excellent:
        return Colors.green;
      case DocumentQuality.good:
        return Colors.lightGreen;
      case DocumentQuality.fair:
        return Colors.orange;
      case DocumentQuality.poor:
        return Colors.red;
    }
  }
}

class DocumentFeedback {
  final FeedbackType type;
  final String content;
  final String? suggestion;
  final int? startOffset; // Character offset in the document where this feedback applies
  final int? endOffset; // Character offset in the document where this feedback ends
  
  DocumentFeedback({
    required this.type,
    required this.content,
    this.suggestion,
    this.startOffset,
    this.endOffset,
  });
  
  factory DocumentFeedback.fromJson(Map<String, dynamic> json) {
    return DocumentFeedback(
      type: FeedbackTypeExtension.fromString(json['type'] as String),
      content: json['content'] as String,
      suggestion: json['suggestion'] as String?,
      startOffset: json['start_offset'] as int?,
      endOffset: json['end_offset'] as int?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'type': type.toShortString(),
      'content': content,
      'suggestion': suggestion,
      'start_offset': startOffset,
      'end_offset': endOffset,
    };
  }
}

enum FeedbackType {
  improvement,
  strength,
  weakness,
  missing,
  legal,
  formatting,
  grammar,
}

extension FeedbackTypeExtension on FeedbackType {
  String get displayName {
    switch (this) {
      case FeedbackType.improvement:
        return 'Suggested Improvement';
      case FeedbackType.strength:
        return 'Strength';
      case FeedbackType.weakness:
        return 'Weakness';
      case FeedbackType.missing:
        return 'Missing Content';
      case FeedbackType.legal:
        return 'Legal Consideration';
      case FeedbackType.formatting:
        return 'Formatting Issue';
      case FeedbackType.grammar:
        return 'Grammar/Style';
    }
  }
  
  static FeedbackType fromString(String value) {
    switch (value) {
      case 'improvement':
        return FeedbackType.improvement;
      case 'strength':
        return FeedbackType.strength;
      case 'weakness':
        return FeedbackType.weakness;
      case 'missing':
        return FeedbackType.missing;
      case 'legal':
        return FeedbackType.legal;
      case 'formatting':
        return FeedbackType.formatting;
      case 'grammar':
        return FeedbackType.grammar;
      default:
        return FeedbackType.improvement;
    }
  }
  
  String toShortString() {
    switch (this) {
      case FeedbackType.improvement:
        return 'improvement';
      case FeedbackType.strength:
        return 'strength';
      case FeedbackType.weakness:
        return 'weakness';
      case FeedbackType.missing:
        return 'missing';
      case FeedbackType.legal:
        return 'legal';
      case FeedbackType.formatting:
        return 'formatting';
      case FeedbackType.grammar:
        return 'grammar';
    }
  }
  
  IconData get icon {
    switch (this) {
      case FeedbackType.improvement:
        return Icons.lightbulb_outline;
      case FeedbackType.strength:
        return Icons.check_circle_outline;
      case FeedbackType.weakness:
        return Icons.error_outline;
      case FeedbackType.missing:
        return Icons.add_circle_outline;
      case FeedbackType.legal:
        return Icons.gavel;
      case FeedbackType.formatting:
        return Icons.format_paint;
      case FeedbackType.grammar:
        return Icons.spellcheck;
    }
  }
  
  Color get color {
    switch (this) {
      case FeedbackType.improvement:
        return Colors.blue;
      case FeedbackType.strength:
        return Colors.green;
      case FeedbackType.weakness:
        return Colors.red;
      case FeedbackType.missing:
        return Colors.orange;
      case FeedbackType.legal:
        return Colors.purple;
      case FeedbackType.formatting:
        return Colors.teal;
      case FeedbackType.grammar:
        return Colors.amber;
    }
  }
}