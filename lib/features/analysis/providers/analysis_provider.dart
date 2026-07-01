import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/analysis.dart';
import '../../../data/models/content_item.dart';
import '../../../data/models/recommendation.dart';
import '../../../data/repositories/content_repository.dart';

final analysisProvider = Provider<Analysis>((ref) => mockAnalysis);

// 전체 콘텐츠 라이브러리 (JSON에서 로드)
final contentLibraryProvider = FutureProvider<List<ContentItem>>((ref) {
  return ContentRepository.loadAll();
});

// 현재 분석 결과에 맞춘 추천 (실제 JSON 콘텐츠 기반)
final recommendationProvider = FutureProvider<Recommendation>((ref) async {
  final analysis = ref.watch(analysisProvider);
  final allContent = await ref.watch(contentLibraryProvider.future);

  final recommended = ContentRepository.recommend(
    all: allContent,
    themes: analysis.themes,
    emotions: analysis.emotionScores.keys.toList(),
  );

  return Recommendation(
    id: 'rec_${analysis.id}',
    analysisId: analysis.id,
    items: recommended,
    reason: '${analysis.themes.take(2).join(', ')} 주제와 '
        '${analysis.emotionScores.keys.take(2).join(', ')} 감정에 맞는 연습을 선택했어요.',
  );
});
