import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bmw_legal_assistant/core/theme/colors.dart';
import 'package:bmw_legal_assistant/core/api/ai_service.dart';
import 'package:bmw_legal_assistant/core/models/case_model.dart';
import 'package:bmw_legal_assistant/core/models/document_model.dart';
import 'package:bmw_legal_assistant/features/case_analysis/screens/case_analysis_screen.dart';
import 'package:bmw_legal_assistant/features/document_review/widgets/WinProbabilityPath.dart';



// Document review providers
final documentProvider = StateProvider<DocumentModel?>((ref) => null);
final isGeneratingDocumentProvider = StateProvider<bool>((ref) => false);
final isAnalyzingDocumentProvider = StateProvider<bool>((ref) => false);
final documentContentProvider = StateProvider<String>((ref) => '');
final documentAnalysisProvider = StateProvider<DocumentAnalysis?>((ref) => null);

class DocumentReviewScreen extends ConsumerStatefulWidget {
  const DocumentReviewScreen({super.key});

  @override
  ConsumerState<DocumentReviewScreen> createState() => _DocumentReviewScreenState();
}

class _DocumentReviewScreenState extends ConsumerState<DocumentReviewScreen> {
  final TextEditingController _documentController = TextEditingController();
  DocumentType _selectedDocumentType = DocumentType.statementOfDefense; // Using an actual type from your enum
  
  @override
  void dispose() {
    _documentController.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    // Initialize controller with existing content if any
    _documentController.text = ref.read(documentContentProvider);
    _documentController.addListener(() {
      ref.read(documentContentProvider.notifier).state = _documentController.text;
    });
  }

