import 'content_item.dart';

class Recommendation {
  final String id;
  final String analysisId;
  final List<ContentItem> items;
  final String reason;

  const Recommendation({
    required this.id,
    required this.analysisId,
    required this.items,
    required this.reason,
  });
}
