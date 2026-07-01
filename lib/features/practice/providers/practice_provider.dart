import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/content_item.dart';
import '../../../data/repositories/content_repository.dart';

class PracticeState {
  final ContentItem item;
  final int currentStep;
  final bool completed;

  const PracticeState({
    required this.item,
    this.currentStep = 0,
    this.completed = false,
  });

  int get totalSteps => item.steps.length;
  double get progress =>
      totalSteps == 0 ? 0 : (currentStep + 1) / totalSteps;
  bool get isLastStep => currentStep >= totalSteps - 1;

  PracticeState copyWith({int? currentStep, bool? completed}) =>
      PracticeState(
        item: item,
        currentStep: currentStep ?? this.currentStep,
        completed: completed ?? this.completed,
      );
}

class PracticeNotifier extends StateNotifier<PracticeState> {
  PracticeNotifier(ContentItem item) : super(PracticeState(item: item));

  void next() {
    if (state.isLastStep) {
      state = state.copyWith(completed: true);
    } else {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void prev() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }
}

// JSON 전체 콘텐츠에서 id로 조회 — FutureProvider
final practiceItemProvider =
    FutureProvider.family<ContentItem, String>((ref, id) async {
  final all = await ContentRepository.loadAll();
  return all.firstWhere(
    (c) => c.id == id,
    orElse: () => all.first,
  );
});

final practiceProvider = StateNotifierProvider.family
    .autoDispose<PracticeNotifier, PracticeState, String>(
  (ref, id) {
    // 캐시가 이미 로드됐으면 동기로 사용, 아직이면 첫 번째 목 데이터로 시작 후 갱신
    final asyncItem = ref.watch(practiceItemProvider(id));
    final item = asyncItem.maybeWhen(
      data: (i) => i,
      orElse: () => null,
    );
    if (item != null) return PracticeNotifier(item);

    // 로딩 중 — 빈 플레이스홀더
    return PracticeNotifier(ContentItem(
      id: id,
      title: '불러오는 중...',
      description: '',
      type: ContentType.cbt,
      steps: ['잠시만 기다려주세요...'],
      durationMinutes: 0,
      targetThemes: [],
      targetEmotions: [],
    ));
  },
);
