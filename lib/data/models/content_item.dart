enum ContentType { cbt, dbt, mindfulness }

class ContentItem {
  final String id;
  final String title;
  final String description;
  final ContentType type;
  final List<String> steps;
  final int durationMinutes;
  final List<String> targetThemes;
  final List<String> targetEmotions;
  final String evidenceNote;

  const ContentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.steps,
    required this.durationMinutes,
    required this.targetThemes,
    required this.targetEmotions,
    this.evidenceNote = '',
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = typeStr == 'CBT'
        ? ContentType.cbt
        : typeStr == 'DBT'
            ? ContentType.dbt
            : ContentType.mindfulness;

    return ContentItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: type,
      steps: List<String>.from(json['steps'] as List),
      durationMinutes: json['duration'] as int,
      targetThemes: List<String>.from(json['targetThemes'] as List),
      targetEmotions: List<String>.from(json['targetEmotions'] as List),
      evidenceNote: json['evidenceNote'] as String? ?? '',
    );
  }

  String get typeLabel {
    switch (type) {
      case ContentType.cbt:
        return 'CBT';
      case ContentType.dbt:
        return 'DBT';
      case ContentType.mindfulness:
        return '마음챙김';
    }
  }
}
