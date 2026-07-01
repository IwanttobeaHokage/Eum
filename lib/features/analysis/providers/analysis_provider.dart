import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/analysis.dart';
import '../../../data/models/recommendation.dart';
import '../../../data/mock/mock_data.dart';

final analysisProvider = Provider<Analysis>((ref) => mockAnalysis);

final recommendationProvider =
    Provider<Recommendation>((ref) => mockRecommendation);
