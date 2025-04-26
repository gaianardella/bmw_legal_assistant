import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bmw_legal_assistant/core/theme/colors.dart';

class DocumentReviewScreen extends ConsumerWidget {
  const DocumentReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    'Document Review',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Create or analyze legal documents',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Main Content
          SliverFillRemaining(
            child: _buildEmptyState(context),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.text_snippet_rounded,
                size: 60,
                color: AppColors.bmwBlue.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 40),
            
            // Title and description
            Text(
              'Document Review',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Create new legal documents or analyze existing ones with AI assistance.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
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
                  () {
                    // TODO: Implement document upload functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Document upload coming soon!')),
                    );
                  },
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  context,
                  'Create New',
                  Icons.add_rounded,
                  Colors.white,
                  AppColors.bmwBlue,
                  () {
                    // TODO: Implement document creation functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Document creation coming soon!')),
                    );
                  },
                  outlined: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed, {
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
}