  // Update the build method to include both FABs using a Column with FloatingActionButtons
@override
Widget build(BuildContext context) {
  final caseAnalysis = ref.watch(caseAnalysisProvider);
  final document = ref.watch(documentProvider);
  final isGenerating = ref.watch(isGeneratingDocumentProvider);
  final isAnalyzing = ref.watch(isAnalyzingDocumentProvider);
  final documentAnalysis = ref.watch(documentAnalysisProvider);
  
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
              mainAxisSize: MainAxisSize.min, // Fix overflow issue
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Document Review',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  document != null 
                      ? document.title 
                      : 'Create or analyze legal documents',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        
        // Main Content
        SliverToBoxAdapter(
          child: caseAnalysis == null
              ? _buildNoCaseState(context)
              : document == null
                  ? _buildDocumentOptions(context)
                  : _buildDocumentEditor(context),
        ),
      ],
    ),
    floatingActionButton: document != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Back to documents button
              FloatingActionButton.extended(
                onPressed: () {
                  // Reset document state to return to document options
                  ref.read(documentProvider.notifier).state = null;
                  ref.read(documentAnalysisProvider.notifier).state = null;
                  ref.read(documentContentProvider.notifier).state = '';
                  _documentController.text = '';
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Documents'),
                backgroundColor: Colors.white,
                foregroundColor: AppColors.bmwBlue,
                heroTag: 'back_button',
              ),
              const SizedBox(height: 16),
              // Review document button
              FloatingActionButton.extended(
                onPressed: () => _reviewDocument(context),
                icon: const Icon(Icons.rate_review_outlined),
                label: const Text('Review Document'),
                backgroundColor: AppColors.bmwBlue,
                foregroundColor: Colors.white,
                heroTag: 'review_button',
              ),
            ],
          )
        : null,
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );
}
  
  Widget _buildNoCaseState(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.description_outlined,
                size: 60,
                color: AppColors.bmwBlue.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 40),
            
            Text(
              'No Case Selected',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please analyze a case first before creating or reviewing documents.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),  
            ),
            const SizedBox(height: 40),
            
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to case analysis screen
                // You'll need to implement your navigation logic here
              },
              icon: const Icon(Icons.search),
              label: const Text('Go to Case Analysis'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bmwBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDocumentOptions(BuildContext context) {
    final caseAnalysis = ref.watch(caseAnalysisProvider);
    final isGenerating = ref.watch(isGeneratingDocumentProvider);
    
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Case info
            if (caseAnalysis != null) ...[
              Text(
                caseAnalysis.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Case ID: ${caseAnalysis.id}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
            ],
            
            // Document options
            Text(
              'Document Options',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Create a new legal document or upload an existing one.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            
            // Document type selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<DocumentType>(
                  value: _selectedDocumentType,
                  isExpanded: true,
                  items: DocumentType.values.map((DocumentType type) {
                    return DropdownMenuItem<DocumentType>(
                      value: type,
                      child: Text(type.displayName),
                    );
                  }).toList(),
                  onChanged: (DocumentType? value) {
                    if (value != null) {
                      setState(() {
                        _selectedDocumentType = value;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  context,
                  'Upload Document',
                  Icons.upload_file_rounded,
                  AppColors.bmwBlue,
                  Colors.white,
                  () => _pickDocument(context),
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  context,
                  'Generate Document',
                  isGenerating ? Icons.hourglass_bottom : Icons.smart_toy_outlined,
                  isGenerating ? Colors.grey : Colors.white,
                  isGenerating ? Colors.white : AppColors.bmwBlue,
                  isGenerating ? null : () => _generateDocument(context),
                  outlined: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDocumentEditor(BuildContext context) {
    final document = ref.watch(documentProvider);
    final documentAnalysis = ref.watch(documentAnalysisProvider);
    
    if (document == null) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document title and info
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last modified: ${document.lastModified.toString().split('.')[0]}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (documentAnalysis != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up, 
                        color: AppColors.bmwBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      
                      // Text(
                      //   'Win probability: ${documentAnalysis.strengthScore}%',
                      //   style: TextStyle(
                      //     color: AppColors.bmwBlue,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      if (documentAnalysis != null)
  WinProbabilityPath(
    strengthScore: documentAnalysis.strengthScore.toDouble(),
  ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Document editor
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Container(
              constraints: const BoxConstraints(minHeight: 500),
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _documentController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your document content here...',
                ),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
              ),
            ),
          ),
          
          // If we have document analysis feedback, show it
          if (documentAnalysis != null && documentAnalysis.feedback.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Document Feedback',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...documentAnalysis.feedback.map((feedback) => _buildFeedbackItem(context, feedback)),
          ],
          
          // Add some bottom padding
          const SizedBox(height: 100),
        ],
      ),
    );
  }
  
  Widget _buildFeedbackItem(BuildContext context, DocumentFeedback feedback) {
    // Using the color from the feedback type extension
    final Color bgColor = feedback.type.color.withOpacity(0.1);
    final Color textColor = feedback.type.color;
    final IconData icon = feedback.type.icon;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedback.content,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (feedback.suggestion != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Suggestion: ${feedback.suggestion}',
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color backgroundColor,
    Color textColor,
    VoidCallback? onPressed, {
    bool outlined = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: outlined
              ? BorderSide(color: AppColors.bmwBlue)
              : BorderSide.none,
        ),
      ),
    );
  }
  
  // Function to pick a document
  Future<void> _pickDocument(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc', 'txt'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        final caseAnalysis = ref.read(caseAnalysisProvider);
        
        if (caseAnalysis == null) return;
        
        // Set analyzing state
        ref.read(isAnalyzingDocumentProvider.notifier).state = true;
        
        try {
          // Call AI service to analyze document
          final aiService = AIService();
          final analysis = await aiService.analyzeDocument(file, caseAnalysis.id);
          
          // Create document model
          final document = DocumentModel(
            id: 'DOC-${DateTime.now().millisecondsSinceEpoch}',
            title: '${_selectedDocumentType.displayName} - ${result.files.first.name}',
            fileName: result.files.first.name,
            type: _selectedDocumentType,
            createdAt: DateTime.now(),
            lastModified: DateTime.now(),
            content: await file.readAsString(),
            analysis: analysis,
          );
          
          // Update state with document and analysis
          ref.read(documentProvider.notifier).state = document;
          ref.read(documentContentProvider.notifier).state = document.content!;
          ref.read(documentAnalysisProvider.notifier).state = analysis;
          
          // Update document controller
          _documentController.text = document.content!;
        } catch (e) {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error analyzing document: $e')),
          );
        } finally {
          // Reset analyzing state
          ref.read(isAnalyzingDocumentProvider.notifier).state = false;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }
  
  // Function to generate a document using AI
  Future<void> _generateDocument(BuildContext context) async {
    final caseAnalysis = ref.read(caseAnalysisProvider);
    
    if (caseAnalysis == null) return;
    
    // Set generating state
    ref.read(isGeneratingDocumentProvider.notifier).state = true;
    
    try {
      // Call AI service to generate document
      final aiService = AIService();
      final document = await aiService.generateDocumentDraft(
        caseAnalysis.id, 
        _selectedDocumentType,
      );
      
      // Update state with generated document
      ref.read(documentProvider.notifier).state = document;
      ref.read(documentContentProvider.notifier).state = document.content ?? '';
      ref.read(documentAnalysisProvider.notifier).state = document.analysis;
      
      // Update document controller
      _documentController.text = document.content ?? '';
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating document: $e')),
      );
    } finally {
      // Reset generating state
      ref.read(isGeneratingDocumentProvider.notifier).state = false;
    }
  }
  
  // Function to review the document
  Future<void> _reviewDocument(BuildContext context) async {
    final document = ref.read(documentProvider);
    final content = _documentController.text;
    
    if (document == null) return;
    
    // Check if content has changed
    if (content == document.content) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes detected in the document.')),
      );
      return;
    }
    
    // Set analyzing state
    ref.read(isAnalyzingDocumentProvider.notifier).state = true;
    
    try {
      // Call AI service to analyze updated document
      final aiService = AIService();
      final analysis = await aiService.updateDocumentAnalysis(
        document.id, 
        content,
      );
      
      // Create updated document model
      final updatedDocument = DocumentModel(
        id: document.id,
        title: document.title,
        fileName: document.fileName,
        type: document.type,
        createdAt: document.createdAt,
        lastModified: DateTime.now(),
        content: content,
        analysis: analysis,
      );
      
      // Update state with analyzed document
      ref.read(documentProvider.notifier).state = updatedDocument;
      ref.read(documentAnalysisProvider.notifier).state = analysis;
      
      // Show success message with improvement
      int improvement = analysis.strengthScore - (document.analysis?.strengthScore ?? 0);
      String message = improvement > 0 
          ? 'Document improved! Win probability increased by $improvement%.'
          : improvement < 0
              ? 'Win probability decreased by ${improvement.abs()}%.'
              : 'Document reviewed. Win probability unchanged.';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: improvement > 0 ? Colors.green : Colors.blue,
        ),
      );
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error reviewing document: $e')),
      );
    } finally {
      // Reset analyzing state
      ref.read(isAnalyzingDocumentProvider.notifier).state = false;
    }
  }
}