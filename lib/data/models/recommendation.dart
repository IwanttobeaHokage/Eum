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

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'] as String,
      analysisId: json['analysisId'] as String,
      items: (json['items'] as List)
          .map((e) => ContentItem.fromApiJson(e as Map<String, dynamic>))
          .toList(),
      reason: json['reason'] as String,
    );
  }
}
