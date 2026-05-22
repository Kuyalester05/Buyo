import 'dart:typed_data';

class SavedScan {
  SavedScan({
    this.id,
    required this.imagePath,
    required this.imageBytes,
    required this.diseaseName,
    required this.severityLevel,
    required this.confidence,
    required this.classification,
    required this.recommendations,
    required this.actionNeeded,
    required this.accentColor,
    required this.createdAt,
  });

  final int? id;
  final String imagePath;
  final Uint8List imageBytes;
  final String diseaseName;
  final String severityLevel;
  final double confidence;
  final String classification;
  final String recommendations;
  final String actionNeeded;
  final int accentColor;
  final DateTime createdAt;

  SavedScan copyWith({
    int? id,
    String? imagePath,
    Uint8List? imageBytes,
    String? diseaseName,
    String? severityLevel,
    double? confidence,
    String? classification,
    String? recommendations,
    String? actionNeeded,
    int? accentColor,
    DateTime? createdAt,
  }) {
    return SavedScan(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      imageBytes: imageBytes ?? this.imageBytes,
      diseaseName: diseaseName ?? this.diseaseName,
      severityLevel: severityLevel ?? this.severityLevel,
      confidence: confidence ?? this.confidence,
      classification: classification ?? this.classification,
      recommendations: recommendations ?? this.recommendations,
      actionNeeded: actionNeeded ?? this.actionNeeded,
      accentColor: accentColor ?? this.accentColor,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'diseaseName': diseaseName,
      'severityLevel': severityLevel,
      'confidence': confidence,
      'classification': classification,
      'recommendations': recommendations,
      'actionNeeded': actionNeeded,
      'accentColor': accentColor,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SavedScan.fromMap(Map<String, dynamic> map, Uint8List imageBytes) {
    return SavedScan(
      id: map['id'] as int?,
      imagePath: map['imagePath'] as String,
      imageBytes: imageBytes,
      diseaseName: map['diseaseName'] as String,
      severityLevel: map['severityLevel'] as String,
      confidence: map['confidence'] as double,
      classification: map['classification'] as String,
      recommendations: map['recommendations'] as String,
      actionNeeded: map['actionNeeded'] as String,
      accentColor: map['accentColor'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
