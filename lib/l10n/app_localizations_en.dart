// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get scanner => 'Scanner';

  @override
  String get settings => 'Settings';

  @override
  String get statistics => 'Statistics';

  @override
  String get receipts => 'Receipts';

  @override
  String get totalReceipts => 'Total number of receipts';

  @override
  String receiptsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count receipts',
      one: '$count receipt',
      zero: 'No receipts',
    );
    return '$_temp0';
  }

  @override
  String get addReceipt => 'Add receipt';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get screensCameraInitialViewTitle => 'Rozpocznij Skanowanie';

  @override
  String get screensCameraInitialViewDescription =>
      'Zrób zdjęcie paragonu lub wybierz istniejące z galerii, aby dodać nowy wydatek.';

  @override
  String get screensCameraInitialViewTakePhotoButton => 'Zrób zdjęcie';

  @override
  String get screensCameraInitialViewChooseFromGalleryButton =>
      'Wybierz z galerii';

  @override
  String get screensCameraProcessingViewStatus => 'Analizuję paragon...';
}
