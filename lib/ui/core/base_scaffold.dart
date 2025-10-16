import 'package:flutter/material.dart';
import 'package:paragonik/ui/core/app_bottom_navigation_bar.dart';
import 'package:paragonik/ui/core/themes/theme_notifier.dart';
import 'package:provider/provider.dart';

class BaseScaffold extends StatefulWidget {
  final Widget child;

  const BaseScaffold({required this.child, super.key});

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  bool _isDrawerVisible = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final switchThemeIcon = isDarkMode ? Icons.light_mode : Icons.dark_mode;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final themeToggleButton = IconButton(
          icon: Icon(switchThemeIcon),
          onPressed: () {
            context.read<ThemeNotifier>().toggleTheme();
          },
        );

        if (isMobile) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Paragonik"),
              actions: [themeToggleButton],
              leading: IconButton(
                padding: EdgeInsets.zero,
                icon: Image.asset(
                  'assets/images/logo.png',
                  width: 48,
                  height: 48,
                ),
                onPressed: () {
                  setState(() {
                    _isDrawerVisible = !_isDrawerVisible;
                  });
                },
              ),
            ),
            body: widget.child,
            bottomNavigationBar: const AppBottomNavigationBar(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Paragonik"),
              actions: [themeToggleButton],
              leading: IconButton(
                padding: EdgeInsets.zero,
                icon: Image.asset(
                  'assets/images/logo.png',
                  width: 48,
                  height: 48,
                ),
                onPressed: () {
                  setState(() {
                    _isDrawerVisible = !_isDrawerVisible;
                  });
                },
              ),
            ),
            body: Row(
              children: [
                if (_isDrawerVisible) const Placeholder(),
                if (_isDrawerVisible)
                  const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: widget.child),
              ],
            ),
          );
        }
      },
    );
  }
}