import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class PracticeScreen extends StatelessWidget {
  final String contentId;
  const PracticeScreen({super.key, required this.contentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('연습 실천')),
      body: Center(
        child: Text('연습 화면 (구현 예정) ID: $contentId',
            style: AppTextStyles.bodyLarge),
      ),
    );
  }
}
