import 'check_in.dart';

class Report {
  final String id;
  final DateTime periodStart;
  final DateTime periodEnd;
  final List<CheckIn> checkIns;
  final List<String> topThemes;
  final List<Map<String, dynamic>> emotionTrend; // [{date, score}]

  const Report({
    required this.id,
    required this.periodStart,
    required this.periodEnd,
    required this.checkIns,
    required this.topThemes,
    required this.emotionTrend,
  });

  double get avgMoodScore {
    if (checkIns.isEmpty) return 0;
    return checkIns.map((c) => c.moodScore).reduce((a, b) => a + b) /
        checkIns.length;
  }

  double get practiceCompletionRate {
    if (checkIns.isEmpty) return 0;
    final done = checkIns.where((c) => c.practiceCompleted).length;
    return done / checkIns.length;
  }
}
