import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import 'models/analysis_result_model.dart';

/// Thrown when the image does not appear to be a Buyo leaf.
class NotABuyoLeafException implements Exception {
  const NotABuyoLeafException({required this.confidence});

  /// The model's highest confidence score for any class (0.0–1.0).
  final double confidence;

  @override
  String toString() => 'NotABuyoLeafException(confidence: $confidence)';
}

class LeafAnalysisService {
  static const _modelPath = 'assets/models/piper_betle/buyo_model.tflite';
  static const _labelsPath = 'assets/models/piper_betle/labels.txt';
  static const _inputSize = 224;

  /// Minimum confidence required to accept an image as a Buyo leaf.
  /// Images whose top prediction scores below this are rejected.
  static const _confidenceThreshold = 0.65;

  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> initialize() async {
    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);
      _labels = await _loadLabels();
    } catch (e) {
      throw Exception('Failed to initialize model: $e');
    }
  }

  Future<List<String>> _loadLabels() async {
    final labelData = await rootBundle.loadString(_labelsPath);
    return labelData.split('\n').where((label) => label.isNotEmpty).toList();
  }

  Future<AnalysisResult> analyzeImage(String imagePath) async {
    if (_interpreter == null || _labels == null) {
      await initialize();
    }

    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    final decodedImage = img.decodeImage(imageBytes);

    if (decodedImage == null) {
      throw Exception('Failed to decode image');
    }

    final resizedImage = img.copyResize(
      decodedImage,
      width: _inputSize,
      height: _inputSize,
      interpolation: img.Interpolation.linear,
    );

    final input = _preprocessImage(resizedImage);
    final output = List.generate(1, (_) => List<double>.filled(_labels!.length, 0.0));

    _interpreter!.run(input, output);

    final outputValues = output[0];
    final maxIndex = outputValues.indexOf(outputValues.reduce((a, b) => a > b ? a : b));
    final confidence = outputValues[maxIndex];
    final classification = _labels![maxIndex];

    return AnalysisResult.fromClassification(
      imagePath,
      classification,
      confidence,
    );
  }

  Future<AnalysisResult> analyzeImageBytes(Uint8List imageBytes) async {
    if (_interpreter == null || _labels == null) {
      await initialize();
    }

    final decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) {
      throw Exception('Failed to decode image');
    }

    final resizedImage = img.copyResize(
      decodedImage,
      width: _inputSize,
      height: _inputSize,
      interpolation: img.Interpolation.linear,
    );

    final input = _preprocessImage(resizedImage);
    final output = List.generate(1, (_) => List<double>.filled(_labels!.length, 0.0));

    _interpreter!.run(input, output);

    final outputValues2 = output[0];
    final maxIndex2 = outputValues2.indexOf(outputValues2.reduce((a, b) => a > b ? a : b));
    final confidence2 = outputValues2[maxIndex2];
    final classification2 = _labels![maxIndex2];

    return AnalysisResult.fromClassification(
      'cropped-image',
      classification2,
      confidence2,
    );
  }

  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    // Ensure the image is in 8-bit format before processing.
    // This eliminates the ColorFloat32 branch entirely, so all pixels
    // are standard Color with channels in [0, 255] that we normalize to [0, 1].
    final rgbImage = image.format != img.Format.uint8
        ? image.convert(format: img.Format.uint8)
        : image;

    final input = List.generate(
      1,
      (i) => List.generate(
        _inputSize,
        (y) => List.generate(
          _inputSize,
          (x) => List.generate(
            3,
            (channel) {
              final pixel = rgbImage.getPixelSafe(x, y);
              // Normalize to [0.0, 1.0] — always divide by 255
              return switch (channel) {
                0 => (pixel.r / 255.0).clamp(0.0, 1.0),
                1 => (pixel.g / 255.0).clamp(0.0, 1.0),
                2 => (pixel.b / 255.0).clamp(0.0, 1.0),
                _ => 0.0,
              };
            },
          ),
        ),
      ),
    );

    return input;
  }

  void dispose() {
    _interpreter?.close();
  }
}