import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/record/presentation/record_screen.dart';
import '../../features/analysis/presentation/analysis_screen.dart';
import '../../features/practice/presentation/practice_screen.dart';
import '../../features/checkin/presentation/checkin_screen.dart';
import '../../features/report/presentation/report_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => _Shell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/checkin',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CheckInScreen(),
          ),
        ),
        GoRoute(
          path: '/report',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ReportScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/record',
      builder: (context, state) => const RecordScreen(),
    ),
    GoRoute(
      path: '/analysis',
      builder: (context, state) => const AnalysisScreen(),
    ),
    GoRoute(
      path: '/practice/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return PracticeScreen(contentId: id);
      },
    ),
  ],
);

class _Shell extends StatefulWidget {
  final Widget child;
  const _Shell({required this.child});

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  int _selectedIndex = 0;

  static const _tabs = ['/home', '/checkin', '/report'];

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
    context.go(_tabs[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            activeIcon: Icon(Icons.check_circle),
            label: '체크인',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: '리포트',
          ),
        ],
      ),
    );
  }
}
