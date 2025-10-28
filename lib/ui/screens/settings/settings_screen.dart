import 'package:flutter/material.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/notifiers/locale_notifier.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Helper do wyświetlania dialogu wyboru języka
  void _showLanguageSelectionDialog(BuildContext context) {
    final localeNotifier = context.read<LocaleNotifier>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.screensSettingsLanguageDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<Locale>(
                title: const Text('Polski'),
                value: const Locale('pl'),
                groupValue: localeNotifier.locale,
                onChanged: (locale) {
                  if (locale != null) {
                    localeNotifier.setLocale(locale);
                  }
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<Locale>(
                title: const Text('English'),
                value: const Locale('en'),
                groupValue: localeNotifier.locale,
                onChanged: (locale) {
                  if (locale != null) {
                    localeNotifier.setLocale(locale);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _getCurrentLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'pl':
        return 'Polski';
      default:
        return 'Nieznany';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeNotifier = context.watch<LocaleNotifier>();
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
            child: Text(
              l10n.coreWidgetsAppBottomNavigationBarSettingsTabLabel,
              style: theme.textTheme.headlineMedium,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.screensSettingsLanguageSettingTitle),
            subtitle: Text(_getCurrentLanguageName(localeNotifier.locale)),
            onTap: () => _showLanguageSelectionDialog(context),
          ),
        ],
      ),
    );
  }
}