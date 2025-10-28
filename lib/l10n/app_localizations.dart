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

  /// No description provided for @scanner.
  ///
  /// In pl, this message translates to:
  /// **'Skaner'**
  String get scanner;

  /// No description provided for @settings.
  ///
  /// In pl, this message translates to:
  /// **'Ustawienia'**
  String get settings;

  /// No description provided for @statistics.
  ///
  /// In pl, this message translates to:
  /// **'Statystyki'**
  String get statistics;

  /// No description provided for @receipts.
  ///
  /// In pl, this message translates to:
  /// **'Paragony'**
  String get receipts;

  /// No description provided for @totalReceipts.
  ///
  /// In pl, this message translates to:
  /// **'Całkowita liczba paragonów'**
  String get totalReceipts;

  /// No description provided for @receiptsCount.
  ///
  /// In pl, this message translates to:
  /// **'{count, plural, =0{Brak paragonów} =1{{count} paragon} few{{count} paragony} many{{count} paragonów} other{{count} paragonu}}'**
  String receiptsCount(num count);

  /// No description provided for @addReceipt.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj paragon'**
  String get addReceipt;

  /// No description provided for @saveChanges.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz zmiany'**
  String get saveChanges;

  /// No description provided for @screensCameraInitialViewTitle.
  ///
  /// In pl, this message translates to:
  /// **'Rozpocznij Skanowanie'**
  String get screensCameraInitialViewTitle;

  /// No description provided for @screensCameraInitialViewDescription.
  ///
  /// In pl, this message translates to:
  /// **'Zrób zdjęcie paragonu lub wybierz istniejące z galerii, aby dodać nowy wydatek.'**
  String get screensCameraInitialViewDescription;

  /// No description provided for @screensCameraInitialViewTakePhotoButton.
  ///
  /// In pl, this message translates to:
  /// **'Zrób zdjęcie'**
  String get screensCameraInitialViewTakePhotoButton;

  /// No description provided for @screensCameraInitialViewChooseFromGalleryButton.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz z galerii'**
  String get screensCameraInitialViewChooseFromGalleryButton;

  /// No description provided for @screensCameraProcessingViewStatus.
  ///
  /// In pl, this message translates to:
  /// **'Analizuję paragon...'**
  String get screensCameraProcessingViewStatus;

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
