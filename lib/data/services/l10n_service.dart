import 'package:paragonik/l10n/app_localizations.dart';

class L10nService {
  static late AppLocalizations _l10n;

  static AppLocalizations get l10n => _l10n;

  static void initialize(AppLocalizations localizations) {
    _l10n = localizations;
  }
}
