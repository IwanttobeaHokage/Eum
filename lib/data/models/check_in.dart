class CheckIn {
  final String id;
  final DateTime date;
  final int moodScore; // 1–5
  final double sleepHours;
  final bool practiceCompleted;
  final String? note;

  const CheckIn({
    required this.id,
    required this.date,
    required this.moodScore,
    required this.sleepHours,
    required this.practiceCompleted,
    this.note,
  });
}
