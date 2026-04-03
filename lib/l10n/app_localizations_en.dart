// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Voice from the Archive';

  @override
  String get homeHeroEyebrow => 'THE LIVING DOSSIER';

  @override
  String get homeLandingSubtitle =>
      'A digital repository dedicated to preserving the testimonies, records, and identities of those once erased by institutional repression.';

  @override
  String get homeHeroTitleLine1 => 'Voices from';

  @override
  String get homeHeroTitleThe => 'the ';

  @override
  String get homeHeroTitleSilence => 'Silence';

  @override
  String get askAssistantHint => 'Ask me';

  @override
  String get placeholderSectionBody => 'Content placeholder';

  @override
  String get homeSectionArchiveTitle => 'Archive materials';

  @override
  String get homeSectionArchiveSubtitle =>
      'A catalog of documents, records, and memories will appear here.';

  @override
  String get homeSectionStoriesTitle => 'Stories and testimonies';

  @override
  String get homeSectionStoriesSubtitle =>
      'Personal stories and related materials.';

  @override
  String get homeSectionHelpTitle => 'Support the project';

  @override
  String get homeSectionHelpSubtitle =>
      'Volunteering, donations, and spreading the word — placeholder.';

  @override
  String get homeSectionLegalTitle => 'Contacts and legal';

  @override
  String get homeSectionLegalSubtitle =>
      'Details, privacy policy, and contact — placeholder.';

  @override
  String get tabAiAssistantTitle => 'AI Assistant';

  @override
  String get tabAiAssistantSubtitle => 'The assistant will be here.';

  @override
  String get tabAddEntryTitle => 'Add Entry';

  @override
  String get tabAddEntrySubtitle => 'Form to add a record to the archive.';

  @override
  String get navArchive => 'ARCHIVE';

  @override
  String get navAiAssistant => 'AI ASSISTANT';

  @override
  String get navAddEntry => 'ADD ENTRY';

  @override
  String get searchHint => 'Search';

  @override
  String get tooltipMenu => 'Menu';

  @override
  String get tooltipSearch => 'Search';

  @override
  String get drawerLanguage => 'Language';

  @override
  String get actionLogin => 'LOG IN';

  @override
  String get actionLogout => 'LOG OUT';

  @override
  String get authLoginTitle => 'Sign in';

  @override
  String get authRegisterTitle => 'Create account';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authFirstNameLabel => 'First name (optional)';

  @override
  String get authLastNameLabel => 'Last name (optional)';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authSignUp => 'Register';

  @override
  String get authNoAccount => 'No account yet?';

  @override
  String get authHaveAccount => 'Already have an account?';

  @override
  String get authGoRegister => 'Create account';

  @override
  String get authGoLogin => 'Sign in';

  @override
  String get authPanelSubtitle => 'Preserve testimonies and memory.';

  @override
  String get authEmailRequired => 'Enter your email';

  @override
  String get authEmailInvalid => 'Invalid email format';

  @override
  String get authPasswordRequired => 'Enter your password';

  @override
  String get authPasswordTooShort => 'At least 8 characters';

  @override
  String get authConfirmMismatch => 'Passwords do not match';

  @override
  String get addEntryEyebrow => 'ENTRY FORM';

  @override
  String get addEntryTitle => 'Add a new record';

  @override
  String get addEntryWhyTitle => 'Why your contribution matters';

  @override
  String get addEntryWhyBody =>
      'Each documented life restores names, dates, and context that repression tried to erase. Careful, source-based entries strengthen collective memory for families, researchers, and the public.';

  @override
  String get addEntryHowTitle => 'How to use this form';

  @override
  String get addEntryHowIntro =>
      'Upload scans and photos for automatic extraction where available, or type everything yourself — you can combine both approaches.';

  @override
  String get addEntryHowStep1 =>
      '«From files»: upload one PDF; text and fields will be suggested when the import service is enabled.';

  @override
  String get addEntryHowStep2 =>
      'Manual: fill biographical fields and attach portrait or evidence photos yourself.';

  @override
  String get addEntryHowStep3 =>
      'Review the draft, submit it for moderation, and be ready to clarify sources if we contact you.';

  @override
  String get addEntryTabAuto => 'FROM FILES';

  @override
  String get addEntryTabManual => 'MANUAL';

  @override
  String get addEntryDocumentsTitle => 'PDF document';

  @override
  String get addEntryDocumentsHint =>
      'Only PDF. Drag and drop here or choose a file.';

  @override
  String get addEntryPhotosTitle => 'Photo';

  @override
  String get addEntryPhotosHint =>
      'Only JPEG or PNG. Drag and drop here or choose a file.';

  @override
  String get addEntryBrowseFiles => 'Choose file';

  @override
  String get addEntryFileChange => 'Replace';

  @override
  String get addEntryFileRemove => 'Remove file';

  @override
  String get addEntryInvalidFilePdf => 'Only PDF files are accepted.';

  @override
  String get addEntryInvalidFileImage =>
      'Only JPEG or PNG images are accepted.';

  @override
  String get addEntrySendData => 'SEND MATERIALS';

  @override
  String get addEntryPublish => 'PUBLISH RECORD';

  @override
  String get addEntryCancel => 'CANCEL';

  @override
  String get addEntryFieldFullName => 'Full name';

  @override
  String get addEntryFieldFullNameHint => 'e.g. Ivan Ivanov';

  @override
  String get addEntryFieldAccusation => 'Charge / statutory article';

  @override
  String get addEntryFieldLifeYears => 'Years of life';

  @override
  String get addEntryYearFrom => 'from';

  @override
  String get addEntryYearTo => 'to';

  @override
  String get addEntryFieldPunishment => 'Punishment';

  @override
  String get addEntryFieldRegion => 'Region of residence';

  @override
  String get addEntryFieldRegionHint => 'e.g. Chüy';

  @override
  String get addEntryFieldPunishmentDate => 'Punishment carried out (date)';

  @override
  String get addEntryFieldOccupation => 'Occupation or public role';

  @override
  String get addEntryFieldRehabDate => 'Rehabilitation date';

  @override
  String get addEntryFieldBiography => 'Biography';

  @override
  String get addEntrySubmitPlaceholder =>
      'Sending to the server is not enabled yet — your draft stays on this device.';
}
