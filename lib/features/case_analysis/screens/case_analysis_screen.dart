import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bmw_legal_assistant/core/api/ai_service.dart';
import 'package:bmw_legal_assistant/core/models/case_model.dart';
import 'package:bmw_legal_assistant/features/case_analysis/widgets/case_summary_card.dart';
import 'package:bmw_legal_assistant/features/case_analysis/widgets/risk_assessment_card.dart';
import 'package:bmw_legal_assistant/features/case_analysis/widgets/similar_cases_card.dart';
import 'package:bmw_legal_assistant/features/case_analysis/widgets/case_upload_card.dart';
import 'package:file_picker/file_picker.dart';

// Provider for the case analysis
final caseAnalysisProvider = StateProvider<CaseModel?>((ref) => null);
final isAnalyzingProvider = StateProvider<bool>((ref) => false);

class CaseAnalysisScreen extends ConsumerWidget {
  const CaseAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caseAnalysis = ref.watch(caseAnalysisProvider);
    final isAnalyzing = ref.watch(isAnalyzingProvider);

    Future<void> pickAndAnalyzeDocument() async {
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'docx', 'doc', 'txt'],
        );

        if (result != null && result.files.isNotEmpty) {
          final file = File(result.files.first.path!);
          
          // Set analyzing state
          ref.read(isAnalyzingProvider.notifier).state = true;
          
          try {
            // Call AI service to analyze document
            final aiService = AIService();
            final analysis = await aiService.analyzeCaseDocument(file);
            
            // Update state with analysis results
            ref.read(caseAnalysisProvider.notifier).state = analysis;
          } catch (e) {
            // Handle error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error analyzing document: $e')),
            );
          } finally {
            // Reset analyzing state
            ref.read(isAnalyzingProvider.notifier).state = false;
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Case Analysis',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (caseAnalysis != null)
                    Text(
                      caseAnalysis.id,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Main Content
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // If no analysis yet or still analyzing, show upload card
                  if (caseAnalysis == null)
                    CaseUploadCard(
                      isAnalyzing: isAnalyzing,
                      onUpload: pickAndAnalyzeDocument,
                    ),
                    
                  // If analysis is available, show results
                  if (caseAnalysis != null) ...[
                    CaseSummaryCard(caseModel: caseAnalysis),
                    const SizedBox(height: 24),
                    RiskAssessmentCard(riskAssessment: caseAnalysis.riskAssessment),
                    const SizedBox(height: 24),
                    SimilarCasesCard(similarCases: caseAnalysis.similarCases),
                  ],
                  
                  // Add some bottom padding
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}