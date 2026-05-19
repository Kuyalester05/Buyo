import 'package:flutter/material.dart';

import '../features/history/presentation/history_page.dart';
import '../features/home/presentation/home_page.dart';
import '../shared/widgets/app_bottom_navigation.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

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
              children: const [
                HomePage(),
                HistoryPage(),
                _SettingsPlaceholder(),
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

class _SettingsPlaceholder extends StatelessWidget {
  const _SettingsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFECF8F4),
      child: Center(
        child: Icon(Icons.settings_outlined, color: Colors.black, size: 36),
      ),
    );
  }
}
