import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckInFormState {
  final int moodScore;       // 1–5
  final double sleepHours;   // 0–12
  final bool practiceCompleted;
  final String note;
  final bool submitted;

  const CheckInFormState({
    this.moodScore = 3,
    this.sleepHours = 7,
    this.practiceCompleted = false,
    this.note = '',
    this.submitted = false,
  });

  CheckInFormState copyWith({
    int? moodScore,
    double? sleepHours,
    bool? practiceCompleted,
    String? note,
    bool? submitted,
  }) => CheckInFormState(
        moodScore: moodScore ?? this.moodScore,
        sleepHours: sleepHours ?? this.sleepHours,
        practiceCompleted: practiceCompleted ?? this.practiceCompleted,
        note: note ?? this.note,
        submitted: submitted ?? this.submitted,
      );
}

class CheckInNotifier extends StateNotifier<CheckInFormState> {
  CheckInNotifier() : super(const CheckInFormState());

  void setMood(int v) => state = state.copyWith(moodScore: v);
  void setSleep(double v) => state = state.copyWith(sleepHours: v);
  void togglePractice() =>
      state = state.copyWith(practiceCompleted: !state.practiceCompleted);
  void setNote(String v) => state = state.copyWith(note: v);

  void submit() => state = state.copyWith(submitted: true);
  void reset() => state = const CheckInFormState();
}

final checkInFormProvider =
    StateNotifierProvider<CheckInNotifier, CheckInFormState>(
  (ref) => CheckInNotifier(),
);
