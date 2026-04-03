import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ky'),
    Locale('ru'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice from the Archive'**
  String get appTitle;

  /// No description provided for @homeHeroEyebrow.
  ///
  /// In en, this message translates to:
  /// **'THE LIVING DOSSIER'**
  String get homeHeroEyebrow;

  /// No description provided for @homeLandingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A digital repository dedicated to preserving the testimonies, records, and identities of those once erased by institutional repression.'**
  String get homeLandingSubtitle;

  /// No description provided for @homeHeroTitleLine1.
  ///
  /// In en, this message translates to:
  /// **'Voices from'**
  String get homeHeroTitleLine1;

  /// No description provided for @homeHeroTitleThe.
  ///
  /// In en, this message translates to:
  /// **'the '**
  String get homeHeroTitleThe;

  /// No description provided for @homeHeroTitleSilence.
  ///
  /// In en, this message translates to:
  /// **'Silence'**
  String get homeHeroTitleSilence;

  /// No description provided for @askAssistantHint.
  ///
  /// In en, this message translates to:
  /// **'Ask me'**
  String get askAssistantHint;

  /// No description provided for @placeholderSectionBody.
  ///
  /// In en, this message translates to:
  /// **'Content placeholder'**
  String get placeholderSectionBody;

  /// No description provided for @homeSectionArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive materials'**
  String get homeSectionArchiveTitle;

  /// No description provided for @homeSectionArchiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A catalog of documents, records, and memories will appear here.'**
  String get homeSectionArchiveSubtitle;

  /// No description provided for @homeSectionStoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Stories and testimonies'**
  String get homeSectionStoriesTitle;

  /// No description provided for @homeSectionStoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personal stories and related materials.'**
  String get homeSectionStoriesSubtitle;

  /// No description provided for @homeSectionHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Support the project'**
  String get homeSectionHelpTitle;

  /// No description provided for @homeSectionHelpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Volunteering, donations, and spreading the word — placeholder.'**
  String get homeSectionHelpSubtitle;

  /// No description provided for @homeSectionLegalTitle.
  ///
  /// In en, this message translates to:
  /// **'Contacts and legal'**
  String get homeSectionLegalTitle;

  /// No description provided for @homeSectionLegalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Details, privacy policy, and contact — placeholder.'**
  String get homeSectionLegalSubtitle;

  /// No description provided for @tabAiAssistantTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get tabAiAssistantTitle;

  /// No description provided for @tabAiAssistantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The assistant will be here.'**
  String get tabAiAssistantSubtitle;

  /// No description provided for @tabAddEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Entry'**
  String get tabAddEntryTitle;

  /// No description provided for @tabAddEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Form to add a record to the archive.'**
  String get tabAddEntrySubtitle;

  /// No description provided for @navArchive.
  ///
  /// In en, this message translates to:
  /// **'ARCHIVE'**
  String get navArchive;

  /// No description provided for @navAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI ASSISTANT'**
  String get navAiAssistant;

  /// No description provided for @navAddEntry.
  ///
  /// In en, this message translates to:
  /// **'ADD ENTRY'**
  String get navAddEntry;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// No description provided for @tooltipMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get tooltipMenu;

  /// No description provided for @tooltipSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get tooltipSearch;

  /// No description provided for @drawerLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get drawerLanguage;

  /// No description provided for @actionLogin.
  ///
  /// In en, this message translates to:
  /// **'LOG IN'**
  String get actionLogin;

  /// No description provided for @actionLogout.
  ///
  /// In en, this message translates to:
  /// **'LOG OUT'**
  String get actionLogout;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLoginTitle;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authRegisterTitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First name (optional)'**
  String get authFirstNameLabel;

  /// No description provided for @authLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name (optional)'**
  String get authLastNameLabel;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authSignUp;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No account yet?'**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHaveAccount;

  /// No description provided for @authGoRegister.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authGoRegister;

  /// No description provided for @authGoLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authGoLogin;

  /// No description provided for @authPanelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Preserve testimonies and memory.'**
  String get authPanelSubtitle;

  /// No description provided for @authEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEmailRequired;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authPasswordRequired;

  /// No description provided for @authPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get authPasswordTooShort;

  /// No description provided for @authConfirmMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authConfirmMismatch;

  /// No description provided for @addEntryEyebrow.
  ///
  /// In en, this message translates to:
  /// **'ENTRY FORM'**
  String get addEntryEyebrow;

  /// No description provided for @addEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new record'**
  String get addEntryTitle;

  /// No description provided for @addEntryWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why your contribution matters'**
  String get addEntryWhyTitle;

  /// No description provided for @addEntryWhyBody.
  ///
  /// In en, this message translates to:
  /// **'Each documented life restores names, dates, and context that repression tried to erase. Careful, source-based entries strengthen collective memory for families, researchers, and the public.'**
  String get addEntryWhyBody;

  /// No description provided for @addEntryHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How to use this form'**
  String get addEntryHowTitle;

  /// No description provided for @addEntryHowIntro.
  ///
  /// In en, this message translates to:
  /// **'Upload scans and photos for automatic extraction where available, or type everything yourself — you can combine both approaches.'**
  String get addEntryHowIntro;

  /// No description provided for @addEntryHowStep1.
  ///
  /// In en, this message translates to:
  /// **'«From files»: upload one PDF; text and fields will be suggested when the import service is enabled.'**
  String get addEntryHowStep1;

  /// No description provided for @addEntryHowStep2.
  ///
  /// In en, this message translates to:
  /// **'Manual: fill biographical fields and attach portrait or evidence photos yourself.'**
  String get addEntryHowStep2;

  /// No description provided for @addEntryHowStep3.
  ///
  /// In en, this message translates to:
  /// **'Review the draft, submit it for moderation, and be ready to clarify sources if we contact you.'**
  String get addEntryHowStep3;

  /// No description provided for @addEntryTabAuto.
  ///
  /// In en, this message translates to:
  /// **'FROM FILES'**
  String get addEntryTabAuto;

  /// No description provided for @addEntryTabManual.
  ///
  /// In en, this message translates to:
  /// **'MANUAL'**
  String get addEntryTabManual;

  /// No description provided for @addEntryDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'PDF document'**
  String get addEntryDocumentsTitle;

  /// No description provided for @addEntryDocumentsHint.
  ///
  /// In en, this message translates to:
  /// **'Only PDF. Drag and drop here or choose a file.'**
  String get addEntryDocumentsHint;

  /// No description provided for @addEntryPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get addEntryPhotosTitle;

  /// No description provided for @addEntryPhotosHint.
  ///
  /// In en, this message translates to:
  /// **'Only JPEG or PNG. Drag and drop here or choose a file.'**
  String get addEntryPhotosHint;

  /// No description provided for @addEntryBrowseFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get addEntryBrowseFiles;

  /// No description provided for @addEntryFileChange.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get addEntryFileChange;

  /// No description provided for @addEntryFileRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove file'**
  String get addEntryFileRemove;

  /// No description provided for @addEntryInvalidFilePdf.
  ///
  /// In en, this message translates to:
  /// **'Only PDF files are accepted.'**
  String get addEntryInvalidFilePdf;

  /// No description provided for @addEntryInvalidFileImage.
  ///
  /// In en, this message translates to:
  /// **'Only JPEG or PNG images are accepted.'**
  String get addEntryInvalidFileImage;

  /// No description provided for @addEntrySendData.
  ///
  /// In en, this message translates to:
  /// **'SEND MATERIALS'**
  String get addEntrySendData;

  /// No description provided for @addEntryPublish.
  ///
  /// In en, this message translates to:
  /// **'PUBLISH RECORD'**
  String get addEntryPublish;

  /// No description provided for @addEntryCancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get addEntryCancel;

  /// No description provided for @addEntryFieldFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get addEntryFieldFullName;

  /// No description provided for @addEntryFieldFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ivan Ivanov'**
  String get addEntryFieldFullNameHint;

  /// No description provided for @addEntryFieldAccusation.
  ///
  /// In en, this message translates to:
  /// **'Charge / statutory article'**
  String get addEntryFieldAccusation;

  /// No description provided for @addEntryFieldLifeYears.
  ///
  /// In en, this message translates to:
  /// **'Years of life'**
  String get addEntryFieldLifeYears;

  /// No description provided for @addEntryYearFrom.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get addEntryYearFrom;

  /// No description provided for @addEntryYearTo.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get addEntryYearTo;

  /// No description provided for @addEntryFieldPunishment.
  ///
  /// In en, this message translates to:
  /// **'Punishment'**
  String get addEntryFieldPunishment;

  /// No description provided for @addEntryFieldRegion.
  ///
  /// In en, this message translates to:
  /// **'Region of residence'**
  String get addEntryFieldRegion;

  /// No description provided for @addEntryFieldRegionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Chüy'**
  String get addEntryFieldRegionHint;

  /// No description provided for @addEntryFieldPunishmentDate.
  ///
  /// In en, this message translates to:
  /// **'Punishment carried out (date)'**
  String get addEntryFieldPunishmentDate;

  /// No description provided for @addEntryFieldOccupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation or public role'**
  String get addEntryFieldOccupation;

  /// No description provided for @addEntryFieldRehabDate.
  ///
  /// In en, this message translates to:
  /// **'Rehabilitation date'**
  String get addEntryFieldRehabDate;

  /// No description provided for @addEntryFieldBiography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get addEntryFieldBiography;

  /// No description provided for @addEntrySubmitPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Sending to the server is not enabled yet — your draft stays on this device.'**
  String get addEntrySubmitPlaceholder;
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
      <String>['en', 'ky', 'ru', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ky':
      return AppLocalizationsKy();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
