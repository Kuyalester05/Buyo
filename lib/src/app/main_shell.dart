import 'package:flutter/material.dart';

import '../features/history/presentation/history_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../shared/widgets/app_bottom_navigation.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  AppTab _activeTab = AppTab.home;

  int get _activeIndex {
    return switch (_activeTab) {
      AppTab.home => 0,
      AppTab.history => 1,
      AppTab.settings => 2,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _activeIndex,
              children: [
                const HomePage(),
                const HistoryPage(),
                SettingsPage(
                  themeMode: widget.themeMode,
                  onThemeModeChanged: widget.onThemeModeChanged,
                ),
              ],
            ),
          ),
          AppBottomNavigation(
            activeTab: _activeTab,
            onTabSelected: (tab) {
              if (tab == _activeTab) return;
              setState(() => _activeTab = tab);
            },
          ),
        ],
      ),
    );
  }
}
