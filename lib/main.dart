import 'package:flutter/material.dart';
import 'package:paragonik/data/services/l10n_service.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:paragonik/data/services/settings_service.dart';
import 'package:paragonik/l10n/app_localizations.dart';
import 'package:paragonik/notifiers/loading_notifier.dart';
import 'package:paragonik/notifiers/locale_notifier.dart';
import 'package:paragonik/routing/app_router.dart';
import 'package:paragonik/ui/core/themes/theme.dart';
import 'package:paragonik/ui/core/themes/theme_notifier.dart';
import 'package:paragonik/ui/core/widgets/global_loading_overlay.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SettingsService.instance.init();

  final localeNotifier = LocaleNotifier();
  await localeNotifier.loadSavedLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider.value(value: localeNotifier),
        ChangeNotifierProvider(create: (_) => LoadingNotifier.instance),
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
    final localeNotifier = context.watch<LocaleNotifier>();

    return MaterialApp.router(
      title: 'Paragonik',
      scaffoldMessengerKey: NotificationService.messengerKey,
      routerConfig: router,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier.themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: localeNotifier.locale,
      builder: (context, child) {
        L10nService.initialize(AppLocalizations.of(context)!);
        return GlobalLoadingOverlay(child: child!);
      },
    );
  }
}
