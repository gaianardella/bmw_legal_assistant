import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:bmw_legal_assistant/core/models/case_model.dart';
import 'package:bmw_legal_assistant/core/theme/colors.dart';
import 'package:intl/intl.dart';

class SimilarCasesCard extends StatefulWidget {
  final List<SimilarCase> similarCases;

  const SimilarCasesCard({
    super.key,
    required this.similarCases,
  });

  @override
  _SimilarCasesCardState createState() => _SimilarCasesCardState();
}

class _SimilarCasesCardState extends State<SimilarCasesCard> {
  // Helper method to determine if we're on a mobile device
  bool _isMobileDevice(BuildContext context) {
    // Check if screen width is less than 600 (tablet breakpoint)
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    // Check if we're on a mobile platform (iOS or Android)
    final isMobilePlatform = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
    
    // Return true if either condition is met
    return isSmallScreen || isMobilePlatform;
  }
  
  void _openCaseDrawer(SimilarCase similarCase) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SimilarCasesDetailView(
          similarCase: similarCase,
          scrollController: scrollController,
          isMobile: _isMobileDevice(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobileDevice(context);
    
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
          // Header - padding ridotto su mobile
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Similar Cases',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: isMobile ? 18 : null, // Ridotto font su mobile
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Previous BMW cases with similar characteristics',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontSize: isMobile ? 12 : null, // Ridotto font su mobile
                  ),
                ),
              ],
            ),
          ),

          // Similar cases list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.similarCases.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) => _buildSimilarCaseItem(
              context,
              widget.similarCases[index],
              isMobile,
            ),
          ),
          
          // See all button
          Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  // TODO: Navigate to full similar cases screen
                },
                icon: Icon(Icons.search, size: isMobile ? 16 : 20),
                label: Text(
                  'Find more similar cases',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
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
    bool isMobile,
  ) {
    final dateFormat = DateFormat('MMM yyyy');
    
    return InkWell(
      onTap: () {
        // Open drawer with case details
        _openCaseDrawer(similarCase);
      },
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 20),
        child: isMobile
            // Layout mobile ottimizzato
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Prima riga: icona outcome e titolo
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCaseOutcomeIcon(similarCase.outcome, isMobile),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              similarCase.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14, // Font più piccolo su mobile
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // Punteggio di corrispondenza
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${(similarCase.similarityScore * 100).toInt()}% match',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.bmwBlue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Freccia
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.bmwBlue,
                      ),
                    ],
                  ),
                  
                  // Descrizione
                  Padding(
                    padding: const EdgeInsets.only(left: 48),
                    child: Text(
                      similarCase.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        height: 1.3,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  
                  // Chip informativi a fondo
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 48),
                    child: Wrap(
                      spacing: 6,
                      children: [
                        _buildInfoChip(
                          similarCase.type.displayName,
                          Icons.folder_outlined,
                          isMobile,
                        ),
                        _buildInfoChip(
                          similarCase.isClosed
                              ? 'Closed ${dateFormat.format(similarCase.closingDate!)}'
                              : 'Filed ${dateFormat.format(similarCase.filingDate)}',
                          Icons.calendar_today_outlined,
                          isMobile,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            
            // Layout originale per desktop
            : Row(
                children: [
                  // Case icon with outcome indicator
                  _buildCaseOutcomeIcon(similarCase.outcome, isMobile),
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
                              isMobile,
                            ),
                            const SizedBox(width: 8),
                            _buildInfoChip(
                              similarCase.isClosed
                                  ? '${dateFormat.format(similarCase.filingDate)} - ${dateFormat.format(similarCase.closingDate!)}'
                                  : 'Filed ${dateFormat.format(similarCase.filingDate)}',
                              Icons.calendar_today_outlined,
                              isMobile,
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
    );
  }

  Widget _buildCaseOutcomeIcon(CaseOutcome outcome, bool isMobile) {
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
        backgroundColor = AppColors.bmwBlue.withOpacity(0.1);
        iconColor = AppColors.bmwBlue;
        icon = Icons.info_outline_rounded;
        break;
    }
    
    // Container più piccolo su mobile
    final padding = isMobile ? 8.0 : 12.0;
    final iconSize = isMobile ? 18.0 : 24.0;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon, bool isMobile) {
    // Font e padding ridotti su mobile
    final horizontalPadding = isMobile ? 6.0 : 8.0;
    final verticalPadding = isMobile ? 2.0 : 4.0;
    final fontSize = isMobile ? 9.0 : 10.0;
    final iconSize = isMobile ? 10.0 : 12.0;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
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
            size: iconSize,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SimilarCasesDetailView extends StatelessWidget {
  final SimilarCase similarCase;
  final ScrollController? scrollController;
  final bool isMobile;

  const SimilarCasesDetailView({
    super.key,
    required this.similarCase,
    this.scrollController,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 50,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              // Case Title and Outcome
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      similarCase.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.bmwBlue,
                        fontSize: isMobile ? 18 : null, // Font più piccolo su mobile
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildCaseOutcomeIcon(context, similarCase.outcome),
                ],
              ),
              const SizedBox(height: 16),

              // Comprehensive Case Summary
              Text(
                'Comprehensive Case Summary',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                  fontSize: isMobile ? 15 : null, // Font più piccolo su mobile
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _generateDetailedSummary(similarCase),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: Colors.grey[700],
                  fontSize: isMobile ? 13 : null, // Font più piccolo su mobile
                ),
              ),
              const SizedBox(height: 16),

              // Detailed Case Information
              _buildSectionHeader(context, 'Case Details'),
              _buildDetailRow(
                context, 
                'Case Type', 
                similarCase.type.displayName
              ),
              _buildDetailRow(
                context, 
                'Filing Date', 
                DateFormat('dd MMMM yyyy').format(similarCase.filingDate)
              ),
              if (similarCase.isClosed) 
                _buildDetailRow(
                  context, 
                  'Closing Date', 
                  DateFormat('dd MMMM yyyy').format(similarCase.closingDate!)
                ),
              _buildDetailRow(
                context, 
                'Case Outcome', 
                _getCaseOutcomeString(similarCase.outcome)
              ),
              _buildDetailRow(
                context, 
                'Similarity Score', 
                '${(similarCase.similarityScore * 100).toInt()}%'
              ),

              // Key Insights Section
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Key Insights'),
              _buildInsightsList(context, similarCase),

              // Legal Implications
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Legal Implications'),
              Text(
                _generateLegalImplications(similarCase),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: Colors.grey[700],
                  fontSize: isMobile ? 13 : null, // Font più piccolo su mobile
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Generate a detailed summary based on case characteristics
  String _generateDetailedSummary(SimilarCase similarCase) {
    return '''
This case represents a significant legal matter involving ${similarCase.type.displayName}. 
The core legal dispute centers around ${_generateCoreDispute(similarCase)}.

The case provides critical insights into ${_generateInsightDescription(similarCase)}, 
highlighting the complexities of legal proceedings in this domain.
''';
  }

  // Helper method to generate core dispute description
  String _generateCoreDispute(SimilarCase similarCase) {
    switch (similarCase.type) {
      case CaseType.dataPrivacy:
        return 'data protection regulations and potential privacy violations';
      case CaseType.intellectualProperty:
        return 'trademark, patent, or copyright protection and potential infringements';
      case CaseType.consumerRights:
        return 'consumer protection laws and potential product-related disputes';
      case CaseType.productLiability:
        return 'product safety and manufacturer responsibilities';
      default:
        return 'legal complexities within the BMW legal framework';
    }
  }

  // Generate insight description
  String _generateInsightDescription(SimilarCase similarCase) {
    switch (similarCase.outcome) {
      case CaseOutcome.won:
        return 'successful legal strategies and key arguments that led to a favorable outcome';
      case CaseOutcome.lost:
        return 'potential legal vulnerabilities and areas for improvement';
      case CaseOutcome.settled:
        return 'negotiation tactics and compromise strategies';
      case CaseOutcome.dismissed:
        return 'procedural nuances and legal technicalities';
      case CaseOutcome.pending:
        return 'ongoing legal challenges and potential future implications';
      default:
        return 'legal precedents and strategic considerations';
    }
  }

  // Generate legal implications
  String _generateLegalImplications(SimilarCase similarCase) {
    return '''
The implications of this case extend beyond its immediate context. 
Key takeaways include potential impacts on:
- Future legal strategies
- Risk management approaches
- Compliance protocols
- Potential policy modifications

Understanding the nuanced details of this case can provide valuable 
insights for proactive legal decision-making within the organization.
''';
  }

  // Build a list of key insights
  Widget _buildInsightsList(BuildContext context, SimilarCase similarCase) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInsightItem(
          context, 
          Icons.lightbulb_outline,
          'Strategic Significance',
          _generateStrategicInsight(similarCase),
        ),
        _buildInsightItem(
          context, 
          Icons.account_balance_outlined,
          'Legal Precedent',
          _generatePrecedentInsight(similarCase),
        ),
        _buildInsightItem(
          context, 
          Icons.warning_outlined,
          'Risk Assessment',
          _generateRiskInsight(similarCase),
        ),
      ],
    );
  }

  // Generate strategic insight
  String _generateStrategicInsight(SimilarCase similarCase) {
    switch (similarCase.type) {
      case CaseType.dataPrivacy:
        return 'Strategic approach to data protection and privacy compliance';
      case CaseType.intellectualProperty:
        return 'Proactive intellectual property management and protection strategies';
      case CaseType.consumerRights:
        return 'Comprehensive consumer rights and product responsibility framework';
      case CaseType.productLiability:
        return 'Robust product safety and risk mitigation protocols';
      default:
        return 'Comprehensive legal strategy development';
    }
  }

  // Generate precedent insight
  String _generatePrecedentInsight(SimilarCase similarCase) {
    switch (similarCase.outcome) {
      case CaseOutcome.won:
        return 'Establishes a favorable legal precedent for similar future cases.';
      case CaseOutcome.lost:
        return 'Identifies potential legal vulnerabilities to address proactively.';
      case CaseOutcome.settled:
        return 'Demonstrates the value of negotiation and compromise.';
      case CaseOutcome.dismissed:
        return 'Highlights the importance of procedural compliance.';
      case CaseOutcome.pending:
        return 'Indicates ongoing legal complexity and potential future developments.';
      default:
        return 'Offers insights into legal strategic decision-making.';
    }
  }

  // Generate risk insight
  String _generateRiskInsight(SimilarCase similarCase) {
    return 'Provides a comprehensive assessment of potential legal and operational risks.';
  }

  // Build an individual insight item
  Widget _buildInsightItem(
    BuildContext context, 
    IconData icon, 
    String title, 
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.bmwBlue,
            size: isMobile ? 20 : 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                    fontSize: isMobile ? 13 : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    height: 1.5,
                    fontSize: isMobile ? 12 : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to convert CaseOutcome to readable string
  String _getCaseOutcomeString(CaseOutcome outcome) {
    switch (outcome) {
      case CaseOutcome.won:
        return 'Successful Outcome';
      case CaseOutcome.lost:
        return 'Unfavorable Outcome';
      case CaseOutcome.settled:
        return 'Negotiated Settlement';
      case CaseOutcome.dismissed:
        return 'Case Dismissed';
      case CaseOutcome.pending:
        return 'Ongoing Proceedings';
      case CaseOutcome.unknown:
        return 'Default Case Analysis';
    }
  }

  // Build a section header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.bmwBlue,
          letterSpacing: 0.5,
          fontSize: isMobile ? 15 : null,
        ),
      ),
    );
  }

  // Build a detail row
  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 4 : 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
              fontSize: isMobile ? 12 : null,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
              fontSize: isMobile ? 12 : null,
            ),
          ),
        ],
      ),
    );
  }

  // Build case outcome icon (con dimensioni adattate)
  Widget _buildCaseOutcomeIcon(BuildContext context, CaseOutcome outcome) {
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
        backgroundColor = AppColors.bmwBlue.withOpacity(0.1);
        iconColor = AppColors.bmwBlue;
        icon = Icons.info_outline_rounded;
        break;
    }
    
    final padding = isMobile ? 10.0 : 12.0;
    final iconSize = isMobile ? 20.0 : 24.0;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}