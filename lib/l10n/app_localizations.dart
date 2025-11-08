import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
  ];

  /// Etykieta dla zakładki 'Skaner' na dolnym pasku nawigacji.
  ///
  /// In pl, this message translates to:
  /// **'Skaner'**
  String get coreWidgetsAppBottomNavigationBarScannerTabLabel;

  /// Etykieta dla zakładki 'Paragony' na dolnym pasku nawigacji.
  ///
  /// In pl, this message translates to:
  /// **'Paragony'**
  String get coreWidgetsAppBottomNavigationBarReceiptsListTabLabel;

  /// Etykieta dla zakładki 'Statystyki' na dolnym pasku nawigacji.
  ///
  /// In pl, this message translates to:
  /// **'Statystyki'**
  String get coreWidgetsAppBottomNavigationBarStatisticsTabLabel;

  /// Etykieta dla zakładki 'Ustawienia' na dolnym pasku nawigacji.
  ///
  /// In pl, this message translates to:
  /// **'Ustawienia'**
  String get coreWidgetsAppBottomNavigationBarSettingsTabLabel;

  /// Etykieta przycisku do anulowania akcji.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get commonCancel;

  /// Etykieta przycisku do zapisywania danych.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz'**
  String get commonSave;

  /// Etykieta przycisku do zapisywania zmian.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz zmiany'**
  String get commonSaveChanges;

  /// Etykieta przycisku do usuwania elementu.
  ///
  /// In pl, this message translates to:
  /// **'Usuń'**
  String get commonDelete;

  /// Etykieta przycisku do kontynuowania akcji.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj'**
  String get commonContinue;

  /// Etykieta przycisku do eksportowania danych.
  ///
  /// In pl, this message translates to:
  /// **'Eksportuj'**
  String get commonExport;

  /// Komunikat wyświetlany po błędzie ładowania paragonów.
  ///
  /// In pl, this message translates to:
  /// **'Ups! Coś poszło nie tak przy ładowaniu paragonów'**
  String get notificationsErrorLoadingReceipts;

  /// Komunikat wyświetlany po pomyślnym zapisaniu zmian.
  ///
  /// In pl, this message translates to:
  /// **'Zapisano zmiany!'**
  String get notificationsSuccessChangesSaved;

  /// Komunikat wyświetlany po pomyślnym usunięciu paragonu.
  ///
  /// In pl, this message translates to:
  /// **'Paragon usunięty!'**
  String get notificationsSuccessReceiptDeleted;

  /// Komunikat wyświetlany po pomyślnym dodaniu paragonu.
  ///
  /// In pl, this message translates to:
  /// **'Paragon dodany!'**
  String get notificationsSuccessReceiptAdded;

  /// Komunikat wyświetlany po błędzie ładowania aparatu.
  ///
  /// In pl, this message translates to:
  /// **'Ups! Coś poszło nie tak przy ładowaniu aparatu.'**
  String get notificationErrorLoadingCamera;

  /// Komunikat wyświetlany po błędzie przy robieniu zdjęcia.
  ///
  /// In pl, this message translates to:
  /// **'Ups! Coś poszło nie tak przy robieniu zdjęcia.'**
  String get notificationErrorTakingPicture;

  /// Komunikat wyświetlany po odmowie dostępu do uprawnień.
  ///
  /// In pl, this message translates to:
  /// **'Odmówiono dostępu do uprawnień.'**
  String get notifictationRefusedPermission;

  /// Komunikat wyświetlany po wprowadzeniu nieprawidłowej kwoty.
  ///
  /// In pl, this message translates to:
  /// **'Wprowadzono nieprawidłową kwotę.'**
  String get notificationInvalidSum;

  /// Komunikat wyświetlany po błędzie latarki.
  ///
  /// In pl, this message translates to:
  /// **'Ups! Błąd latarki :('**
  String get notificationFlashlightError;

  /// Tekst wyświetlany w oknie ładowania podczas analizowania paragonu.
  ///
  /// In pl, this message translates to:
  /// **'Analizuję paragon...'**
  String get globalLoadingOverlayAnalyzingReceiptMessage;

  /// Tekst wyświetlany w oknie ładowania podczas obracania paragonu.
  ///
  /// In pl, this message translates to:
  /// **'Obracam paragon...'**
  String get globalLoadingOverlayRotatingReceiptMessage;

  /// Domyślny tekst dla nierozpoznanej nazwy sklepu.
  ///
  /// In pl, this message translates to:
  /// **'Nieznany sklep'**
  String get unknownStore;

  /// Główny tytuł na ekranie początkowym skanera.
  ///
  /// In pl, this message translates to:
  /// **'Rozpocznij Skanowanie'**
  String get screensCameraInitialViewTitle;

  /// Tekst instruktażowy pod głównym tytułem na ekranie skanera.
  ///
  /// In pl, this message translates to:
  /// **'Zrób zdjęcie paragonu lub wybierz istniejące z galerii, aby dodać nowy wydatek.'**
  String get screensCameraInitialViewDescription;

  /// Etykieta przycisku do uruchomienia aparatu w celu zrobienia zdjęcia.
  ///
  /// In pl, this message translates to:
  /// **'Zrób zdjęcie'**
  String get screensCameraInitialViewTakePhotoButton;

  /// Etykieta przycisku do otwarcia galerii w celu wybrania zdjęcia.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz z galerii'**
  String get screensCameraInitialViewChooseFromGalleryButton;

  /// Komunikat wyświetlany podczas analizy obrazu paragonu przez OCR.
  ///
  /// In pl, this message translates to:
  /// **'Analizuję paragon...'**
  String get screensCameraProcessingViewStatus;

  /// Tooltip dla przycisku do przełączania latarki.
  ///
  /// In pl, this message translates to:
  /// **'Przełącz latarkę'**
  String get screensCameraFlashTooltip;

  /// Tekst wyświetlany, gdy data nie została znaleziona na paragonie.
  ///
  /// In pl, this message translates to:
  /// **'Nie znaleziono'**
  String get screensCameraImagePreviewViewResultPanelDateNotFound;

  /// Domyślny tekst dla nierozpoznanej nazwy sklepu.
  ///
  /// In pl, this message translates to:
  /// **'Nieznany sklep'**
  String get screensCameraImagePreviewViewResultPanelUnknownStore;

  /// Domyślna etykieta dla pola z kwotą paragonu.
  ///
  /// In pl, this message translates to:
  /// **'Kwota:'**
  String get screensCameraImagePreviewViewResultPanelAmountLabel;

  /// Etykieta dla pola z kwotą, gdy została ona ręcznie poprawiona.
  ///
  /// In pl, this message translates to:
  /// **'Kwota (Poprawiona):'**
  String get screensCameraImagePreviewViewResultPanelAmountLabelCorrected;

  /// Domyślna etykieta dla pola z datą paragonu.
  ///
  /// In pl, this message translates to:
  /// **'Data:'**
  String get screensCameraImagePreviewViewResultPanelDateLabel;

  /// Etykieta dla pola z datą, gdy została ona ręcznie poprawiona.
  ///
  /// In pl, this message translates to:
  /// **'Data (Poprawiona):'**
  String get screensCameraImagePreviewViewResultPanelDateLabelCorrected;

  /// Etykieta dla pola z nazwą sklepu.
  ///
  /// In pl, this message translates to:
  /// **'Sklep:'**
  String get screensCameraImagePreviewViewResultPanelStoreLabel;

  /// Tooltip przycisku do przełączania podglądu na oryginalne zdjęcie.
  ///
  /// In pl, this message translates to:
  /// **'Pokaż oryginał'**
  String get screensCameraImagePreviewViewImageDisplayShowOriginalTooltip;

  /// Tooltip przycisku do przełączania podglądu na przetworzony skan.
  ///
  /// In pl, this message translates to:
  /// **'Pokaż skan'**
  String get screensCameraImagePreviewViewImageDisplayShowScanTooltip;

  /// Etykieta przycisku do zmiany wybranego zdjęcia paragonu.
  ///
  /// In pl, this message translates to:
  /// **'Zmień zdjęcie'**
  String get screensCameraActionPanelChangePhotoButton;

  /// Etykieta przycisku do rozpoczęcia analizy OCR zdjęcia.
  ///
  /// In pl, this message translates to:
  /// **'Przetwórz'**
  String get screensCameraActionPanelProcessButton;

  /// Tytuł okna dialogowego informującego o braku uprawnień.
  ///
  /// In pl, this message translates to:
  /// **'Brak uprawnień'**
  String get screensCameraHelpersPermissionDialogTitle;

  /// Treść okna dialogowego z prośbą o włączenie uprawnień do aparatu.
  ///
  /// In pl, this message translates to:
  /// **'Aplikacja potrzebuje dostępu do aparatu. Proszę włączyć uprawnienie w ustawieniach aplikacji.'**
  String get screensCameraHelpersPermissionDialogContentCamera;

  /// Treść okna dialogowego z prośbą o włączenie uprawnień do galerii.
  ///
  /// In pl, this message translates to:
  /// **'Aplikacja potrzebuje dostępu do galerii. Proszę włączyć uprawnienie w ustawieniach aplikacji.'**
  String get screensCameraHelpersPermissionDialogContentGallery;

  /// Etykieta przycisku, który przenosi użytkownika do ustawień aplikacji.
  ///
  /// In pl, this message translates to:
  /// **'Otwórz ustawienia'**
  String get screensCameraHelpersPermissionDialogOpenSettingsButton;

  /// Tekst wyświetlany na ekranie listy paragonów, gdy nie ma jeszcze żadnych zapisanych paragonów.
  ///
  /// In pl, this message translates to:
  /// **'Brak zapisanych paragonów.'**
  String get screensReceiptsNoReceiptsSaved;

  /// Etykieta dla pola z kwotą na ekranie edycji paragonu.
  ///
  /// In pl, this message translates to:
  /// **'Kwota:'**
  String get screensReceiptsEditAmountLabel;

  /// Etykieta dla pola z datą na ekranie edycji paragonu.
  ///
  /// In pl, this message translates to:
  /// **'Data i godzina'**
  String get screensReceiptsEditDateTimeLabel;

  /// Etykieta dla pola ze sklepem na ekranie edycji paragonu.
  ///
  /// In pl, this message translates to:
  /// **'Sklep'**
  String get screensReceiptsEditStoreLabel;

  /// Tekst wyświetlany na liście paragonów, gdy filtry nie znajdują żadnych pasujących wyników.
  ///
  /// In pl, this message translates to:
  /// **'Nie znaleziono pasujących paragonów.'**
  String get screensReceiptsReceiptsListNoMatchingReceipts;

  /// Tytuł okna dialogowego z prośbą o potwierdzenie usunięcia paragonu.
  ///
  /// In pl, this message translates to:
  /// **'Potwierdź usunięcie'**
  String get screensReceiptsReceiptsListConfirmDeleteDialogTitle;

  /// Treść okna dialogowego z prośbą o potwierdzenie usunięcia paragonu.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz usunąć ten paragon?'**
  String get screensReceiptsReceiptsListConfirmDeleteDialogContent;

  /// Tekst wyświetlany jako podpowiedź w polu wyszukiwania na liście paragonów.
  ///
  /// In pl, this message translates to:
  /// **'Szukaj...'**
  String get screensReceiptsReceiptsScreenWidgetsSearchLabel;

  /// Etykieta karty pokazującej całkowitą liczbę wszystkich paragonów.
  ///
  /// In pl, this message translates to:
  /// **'Całkowita liczba paragonów'**
  String get screensReceiptsReceiptsScreenWidgetsCounterTitle;

  /// Etykieta przycisku do grupowania paragonów po dacie zakupu.
  ///
  /// In pl, this message translates to:
  /// **'Data paragonu'**
  String get screensReceiptsReceiptsScreenWidgetsGroupingToggleReceiptDate;

  /// Etykieta przycisku do grupowania paragonów po dacie ich dodania do aplikacji.
  ///
  /// In pl, this message translates to:
  /// **'Data dodania'**
  String get screensReceiptsReceiptsScreenWidgetsGroupingToggleAddedDate;

  /// Tytuł okna modalnego do filtrowania paragonów po sklepie.
  ///
  /// In pl, this message translates to:
  /// **'Filtruj po sklepie'**
  String get screensReceiptsReceiptsScreenWidgetsModalsFilterTitle;

  /// Etykieta opcji w dropdownie, która usuwa filtr sklepu.
  ///
  /// In pl, this message translates to:
  /// **'Wszystkie sklepy'**
  String get screensReceiptsReceiptsScreenWidgetsModalsFilterAllStoresOption;

  /// Tytuł okna dialogowego do eksportowania paragonów.
  ///
  /// In pl, this message translates to:
  /// **'Eksportuj paragony'**
  String
  get screensReceiptsReceiptsScreenWidgetsModalsExportReceiptsDialogTitle;

  /// Etykieta pola do wyboru zakresu dat.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz zakres dat:'**
  String
  get screensReceiptsReceiptsScreenWidgetsModalsExportReceiptsDialogDateRangeLabel;

  /// Opis przycisku do eksportowania paragonów.
  ///
  /// In pl, this message translates to:
  /// **'Eksportuj paragony'**
  String get screensReceiptsReceiptsScreenExportReceiptsButtonTooltip;

  /// Etykieta 'chipu' pokazującego aktywny filtr sklepu.
  ///
  /// In pl, this message translates to:
  /// **'Filtr: {storeName}'**
  String screensReceiptsActiveStoreFilterLabel(String storeName);

  /// Tooltip dla przycisku 'X' na chipie aktywnego filtra.
  ///
  /// In pl, this message translates to:
  /// **'Wyczyść filtr'**
  String get screensReceiptsClearFilterTooltip;

  /// Główny tytuł na ekranie statystyk.
  ///
  /// In pl, this message translates to:
  /// **'Podsumowanie'**
  String get screensStatisticsScreenTitle;

  /// Tytuł karty pokazującej sumę wydatków.
  ///
  /// In pl, this message translates to:
  /// **'Wydatki'**
  String get screensStatisticsCardSpendingTitle;

  /// Tytuł karty porównującej wydatki z poprzednim miesiącem.
  ///
  /// In pl, this message translates to:
  /// **'Poprzedni miesiąc'**
  String get screensStatisticsCardVsPreviousMonthTitle;

  /// Tytuł karty pokazującej średnie dzienne wydatki.
  ///
  /// In pl, this message translates to:
  /// **'Średnio dziennie'**
  String get screensStatisticsCardDailyAverageTitle;

  /// Tytuł karty pokazującej liczbę paragonów w danym okresie.
  ///
  /// In pl, this message translates to:
  /// **'Liczba paragonów'**
  String get screensStatisticsCardReceiptsCountTitle;

  /// Tytuł sekcji pokazującej wydatki w poszczególnych sklepach.
  ///
  /// In pl, this message translates to:
  /// **'Wydatki w sklepach'**
  String get screensStatisticsStoreSpendingTitle;

  /// Etykieta przycisku wyboru zakresu 'Tydzień'.
  ///
  /// In pl, this message translates to:
  /// **'Tydzień'**
  String get screensStatisticsTimeRangeWeek;

  /// Etykieta przycisku wyboru zakresu 'Miesiąc'.
  ///
  /// In pl, this message translates to:
  /// **'Miesiąc'**
  String get screensStatisticsTimeRangeMonth;

  /// Komunikat wyświetlany, gdy w wybranym okresie nie ma żadnych wydatków.
  ///
  /// In pl, this message translates to:
  /// **'Brak wydatków w tym okresie.'**
  String get screensStatisticsNoSpendingInRange;

  ///
  ///
  /// In pl, this message translates to:
  /// **'Bieżący tydzień'**
  String get screensStatisticsRangeLabelCurrentWeek;

  ///
  ///
  /// In pl, this message translates to:
  /// **'Bieżący miesiąc'**
  String get screensStatisticsRangeLabelCurrentMonth;

  ///
  ///
  /// In pl, this message translates to:
  /// **'Niestandardowy'**
  String get screensStatisticsRangeLabelCustom;

  /// Domyślna nazwa sklepu, gdy nie zostanie rozpoznany lub podany.
  ///
  /// In pl, this message translates to:
  /// **'Nieznany sklep'**
  String get widgetsStoreDisplayUnknownStore;

  /// Tooltip przycisku do przełączania podglądu na oryginalne zdjęcie.
  ///
  /// In pl, this message translates to:
  /// **'Pokaż oryginał'**
  String get widgetsImageViewerTooltipShowOriginal;

  /// Tooltip przycisku do przełączania podglądu na przetworzony skan.
  ///
  /// In pl, this message translates to:
  /// **'Pokaż skan'**
  String get widgetsImageViewerTooltipShowScan;

  /// Tekst wyświetlany jako podpowiedź w polu wyszukiwania w oknie wyboru sklepu.
  ///
  /// In pl, this message translates to:
  /// **'Wyszukaj sklep...'**
  String get widgetsModalsStoreSelectionSearchLabel;

  /// Tytuł okna dialogowego do ręcznej edycji kwoty paragonu.
  ///
  /// In pl, this message translates to:
  /// **'Ręczna poprawa kwoty'**
  String get helpersSumInputDialogTitle;

  /// Etykieta pola tekstowego do wprowadzania kwoty.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz poprawną kwotę'**
  String get helpersSumInputDialogLabel;

  /// Tytuł okna dialogowego ostrzegającego o dacie z przyszłości.
  ///
  /// In pl, this message translates to:
  /// **'Data z przyszłości'**
  String get helpersModalsFutureDateWarningDialogTitle;

  /// Treść okna dialogowego z prośbą o potwierdzenie zapisu paragonu z datą z przyszłości.
  ///
  /// In pl, this message translates to:
  /// **'Wybrana data paragonu jest z przyszłości. Czy na pewno chcesz kontynuować?'**
  String get helpersModalsFutureDateWarningDialogContent;

  /// Nagłówek grupy dla paragonów z dzisiejszego dnia.
  ///
  /// In pl, this message translates to:
  /// **'Dzisiaj'**
  String get viewModelsScreensReceiptsGroupToday;

  /// Nagłówek grupy dla paragonów z wczorajszego dnia.
  ///
  /// In pl, this message translates to:
  /// **'Wczoraj'**
  String get viewModelsScreensReceiptsGroupYesterday;

  /// Nagłówek grupy dla paragonów z bieżącego tygodnia.
  ///
  /// In pl, this message translates to:
  /// **'W tym tygodniu'**
  String get viewModelsScreensReceiptsGroupThisWeek;

  /// Nagłówek grupy dla paragonów starszych niż bieżący tydzień.
  ///
  /// In pl, this message translates to:
  /// **'Wcześniej'**
  String get viewModelsScreensReceiptsGroupEarlier;

  /// Komunikat błędu wyświetlany, gdy użytkownik próbuje wyeksportować dane z pustego zakresu dat.
  ///
  /// In pl, this message translates to:
  /// **'Brak paragonów w wybranym okresie.'**
  String get viewModelsScreensReceiptsExportNoReceiptsInDateRangeError;

  /// Treść udostępnianej wiadomości/e-maila podczas eksportu.
  ///
  /// In pl, this message translates to:
  /// **'Eksport paragonów z Paragonik dla okresu: {dateRange}'**
  String viewModelsScreensReceiptsExportShareText(String dateRange);

  /// Tytuł e-maila podczas eksportu paragonów.
  ///
  /// In pl, this message translates to:
  /// **'Paragonik - eksport paragonów z okresu {dateRange}'**
  String viewModelsScreensReceiptsExportShareSubject(String dateRange);

  /// Prefiks nazwy pliku dla eksportu paragonów do CSV.
  ///
  /// In pl, this message translates to:
  /// **'paragony'**
  String get viewModelsScreensReceiptsExportFileNamePrefix;

  /// Etykieta ustawienia wyboru języka.
  ///
  /// In pl, this message translates to:
  /// **'Język aplikacji'**
  String get screensSettingsLanguageSettingTitle;

  /// Tytuł okna dialogowego do wyboru języka.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz język'**
  String get screensSettingsLanguageDialogTitle;

  /// Nagłówek kolumny 'Data Zakupu' w pliku CSV.
  ///
  /// In pl, this message translates to:
  /// **'Data Zakupu'**
  String get servicesCsvExportHeaderPurchaseDate;

  /// Nagłówek kolumny 'Sklep' w pliku CSV.
  ///
  /// In pl, this message translates to:
  /// **'Sklep'**
  String get servicesCsvExportHeaderStore;

  /// Nagłówek kolumny 'Kwota' w pliku CSV.
  ///
  /// In pl, this message translates to:
  /// **'Kwota'**
  String get servicesCsvExportHeaderAmount;

  /// Nagłówek kolumny 'Data Dodania' w pliku CSV.
  ///
  /// In pl, this message translates to:
  /// **'Data Dodania'**
  String get servicesCsvExportHeaderDateAdded;

  /// Komunikat błędu wyświetlany, gdy wystąpi błań podczas przetwarzania obrazu.
  ///
  /// In pl, this message translates to:
  /// **'Błąd podczas przetwarzania obrazu'**
  String get servicesImageProcessingError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
