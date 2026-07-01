class User {
  final String id;
  final String name;
  final DateTime nextSessionDate;
  final String therapistName;

  const User({
    required this.id,
    required this.name,
    required this.nextSessionDate,
    required this.therapistName,
  });

  int get daysUntilSession {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final session = DateTime(
      nextSessionDate.year,
      nextSessionDate.month,
      nextSessionDate.day,
    );
    return session.difference(today).inDays;
  }
}
