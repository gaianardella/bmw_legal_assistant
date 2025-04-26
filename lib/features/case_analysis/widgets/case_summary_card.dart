import 'package:flutter/material.dart';
import 'package:bmw_legal_assistant/core/models/case_model.dart';
import 'package:bmw_legal_assistant/core/theme/colors.dart';
import 'package:intl/intl.dart';

class CaseSummaryCard extends StatelessWidget {
  final CaseModel caseModel;

  const CaseSummaryCard({
    super.key,
    required this.caseModel,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    
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
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                _buildCaseTypeChip(context, caseModel.type),
              ],
            ),
          ),
          
          // Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Case description
                Text(
                  caseModel.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Date information
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: _getCaseTypeColor(type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type.displayName,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: _getCaseTypeColor(type),
          fontWeight: FontWeight.w500,
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
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.lightBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 16,
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
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
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