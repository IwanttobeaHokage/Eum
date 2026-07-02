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

  factory Analysis.fromJson(Map<String, dynamic> json) {
    return Analysis(
      id: json['id'] as String,
      recordId: json['recordId'] as String,
      summary: json['summary'] as String,
      keywords: List<String>.from(json['keywords'] as List),
      themes: List<String>.from(json['themes'] as List),
      emotionScores: Map<String, double>.fromEntries(
        (json['emotionScores'] as Map<String, dynamic>)
            .entries
            .map((e) => MapEntry(e.key, (e.value as num).toDouble())),
      ),
    );
  }
}
