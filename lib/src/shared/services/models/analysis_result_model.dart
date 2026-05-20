class AnalysisResult {
  AnalysisResult({
    required this.imagePath,
    required this.classification,
    required this.confidence,
    required this.diseaseName,
    required this.severityLevel,
    required this.recommendations,
    required this.actionNeeded,
    required this.accentColor,
  });

  final String imagePath;
  final String classification;
  final double confidence;
  final String diseaseName;
  final String severityLevel;
  final List<String> recommendations;
  final String actionNeeded;
  final int accentColor;

  factory AnalysisResult.fromClassification(
    String imagePath,
    String classification,
    double confidence,
  ) {
    final Map<String, (String, String, String, String, List<String>)> diseaseData = {
      'Blight_Early': (
        'Blight',
        'Early',
        'Moderate',
        'Early',
        [
          'Remove and dispose infected leaves carefully to limit spread.',
          'Apply copper-based fungicide to affected plants promptly.',
          'Avoid overhead watering; improve air circulation.',
          'Monitor remaining leaves daily for further progression.',
        ],
      ),
      'Blight_Severe': (
        'Blight',
        'Severe',
        'Critical',
        'Severe',
        [
          'Isolate affected plants immediately to prevent spread.',
          'Remove entire plant or severely affected portions.',
          'Apply systemic fungicides as recommended by specialist.',
          'Ensure proper soil drainage and avoid plant stress.',
          'Consider crop rotation strategy for next planting.',
        ],
      ),
      'Healthy': (
        'Healthy Leaf',
        'N/A',
        'Optimal',
        'None',
        [
          'Continue regular monitoring schedule.',
          'Maintain consistent watering and fertilization.',
          'Ensure good air circulation around plants.',
          'Check for any early signs of disease weekly.',
        ],
      ),
      'LeafSpot_Early': (
        'Leaf Spot',
        'Early',
        'Moderate',
        'Early',
        [
          'Remove affected leaves and dispose properly.',
          'Apply fungicide spray to remaining foliage.',
          'Increase air circulation around plants.',
          'Reduce leaf wetness; water at soil level.',
          'Monitor progression closely over next week.',
        ],
      ),
      'LeafSpot_Severe': (
        'Leaf Spot',
        'Severe',
        'Critical',
        'Severe',
        [
          'Prune severely affected branches and leaves.',
          'Apply strong fungicide treatments immediately.',
          'Improve drainage and reduce humidity.',
          'Remove fallen leaves from ground immediately.',
          'Consider professional agricultural consultation.',
        ],
      ),
    };

    final data = diseaseData[classification] ?? ('Unknown', 'Unknown', 'Unknown', 'Unknown', []);

    return AnalysisResult(
      imagePath: imagePath,
      classification: classification,
      confidence: confidence,
      diseaseName: data.$1,
      severityLevel: data.$2,
      recommendations: data.$5,
      actionNeeded: data.$4,
      accentColor: _getColorForClassification(classification),
    );
  }

  static int _getColorForClassification(String classification) {
    switch (classification) {
      case 'Healthy':
        return 0xFF00BD62;
      case 'Blight_Early':
      case 'LeafSpot_Early':
        return 0xFFC2A100;
      case 'Blight_Severe':
      case 'LeafSpot_Severe':
        return 0xFFFF174A;
      default:
        return 0xFF10BC97;
    }
  }
}
