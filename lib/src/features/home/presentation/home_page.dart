import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/services/leaf_image_picker.dart';
import '../../../shared/theme/app_theme_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const _teal = Color(0xFF10BC97);
  static const _darkTeal = Color(0xFF07977D);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _leafImagePicker = LeafImagePicker();

  Future<void> _captureLeafImage() async {
    final image = await _leafImagePicker.captureLeafImage();
    if (!mounted) return;
    _showImagePickerResult(image, 'Leaf photo captured.');
  }

  Future<void> _uploadLeafImage() async {
    final image = await _leafImagePicker.uploadLeafImage();
    if (!mounted) return;
    _showImagePickerResult(image, 'Leaf image selected.');
  }

  void _showImagePickerResult(XFile? image, String successMessage) {
    final message = image == null ? 'No image selected.' : successMessage;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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
                  ..._recentScans.map(
                    (scan) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _RecentScanTile(scan: scan),
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
  const _RecentScanTile({required this.scan});

  final _ScanItem scan;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Container(
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
              color: scan.accentBackground,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(Icons.eco_outlined, color: scan.accent, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scan.title,
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
                  scan.subtitle,
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
          _StatusPill(scan: scan),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.scan});

  final _ScanItem scan;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      constraints: const BoxConstraints(minWidth: 58),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: scan.pillBackground,
        border: Border.all(color: scan.accent, width: 2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        scan.status,
        maxLines: 1,
        style: TextStyle(
          color: scan.accent,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
          height: 1,
        ),
      ),
    );
  }
}

class _ScanItem {
  const _ScanItem({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.accent,
    required this.accentBackground,
    required this.pillBackground,
  });

  final String title;
  final String subtitle;
  final String status;
  final Color accent;
  final Color accentBackground;
  final Color pillBackground;
}

const _recentScans = [
  _ScanItem(
    title: 'Healthy Leaf',
    subtitle: 'Scan #24 - 2 hrs ago',
    status: 'Healthy',
    accent: Color(0xFF00BD62),
    accentBackground: Color(0xFFCFFBE9),
    pillBackground: Color(0xFFFFFFFF),
  ),
  _ScanItem(
    title: 'Blight - Early',
    subtitle: 'Scan #23 - 4 hrs ago',
    status: 'Early',
    accent: Color(0xFFC2A100),
    accentBackground: Color(0xFFF7F19B),
    pillBackground: Color(0xFFFFFFFF),
  ),
  _ScanItem(
    title: 'Leaf Spot - Severe',
    subtitle: 'Scan #20 - Yesterday',
    status: 'Severe',
    accent: Color(0xFFFF174A),
    accentBackground: Color(0xFFFFD1DA),
    pillBackground: Color(0xFFFFFFFF),
  ),
];
