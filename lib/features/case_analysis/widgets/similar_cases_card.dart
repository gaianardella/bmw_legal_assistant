import 'package:flutter/material.dart';
import 'package:bmw_legal_assistant/core/models/case_model.dart';
import 'package:bmw_legal_assistant/core/theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SimilarCasesCard extends StatelessWidget {
  final List<SimilarCase> similarCases;

  const SimilarCasesCard({
    super.key,
    required this.similarCases,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (rimane invariato)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Similar Cases',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Previous BMW cases with similar characteristics',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Similar cases list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: similarCases.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) => _buildSimilarCaseItem(
              context,
              similarCases[index],
              index == 0, // Highlight the most similar case
            ),
          ),
          
          // See all button (rimane invariato)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  // TODO: Navigate to full similar cases screen
                },
                icon: const Icon(Icons.search),
                label: const Text('Find more similar cases'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.bmwBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarCaseItem(
    BuildContext context,
    SimilarCase similarCase,
    bool isHighlighted,
  ) {
    final dateFormat = DateFormat('MMM yyyy');
    final backgroundColor = isHighlighted
        ? AppColors.lightBlue
        : Colors.transparent;
    
    return Container(
      color: backgroundColor,
      child: InkWell(
        onTap: () {
          // Apertura del PDF se disponibile
          _openCasePDF(context, similarCase);
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Case icon with outcome indicator
              _buildCaseOutcomeIcon(similarCase.outcome),
              const SizedBox(width: 16),
              
              // Case info (rimane invariato)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      similarCase.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      similarCase.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildInfoChip(
                          similarCase.type.displayName,
                          Icons.folder_outlined,
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          similarCase.isClosed
                              ? '${dateFormat.format(similarCase.filingDate)} - ${dateFormat.format(similarCase.closingDate!)}'
                              : 'Filed ${dateFormat.format(similarCase.filingDate)}',
                          Icons.calendar_today_outlined,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Similarity score and arrow (rimane invariato)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(similarCase.similarityScore * 100).toInt()}% match',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.bmwBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.bmwBlue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Nuova funzione per aprire il PDF
  void _openCasePDF(BuildContext context, SimilarCase similarCase) async {
    // Verifica se è presente un link PDF
    if (similarCase.pdfLink != null && similarCase.pdfLink!.isNotEmpty) {
      final Uri url = Uri.parse(similarCase.pdfLink!);
      try {
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          _showPDFErrorSnackBar(context, 'Could not launch PDF');
        }
      } catch (e) {
        _showPDFErrorSnackBar(context, 'Error opening PDF');
      }
    } else {
      // Mostra un messaggio se non c'è un link PDF
      _showPDFErrorSnackBar(context, 'No PDF available for this case');
    }
  }

  // Metodo helper per mostrare messaggi di errore
  void _showPDFErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Metodi esistenti (_buildCaseOutcomeIcon, _buildInfoChip) rimangono invariati
}
  Widget _buildSimilarCaseItem(
    BuildContext context,
    SimilarCase similarCase,
    bool isHighlighted,
  ) {
    final dateFormat = DateFormat('MMM yyyy');
    final backgroundColor = isHighlighted
        ? AppColors.lightBlue
        : Colors.transparent;
    
    return Container(
      color: backgroundColor,
      child: InkWell(
        onTap: () {
          // TODO: Show case details in a dialog or navigate to case details
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Case icon with outcome indicator
              _buildCaseOutcomeIcon(similarCase.outcome),
              const SizedBox(width: 16),
              
              // Case info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      similarCase.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      similarCase.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildInfoChip(
                          similarCase.type.displayName,
                          Icons.folder_outlined,
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          similarCase.isClosed
                              ? '${dateFormat.format(similarCase.filingDate)} - ${dateFormat.format(similarCase.closingDate!)}'
                              : 'Filed ${dateFormat.format(similarCase.filingDate)}',
                          Icons.calendar_today_outlined,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Similarity score and arrow
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(similarCase.similarityScore * 100).toInt()}% match',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.bmwBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.bmwBlue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaseOutcomeIcon(CaseOutcome outcome) {
    Color backgroundColor;
    Color iconColor;
    IconData icon;
    
    switch (outcome) {
      case CaseOutcome.won:
        backgroundColor = AppColors.successGreen.withOpacity(0.1);
        iconColor = AppColors.successGreen;
        icon = Icons.check_circle_outline_rounded;
        break;
      case CaseOutcome.lost:
        backgroundColor = AppColors.errorRed.withOpacity(0.1);
        iconColor = AppColors.errorRed;
        icon = Icons.cancel_outlined;
        break;
      case CaseOutcome.settled:
        backgroundColor = Colors.purple.withOpacity(0.1);
        iconColor = Colors.purple;
        icon = Icons.handshake_outlined;
        break;
      case CaseOutcome.dismissed:
        backgroundColor = Colors.orange.withOpacity(0.1);
        iconColor = Colors.orange;
        icon = Icons.gavel_rounded;
        break;
      case CaseOutcome.pending:
        backgroundColor = Colors.grey.withOpacity(0.1);
        iconColor = Colors.grey;
        icon = Icons.hourglass_empty_rounded;
        break;
      case CaseOutcome.unknown:
        backgroundColor = Colors.grey.withOpacity(0.1);
        iconColor = Colors.grey;
        icon = Icons.help_outline_rounded;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 24,
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
