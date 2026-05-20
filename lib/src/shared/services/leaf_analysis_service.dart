import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import 'models/analysis_result_model.dart';

class LeafAnalysisService {
  static const _modelPath = 'assets/models/piper_betle/buyo_model.tflite';
  static const _labelsPath = 'assets/models/piper_betle/labels.txt';
  static const _inputSize = 224;

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
    );

    final input = _preprocessImage(resizedImage);
    final output = List<double>.filled(_labels!.length, 0.0);

    _interpreter!.run(input, output);

    final maxIndex = output.indexOf(output.reduce((a, b) => a > b ? a : b));
    final confidence = output[maxIndex];
    final classification = _labels![maxIndex];

    return AnalysisResult.fromClassification(
      imagePath,
      classification,
      confidence,
    );
  }

  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    final input = List.generate(
      1,
      (i) => List.generate(
        _inputSize,
        (j) => List.generate(
          _inputSize,
          (k) => List.generate(
            3,
            (l) {
              final pixel = image.getPixelSafe(k, j);
              double value = 0;

              if (pixel is img.ColorFloat32) {
                value = switch (l) {
                  0 => (pixel.r).toDouble(),
                  1 => (pixel.g).toDouble(),
                  2 => (pixel.b).toDouble(),
                  _ => 0.0,
                };
              } else {
                final color = pixel as img.Color;
                value = switch (l) {
                  0 => (color.r / 255.0).toDouble(),
                  1 => (color.g / 255.0).toDouble(),
                  2 => (color.b / 255.0).toDouble(),
                  _ => 0.0,
                };
              }

              return value;
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
