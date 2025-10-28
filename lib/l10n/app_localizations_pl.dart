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
  String get commonCancel => 'Anuluj';

  @override
  String get commonSave => 'Zapisz';

  @override
  String get commonSaveChanges => 'Zapisz zmiany';

  @override
  String get commonDelete => 'Usuń';

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

  @override
  String get screensCameraImagePreviewViewResultPanelDateNotFound =>
      'Nie znaleziono';

  @override
  String get screensCameraImagePreviewViewResultPanelUnknownStore =>
      'Nieznany sklep';

  @override
  String get screensCameraImagePreviewViewResultPanelAmountLabel => 'Kwota:';

  @override
  String get screensCameraImagePreviewViewResultPanelAmountLabelCorrected =>
      'Kwota (Poprawiona):';

  @override
  String get screensCameraImagePreviewViewResultPanelDateLabel => 'Data:';

  @override
  String get screensCameraImagePreviewViewResultPanelDateLabelCorrected =>
      'Data (Poprawiona):';

  @override
  String get screensCameraImagePreviewViewResultPanelStoreLabel => 'Sklep:';

  @override
  String get screensCameraImagePreviewViewImageDisplayShowOriginalTooltip =>
      'Pokaż oryginał';

  @override
  String get screensCameraImagePreviewViewImageDisplayShowScanTooltip =>
      'Pokaż skan';

  @override
  String get screensCameraActionPanelChangePhotoButton => 'Zmień zdjęcie';

  @override
  String get screensCameraActionPanelProcessButton => 'Przetwórz';

  @override
  String get screensCameraHelpersPermissionDialogTitle => 'Brak uprawnień';

  @override
  String get screensCameraHelpersPermissionDialogContentCamera =>
      'Aplikacja potrzebuje dostępu do aparatu. Proszę włączyć uprawnienie w ustawieniach aplikacji.';

  @override
  String get screensCameraHelpersPermissionDialogContentGallery =>
      'Aplikacja potrzebuje dostępu do galerii. Proszę włączyć uprawnienie w ustawieniach aplikacji.';

  @override
  String get screensCameraHelpersPermissionDialogOpenSettingsButton =>
      'Otwórz ustawienia';

  @override
  String get screensReceiptsNoReceiptsSaved => 'Brak zapisanych paragonów.';

  @override
  String get screensReceiptsEditAmountLabel => 'Kwota:';

  @override
  String get screensReceiptsEditDateTimeLabel => 'Data i godzina';

  @override
  String get screensReceiptsEditStoreLabel => 'Sklep';

  @override
  String get notificationsSuccessChangesSaved => 'Zapisano zmiany!';

  @override
  String get screensReceiptsReceiptsListNoMatchingReceipts =>
      'Nie znaleziono pasujących paragonów.';

  @override
  String get screensReceiptsReceiptsListConfirmDeleteDialogTitle =>
      'Potwierdź usunięcie';

  @override
  String get screensReceiptsReceiptsListConfirmDeleteDialogContent =>
      'Czy na pewno chcesz usunąć ten paragon?';

  @override
  String get notificationsSuccessReceiptDeleted => 'Paragon usunięty!';

  @override
  String get screensReceiptsReceiptsScreenWidgetsSearchLabel => 'Szukaj...';

  @override
  String get screensReceiptsReceiptsScreenWidgetsCounterTitle =>
      'Całkowita liczba paragonów';

  @override
  String get screensReceiptsReceiptsScreenWidgetsGroupingToggleReceiptDate =>
      'Data paragonu';

  @override
  String get screensReceiptsReceiptsScreenWidgetsGroupingToggleAddedDate =>
      'Data dodania';

  @override
  String get screensReceiptsReceiptsScreenWidgetsModalsFilterTitle =>
      'Filtruj po sklepie';

  @override
  String get screensReceiptsReceiptsScreenWidgetsModalsFilterAllStoresOption =>
      'Wszystkie sklepy';

  @override
  String get screensStatisticsScreenTitle => 'Statystyki';

  @override
  String screensStatisticsSummaryTitleWithRange(String range) {
    return 'Podsumowanie ($range)';
  }

  @override
  String get screensStatisticsCardSpendingTitle => 'Wydatki';

  @override
  String get screensStatisticsCardVsPreviousMonthTitle =>
      'vs Poprzedni miesiąc';

  @override
  String get screensStatisticsCardDailyAverageTitle => 'Średnio dziennie';

  @override
  String get screensStatisticsCardReceiptsCountTitle => 'Liczba paragonów';

  @override
  String get screensStatisticsStoreSpendingTitle => 'Wydatki w sklepach';

  @override
  String get screensStatisticsTimeRangeWeek => 'Tydzień';

  @override
  String get screensStatisticsTimeRangeMonth => 'Miesiąc';

  @override
  String get screensStatisticsNoSpendingInRange =>
      'Brak wydatków w tym okresie.';

  @override
  String get screensStatisticsRangeLabelCurrentWeek => 'Bieżący tydzień';

  @override
  String get screensStatisticsRangeLabelCurrentMonth => 'Bieżący miesiąc';

  @override
  String get screensStatisticsRangeLabelCustom => 'Niestandardowy';

  @override
  String get widgetsStoreDisplayUnknownStore => 'Nieznany sklep';

  @override
  String get widgetsImageViewerTooltipShowOriginal => 'Pokaż oryginał';

  @override
  String get widgetsImageViewerTooltipShowScan => 'Pokaż skan';

  @override
  String get widgetsModalsStoreSelectionSearchLabel => 'Wyszukaj sklep...';
}
