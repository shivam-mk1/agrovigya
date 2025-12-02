import 'package:flutter/foundation.dart';

class LaborEstimationService {
  // Scaling factors for farm sizes
  final Map<String, double> scalingFactors = {
    "small": 1.0,
    "medium": 2.5,
    "large": 4.5,
    "xlarge": 6.0
  };

  // Efficiency factors for farm sizes
  final Map<String, double> efficiencyFactors = {
    "small": 1.0,
    "medium": 0.95,
    "large": 0.9,
    "xlarge": 0.85
  };

  // Base labor requirements per crop type (per hectare)
  final Map<String, double> baseLaborRequirements = {
    "Vegetable": 32.0,
    "Fruit": 40.0,
    "Grain": 25.0,
    "Pulse": 28.0
  };

  // Season factors
  final Map<String, double> seasonFactors = {
    "Spring": 1.0,
    "Summer": 1.1,
    "Fall": 0.95,
    "Winter": 0.9
  };

  // Crop name to crop type mapping
  final Map<String, String> cropTypeMap = {
    'Tomato': 'Vegetable',
    'Potato': 'Vegetable',
    'Onion': 'Vegetable',
    'Wheat': 'Grain',
    'Rice': 'Grain',
    'Corn': 'Grain',
    'Chickpea': 'Pulse',
    'Soybean': 'Pulse',
    'Apple': 'Fruit',
    'Banana': 'Fruit',
    'Mango': 'Fruit'
  };

  String getFarmSizeCategory(double area) {
    if (area <= 1) {
      return "small";
    } else if (area <= 3) {
      return "medium";
    } else if (area <= 5) {
      return "large";
    } else {
      return "xlarge";
    }
  }

  Future<void> loadModels() async {
    // No models to load, this is a simplified version
    return;
  }

  Future<double> estimateLaborDemand(
      String cropType, double area, String season) async {
    // Get base labor requirement for this crop type
    double baseLabor = baseLaborRequirements[cropType] ?? 30.0;

    // Apply season factor
    double seasonFactor = seasonFactors[season] ?? 1.0;

    // Apply farm size efficiency
    String farmSize = getFarmSizeCategory(area);
    double efficiency = efficiencyFactors[farmSize] ?? 1.0;

    // Calculate total labor demand
    return baseLabor * area * seasonFactor * efficiency;
  }

  Future<Map<String, dynamic>> estimateCost(
      String cropName,
      String cropType,
      double area,
      String wageType,
      String season,
      double govtWage,
      double expectedWage) async {
    try {
      // Estimate labor demand
      double laborDemand = await estimateLaborDemand(cropType, area, season);
      double laborPerHa = area > 0 ? laborDemand / area : 0;

      // Calculate cost based on wage type
      double wage = wageType == 'Govt' ? govtWage : expectedWage;
      double costPerHa = laborPerHa * wage;
      double totalCost = costPerHa * area;

      return {
        "crop": cropName,
        "area": area,
        "season": season,
        "wage_type": wageType,
        "total_cost": totalCost.round().toDouble(),
        "cost_per_ha": costPerHa.round().toDouble(),
        "labor_demand": laborDemand.round()
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error in estimation: $e');
      }
      rethrow;
    }
  }

  String getCropTypeForCrop(String cropName) {
    return cropTypeMap[cropName] ?? 'Vegetable';
  }

  void dispose() {
    // Nothing to dispose in the simplified version
  }
}
