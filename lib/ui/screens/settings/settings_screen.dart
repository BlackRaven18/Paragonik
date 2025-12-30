import 'package:flutter/material.dart';
import 'package:paragonik/data/services/backup_service.dart';
import 'package:paragonik/data/services/l10n_service.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/notifiers/locale_notifier.dart';
import 'package:paragonik/ui/core/assets/asset_manager.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showLanguageSelectionDialog(BuildContext context) {
    final localeNotifier = context.read<LocaleNotifier>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(context.l10n.screensSettingsLanguageDialogTitle),
              content: RadioGroup<Locale>(
                groupValue: localeNotifier.locale,
                onChanged: (locale) {
                  if (locale != null) {
                    localeNotifier.setLocale(locale);
                  }
                  setState(() {});
                  Future.delayed(const Duration(milliseconds: 200), () {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    RadioListTile<Locale>(
                      title: Text('Polski'),
                      value: Locale('pl'),
                    ),
                    RadioListTile<Locale>(
                      title: Text('English'),
                      value: Locale('en'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBackupSelectionDialog(BuildContext context) {
    final l10n = context.l10n;

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(l10n.screensSettingsBackupDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.screensSettingsBackupDialogDescription),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: Text(l10n.screensSettingsBackupCreateAction),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _handleCreateBackup(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.restore_page),
                title: Text(l10n.screensSettingsBackupRestoreAction),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _handleRestoreBackup(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(context.l10n.commonCancel),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleCreateBackup(BuildContext context) async {
    try {
      await BackupService().createAndShareBackup();
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError('${context.l10n.commonError}: $e');
      }
    }
  }

  Future<void> _handleRestoreBackup(BuildContext context) async {
    final l10n = context.l10n;

    try {
      final success = await BackupService().restoreBackup();

      if (success && context.mounted) {
        NotificationService.showSuccess(
          l10n.screensSettingsBackupRestoreSuccess,
        );

        // context.read<ReceiptsViewModel>().fetchReceipts();
      }
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError(
          '${l10n.screensSettingsBackupRestoreError}: $e',
        );
      }
    }
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

  Future<void> _launchGitHubUrl() async {
    final url = Uri.parse('https://github.com/BlackRaven18');
    if (!await launchUrl(url)) {
      NotificationService.showError(L10nService.l10n.notificationsOpenUrlError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeNotifier = context.watch<LocaleNotifier>();
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
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
                  subtitle: Text(
                    _getCurrentLanguageName(localeNotifier.locale),
                  ),
                  onTap: () => _showLanguageSelectionDialog(context),
                ),
                ListTile(
                  leading: const Icon(Icons.backup),
                  title: Text(l10n.screensSettingsBackupDialogTitle),
                  onTap: () => _showBackupSelectionDialog(context),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton.icon(
              onPressed: _launchGitHubUrl,
              icon: Image.asset(AssetManager.githubIcon, width: 18, height: 18),
              label: Text(
                l10n.screensSettingsAuthorLabel,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
