import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('데일리 체크인')),
      body: Center(
        child: Text('체크인 화면 (구현 예정)', style: AppTextStyles.bodyLarge),
      ),
    );
  }
}
