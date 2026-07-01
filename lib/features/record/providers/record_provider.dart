import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/record.dart';

class RecordFormState {
  final String content;
  final int moodScore;
  final List<String> selectedTags;

  const RecordFormState({
    this.content = '',
    this.moodScore = 5,
    this.selectedTags = const [],
  });

  RecordFormState copyWith({
    String? content,
    int? moodScore,
    List<String>? selectedTags,
  }) {
    return RecordFormState(
      content: content ?? this.content,
      moodScore: moodScore ?? this.moodScore,
      selectedTags: selectedTags ?? this.selectedTags,
    );
  }

  bool get isValid => content.trim().length >= 10;
}

class RecordFormNotifier extends StateNotifier<RecordFormState> {
  RecordFormNotifier() : super(const RecordFormState());

  void setContent(String v) => state = state.copyWith(content: v);
  void setMood(int v) => state = state.copyWith(moodScore: v);

  void toggleTag(String tag) {
    final tags = List<String>.from(state.selectedTags);
    tags.contains(tag) ? tags.remove(tag) : tags.add(tag);
    state = state.copyWith(selectedTags: tags);
  }

  Record submit() {
    return Record(
      id: 'r_${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      content: state.content,
      moodScore: state.moodScore,
      tags: state.selectedTags,
    );
  }

  void reset() => state = const RecordFormState();
}

final recordFormProvider =
    StateNotifierProvider.autoDispose<RecordFormNotifier, RecordFormState>(
  (ref) => RecordFormNotifier(),
);

const availableTags = [
  '직장스트레스', '대인관계', '가족', '자기비난', '불안', '슬픔',
  '분노', '외로움', '수면', '신체증상', '반추', '성취감',
];
