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
      body: Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFA2CAFE), // azzurro chiaro
        Color(0xFF004AAD), // blu intenso
      ],
    ),
  ),
  child: Column(
    children: [
      _TopBar(),
      Expanded(
        child: Row(
          children: [
            _SideNavigation(
              selectedIndex: selectedTabIndex,
              onIndexChanged: (index) => ref.read(selectedTabProvider.notifier).state = index,
            ),
            Expanded(
              child: IndexedStack(
                index: selectedTabIndex,
                children: const [
                  CaseAnalysisScreen(),
                  DocumentReviewScreen(),
                  Placeholder(color: AppColors.lightBlue),
                  Placeholder(color: AppColors.lightBlue),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),

    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
       child: Row(
        children: [
          // BMW Logo come immagine
          Image.asset(
            'assets/images/BMW_logo.png',
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 16),
          
          // Mini Logo come immagine
          Image.asset(
            'assets/images/MINI_logo.jpg',
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 16),
          
          // Rolls-Royce Logo come immagine
          Image.asset(
            'assets/images/Rolls_Royce_logo.png',
            width: 40,
            height: 40,
          ),
          
          // Title
          const SizedBox(width: 24),
          const Text(
            'BMW Group Legal Assistant',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          
          const Spacer(),
          
          // User Avatar on the right
          _UserAvatar(),
        ],
      ),
    );
  }

  Widget _buildBMWLogo() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      child: Center(
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: const Center(
            child: Text(
              'BMW',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniLogo() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      child: const Center(
        child: Text(
          'MINI',
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRollsRoyceLogo() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: const Center(
        child: Text(
          'RR',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
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
    // Width reduced from 80 to 60
    return Container(
      width: 60,
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
          const SizedBox(height: 24),
          
          // Navigation Items (removed the BMW logo from here)
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
              ],
            ),
          ),
        ],
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
                  width: 40, // Reduced from 48
                  height: 40, // Reduced from 48
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.lightBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? AppColors.bmwBlue : AppColors.textMedium,
                    size: 20, // Reduced from 24
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