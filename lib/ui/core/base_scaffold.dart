import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paragonik/ui/core/app_bottom_navigation_bar.dart';
import 'package:paragonik/ui/core/assets/asset_manager.dart';
import 'package:paragonik/ui/core/themes/theme_notifier.dart';
import 'package:provider/provider.dart';

class BaseScaffold extends StatefulWidget {
  final Widget child;

  const BaseScaffold({required this.child, super.key});

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final switchThemeIcon = isDarkMode ? Icons.light_mode : Icons.dark_mode;

    return LayoutBuilder(
      builder: (context, constraints) {
        final themeToggleButton = IconButton(
          icon: Icon(switchThemeIcon),
          onPressed: () {
            context.read<ThemeNotifier>().toggleTheme();
          },
        );

          return Scaffold(
            appBar: AppBar(
              title: const Text("Paragonik"),
              actions: [themeToggleButton],
              leading: IconButton(
                padding: EdgeInsets.zero,
                icon: Image.asset(AssetManager.appLogo, width: 48, height: 48),
                onPressed: () => context.go('/camera'),
              ),
            ),
            body: widget.child,
            bottomNavigationBar: const AppBottomNavigationBar(),
          );
       
      },
    );
  }
}
