
class CropRecommendationService {
  static final CropRecommendationService _instance =
      CropRecommendationService._internal();

  factory CropRecommendationService() => _instance;

  CropRecommendationService._internal();

  // Keep the mapping from model output indices to crop names
  final List<String> _cropLabels = [
    'apple',
    'banana',
    'blackgram',
    'chickpea',
    'coconut',
    'coffee',
    'cotton',
    'grapes',
    'jute',
    'kidneybeans',
    'lentil',
    'maize',
    'mango',
    'mothbeans',
    'mungbean',
    'muskmelon',
    'orange',
    'papaya',
    'pigeonpeas',
    'pomegranate',
    'rice',
    'watermelon'
  ];

  Future<String> predictCrop({
    required double nitrogen,
    required double phosphorus,
    required double potassium,
    required double temperature,
    required double humidity,
    required double ph,
    required double rainfall,
  }) async {
    // Dummy implementation
    await Future.delayed(const Duration(seconds: 1));
    // Return a default crop for now
    return _cropLabels[0];
  }

  void dispose() {
    // No-op
  }
}