// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get scanner => 'Skaner';

  @override
  String get settings => 'Ustawienia';

  @override
  String get statistics => 'Statystyki';

  @override
  String get receipts => 'Paragony';

  @override
  String get totalReceipts => 'Całkowita liczba paragonów';

  @override
  String receiptsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paragonu',
      many: '$count paragonów',
      few: '$count paragony',
      one: '$count paragon',
      zero: 'Brak paragonów',
    );
    return '$_temp0';
  }

  @override
  String get addReceipt => 'Dodaj paragon';

  @override
  String get saveChanges => 'Zapisz zmiany';

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
