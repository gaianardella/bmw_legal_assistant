import 'package:flutter/material.dart';
import 'package:bmw_legal_assistant/core/models/case_model.dart';
import 'package:bmw_legal_assistant/core/theme/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RiskAssessmentCard extends StatelessWidget {
  final RiskAssessment riskAssessment;

  const RiskAssessmentCard({
    super.key,
    required this.riskAssessment,
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
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Risk Assessment',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AI-powered analysis of case risks and win probability',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Risk indicators
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                // Win probability circular indicator
                Expanded(
                  flex: 2,
                  child: _buildWinProbabilityChart(context),
                ),
                const SizedBox(width: 24),
                // Risk bars
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildRiskBar(
                        context,
                        'Brand Reputation',
                        riskAssessment.brandReputationRisk,
                        _getRiskColor(riskAssessment.brandReputationRiskLevel),
                      ),
                      const SizedBox(height: 16),
                      _buildRiskBar(
                        context,
                        'Legal Complexity',
                        riskAssessment.mediaCoverageRisk,
                        _getRiskColor(riskAssessment.mediaCoverageRiskLevel),
                      ),
                      const SizedBox(height: 16),
                      _buildRiskBar(
                        context,
                        'Financial Exposure',
                        riskAssessment.financialExposureRisk,
                        _getRiskColor(riskAssessment.financialExposureRiskLevel),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Overall risk indicator
          Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getOverallRiskBackgroundColor(riskAssessment.overallRiskLevel),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getOverallRiskIcon(riskAssessment.overallRiskLevel),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Risk Level: ${riskAssessment.overallRiskLevel.displayName}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getOverallRiskDescription(riskAssessment.overallRiskLevel),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWinProbabilityChart(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SfCircularChart(
            margin: EdgeInsets.zero,
            series: <CircularSeries>[
              RadialBarSeries<_ChartData, String>(
                dataSource: [
                  _ChartData('Win Probability', riskAssessment.winProbabilityScore.toDouble()),
                ],
                cornerStyle: CornerStyle.bothCurve,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                maximumValue: 100,
                radius: '80%',
                innerRadius: '75%',
                gap: '5%',
                pointColorMapper: (_ChartData data, _) => _getWinProbabilityColor(riskAssessment.winProbabilityLevel),
                trackColor: Colors.grey,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${riskAssessment.winProbabilityScore}%',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: _getWinProbabilityColor(riskAssessment.winProbabilityLevel),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Win Rate',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildRiskBar(
    BuildContext context,
    String label,
    int value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$value%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
  
  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return AppColors.successGreen;
      case RiskLevel.medium:
        return AppColors.warningYellow;
      case RiskLevel.high:
        return AppColors.errorRed;
    }
  }
  
  Color _getWinProbabilityColor(WinProbability level) {
    switch (level) {
      case WinProbability.low:
        return AppColors.errorRed;
      case WinProbability.medium:
        return AppColors.warningYellow;
      case WinProbability.high:
        return AppColors.successGreen;
    }
  }
  
  Color _getOverallRiskBackgroundColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return AppColors.successGreen;
      case RiskLevel.medium:
        return AppColors.warningYellow;
      case RiskLevel.high:
        return AppColors.errorRed;
    }
  }
  
  IconData _getOverallRiskIcon(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return Icons.check_circle_rounded;
      case RiskLevel.medium:
        return Icons.warning_rounded;
      case RiskLevel.high:
        return Icons.error_rounded;
    }
  }
  
  String _getOverallRiskDescription(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return 'This case presents minimal risk to BMW Group';
      case RiskLevel.medium:
        return 'This case requires careful handling to mitigate potential risks';
      case RiskLevel.high:
        return 'This case presents significant risks and requires immediate attention';
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}