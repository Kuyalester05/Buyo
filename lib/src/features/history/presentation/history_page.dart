import 'package:flutter/material.dart';

import '../../../shared/services/models/saved_scan_model.dart';
import '../../../shared/services/scan_storage_service.dart';
import '../../../shared/theme/app_theme_colors.dart';
import '../../scan_detail/presentation/scan_detail_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  static const _darkTeal = Color(0xFF078F78);

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
  final _storageService = ScanStorageService();
  late Future<List<SavedScan>> _scansFuture;
  String _selectedSort = _sortOptions.first;
  String _selectedFilter = _filters.first;

  @override
  void initState() {
    super.initState();
    _scansFuture = _storageService.getAllScans();
  }

  @override
  void dispose() {
    _filterScrollController.dispose();
    super.dispose();
  }

  void _deleteScan(int id) {
    _storageService.deleteScan(id);
    _refreshScans();
  }

  void _refreshScans() {
    setState(() {
      _scansFuture = _storageService.getAllScans();
    });
  }

  void _viewScanDetail(SavedScan scan) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ScanDetailPage(scan: scan)),
    );
  }

  List<SavedScan> _filterAndSortScans(List<SavedScan> scans) {
    var filtered = scans;

    if (_selectedFilter != 'All') {
      filtered = scans
          .where((scan) =>
              scan.diseaseName == _selectedFilter ||
              (scan.classification.contains('Early') && _selectedFilter.contains('Early')) ||
              (scan.classification.contains('Severe') && _selectedFilter.contains('Severe')) ||
              (scan.classification == 'Healthy' && _selectedFilter == 'Healthy'))
          .toList();
    }

    if (_selectedSort == 'Accuracy') {
      filtered.sort((a, b) => b.confidence.compareTo(a.confidence));
    } else if (_selectedSort == 'Date') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return ColoredBox(
      color: colors.alternateBackground,
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
            child: FutureBuilder<List<SavedScan>>(
              future: _scansFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final allScans = snapshot.data ?? [];
                final filtered = _filterAndSortScans(allScans);

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'No scans found',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(30, 24, 30, 24),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    return _HistoryScanTile(
                      scan: filtered[index],
                      onTap: () => _viewScanDetail(filtered[index]),
                      onDelete: () => _deleteScan(filtered[index].id!),
                    );
                  },
                );
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
      height: 118,
      color: HistoryPage._darkTeal,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Scan History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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
          'Sort by:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(width: 7),
        Container(
          height: 30,
          width: 104,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedSort,
              isDense: true,
              isExpanded: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: Color(0xFF777777),
              ),
              dropdownColor: Colors.white,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.w700,
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
    final colors = AppThemeColors.of(context);

    return ColoredBox(
      color: colors.card,
      child: SizedBox(
        height: 65,
        child: Scrollbar(
          controller: controller,
          thumbVisibility: true,
          trackVisibility: true,
          notificationPredicate: (notification) =>
              notification.metrics.axis == Axis.horizontal,
          child: ListView.separated(
            controller: controller,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(30, 12, 30, 19),
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
    final colors = AppThemeColors.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 34,
        constraints: const BoxConstraints(minWidth: 76),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: selected ? HistoryPage._darkTeal : colors.card,
          border: Border.all(color: colors.cardBorder),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          maxLines: 1,
          style: TextStyle(
            color: selected ? Colors.white : colors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class _HistoryScanTile extends StatelessWidget {
  const _HistoryScanTile({
    required this.scan,
    required this.onTap,
    required this.onDelete,
  });

  final SavedScan scan;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final accentColor = Color(scan.accentColor);

    return Dismissible(
      key: ValueKey(scan.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFF174A),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 76,
          decoration: BoxDecoration(
            color: colors.card,
            border: Border.all(color: colors.cardBorder, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.fromLTRB(18, 14, 20, 14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(Icons.eco_outlined, color: accentColor, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scan.diseaseName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatTimeAgo(scan.createdAt),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(scan.confidence * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      height: 1,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Accuracy',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
