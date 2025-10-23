import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/camera2');
        break;
      case 1:
        context.go('/camera');
        break;
      case 2:
        context.go('/receipts');
        break;
      case 3:
        context.go('/stats');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/camera2')) return 0;
    if (location.startsWith('/camera')) return 1;
    if (location.startsWith('/receipts')) return 2;
    if (location.startsWith('/stats')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _calculateSelectedIndex(context),
      onTap: (index) => _onItemTapped(index, context),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Skaner2',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Skaner',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Paragony',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Statystyki',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Ustawienia',
        ),
      ],
    );
  }
}