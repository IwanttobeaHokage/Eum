import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/user.dart';
import '../../../data/models/check_in.dart';

final userProvider = Provider<User>((ref) => mockUser);

final recentCheckInsProvider = Provider<List<CheckIn>>((ref) {
  return mockCheckIns.take(7).toList();
});

final todayCheckInProvider = Provider<CheckIn?>((ref) {
  final checkIns = ref.watch(recentCheckInsProvider);
  final today = DateTime.now();
  try {
    return checkIns.firstWhere(
      (c) =>
          c.date.year == today.year &&
          c.date.month == today.month &&
          c.date.day == today.day,
    );
  } catch (_) {
    return null;
  }
});
