import 'package:flutter/material.dart';

import '../../../shared/theme/app_theme_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  static const _teal = Color(0xFF10BC97);
  static const _darkTeal = Color(0xFF078F78);

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  bool get _isDarkMode => themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return ColoredBox(
      color: colors.pageBackground,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _SettingsHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(30, 24, 30, 28),
            sliver: SliverList.list(
              children: [
                _SettingsCard(
                  color: colors.card,
                  borderColor: colors.cardBorder,
                  child: Row(
                    children: [
                      const _IconBadge(icon: Icons.dark_mode_outlined),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dark Mode',
                              style: _titleStyle(colors.textPrimary),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Switch between light and dark appearance.',
                              style: _bodyStyle(colors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isDarkMode,
                        activeThumbColor: _teal,
                        onChanged: (enabled) {
                          onThemeModeChanged(
                            enabled ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _SettingsCard(
                  color: colors.card,
                  borderColor: colors.cardBorder,
                  child: _InfoSection(
                    icon: Icons.info_outline,
                    title: 'About Application',
                    textColor: colors.textPrimary,
                    bodyColor: colors.textSecondary,
                    children: const [
                      'BUYO is a mobile assistant for image-based Buyo leaf disease screening. It lets users capture or upload a leaf image, review scan history, and inspect classification results.',
                      'Study: Image-Based Classification and Severity Assessment of Buyo (Piper betle Linn) Leaf Diseases Using a Custom Convolutional Neural Network.',
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _SettingsCard(
                  color: colors.card,
                  borderColor: colors.cardBorder,
                  child: _InfoSection(
                    icon: Icons.eco_outlined,
                    title: 'About Piper Betle',
                    textColor: colors.textPrimary,
                    bodyColor: colors.textSecondary,
                    children: const [
                      'Piper betle Linn, locally known as Buyo, is a climbing vine whose leaves are widely used in South and Southeast Asian traditional practices.',
                      'Leaves are commonly used fresh, as herbal preparations, and in cultural chewing practices. This app focuses on the health of the leaf crop, not on recommending medicinal use.',
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _SettingsCard(
                  color: colors.card,
                  borderColor: colors.cardBorder,
                  child: _BulletSection(
                    icon: Icons.healing_outlined,
                    title: 'Traditional Uses and Possible Benefits',
                    textColor: colors.textPrimary,
                    bodyColor: colors.textSecondary,
                    bullets: const [
                      'Used traditionally for mouth freshness, wound care, digestion, and soothing minor discomforts.',
                      'Research reviews report antimicrobial, antioxidant, and anti-inflammatory potential in leaf extracts.',
                      'Some communities prepare leaves as teas, poultices, or topical herbal applications.',
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _SettingsCard(
                  color: colors.card,
                  borderColor: colors.cardBorder,
                  child: _BulletSection(
                    icon: Icons.warning_amber_rounded,
                    title: 'Limitations and Safety Notes',
                    textColor: colors.textPrimary,
                    bodyColor: colors.textSecondary,
                    bullets: const [
                      'Herbal use should not replace professional medical care.',
                      'Betel quid chewing, especially with areca nut or tobacco, is linked to serious oral health risks.',
                      'Possible concerns include irritation, allergies, contamination, and unknown interactions with medicines.',
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static TextStyle _titleStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.w900,
      letterSpacing: 0,
    );
  }

  static TextStyle _bodyStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.35,
      letterSpacing: 0,
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      color: SettingsPage._darkTeal,
      child: const SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 22),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.color,
    required this.borderColor,
    required this.child,
  });

  final Color color;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(18),
      child: child,
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: SettingsPage._teal.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, color: SettingsPage._darkTeal, size: 26),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.icon,
    required this.title,
    required this.textColor,
    required this.bodyColor,
    required this.children,
  });

  final IconData icon;
  final String title;
  final Color textColor;
  final Color bodyColor;
  final List<String> children;

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      icon: icon,
      title: title,
      textColor: textColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
            .map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Text(text, style: SettingsPage._bodyStyle(bodyColor)),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _BulletSection extends StatelessWidget {
  const _BulletSection({
    required this.icon,
    required this.title,
    required this.textColor,
    required this.bodyColor,
    required this.bullets,
  });

  final IconData icon;
  final String title;
  final Color textColor;
  final Color bodyColor;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      icon: icon,
      title: title,
      textColor: textColor,
      child: Column(
        children: bullets.map((bullet) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6, right: 10),
                  decoration: const BoxDecoration(
                    color: SettingsPage._teal,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    bullet,
                    style: SettingsPage._bodyStyle(bodyColor),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SectionFrame extends StatelessWidget {
  const _SectionFrame({
    required this.icon,
    required this.title,
    required this.textColor,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Color textColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _IconBadge(icon: icon),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title, style: SettingsPage._titleStyle(textColor)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}
