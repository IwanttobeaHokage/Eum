import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/analysis.dart';
import '../models/recommendation.dart';

typedef AnalyzeResult = ({Analysis analysis, Recommendation recommendation});

class AnalyzeRepository {
  static const _baseUrl = 'http://localhost:8000';

  static Future<AnalyzeResult> analyze({
    required String text,
    required int mood,
    required List<String> tags,
  }) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/analyze'),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({'text': text, 'mood': mood, 'tags': tags}),
        )
        .timeout(const Duration(seconds: 90));

    if (response.statusCode != 200) {
      final body = utf8.decode(response.bodyBytes);
      throw Exception('서버 오류 ${response.statusCode}: $body');
    }

    final json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return (
      analysis: Analysis.fromJson(json['analysis'] as Map<String, dynamic>),
      recommendation:
          Recommendation.fromJson(json['recommendation'] as Map<String, dynamic>),
    );
  }
}
