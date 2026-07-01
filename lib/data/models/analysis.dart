class Analysis {
  final String id;
  final String recordId;
  final String summary;
  final List<String> keywords;
  final List<String> themes;
  final Map<String, double> emotionScores; // e.g. {'불안': 0.7, '슬픔': 0.4}

  const Analysis({
    required this.id,
    required this.recordId,
    required this.summary,
    required this.keywords,
    required this.themes,
    required this.emotionScores,
  });
}
