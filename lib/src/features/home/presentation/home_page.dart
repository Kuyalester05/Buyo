import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/app_routes.dart';
import '../../../shared/services/leaf_image_picker.dart';
import '../../../shared/services/models/saved_scan_model.dart';
import '../../../shared/services/scan_storage_service.dart';
import '../../../shared/theme/app_theme_colors.dart';
import '../../scan_detail/presentation/scan_detail_page.dart';
import '../../scan_preview/presentation/scan_preview_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const _teal = Color(0xFF10BC97);
  static const _darkTeal = Color(0xFF07977D);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _leafImagePicker = LeafImagePicker();
  final _storageService = ScanStorageService();
  late Future<List<SavedScan>> _scansFuture;

  @override
  void initState() {
    super.initState();
    _scansFuture = _storageService.getAllScans();
  }

  Future<void> _captureLeafImage() async {
    final image = await _leafImagePicker.captureLeafImage();
    if (!mounted) return;
    await _openScanPreview(image, 'Camera photo');
  }

  Future<void> _uploadLeafImage() async {
    final image = await _leafImagePicker.uploadLeafImage();
    if (!mounted) return;
    await _openScanPreview(image, 'Gallery image');
  }

  Future<void> _openScanPreview(XFile? image, String sourceLabel) async {
    if (image == null) {
      _showMessage('No image selected.');
      return;
    }

    final shouldContinue = await Navigator.of(context).pushNamed<bool>(
      AppRoutes.scanPreview,
      arguments: ScanPreviewArguments(image: image, sourceLabel: sourceLabel),
    );
    if (!mounted || shouldContinue != true) return;

    _showMessage('Leaf image ready for scanning.');
    _refreshScans();
  }

  void _refreshScans() {
    setState(() {
      _scansFuture = _storageService.getAllScans();
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _deleteScan(int id) {
    _storageService.deleteScan(id);
    _refreshScans();
  }

  void _viewScanDetail(SavedScan scan) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ScanDetailPage(scan: scan)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return ColoredBox(
      color: colors.pageBackground,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _HomeHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 24, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.camera_alt_outlined,
                          title: 'Scan Leaf',
                          subtitle: 'Take a photo now',
                          onTap: _captureLeafImage,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.upload_outlined,
                          title: 'Upload Image',
                          subtitle: 'From gallery',
                          onTap: _uploadLeafImage,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 27),
                  Text(
                    'Recent Scans',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 15),
                  FutureBuilder<List<SavedScan>>(
                    future: _scansFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final scans = snapshot.data ?? [];

                      if (scans.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: colors.card,
                            border: Border.all(color: colors.cardBorder, width: 2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              'No scans yet. Start by scanning a leaf!',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: scans.take(3).map((scan) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _RecentScanTile(
                              scan: scan,
                              onTap: () => _viewScanDetail(scan),
                              onDelete: () => _deleteScan(scan.id!),
                            ),
                          );
                        }).toList(),
                      );
                    },
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF15C89C), HomePage._darkTeal],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(43)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(44, 27, 44, 31),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'B U Y O',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                'Good Morning',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Check your Buyo leaves today',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Material(
      color: colors.card,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          height: 133,
          decoration: BoxDecoration(
            border: Border.all(color: colors.cardBorder, width: 2),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 51,
                height: 51,
                decoration: BoxDecoration(
                  color: HomePage._teal.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: HomePage._darkTeal, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentScanTile extends StatelessWidget {
  const _RecentScanTile({
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
              _StatusPill(severityLevel: scan.severityLevel, accent: accentColor),
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

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.severityLevel,
    required this.accent,
  });

  final String severityLevel;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      constraints: const BoxConstraints(minWidth: 58),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: accent, width: 2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        severityLevel,
        maxLines: 1,
        style: TextStyle(
          color: accent,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
          height: 1,
        ),
      ),
    );
  }
}
