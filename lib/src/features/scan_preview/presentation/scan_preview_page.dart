import 'dart:typed_data';
import 'dart:ui' as ui;

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
  late final Future<Uint8List> _imageBytesFuture;
  Uint8List? _currentImageBytes;

  @override
  void initState() {
    super.initState();
    _imageBytesFuture = widget.arguments.image.readAsBytes();
    _imageBytesFuture.then((bytes) {
      if (!mounted) return;
      setState(() => _currentImageBytes = bytes);
    });
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
                    _ImagePreview(
                      imageBytes: _currentImageBytes,
                      imageFuture: _imageBytesFuture,
                    ),
                    const SizedBox(height: 18),
                    _CropHint(onCropPressed: _cropImage, enabled: _currentImageBytes != null),
                    _ScanReadinessPanel(fileName: widget.arguments.image.name),
                  ],
                ),
              ),
            ),
            _ContinueBar(
              image: widget.arguments.image,
              imageBytesFuture: _imageBytesFuture,
              currentImageBytes: _currentImageBytes,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    final navigator = Navigator.of(context);
    final bytes = _currentImageBytes ?? await _imageBytesFuture;
    final croppedBytes = await navigator.push<Uint8List?>(
      MaterialPageRoute(
        builder: (_) => _CropImagePage(imageBytes: bytes),
      ),
    );
    if (croppedBytes == null || !mounted) return;
    setState(() => _currentImageBytes = croppedBytes);
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
  const _ImagePreview({required this.imageBytes, required this.imageFuture});

  final Uint8List? imageBytes;
  final Future<Uint8List> imageFuture;

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
              future: imageFuture,
              builder: (context, snapshot) {
                final displayBytes = imageBytes ?? snapshot.data;
                if (displayBytes != null) {
                  return Image.memory(displayBytes, fit: BoxFit.cover);
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

class _CropHint extends StatelessWidget {
  const _CropHint({required this.onCropPressed, required this.enabled});

  final VoidCallback onCropPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Material(
      color: colors.card,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: enabled ? onCropPressed : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: colors.card,
            border: Border.all(color: colors.cardBorder, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(Icons.crop_free_outlined, color: colors.darkTeal, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Crop image when the leaf is slightly far or has extra background.',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: enabled ? colors.darkTeal : colors.textSecondary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CropImagePage extends StatefulWidget {
  const _CropImagePage({required this.imageBytes});

  final Uint8List imageBytes;

  @override
  State<_CropImagePage> createState() => _CropImagePageState();
}

class _CropImagePageState extends State<_CropImagePage> {
  late Offset _cropStart;
  late Offset _cropEnd;
  bool _isCropping = false;

  @override
  void initState() {
    super.initState();
    _cropStart = const Offset(0.2, 0.2);
    _cropEnd = const Offset(0.8, 0.8);
  }

  void _updateCropArea(Offset newStart, Offset newEnd) {
    setState(() {
      _cropStart = Offset(
        newStart.dx.clamp(0.0, 1.0),
        newStart.dy.clamp(0.0, 1.0),
      );
      _cropEnd = Offset(
        newEnd.dx.clamp(0.0, 1.0),
        newEnd.dy.clamp(0.0, 1.0),
      );
    });
  }

  Future<void> _performCrop() async {
    setState(() => _isCropping = true);

    try {
      final image = await _decodeCropImage(
        widget.imageBytes,
        _cropStart,
        _cropEnd,
      );
      if (!mounted) return;
      Navigator.of(context).pop(image);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCropping = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Crop failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Scaffold(
      backgroundColor: colors.pageBackground,
      appBar: AppBar(
        backgroundColor: colors.pageBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.textPrimary),
        title: Text('Crop image', style: TextStyle(color: colors.textPrimary)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Image.memory(widget.imageBytes, fit: BoxFit.cover),
                _CropOverlay(
                  cropStart: _cropStart,
                  cropEnd: _cropEnd,
                  onCropUpdate: _updateCropArea,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _isCropping ? null : _performCrop,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.darkTeal,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: colors.darkTeal.withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isCropping ? 'Processing...' : 'Crop',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _decodeCropImage(
    Uint8List imageBytes,
    Offset start,
    Offset end,
  ) async {
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final width = (image.width * (end.dx - start.dx)).toInt();
    final height = (image.height * (end.dy - start.dy)).toInt();
    final x = (image.width * start.dx).toInt();
    final y = (image.height * start.dy).toInt();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(x.toDouble(), y.toDouble(), width.toDouble(), height.toDouble()),
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      Paint(),
    );

    final picture = recorder.endRecording();
    final croppedImage = await picture.toImage(width, height);
    final byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}

class _CropOverlay extends StatefulWidget {
  const _CropOverlay({
    required this.cropStart,
    required this.cropEnd,
    required this.onCropUpdate,
  });

  final Offset cropStart;
  final Offset cropEnd;
  final Function(Offset, Offset) onCropUpdate;

  @override
  State<_CropOverlay> createState() => _CropOverlayState();
}

class _CropOverlayState extends State<_CropOverlay> {
  String? _dragHandle;

  void _onPanDown(TapDownDetails details, Size size) {
    final pos = Offset(
      details.localPosition.dx / size.width,
      details.localPosition.dy / size.height,
    );

    const handleSize = 0.05;
    final startX = widget.cropStart.dx;
    final startY = widget.cropStart.dy;
    final endX = widget.cropEnd.dx;
    final endY = widget.cropEnd.dy;

    if ((pos.dx - startX).abs() < handleSize && (pos.dy - startY).abs() < handleSize) {
      _dragHandle = 'topLeft';
    } else if ((pos.dx - endX).abs() < handleSize && (pos.dy - startY).abs() < handleSize) {
      _dragHandle = 'topRight';
    } else if ((pos.dx - startX).abs() < handleSize && (pos.dy - endY).abs() < handleSize) {
      _dragHandle = 'bottomLeft';
    } else if ((pos.dx - endX).abs() < handleSize && (pos.dy - endY).abs() < handleSize) {
      _dragHandle = 'bottomRight';
    } else if ((pos.dx - startX).abs() < handleSize && pos.dy > startY && pos.dy < endY) {
      _dragHandle = 'left';
    } else if ((pos.dx - endX).abs() < handleSize && pos.dy > startY && pos.dy < endY) {
      _dragHandle = 'right';
    } else if ((pos.dy - startY).abs() < handleSize && pos.dx > startX && pos.dx < endX) {
      _dragHandle = 'top';
    } else if ((pos.dy - endY).abs() < handleSize && pos.dx > startX && pos.dx < endX) {
      _dragHandle = 'bottom';
    }
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    if (_dragHandle == null) return;

    final delta = Offset(
      details.delta.dx / size.width,
      details.delta.dy / size.height,
    );

    var newStart = widget.cropStart;
    var newEnd = widget.cropEnd;

    switch (_dragHandle) {
      case 'topLeft':
        newStart = newStart + delta;
        break;
      case 'topRight':
        newStart = Offset(newStart.dx, newStart.dy + delta.dy);
        newEnd = Offset(newEnd.dx + delta.dx, newEnd.dy);
        break;
      case 'bottomLeft':
        newStart = Offset(newStart.dx + delta.dx, newStart.dy);
        newEnd = Offset(newEnd.dx, newEnd.dy + delta.dy);
        break;
      case 'bottomRight':
        newEnd = newEnd + delta;
        break;
      case 'left':
        newStart = Offset(newStart.dx + delta.dx, newStart.dy);
        break;
      case 'right':
        newEnd = Offset(newEnd.dx + delta.dx, newEnd.dy);
        break;
      case 'top':
        newStart = Offset(newStart.dx, newStart.dy + delta.dy);
        break;
      case 'bottom':
        newEnd = Offset(newEnd.dx, newEnd.dy + delta.dy);
        break;
    }

    if (newStart.dx < newEnd.dx && newStart.dy < newEnd.dy) {
      widget.onCropUpdate(newStart, newEnd);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final startPx = Offset(
          widget.cropStart.dx * size.width,
          widget.cropStart.dy * size.height,
        );
        final endPx = Offset(
          widget.cropEnd.dx * size.width,
          widget.cropEnd.dy * size.height,
        );

        return MouseRegion(
          cursor: SystemMouseCursors.basic,
          child: GestureDetector(
            onTapDown: (details) => _onPanDown(details, size),
            onPanUpdate: (details) => _onPanUpdate(details, size),
            child: CustomPaint(
              painter: _CropPainter(
                startPx: startPx,
                endPx: endPx,
              ),
              size: size,
            ),
          ),
        );
      },
    );
  }
}

class _CropPainter extends CustomPainter {
  _CropPainter({required this.startPx, required this.endPx});

  final Offset startPx;
  final Offset endPx;

  @override
  void paint(Canvas canvas, Size size) {
    const darkOverlay = Color.fromARGB(140, 0, 0, 0);
    const gridColor = Color.fromARGB(100, 255, 255, 255);
    const borderColor = Color.fromARGB(255, 0, 150, 136);
    const handleColor = Color.fromARGB(255, 0, 150, 136);

    // Draw dark overlay outside crop area
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = darkOverlay);

    // Draw bright crop area by clearing overlay inside
    canvas.save();
    canvas.clipRect(Rect.fromPoints(startPx, endPx));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.transparent);
    canvas.restore();

    // Draw border with glow effect
    const borderWidth = 2.5;

    // Glow effect
    canvas.drawRect(
      Rect.fromPoints(startPx, endPx),
      Paint()
        ..color = borderColor.withValues(alpha: 0.3)
        ..strokeWidth = borderWidth + 4
        ..style = PaintingStyle.stroke,
    );

    // Main border
    canvas.drawRect(
      Rect.fromPoints(startPx, endPx),
      Paint()
        ..color = borderColor
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke,
    );

    // Draw grid
    _drawGrid(canvas, startPx, endPx, gridColor);

    // Draw handles
    _drawHandles(canvas, startPx, endPx, handleColor);
  }

  void _drawGrid(Canvas canvas, Offset start, Offset end, Color color) {
    final paint = Paint()..color = color..strokeWidth = 1;

    for (int i = 1; i < 3; i++) {
      final x = start.dx + (end.dx - start.dx) * i / 3;
      canvas.drawLine(Offset(x, start.dy), Offset(x, end.dy), paint);

      final y = start.dy + (end.dy - start.dy) * i / 3;
      canvas.drawLine(Offset(start.dx, y), Offset(end.dx, y), paint);
    }
  }

  void _drawHandles(Canvas canvas, Offset start, Offset end, Color color) {
    const cornerHandleSize = 20.0;
    const sideHandleSize = 16.0;

    // Corner handles
    final corners = [start, Offset(end.dx, start.dy), Offset(start.dx, end.dy), end];
    for (final corner in corners) {
      _drawCornerHandle(canvas, corner, cornerHandleSize, color);
    }

    // Side handles
    final sideHandles = [
      Offset((start.dx + end.dx) / 2, start.dy),
      Offset((start.dx + end.dx) / 2, end.dy),
      Offset(start.dx, (start.dy + end.dy) / 2),
      Offset(end.dx, (start.dy + end.dy) / 2),
    ];
    for (final handle in sideHandles) {
      _drawSideHandle(canvas, handle, sideHandleSize, color);
    }
  }

  void _drawCornerHandle(Canvas canvas, Offset pos, double size, Color color) {
    const borderWidth = 2.5;

    // Outer glow
    canvas.drawCircle(
      pos,
      size / 2 + 2,
      Paint()
        ..color = color.withValues(alpha: 0.2)
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke,
    );

    // Fill
    canvas.drawCircle(pos, size / 2, Paint()..color = color);

    // Border
    canvas.drawCircle(
      pos,
      size / 2,
      Paint()
        ..color = Colors.white
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawSideHandle(Canvas canvas, Offset pos, double size, Color color) {
    const borderWidth = 2.0;
    final rect = Rect.fromCenter(center: pos, width: size, height: size);

    // Outer glow
    final glowRect = Rect.fromCenter(center: pos, width: size + 4, height: size + 4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(glowRect, const Radius.circular(3)),
      Paint()
        ..color = color.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );

    // Fill
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      Paint()..color = color,
    );

    // Border
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      Paint()
        ..color = Colors.white
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_CropPainter oldDelegate) =>
      oldDelegate.startPx != startPx || oldDelegate.endPx != endPx;
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
  const _ContinueBar({
    required this.image,
    required this.imageBytesFuture,
    required this.currentImageBytes,
  });

  final XFile image;
  final Future<Uint8List> imageBytesFuture;
  final Uint8List? currentImageBytes;

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

      final imageBytes = widget.currentImageBytes ?? await widget.imageBytesFuture;
      final result = await service.analyzeImageBytes(imageBytes);

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
