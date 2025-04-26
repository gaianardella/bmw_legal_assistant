import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bmw_legal_assistant/features/case_analysis/screens/case_analysis_screen.dart';
import 'package:bmw_legal_assistant/features/document_review/screens/document_review_screen.dart';
import 'package:bmw_legal_assistant/core/theme/colors.dart';

final selectedTabProvider = StateProvider<int>((ref) => 0);

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTabIndex = ref.watch(selectedTabProvider);

    return Scaffold(
      body: Row(
        children: [
          // Side Navigation
          _SideNavigation(
            selectedIndex: selectedTabIndex,
            onIndexChanged: (index) => ref.read(selectedTabProvider.notifier).state = index,
          ),
          
          // Main Content
          Expanded(
            child: IndexedStack(
              index: selectedTabIndex,
              children: const [
                CaseAnalysisScreen(),
                DocumentReviewScreen(),
                // Add more screens here as needed
                Placeholder(color: AppColors.lightBlue), // Placeholder for future screens
                Placeholder(color: AppColors.lightBlue), // Placeholder for future screens
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SideNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  const _SideNavigation({
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(1, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 48),
          // BMW Logo
          _buildBMWLogo(),
          const SizedBox(height: 40),
          
          // Navigation Items
          Expanded(
            child: Column(
              children: [
                _NavItem(
                  icon: Icons.pie_chart_rounded,
                  label: 'Case Analysis',
                  isSelected: selectedIndex == 0,
                  onTap: () => onIndexChanged(0),
                ),
                _NavItem(
                  icon: Icons.text_snippet_rounded,
                  label: 'Documents',
                  isSelected: selectedIndex == 1,
                  onTap: () => onIndexChanged(1),
                ),
                _NavItem(
                  icon: Icons.trending_up_rounded,
                  label: 'Analytics',
                  isSelected: selectedIndex == 2,
                  onTap: () => onIndexChanged(2),
                ),
                _NavItem(
                  icon: Icons.search_rounded,
                  label: 'Search',
                  isSelected: selectedIndex == 3,
                  onTap: () => onIndexChanged(3),
                ),
              ],
            ),
          ),
          
          // User Avatar
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _UserAvatar(),
          ),
        ],
      ),
    );
  }

  Widget _buildBMWLogo() {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.blueGradient,
        ),
      ),
      child: Center(
        child: Text(
          'BMW',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      preferBelow: false,
      verticalOffset: 20,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.lightBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? AppColors.bmwBlue : AppColors.textMedium,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.blueGradient,
        ),
      ),
      child: const Center(
        child: Text(
          'MK',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}