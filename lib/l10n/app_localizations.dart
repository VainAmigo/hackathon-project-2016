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
  /// **'The add-entry form will be here.'**
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
