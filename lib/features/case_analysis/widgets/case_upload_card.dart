import 'package:flutter/material.dart';
import 'package:bmw_legal_assistant/core/theme/colors.dart';

class CaseUploadCard extends StatelessWidget {
  final bool isAnalyzing;
  final VoidCallback onUpload;

  const CaseUploadCard({
    super.key,
    required this.isAnalyzing,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: isAnalyzing
            ? _buildAnalyzingState(context)
            : _buildUploadState(context),
      ),
    );
  }

  Widget _buildUploadState(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Upload icon
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(48),
            ),
            child: Center(
              child: Icon(
                Icons.upload_file_rounded,
                size: 40,
                color: AppColors.bmwBlue,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Title and description
          Text(
            'Upload Case Documents',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Our advanced AI will analyze your case documents, extract critical insights, and provide comprehensive strategic recommendations.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
              height: 1.6,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 40),
          
          // Upload button
          ElevatedButton(
            onPressed: onUpload,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              backgroundColor: AppColors.bmwBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            child: const Text('Select Document'),
          ),
          const SizedBox(height: 24),
          
          // Supported formats
          Text(
            'Supported formats: PDF, DOCX, DOC, TXT',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[500],
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzingState(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated loading indicator
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(48),
            ),
            child: Center(
              child: SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.bmwBlue),
                  strokeWidth: 3.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Title and description
          Text(
            'Analyzing Document',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Our AI is meticulously extracting key information, identifying case complexities, calculating precise risk assessments, and discovering relevant legal precedents.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
              height: 1.6,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 40),
          
          // Loading indicator with percentage
          const _AnimatedLoadingIndicator(),
        ],
      ),
    );
  }
}

class _AnimatedLoadingIndicator extends StatefulWidget {
  const _AnimatedLoadingIndicator();

  @override
  _AnimatedLoadingIndicatorState createState() => _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<_AnimatedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (_animation.value * 100).toInt();
    
    return Column(
      children: [
        LinearProgressIndicator(
          value: _animation.value,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.bmwBlue),
          borderRadius: BorderRadius.circular(4),
          minHeight: 6,
        ),
        const SizedBox(height: 12),
        Text(
          '$percentage%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}