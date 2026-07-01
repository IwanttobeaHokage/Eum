import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/content_item.dart';

class ContentRepository {
  static List<ContentItem>? _cache;

  static Future<List<ContentItem>> loadAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/content.json');
    final list = jsonDecode(raw) as List;
    _cache = list.map((e) => ContentItem.fromJson(e as Map<String, dynamic>)).toList();
    return _cache!;
  }

  // themes/emotions 매칭 점수로 정렬 후 상위 N개 반환
  static List<ContentItem> recommend({
    required List<ContentItem> all,
    required List<String> themes,
    required List<String> emotions,
    int topN = 3,
  }) {
    final scored = all.map((item) {
      final themeHits =
          item.targetThemes.where((t) => themes.contains(t)).length;
      final emotionHits =
          item.targetEmotions.where((e) => emotions.contains(e)).length;
      return (item: item, score: themeHits * 2 + emotionHits);
    }).toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return scored.take(topN).map((e) => e.item).toList();
  }
}
