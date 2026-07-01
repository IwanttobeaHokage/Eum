import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('리포트')),
      body: Center(
        child: Text('리포트 화면 (구현 예정)', style: AppTextStyles.bodyLarge),
      ),
    );
  }
}
