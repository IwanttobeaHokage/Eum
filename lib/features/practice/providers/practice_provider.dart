import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/content_item.dart';

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
  double get progress => totalSteps == 0 ? 0 : (currentStep + 1) / totalSteps;
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

final practiceProvider = StateNotifierProvider.family
    .autoDispose<PracticeNotifier, PracticeState, String>(
  (ref, id) {
    final item = mockContentItems.firstWhere(
      (c) => c.id == id,
      orElse: () => mockContentItems.first,
    );
    return PracticeNotifier(item);
  },
);
