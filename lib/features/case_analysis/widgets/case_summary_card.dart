import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:bmw_legal_assistant/core/models/case_model.dart';
import 'package:bmw_legal_assistant/core/theme/colors.dart';
import 'package:intl/intl.dart';

class CaseSummaryCard extends StatelessWidget {
  final CaseModel caseModel;

  const CaseSummaryCard({
    super.key,
    required this.caseModel,
  });

  // Helper method to determine if we're on a mobile device
  bool _isMobileDevice(BuildContext context) {
    // Check if screen width is less than 600 (tablet breakpoint)
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    // Check if we're on a mobile platform (iOS or Android)
    final isMobilePlatform = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
    
    // Return true if either condition is met
    return isSmallScreen || isMobilePlatform;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
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
          // Header - Ridotto padding laterale su mobile
          Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 16 : 24,
              24,
              isMobile ? 16 : 24,
              isMobile ? 16 : 24,
            ),
            child: isMobile 
              // Layout mobile con titolo e chip in colonne
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Case Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: isMobile ? 18 : null, // Ridotto font su mobile
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      caseModel.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      // Evita overflow del testo su mobile
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    _buildCaseTypeChip(context, caseModel.type),
                  ],
                )
              // Layout desktop con titolo e chip in riga
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Case Summary',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            caseModel.title,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildCaseTypeChip(context, caseModel.type),
                  ],
                ),
          ),
          
          // Details - Ridotto padding laterale su mobile
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Case description
                Text(
                  caseModel.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    fontSize: isMobile ? 13 : null, // Ridotto font su mobile
                  ),
                ),
                const SizedBox(height: 24),
                
                // Date information - Ridisegnato per mobile
                if (isMobile)
                  // Layout in colonna per mobile
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoItem(
                        context,
                        'Filing Date',
                        dateFormat.format(caseModel.filingDate),
                        Icons.calendar_today_rounded,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoItem(
                        context,
                        'Days Active',
                        _getDaysActive(caseModel.filingDate),
                        Icons.timelapse_rounded,
                      ),
                    ],
                  )
                else
                  // Layout in riga per desktop
                  Row(
                    children: [
                      _buildInfoItem(
                        context,
                        'Filing Date',
                        dateFormat.format(caseModel.filingDate),
                        Icons.calendar_today_rounded,
                      ),
                      const SizedBox(width: 24),
                      _buildInfoItem(
                        context,
                        'Days Active',
                        _getDaysActive(caseModel.filingDate),
                        Icons.timelapse_rounded,
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseTypeChip(BuildContext context, CaseType type) {
    final isMobile = _isMobileDevice(context);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: _getCaseTypeColor(type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
      ),
      child: Text(
        type.displayName,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: _getCaseTypeColor(type),
          fontWeight: FontWeight.w500,
          fontSize: isMobile ? 10 : null, // Ridotto font su mobile
        ),
      ),
    );
  }

  Color _getCaseTypeColor(CaseType type) {
    switch (type) {
      case CaseType.vehicleMalfunction:
        return AppColors.errorRed;
      case CaseType.warranty:
        return AppColors.warningYellow;
      case CaseType.productLiability:
        return Colors.deepOrange;
      case CaseType.intellectualProperty:
        return Colors.purple;
      case CaseType.employment:
        return Colors.teal;
      case CaseType.consumerRights:
        return Colors.indigo;
      case CaseType.environmentalClaims:
        return Colors.green;
      case CaseType.dataPrivacy:
        return Colors.blue;
      case CaseType.financialDispute:
        return Colors.amber;
      case CaseType.other:
        return Colors.grey;
    }
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final isMobile = _isMobileDevice(context);
    
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 6 : 8),
          decoration: BoxDecoration(
            color: AppColors.lightBlue,
            borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
          ),
          child: Icon(
            icon,
            size: isMobile ? 14 : 16,
            color: AppColors.bmwBlue,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontSize: isMobile ? 10 : null, // Ridotto font su mobile
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: isMobile ? 12 : null, // Ridotto font su mobile
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getDaysActive(DateTime filingDate) {
    final today = DateTime.now();
    final difference = today.difference(filingDate);
    return '${difference.inDays} days';
  }
}