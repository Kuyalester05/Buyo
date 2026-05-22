import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../shared/services/models/saved_scan_model.dart';
import '../../../shared/theme/app_theme_colors.dart';

class ScanDetailPage extends StatelessWidget {
  const ScanDetailPage({super.key, required this.scan});

  final SavedScan scan;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final accentColor = Color(scan.accentColor);
    final recommendations = scan.recommendations.split('|||');

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _DetailHeader(title: 'Scan Details'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _ImagePreview(imageBytes: scan.imageBytes),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _ClassificationTitle(
                            diseaseName: scan.diseaseName,
                            severityLevel: scan.severityLevel,
                            confidence: scan.confidence,
                            accentColor: accentColor,
                          ),
                          const SizedBox(height: 12),
                          _ConfidenceCard(
                            confidence: scan.confidence,
                            accentColor: accentColor,
                          ),
                          const SizedBox(height: 20),
                          _DetailGrid(
                            diseaseName: scan.diseaseName,
                            severityLevel: scan.severityLevel,
                            actionNeeded: scan.actionNeeded,
                            accentColor: accentColor,
                          ),
                          const SizedBox(height: 24),
                          _DateCard(
                            createdAt: scan.createdAt,
                          ),
                          const SizedBox(height: 24),
                          _RecommendationsCard(
                            recommendations: recommendations,
                            accentColor: accentColor,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 24, 12),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
                height: 1.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.imageBytes});

  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AspectRatio(
        aspectRatio: 0.78,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.card,
            border: Border.all(color: colors.cardBorder, width: 2),
            borderRadius: BorderRadius.circular(18),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.memory(imageBytes, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

class _ClassificationTitle extends StatelessWidget {
  const _ClassificationTitle({
    required this.diseaseName,
    required this.severityLevel,
    required this.confidence,
    required this.accentColor,
  });

  final String diseaseName;
  final String severityLevel;
  final double confidence;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                diseaseName,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: accentColor, width: 1.5),
              ),
              child: Text(
                severityLevel,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Classification completed · ${(confidence * 100).toStringAsFixed(1)}% confidence',
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ConfidenceCard extends StatelessWidget {
  const _ConfidenceCard({
    required this.confidence,
    required this.accentColor,
  });

  final double confidence;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final percentage = (confidence * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        border: Border.all(color: colors.cardBorder, width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Classification Confidence',
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$percentage%',
                style: TextStyle(
                  color: accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: confidence,
              minHeight: 8,
              backgroundColor: accentColor.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailGrid extends StatelessWidget {
  const _DetailGrid({
    required this.diseaseName,
    required this.severityLevel,
    required this.actionNeeded,
    required this.accentColor,
  });

  final String diseaseName;
  final String severityLevel;
  final String actionNeeded;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Row(
      children: [
        Expanded(
          child: _DetailItem(
            label: 'Disease Type',
            value: diseaseName,
            colors: colors,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DetailItem(
            label: 'Severity Level',
            value: severityLevel,
            colors: colors,
            isHighlight: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DetailItem(
            label: 'Action Needed',
            value: actionNeeded,
            colors: colors,
            accentColor: accentColor,
          ),
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({
    required this.label,
    required this.value,
    required this.colors,
    this.isHighlight = false,
    this.accentColor,
  });

  final String label;
  final String value;
  final AppThemeColors colors;
  final bool isHighlight;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.card,
        border: Border.all(color: colors.cardBorder, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: accentColor ?? colors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: isHighlight ? 0.5 : 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  const _DateCard({required this.createdAt});

  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        border: Border.all(color: colors.cardBorder, width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scan Date',
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatDateTime(createdAt),
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final scanDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (scanDate == today) {
      return 'Today at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (scanDate == yesterday) {
      return 'Yesterday at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}

class _RecommendationsCard extends StatelessWidget {
  const _RecommendationsCard({
    required this.recommendations,
    required this.accentColor,
  });

  final List<String> recommendations;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: accentColor, size: 20),
              const SizedBox(width: 10),
              Text(
                'Recommendations',
                style: TextStyle(
                  color: accentColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...recommendations.map(
            (rec) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Icon(Icons.circle, size: 6, color: accentColor),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      rec,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
