import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  static const _darkTeal = Color(0xFF078F78);
  static const _screenBackground = Color(0xFFE5FBF5);
  static const _cardBorder = Color(0xFFCFCFCF);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static const _sortOptions = ['Recent', 'Accuracy', 'Date'];
  static const _filters = [
    'All',
    'Healthy',
    'Leaf Spot Early',
    'Leaf Spot Severe',
    'Blight Early',
    'Blight Severe',
  ];

  final _filterScrollController = ScrollController();
  String _selectedSort = _sortOptions.first;
  String _selectedFilter = _filters.first;

  @override
  void dispose() {
    _filterScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: HistoryPage._screenBackground,
      child: Column(
        children: [
          _HistoryHeader(
            selectedSort: _selectedSort,
            sortOptions: _sortOptions,
            onSortChanged: (sort) {
              if (sort == null) return;
              setState(() => _selectedSort = sort);
            },
          ),
          _FilterBar(
            controller: _filterScrollController,
            filters: _filters,
            selectedFilter: _selectedFilter,
            onSelected: (filter) {
              setState(() => _selectedFilter = filter);
            },
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(46, 22, 46, 24),
              itemCount: _historyScans.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _HistoryScanTile(scan: _historyScans[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({
    required this.selectedSort,
    required this.sortOptions,
    required this.onSortChanged,
  });

  final String selectedSort;
  final List<String> sortOptions;
  final ValueChanged<String?> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 106,
      color: HistoryPage._darkTeal,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 46, 17),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Scan History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              const Spacer(),
              _SortControl(
                selectedSort: selectedSort,
                sortOptions: sortOptions,
                onSortChanged: onSortChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortControl extends StatelessWidget {
  const _SortControl({
    required this.selectedSort,
    required this.sortOptions,
    required this.onSortChanged,
  });

  final String selectedSort;
  final List<String> sortOptions;
  final ValueChanged<String?> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Sort by :',
          style: TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(width: 5),
        Container(
          height: 20,
          width: 82,
          padding: const EdgeInsets.only(left: 5),
          color: Colors.white,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedSort,
              isDense: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 14,
                color: Color(0xFF777777),
              ),
              dropdownColor: Colors.white,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 6.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
              items: sortOptions.map((sort) {
                return DropdownMenuItem(value: sort, child: Text(sort));
              }).toList(),
              onChanged: onSortChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.controller,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  final ScrollController controller;
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SizedBox(
        height: 61,
        child: Scrollbar(
          controller: controller,
          thumbVisibility: true,
          trackVisibility: true,
          notificationPredicate: (notification) =>
              notification.metrics.axis == Axis.horizontal,
          child: ListView.separated(
            controller: controller,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(46, 9, 46, 27),
            itemCount: filters.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final filter = filters[index];
              final selected = filter == selectedFilter;
              return _FilterChip(
                label: filter,
                selected: selected,
                onTap: () => onSelected(filter),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 24,
        constraints: const BoxConstraints(minWidth: 60),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: selected ? HistoryPage._darkTeal : Colors.white,
          border: Border.all(color: const Color(0xFFD4D4D4)),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          maxLines: 1,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontSize: 6.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class _HistoryScanTile extends StatelessWidget {
  const _HistoryScanTile({required this.scan});

  final _HistoryScanItem scan;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: HistoryPage._cardBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 18, 12),
      child: Row(
        children: [
          Container(
            width: 37,
            height: 37,
            decoration: BoxDecoration(
              color: scan.accentBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.eco_outlined, color: scan.accent, size: 17),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scan.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  scan.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 6.5,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '95.2%',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Accuracy',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 6,
                  fontWeight: FontWeight.w400,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryScanItem {
  const _HistoryScanItem({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.accentBackground,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final Color accentBackground;
}

const _historyScans = [
  _HistoryScanItem(
    title: 'Healthy Leaf',
    subtitle: 'Scan #24 - 2 hrs ago',
    accent: Color(0xFF08B85F),
    accentBackground: Color(0xFFA8F6D6),
  ),
  _HistoryScanItem(
    title: 'Blight - Early',
    subtitle: 'Scan #23 - 4 hrs ago',
    accent: Color(0xFF9DAE00),
    accentBackground: Color(0xFFF0FF9F),
  ),
  _HistoryScanItem(
    title: 'Leaf Spot - Severe',
    subtitle: 'Scan #20 - Yesterday',
    accent: Color(0xFFD81E3A),
    accentBackground: Color(0xFFFFB9C1),
  ),
  _HistoryScanItem(
    title: 'Healthy Leaf',
    subtitle: 'Scan #15 - 2 Days ago',
    accent: Color(0xFF08B85F),
    accentBackground: Color(0xFFA8F6D6),
  ),
  _HistoryScanItem(
    title: 'Leaf Spot - Early',
    subtitle: 'Scan #23 - 3 Days ago',
    accent: Color(0xFF9DAE00),
    accentBackground: Color(0xFFF0FF9F),
  ),
];
