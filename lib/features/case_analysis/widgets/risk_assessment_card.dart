import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:bmw_legal_assistant/core/models/case_model.dart';
import 'package:bmw_legal_assistant/core/theme/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RiskAssessmentCard extends StatelessWidget {
  final RiskAssessment riskAssessment;

  const RiskAssessmentCard({
    super.key,
    required this.riskAssessment,
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
                  'Risk Assessment',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: isMobile ? 18 : null, // Ridotto font su mobile
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AI-powered analysis of case risks and win probability',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontSize: isMobile ? 12 : null, // Ridotto font su mobile
                  ),
                ),
              ],
            ),
          ),

          // Risk indicators - layout modificato per mobile
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            child: isMobile
                // Layout in colonna per mobile
                ? Column(
                    children: [
                      // Win probability circular indicator centrato
                      _buildWinProbabilityChart(context),
                      const SizedBox(height: 16),
                      // Risk bars
                      Column(
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
                            riskAssessment.legalComplexityRisk,
                            _getRiskColor(riskAssessment.LegalComplexityRiskLevel),
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
                    ],
                  )
                // Layout originale in riga per desktop
                : Row(
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
                              riskAssessment.legalComplexityRisk,
                              _getRiskColor(riskAssessment.LegalComplexityRiskLevel),
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
          
          const SizedBox(height: 16),
          
          // Overall risk indicator - padding ridotto su mobile
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Container(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              decoration: BoxDecoration(
                color: _getOverallRiskBackgroundColor(riskAssessment.overallRiskLevel),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  isMobile
                      // Layout in colonna per mobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    _getOverallRiskIcon(riskAssessment.overallRiskLevel),
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Overall Risk Level: ${riskAssessment.overallRiskLevel.displayName}',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14, // Font ridotto su mobile
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getOverallRiskDescription(riskAssessment.overallRiskLevel),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 11, // Font ridotto su mobile
                              ),
                            ),
                          ],
                        )
                      // Layout originale in riga per desktop
                      : Row(
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
                  const SizedBox(height: 12),
                  // Sezione per la raccomandazione
                  _buildLitigationRecommendation(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWinProbabilityChart(BuildContext context) {
    final isMobile = _isMobileDevice(context);
    
    return SizedBox(
      height: isMobile ? 160 : 180, // Altezza ridotta su mobile
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
                  fontSize: isMobile ? 24 : null, // Font ridotto su mobile
                ),
              ),
              Text(
                'Win Rate',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: isMobile ? 10 : null, // Font ridotto su mobile
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
    final isMobile = _isMobileDevice(context);
    
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
                fontSize: isMobile ? 10 : null, // Font ridotto su mobile
              ),
            ),
            Text(
              '$value%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: isMobile ? 10 : null, // Font ridotto su mobile
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: isMobile ? 6 : 8, // Altezza ridotta su mobile
          ),
        ),
      ],
    );
  }

  // Sezione per la raccomandazione di contenzioso
  Widget _buildLitigationRecommendation(BuildContext context) {
    final isMobile = _isMobileDevice(context);
    
    return Row(
      children: [
        Icon(
          _getLitigationRecommendationIcon(),
          color: Colors.white,
          size: isMobile ? 16 : 20, // Icona più piccola su mobile
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            _getLitigationRecommendationText(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: isMobile ? 10 : null, // Font ridotto su mobile
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
  
  IconData _getLitigationRecommendationIcon() {
    switch (riskAssessment.overallRiskLevel) {
      case RiskLevel.low:
        return Icons.gavel_outlined; // Procedi
      case RiskLevel.medium:
        return Icons.balance_rounded; // Considera negoziazione
      case RiskLevel.high:
        return Icons.exit_to_app_rounded; // Suggerimento di transazione
    }
  }

  String _getLitigationRecommendationText() {
    switch (riskAssessment.overallRiskLevel) {
      case RiskLevel.low:
        return 'Recommended: Proceed with confidence, strong case for litigation';
      case RiskLevel.medium:
        return 'Recommended: Consider settlement or further negotiation';
      case RiskLevel.high:
        return 'Recommended: Prioritize settlement to minimize potential risks';
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