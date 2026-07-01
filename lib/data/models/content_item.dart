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

  const ContentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.steps,
    required this.durationMinutes,
    required this.targetThemes,
    required this.targetEmotions,
  });

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
