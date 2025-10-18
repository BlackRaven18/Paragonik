import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:paragonik/routing/app_router.dart';
import 'package:paragonik/ui/core/themes/theme.dart';
import 'package:paragonik/ui/core/themes/theme_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();

    return MaterialApp.router(
      title: 'Paragonik',
      routerConfig: router,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier.themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pl', 'PL'),
        Locale('en', 'US'), 
      ],
    );
  }
}
