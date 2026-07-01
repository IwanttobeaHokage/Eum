class Record {
  final String id;
  final DateTime date;
  final String content;
  final int moodScore; // 1–10
  final List<String> tags;

  const Record({
    required this.id,
    required this.date,
    required this.content,
    required this.moodScore,
    required this.tags,
  });
}
