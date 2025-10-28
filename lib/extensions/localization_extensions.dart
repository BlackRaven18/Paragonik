import 'package:flutter/material.dart';
import 'package:paragonik/l10n/app_localizations.dart';

extension BuildContextExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
