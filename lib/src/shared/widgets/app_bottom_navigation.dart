import 'package:flutter/material.dart';

import '../theme/app_theme_colors.dart';

enum AppTab { home, history, settings }

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  final AppTab activeTab;
  final ValueChanged<AppTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Container(
      height: 69,
      decoration: BoxDecoration(
        color: colors.navBackground,
        border: Border(top: BorderSide(color: colors.navBorder, width: 2)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(73, 8, 73, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                isSelected: activeTab == AppTab.home,
                onTap: () => onTabSelected(AppTab.home),
              ),
              const SizedBox(width: 20),
              _NavItem(
                icon: Icons.history_toggle_off,
                label: 'History',
                isSelected: activeTab == AppTab.history,
                onTap: () => onTabSelected(AppTab.history),
              ),
              const SizedBox(width: 20),
              _NavItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                isSelected: activeTab == AppTab.settings,
                onTap: () => onTabSelected(AppTab.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final color = isSelected ? colors.teal : colors.navInactive;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 52,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: isSelected ? 31 : 30),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                letterSpacing: 0,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
