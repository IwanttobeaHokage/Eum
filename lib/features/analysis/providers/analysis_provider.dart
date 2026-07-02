import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/repositories/analyze_repository.dart';
import '../../record/providers/record_provider.dart';

export '../../../data/repositories/analyze_repository.dart' show AnalyzeResult;

// 기록 화면에서 제출한 폼 상태 — 분석 요청 트리거
final pendingRecordProvider = StateProvider<RecordFormState?>((ref) => null);

// API 호출 결과 (분석 + 추천 모두 포함) — record null이면 mock 반환
final analyzeResultProvider = FutureProvider<AnalyzeResult>((ref) async {
  final record = ref.watch(pendingRecordProvider);
  if (record == null) {
    return (analysis: mockAnalysis, recommendation: mockRecommendation);
  }
  return AnalyzeRepository.analyze(
    text: record.content,
    mood: record.moodScore,
    tags: record.selectedTags,
  );
});
