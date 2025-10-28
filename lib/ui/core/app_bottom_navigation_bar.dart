import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paragonik/extensions/localization_extensions.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/camera');
        break;
      case 1:
        context.go('/receipts');
        break;
      case 2:
        context.go('/statistics');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/camera')) return 0;
    if (location.startsWith('/receipts')) return 1;
    if (location.startsWith('/statistics')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _calculateSelectedIndex(context),
      onTap: (index) => _onItemTapped(index, context),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Skaner'),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Paragony',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: context.l10n.statistics,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Ustawienia',
        ),
      ],
    );
  }
}
