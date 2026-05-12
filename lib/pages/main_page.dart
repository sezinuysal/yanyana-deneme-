import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_page.dart';
import 'map_page.dart';
import 'community_page.dart';
import 'guide_donation_page.dart';
import 'accessibility_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    MapPage(),
    CommunityPage(),
    GuideDonationPage(),
    AccessibilityPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: YanYanaColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: YanYanaShadows.nav,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: YanYanaColors.surface,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: YanYanaColors.primary,
          unselectedItemColor: YanYanaColors.textLight,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 10.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10.5,
          ),
          items: [
            _navItem(
              activeIcon: Icons.home_rounded,
              icon: Icons.home_outlined,
              label: 'Ana Sayfa',
              index: 0,
            ),
            _navItem(
              activeIcon: Icons.map_rounded,
              icon: Icons.map_outlined,
              label: 'Harita',
              index: 1,
            ),
            _navItem(
              activeIcon: Icons.groups_rounded,
              icon: Icons.groups_outlined,
              label: 'Topluluk',
              index: 2,
            ),
            _navItem(
              activeIcon: Icons.menu_book_rounded,
              icon: Icons.menu_book_outlined,
              label: 'Rehber',
              index: 3,
            ),
            _navItem(
              activeIcon: Icons.accessibility_new_rounded,
              icon: Icons.accessibility_new_outlined,
              label: 'Erişim',
              index: 4,
            ),
            _navItem(
              activeIcon: Icons.person_rounded,
              icon: Icons.person_outline_rounded,
              label: 'Profil',
              index: 5,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem({
    required IconData activeIcon,
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: isSelected ? primaryGradient : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? Colors.white : YanYanaColors.textLight,
          size: 21,
        ),
      ),
      label: label,
    );
  }
}