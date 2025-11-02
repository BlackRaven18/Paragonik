// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get coreWidgetsAppBottomNavigationBarScannerTabLabel => 'Scanner';

  @override
  String get coreWidgetsAppBottomNavigationBarReceiptsListTabLabel =>
      'Receipts';

  @override
  String get coreWidgetsAppBottomNavigationBarStatisticsTabLabel =>
      'Statistics';

  @override
  String get coreWidgetsAppBottomNavigationBarSettingsTabLabel => 'Settings';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSaveChanges => 'Save Changes';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonExport => 'Export';

  @override
  String get notificationsErrorLoadingReceipts =>
      'Oops! Something went wrong while loading receipts';

  @override
  String get notificationsSuccessChangesSaved => 'Changes saved!';

  @override
  String get notificationsSuccessReceiptDeleted => 'Receipt deleted!';

  @override
  String get notificationsSuccessReceiptAdded => 'Receipt added!';

  @override
  String get notificationErrorLoadingCamera =>
      'Oops! Something went wrong while loading the camera.';

  @override
  String get notificationErrorTakingPicture =>
      'Oops! Something went wrong while taking a picture.';

  @override
  String get notifictationRefusedPermission => 'Permission denied.';

  @override
  String get unknownStore => 'Unknown store';

  @override
  String get screensCameraInitialViewTitle => 'Start Scanning';

  @override
  String get screensCameraInitialViewDescription =>
      'Take a photo of a receipt or choose an existing one from the gallery to add a new expense.';

  @override
  String get screensCameraInitialViewTakePhotoButton => 'Take Photo';

  @override
  String get screensCameraInitialViewChooseFromGalleryButton =>
      'Choose from Gallery';

  @override
  String get screensCameraProcessingViewStatus => 'Analyzing receipt...';

  @override
  String get screensCameraFlashTooltip => 'Toggle flashlight';

  @override
  String get screensCameraImagePreviewViewResultPanelDateNotFound =>
      'Not found';

  @override
  String get screensCameraImagePreviewViewResultPanelUnknownStore =>
      'Unknown store';

  @override
  String get screensCameraImagePreviewViewResultPanelAmountLabel => 'Amount:';

  @override
  String get screensCameraImagePreviewViewResultPanelAmountLabelCorrected =>
      'Amount (Corrected):';

  @override
  String get screensCameraImagePreviewViewResultPanelDateLabel => 'Date:';

  @override
  String get screensCameraImagePreviewViewResultPanelDateLabelCorrected =>
      'Date (Corrected):';

  @override
  String get screensCameraImagePreviewViewResultPanelStoreLabel => 'Store:';

  @override
  String get screensCameraImagePreviewViewImageDisplayShowOriginalTooltip =>
      'Show original';

  @override
  String get screensCameraImagePreviewViewImageDisplayShowScanTooltip =>
      'Show scan';

  @override
  String get screensCameraActionPanelChangePhotoButton => 'Change Photo';

  @override
  String get screensCameraActionPanelProcessButton => 'Process';

  @override
  String get screensCameraHelpersPermissionDialogTitle => 'Permission Denied';

  @override
  String get screensCameraHelpersPermissionDialogContentCamera =>
      'The app needs access to the camera. Please enable the permission in the app settings.';

  @override
  String get screensCameraHelpersPermissionDialogContentGallery =>
      'The app needs access to the gallery. Please enable the permission in the app settings.';

  @override
  String get screensCameraHelpersPermissionDialogOpenSettingsButton =>
      'Open Settings';

  @override
  String get screensReceiptsNoReceiptsSaved => 'No saved receipts.';

  @override
  String get screensReceiptsEditAmountLabel => 'Amount:';

  @override
  String get screensReceiptsEditDateTimeLabel => 'Date and time';

  @override
  String get screensReceiptsEditStoreLabel => 'Store';

  @override
  String get screensReceiptsReceiptsListNoMatchingReceipts =>
      'No matching receipts found.';

  @override
  String get screensReceiptsReceiptsListConfirmDeleteDialogTitle =>
      'Confirm Deletion';

  @override
  String get screensReceiptsReceiptsListConfirmDeleteDialogContent =>
      'Are you sure you want to delete this receipt?';

  @override
  String get screensReceiptsReceiptsScreenWidgetsSearchLabel => 'Search...';

  @override
  String get screensReceiptsReceiptsScreenWidgetsCounterTitle =>
      'Total number of receipts';

  @override
  String get screensReceiptsReceiptsScreenWidgetsGroupingToggleReceiptDate =>
      'Receipt Date';

  @override
  String get screensReceiptsReceiptsScreenWidgetsGroupingToggleAddedDate =>
      'Date Added';

  @override
  String get screensReceiptsReceiptsScreenWidgetsModalsFilterTitle =>
      'Filter by store';

  @override
  String get screensReceiptsReceiptsScreenWidgetsModalsFilterAllStoresOption =>
      'All stores';

  @override
  String
  get screensReceiptsReceiptsScreenWidgetsModalsExportReceiptsDialogTitle =>
      'Export receipts';

  @override
  String
  get screensReceiptsReceiptsScreenWidgetsModalsExportReceiptsDialogDateRangeLabel =>
      'Select date range:';

  @override
  String get screensReceiptsReceiptsScreenExportReceiptsButtonTooltip =>
      'Export receipts';

  @override
  String get screensStatisticsScreenTitle => 'Summary';

  @override
  String get screensStatisticsCardSpendingTitle => 'Spending';

  @override
  String get screensStatisticsCardVsPreviousMonthTitle => 'Previous Month';

  @override
  String get screensStatisticsCardDailyAverageTitle => 'Daily Average';

  @override
  String get screensStatisticsCardReceiptsCountTitle => 'Number of Receipts';

  @override
  String get screensStatisticsStoreSpendingTitle => 'Spending by Store';

  @override
  String get screensStatisticsTimeRangeWeek => 'Week';

  @override
  String get screensStatisticsTimeRangeMonth => 'Month';

  @override
  String get screensStatisticsNoSpendingInRange =>
      'No spending in this period.';

  @override
  String get screensStatisticsRangeLabelCurrentWeek => 'Current Week';

  @override
  String get screensStatisticsRangeLabelCurrentMonth => 'Current Month';

  @override
  String get screensStatisticsRangeLabelCustom => 'Custom';

  @override
  String get widgetsStoreDisplayUnknownStore => 'Unknown store';

  @override
  String get widgetsImageViewerTooltipShowOriginal => 'Show original';

  @override
  String get widgetsImageViewerTooltipShowScan => 'Show scan';

  @override
  String get widgetsModalsStoreSelectionSearchLabel => 'Search store...';

  @override
  String get helpersSumInputDialogTitle => 'Manual Amount Correction';

  @override
  String get helpersSumInputDialogLabel => 'Enter the correct amount';

  @override
  String get helpersModalsFutureDateWarningDialogTitle => 'Future Date';

  @override
  String get helpersModalsFutureDateWarningDialogContent =>
      'The selected receipt date is in the future. Are you sure you want to continue?';

  @override
  String get viewModelsScreensReceiptsGroupToday => 'Today';

  @override
  String get viewModelsScreensReceiptsGroupYesterday => 'Yesterday';

  @override
  String get viewModelsScreensReceiptsGroupThisWeek => 'This Week';

  @override
  String get viewModelsScreensReceiptsGroupEarlier => 'Earlier';

  @override
  String get viewModelsScreensReceiptsExportNoReceiptsInDateRangeError =>
      'No receipts in the selected date range.';

  @override
  String viewModelsScreensReceiptsExportShareText(String dateRange) {
    return 'Paragonik - receipts export for the period $dateRange';
  }

  @override
  String viewModelsScreensReceiptsExportShareSubject(String dateRange) {
    return 'Paragonik - receipts export $dateRange';
  }

  @override
  String get viewModelsScreensReceiptsExportFileNamePrefix => 'receipts';

  @override
  String get screensSettingsLanguageSettingTitle => 'App Language';

  @override
  String get screensSettingsLanguageDialogTitle => 'Choose language';

  @override
  String get servicesCsvExportHeaderPurchaseDate => 'Purchase Date';

  @override
  String get servicesCsvExportHeaderStore => 'Store';

  @override
  String get servicesCsvExportHeaderAmount => 'Amount';

  @override
  String get servicesCsvExportHeaderDateAdded => 'Date Added';
}
