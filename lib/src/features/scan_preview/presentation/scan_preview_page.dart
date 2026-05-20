import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/app_routes.dart';
import '../../../features/analysis/presentation/analysis_result_page.dart';
import '../../../shared/services/leaf_analysis_service.dart';
import '../../../shared/theme/app_theme_colors.dart';

class ScanPreviewArguments {
  const ScanPreviewArguments({required this.image, required this.sourceLabel});

  final XFile image;
  final String sourceLabel;
}

class ScanPreviewPage extends StatefulWidget {
  const ScanPreviewPage({super.key, required this.arguments});

  final ScanPreviewArguments arguments;

  @override
  State<ScanPreviewPage> createState() => _ScanPreviewPageState();
}

class _ScanPreviewPageState extends State<ScanPreviewPage> {
  late final Future<Uint8List> _imageBytes;

  @override
  void initState() {
    super.initState();
    _imageBytes = widget.arguments.image.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _PreviewHeader(sourceLabel: widget.arguments.sourceLabel),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ImagePreview(imageBytes: _imageBytes),
                    const SizedBox(height: 18),
                    _ScanReadinessPanel(fileName: widget.arguments.image.name),
                  ],
                ),
              ),
            ),
            _ContinueBar(image: widget.arguments.image, imageBytes: _imageBytes),
          ],
        ),
      ),
    );
  }
}

class _PreviewHeader extends StatelessWidget {
  const _PreviewHeader({required this.sourceLabel});

  final String sourceLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 24, 12),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).pop(false),
            icon: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preview Scan',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  sourceLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.imageBytes});

  final Future<Uint8List> imageBytes;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return AspectRatio(
      aspectRatio: 0.78,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.card,
          border: Border.all(color: colors.cardBorder, width: 2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: FutureBuilder<Uint8List>(
            future: imageBytes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.memory(snapshot.data!, fit: BoxFit.cover);
              }

              if (snapshot.hasError) {
                return const _PreviewMessage(
                  icon: Icons.broken_image_outlined,
                  title: 'Image unavailable',
                  subtitle: 'Please go back and choose another leaf image.',
                );
              }

              return const _PreviewMessage(
                icon: Icons.image_search_outlined,
                title: 'Loading image',
                subtitle: 'Preparing your leaf preview.',
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PreviewMessage extends StatelessWidget {
  const _PreviewMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: colors.darkTeal, size: 42),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanReadinessPanel extends StatelessWidget {
  const _ScanReadinessPanel({required this.fileName});

  final String fileName;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: colors.card,
        border: Border.all(color: colors.cardBorder, width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.teal.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.eco_outlined, color: colors.darkTeal, size: 25),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready to scan',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  fileName.isEmpty ? 'Selected leaf image' : fileName,
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
        ],
      ),
    );
  }
}

class _ContinueBar extends StatefulWidget {
  const _ContinueBar({required this.image, required this.imageBytes});

  final XFile image;
  final Future<Uint8List> imageBytes;

  @override
  State<_ContinueBar> createState() => _ContinueBarState();
}

class _ContinueBarState extends State<_ContinueBar> {
  bool _isAnalyzing = false;

  Future<void> _performAnalysis() async {
    setState(() => _isAnalyzing = true);

    try {
      final service = LeafAnalysisService();
      await service.initialize();

      final result = await service.analyzeImage(widget.image.path);
      final imageBytes = await widget.imageBytes;

      if (!mounted) return;

      await Navigator.of(context).pushNamed<void>(
        AppRoutes.analysisResult,
        arguments: AnalysisResultArguments(
          result: result,
          imageBytes: imageBytes,
        ),
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Analysis failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
      decoration: BoxDecoration(
        color: colors.navBackground,
        border: Border(top: BorderSide(color: colors.navBorder, width: 1)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton.icon(
          onPressed: _isAnalyzing ? null : _performAnalysis,
          icon: _isAnalyzing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.arrow_forward_rounded, size: 21),
          label: Text(_isAnalyzing ? 'Analyzing...' : 'Continue'),
          style: FilledButton.styleFrom(
            backgroundColor: colors.darkTeal,
            foregroundColor: Colors.white,
            disabledBackgroundColor: colors.darkTeal.withValues(alpha: 0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}
