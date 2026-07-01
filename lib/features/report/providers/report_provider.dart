import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/report.dart';
import '../../../data/mock/mock_data.dart';

final reportProvider = Provider<Report>((ref) => mockReport);
