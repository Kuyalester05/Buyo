import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _teal = Color(0xFF08B88C);
  static const _darkTeal = Color(0xFF078F78);
  static const _mintBackground = Color(0xFFE5FBF5);
  static const _pageBackground = Color(0xFFFDF9F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _HomeHeader(),
                  ColoredBox(
                    color: _mintBackground,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(42, 16, 42, 34),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Expanded(
                                child: _ActionCard(
                                  icon: Icons.camera_alt_outlined,
                                  title: 'Scan Leaf',
                                  subtitle: 'Take a photo now',
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _ActionCard(
                                  icon: Icons.upload_outlined,
                                  title: 'Upload Image',
                                  subtitle: 'From gallery',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),
                          const Text(
                            'Recent Scans',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._recentScans.map(
                            (scan) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _RecentScanTile(scan: scan),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const _BottomNavigation(),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 241,
      decoration: const BoxDecoration(
        color: HomePage._darkTeal,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(44)),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.fromLTRB(42, 0, 42, 22),
      child: const Text(
        'Good Morning',
        style: TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
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
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFC2C2C2)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 37,
            height: 37,
            decoration: BoxDecoration(
              color: HomePage._teal.withValues(alpha: 0.32),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: HomePage._darkTeal, size: 15),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
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
    );
  }
}

class _RecentScanTile extends StatelessWidget {
  const _RecentScanTile({required this.scan});

  final _ScanItem scan;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCFCFCF)),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
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
      width: 39,
      height: 11,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scan.pillBackground,
        border: Border.all(color: scan.accent, width: 1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        scan.status,
        maxLines: 1,
        style: TextStyle(
          color: scan.accent,
          fontSize: 4.8,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 58,
        color: HomePage._pageBackground,
        padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 83,
              height: 40,
              decoration: BoxDecoration(
                color: HomePage._teal,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.home_outlined, color: Colors.white),
            ),
            const Icon(Icons.history_toggle_off, color: Colors.black, size: 25),
            const Icon(Icons.settings_outlined, color: Colors.black, size: 25),
          ],
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
    accent: Color(0xFF08B85F),
    accentBackground: Color(0xFFA8F6D6),
    pillBackground: Color(0xFFDDFBEA),
  ),
  _ScanItem(
    title: 'Blight - Early',
    subtitle: 'Scan #23 - 4 hrs ago',
    status: 'Early',
    accent: Color(0xFF9DAE00),
    accentBackground: Color(0xFFF0FF9F),
    pillBackground: Color(0xFFF5FFC2),
  ),
  _ScanItem(
    title: 'Leaf Spot - Severe',
    subtitle: 'Scan #20 - Yesterday',
    status: 'Severe',
    accent: Color(0xFFD81E3A),
    accentBackground: Color(0xFFFFB9C1),
    pillBackground: Color(0xFFFFCDD2),
  ),
  _ScanItem(
    title: 'Healthy Leaf',
    subtitle: 'Scan #15 - 2 Days ago',
    status: 'Healthy',
    accent: Color(0xFF08B85F),
    accentBackground: Color(0xFFA8F6D6),
    pillBackground: Color(0xFFDDFBEA),
  ),
  _ScanItem(
    title: 'Leaf Spot - Early',
    subtitle: 'Scan #23 - 3 Days ago',
    status: 'Early',
    accent: Color(0xFF9DAE00),
    accentBackground: Color(0xFFF0FF9F),
    pillBackground: Color(0xFFF5FFC2),
  ),
];
