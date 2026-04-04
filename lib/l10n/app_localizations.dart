// Локализация вручную: правки только в этом файле. Файлы lib/l10n/arb/*.arb — справочно для переводчиков, сборку не затрагивают.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Интерфейс всех строк UI.
abstract class AppLocalizations {
  AppLocalizations(this.localeName);

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ky'),
    Locale('ru'),
    Locale('tr'),
  ];
  String get appTitle;
  String get homeHeroEyebrow;
  String get homeLandingSubtitle;
  String get homeHeroTitleLine1;
  String get homeHeroTitleThe;
  String get homeHeroTitleSilence;
  String get askAssistantHint;
  String get homeArchiveSectionTitle;
  String get dataSourceSectionTitle;
  String get dataSourceViewFile;
  String get dataSourceSaveCopy;
  String get dataSourceSavedToast;
  String get dataSourceSaveFailedToast;
  String get dataSourcePdfUnavailable;
  String get dataSourceOpenExternalLink;
  String get dataSourceLinkOpenFailed;
  String get archiveSectionTitleLead;
  String get archiveSectionTitleTail;
  String get archiveViewFullArchive;
  String get archiveCardBirthLabel;
  String get archiveCardDeathLabel;
  String get archiveCaseNumberPrefix;
  String get archiveSourceHeading;
  String get archiveVerdictHeading;
  String get archiveFamilyHeading;
  String get archiveTranscriptHeading;
  String get archiveMetaBirthPlace;
  String get archiveMetaSocialOrigin;
  String get archiveMetaOccupationShort;
  String get archiveFilterTitle;
  String get archiveFilterClear;
  String get archiveFilterSubmitRequest;
  String get archiveOpenFilters;
  String get archiveCatalogEmpty;
  String get tabAiAssistantTitle;
  String get tabAiAssistantSubtitle;
  String get tabAddEntryTitle;
  String get tabAddEntrySubtitle;
  String get navArchive;
  String get navAiAssistant;
  String get navAddEntry;
  String get searchHint;
  String get tooltipMenu;
  String get tooltipSearch;
  String get drawerLanguage;
  String get actionLogin;
  String get actionLogout;
  String get authLoginTitle;
  String get authRegisterTitle;
  String get authEmailLabel;
  String get authPasswordLabel;
  String get authConfirmPasswordLabel;
  String get authFirstNameLabel;
  String get authLastNameLabel;
  String get authSignIn;
  String get authSignUp;
  String get authNoAccount;
  String get authHaveAccount;
  String get authGoRegister;
  String get authGoLogin;
  String get authPanelSubtitle;
  String get authEmailRequired;
  String get authEmailInvalid;
  String get authPasswordRequired;
  String get authPasswordTooShort;
  String get authConfirmMismatch;
  String get addEntryEyebrow;
  String get addEntryTitle;
  String get addEntryWhyTitle;
  String get addEntryWhyBody;
  String get addEntryHowTitle;
  String get addEntryHowIntro;
  String get addEntryHowStep1;
  String get addEntryHowStep2;
  String get addEntryHowStep3;
  String get addEntryTabAuto;
  String get addEntryTabManual;
  String get addEntryDocumentsTitle;
  String get addEntryDocumentsHint;
  String get addEntryPhotosTitle;
  String get addEntryPhotosHint;
  String get addEntryBrowseFiles;
  String get addEntryFileChange;
  String get addEntryFileRemove;
  String get addEntryInvalidFilePdf;
  String get addEntryInvalidFileImage;
  String get addEntrySendData;
  String get addEntryPublish;
  String get addEntryCancel;
  String get addEntryFieldFullName;
  String get addEntryFieldFullNameHint;
  String get addEntryFieldAccusation;
  String get addEntryFieldLifeYears;
  String get addEntryYearFrom;
  String get addEntryYearTo;
  String get addEntryFieldPunishment;
  String get addEntryFieldRegion;
  String get addEntryFieldRegionHint;
  String get addEntryFieldPunishmentDate;
  String get addEntryFieldOccupation;
  String get addEntryFieldRehabDate;
  String get addEntryFieldBiography;
  String get addEntrySubmitPlaceholder;
}

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');

  @override String get appTitle => "Voice from the Archive";
  @override String get homeHeroEyebrow => "THE LIVING DOSSIER";
  @override String get homeLandingSubtitle => "A digital repository dedicated to preserving the testimonies, records, and identities of those once erased by institutional repression.";
  @override String get homeHeroTitleLine1 => "Voices from";
  @override String get homeHeroTitleThe => "the ";
  @override String get homeHeroTitleSilence => "Silence";
  @override String get askAssistantHint => "Ask me";
  @override String get homeArchiveSectionTitle => "From the archive";
  @override String get dataSourceSectionTitle => "Data source";
  @override String get dataSourceViewFile => "View file";
  @override String get dataSourceSaveCopy => "Save or share";
  @override String get dataSourceSavedToast => "File is ready to save or share.";
  @override String get dataSourceSaveFailedToast => "Could not prepare the file.";
  @override String get dataSourcePdfUnavailable => "PDF preview is not available on this device. Save or share the file to open it elsewhere.";
  @override String get dataSourceOpenExternalLink => "Open in browser";
  @override String get dataSourceLinkOpenFailed => "Could not open the link.";
  @override String get archiveSectionTitleLead => "Recent";
  @override String get archiveSectionTitleTail => " recoveries";
  @override String get archiveViewFullArchive => "VIEW FULL ARCHIVE";
  @override String get archiveCardBirthLabel => "BIRTH DATE";
  @override String get archiveCardDeathLabel => "DEATH DATE";
  @override String get archiveCaseNumberPrefix => "Case No.";
  @override String get archiveSourceHeading => "SOURCE";
  @override String get archiveVerdictHeading => "VERDICT";
  @override String get archiveFamilyHeading => "CONSEQUENCES FOR THE FAMILY";
  @override String get archiveTranscriptHeading => "From the interrogation transcript:";
  @override String get archiveMetaBirthPlace => "place of birth";
  @override String get archiveMetaSocialOrigin => "social origin";
  @override String get archiveMetaOccupationShort => "occupation";
  @override String get archiveFilterTitle => "Filters";
  @override String get archiveFilterClear => "Clear";
  @override String get archiveFilterSubmitRequest => "Run search";
  @override String get archiveOpenFilters => "Filters";
  @override String get archiveCatalogEmpty => "No matching records.";
  @override String get tabAiAssistantTitle => "AI Assistant";
  @override String get tabAiAssistantSubtitle => "The assistant will be here.";
  @override String get tabAddEntryTitle => "Add Entry";
  @override String get tabAddEntrySubtitle => "Form to add a record to the archive.";
  @override String get navArchive => "ARCHIVE";
  @override String get navAiAssistant => "AI ASSISTANT";
  @override String get navAddEntry => "ADD ENTRY";
  @override String get searchHint => "Search";
  @override String get tooltipMenu => "Menu";
  @override String get tooltipSearch => "Search";
  @override String get drawerLanguage => "Language";
  @override String get actionLogin => "LOG IN";
  @override String get actionLogout => "LOG OUT";
  @override String get authLoginTitle => "Sign in";
  @override String get authRegisterTitle => "Create account";
  @override String get authEmailLabel => "Email";
  @override String get authPasswordLabel => "Password";
  @override String get authConfirmPasswordLabel => "Confirm password";
  @override String get authFirstNameLabel => "First name (optional)";
  @override String get authLastNameLabel => "Last name (optional)";
  @override String get authSignIn => "Sign in";
  @override String get authSignUp => "Register";
  @override String get authNoAccount => "No account yet?";
  @override String get authHaveAccount => "Already have an account?";
  @override String get authGoRegister => "Create account";
  @override String get authGoLogin => "Sign in";
  @override String get authPanelSubtitle => "Preserve testimonies and memory.";
  @override String get authEmailRequired => "Enter your email";
  @override String get authEmailInvalid => "Invalid email format";
  @override String get authPasswordRequired => "Enter your password";
  @override String get authPasswordTooShort => "At least 8 characters";
  @override String get authConfirmMismatch => "Passwords do not match";
  @override String get addEntryEyebrow => "ENTRY FORM";
  @override String get addEntryTitle => "Add a new record";
  @override String get addEntryWhyTitle => "Why your contribution matters";
  @override String get addEntryWhyBody => "Each documented life restores names, dates, and context that repression tried to erase. Careful, source-based entries strengthen collective memory for families, researchers, and the public.";
  @override String get addEntryHowTitle => "How to use this form";
  @override String get addEntryHowIntro => "Upload scans and photos for automatic extraction where available, or type everything yourself — you can combine both approaches.";
  @override String get addEntryHowStep1 => "«From files»: upload one PDF; text and fields will be suggested when the import service is enabled.";
  @override String get addEntryHowStep2 => "Manual: fill biographical fields and attach portrait or evidence photos yourself.";
  @override String get addEntryHowStep3 => "Review the draft, submit it for moderation, and be ready to clarify sources if we contact you.";
  @override String get addEntryTabAuto => "FROM FILES";
  @override String get addEntryTabManual => "MANUAL";
  @override String get addEntryDocumentsTitle => "PDF document";
  @override String get addEntryDocumentsHint => "Only PDF. Drag and drop here or choose a file.";
  @override String get addEntryPhotosTitle => "Photo";
  @override String get addEntryPhotosHint => "Only JPEG or PNG. Drag and drop here or choose a file.";
  @override String get addEntryBrowseFiles => "Choose file";
  @override String get addEntryFileChange => "Replace";
  @override String get addEntryFileRemove => "Remove file";
  @override String get addEntryInvalidFilePdf => "Only PDF files are accepted.";
  @override String get addEntryInvalidFileImage => "Only JPEG or PNG images are accepted.";
  @override String get addEntrySendData => "SEND MATERIALS";
  @override String get addEntryPublish => "PUBLISH RECORD";
  @override String get addEntryCancel => "CANCEL";
  @override String get addEntryFieldFullName => "Full name";
  @override String get addEntryFieldFullNameHint => "e.g. Ivan Ivanov";
  @override String get addEntryFieldAccusation => "Charge / statutory article";
  @override String get addEntryFieldLifeYears => "Years of life";
  @override String get addEntryYearFrom => "from";
  @override String get addEntryYearTo => "to";
  @override String get addEntryFieldPunishment => "Punishment";
  @override String get addEntryFieldRegion => "Region of residence";
  @override String get addEntryFieldRegionHint => "e.g. Chüy";
  @override String get addEntryFieldPunishmentDate => "Punishment carried out (date)";
  @override String get addEntryFieldOccupation => "Occupation or public role";
  @override String get addEntryFieldRehabDate => "Rehabilitation date";
  @override String get addEntryFieldBiography => "Biography";
  @override String get addEntrySubmitPlaceholder => "Sending to the server is not enabled yet — your draft stays on this device.";
}

class AppLocalizationsKy extends AppLocalizations {
  AppLocalizationsKy() : super('ky');

  @override String get appTitle => "Voice from the Archive";
  @override String get homeHeroEyebrow => "THE LIVING DOSSIER";
  @override String get homeLandingSubtitle => "Бир кездеги институционалдык репрессиядан улам өчүрүлгөндөрдүн күбөлүктөрүн, документтерин жана инсандыгын сактоого арналган санариптик репозиторий.";
  @override String get homeHeroTitleLine1 => "Voices from";
  @override String get homeHeroTitleThe => "the ";
  @override String get homeHeroTitleSilence => "Silence";
  @override String get askAssistantHint => "Суроо бериңиз";
  @override String get homeArchiveSectionTitle => "Архивден";
  @override String get dataSourceSectionTitle => "Дайындар булагы";
  @override String get dataSourceViewFile => "Файлды көрүү";
  @override String get dataSourceSaveCopy => "Сактоо же бөлүшүү";
  @override String get dataSourceSavedToast => "Файл сактоо же бөлүшүүгө даяр.";
  @override String get dataSourceSaveFailedToast => "Файл даярдалган жок.";
  @override String get dataSourcePdfUnavailable => "PDF көрсөтүү бул жерде жеткиликтүү эмес. Файлды сактап, башка колдонмодо ачыңыз.";
  @override String get dataSourceOpenExternalLink => "Серепчиде ачуу";
  @override String get dataSourceLinkOpenFailed => "Шилтемени ачуу мүмкүн болгон жок.";
  @override String get archiveSectionTitleLead => "Жакында";
  @override String get archiveSectionTitleTail => " кайтарылгандар";
  @override String get archiveViewFullArchive => "БАРДЫК АРХИВДИ КӨРҮҮ";
  @override String get archiveCardBirthLabel => "ТУУЛГАН КҮН";
  @override String get archiveCardDeathLabel => "КАЙТЫШКАН КҮН";
  @override String get archiveCaseNumberPrefix => "Иш №";
  @override String get archiveSourceHeading => "БУЛАК";
  @override String get archiveVerdictHeading => "ЧЕЧИМ";
  @override String get archiveFamilyHeading => "ҮЙ-БҮЛӨГӨ ТАСИРИ";
  @override String get archiveTranscriptHeading => "Сурактоо протоколунан:";
  @override String get archiveMetaBirthPlace => "туулган жери";
  @override String get archiveMetaSocialOrigin => "социалдык чыгышы";
  @override String get archiveMetaOccupationShort => "кесиби";
  @override String get archiveFilterTitle => "Чыпкычтар";
  @override String get archiveFilterClear => "Тазалоо";
  @override String get archiveFilterSubmitRequest => "Издөө";
  @override String get archiveOpenFilters => "Чыпкычтар";
  @override String get archiveCatalogEmpty => "Жазуулар табылган жок.";
  @override String get tabAiAssistantTitle => "AI жардамчы";
  @override String get tabAiAssistantSubtitle => "Жардамчы бул жерде болот.";
  @override String get tabAddEntryTitle => "Кошуу";
  @override String get tabAddEntrySubtitle => "Архивге жазуу кошуу формасы.";
  @override String get navArchive => "АРХИВ";
  @override String get navAiAssistant => "AI ЖАРДАМЧЫ";
  @override String get navAddEntry => "КОШУУ";
  @override String get searchHint => "Издөө";
  @override String get tooltipMenu => "Меню";
  @override String get tooltipSearch => "Издөө";
  @override String get drawerLanguage => "Тил";
  @override String get actionLogin => "КИРҮҮ";
  @override String get actionLogout => "ЧЫГУУ";
  @override String get authLoginTitle => "Кирүү";
  @override String get authRegisterTitle => "Катталуу";
  @override String get authEmailLabel => "Электрондук почта";
  @override String get authPasswordLabel => "Сырсөз";
  @override String get authConfirmPasswordLabel => "Сырсөздү кайталоо";
  @override String get authFirstNameLabel => "Аты (милдеттүү эмес)";
  @override String get authLastNameLabel => "Фамилиясы (милдеттүү эмес)";
  @override String get authSignIn => "Кирүү";
  @override String get authSignUp => "Катталуу";
  @override String get authNoAccount => "Аккаунт жокпу?";
  @override String get authHaveAccount => "Аккаунт барбы?";
  @override String get authGoRegister => "Аккаунт түзүү";
  @override String get authGoLogin => "Кирүү";
  @override String get authPanelSubtitle => "Күбөлүктөрдү жана эстеликтерди сактайбыз.";
  @override String get authEmailRequired => "Почтаны киргизиңиз";
  @override String get authEmailInvalid => "Email форматы туура эмес";
  @override String get authPasswordRequired => "Сырсөздү киргизиңиз";
  @override String get authPasswordTooShort => "Эң аз 8 символ";
  @override String get authConfirmMismatch => "Сырсөздөр дал келбейт";
  @override String get addEntryEyebrow => "ЖАЗУУ ФОРМАСЫ";
  @override String get addEntryTitle => "Жаңы жазуу кошуу";
  @override String get addEntryWhyTitle => "Сиздин салымыңыз эмне үчүн маанилүү";
  @override String get addEntryWhyBody => "Ар бир текшерилген жазуу аттарды, даталарды жана контекстти калыбына келтирет. Бул үй-бүлөлөр, изилдөөчүлөр жана коомчулук үчүн орток эстелик базасын бекемдейт.";
  @override String get addEntryHowTitle => "Форманы кантип колдонуу керек";
  @override String get addEntryHowIntro => "Сканерлөө жана сүрөттөрдү жүктөп автоматтык толтурууга (кызмат иштешкенде) же бардыгын кол менен киргизүүгө болот — экөөнү бириктирүүгө да болот.";
  @override String get addEntryHowStep1 => "«Файлдардан» өткөндө: бир PDF тиркеңиз — импорт иштегенде текст жана талаалар сунушталат.";
  @override String get addEntryHowStep2 => "«Кол менен» өткөндө: биографиялык маалыматтарды өзүңүз киргизип, портрет же далил сүрөттөрүн кошуңуз.";
  @override String get addEntryHowStep3 => "Карап чыгыңыз, модерацияга жөнөтүңүз; булактарды тактоо керек болсо сиз менен байланышабыз.";
  @override String get addEntryTabAuto => "ФАЙЛДАН";
  @override String get addEntryTabManual => "КОЛ МЕНЕН";
  @override String get addEntryDocumentsTitle => "PDF документ";
  @override String get addEntryDocumentsHint => "Гана PDF. Сүйрөп алып келиңиз же файл тандаңыз.";
  @override String get addEntryPhotosTitle => "Сүрөт";
  @override String get addEntryPhotosHint => "Гана JPEG же PNG. Сүйрөп алып келиңиз же файл тандаңыз.";
  @override String get addEntryBrowseFiles => "Файл тандоо";
  @override String get addEntryFileChange => "Алмаштыруу";
  @override String get addEntryFileRemove => "Файлды алып салуу";
  @override String get addEntryInvalidFilePdf => "Гана PDF файл кабыл алынат.";
  @override String get addEntryInvalidFileImage => "Гана JPEG же PNG сүрөттөр кабыл алынат.";
  @override String get addEntrySendData => "МАТЕРИАЛДАРДЫ ЖӨНӨТҮҮ";
  @override String get addEntryPublish => "ЖАЗУУНУ ЖАРЫЯЛОО";
  @override String get addEntryCancel => "ЖОККО ЧЫГАРУУ";
  @override String get addEntryFieldFullName => "Аты-жөнү";
  @override String get addEntryFieldFullNameHint => "мисалы: Айбек Айбеков";
  @override String get addEntryFieldAccusation => "Айыптоо / берене";
  @override String get addEntryFieldLifeYears => "Өмүр жылдары";
  @override String get addEntryYearFrom => "баштап";
  @override String get addEntryYearTo => "чейин";
  @override String get addEntryFieldPunishment => "Жаза";
  @override String get addEntryFieldRegion => "Турмуш аймагы";
  @override String get addEntryFieldRegionHint => "мисалы: Чүй";
  @override String get addEntryFieldPunishmentDate => "Жаза аткарылган күн";
  @override String get addEntryFieldOccupation => "Кесиби же кызматы";
  @override String get addEntryFieldRehabDate => "Реабилитация күнү";
  @override String get addEntryFieldBiography => "Биография";
  @override String get addEntrySubmitPlaceholder => "Серверге жөнөтүү азыр иштебейт — черновик бул түзмөктө калат.";
}

class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu() : super('ru');

  @override String get appTitle => "Голос из архива";
  @override String get homeHeroEyebrow => "THE LIVING DOSSIER";
  @override String get homeLandingSubtitle => "Цифровой репозиторий, посвящённый сохранению свидетельств, записей и личностей тех, кого когда-то стёрла институциональная репрессия.";
  @override String get homeHeroTitleLine1 => "Voices from";
  @override String get homeHeroTitleThe => "the ";
  @override String get homeHeroTitleSilence => "Silence";
  @override String get askAssistantHint => "Спросите меня";
  @override String get homeArchiveSectionTitle => "Из архива";
  @override String get dataSourceSectionTitle => "Источник данных";
  @override String get dataSourceViewFile => "Открыть файл";
  @override String get dataSourceSaveCopy => "Сохранить или отправить";
  @override String get dataSourceSavedToast => "Файл готов к сохранению или отправке.";
  @override String get dataSourceSaveFailedToast => "Не удалось подготовить файл.";
  @override String get dataSourcePdfUnavailable => "Просмотр PDF здесь недоступен. Сохраните файл и откройте его во внешнем приложении.";
  @override String get dataSourceOpenExternalLink => "Открыть в браузере";
  @override String get dataSourceLinkOpenFailed => "Не удалось открыть ссылку.";
  @override String get archiveSectionTitleLead => "Недавно";
  @override String get archiveSectionTitleTail => " возвращённые";
  @override String get archiveViewFullArchive => "СМОТРЕТЬ ВЕСЬ АРХИВ";
  @override String get archiveCardBirthLabel => "ДАТА РОЖДЕНИЯ";
  @override String get archiveCardDeathLabel => "ДАТА СМЕРТИ";
  @override String get archiveCaseNumberPrefix => "Дело №";
  @override String get archiveSourceHeading => "ИСТОЧНИК";
  @override String get archiveVerdictHeading => "ПРИГОВОР";
  @override String get archiveFamilyHeading => "ПОСЛЕДСТВИЯ ДЛЯ СЕМЬИ";
  @override String get archiveTranscriptHeading => "Из протокола допроса:";
  @override String get archiveMetaBirthPlace => "место рождения";
  @override String get archiveMetaSocialOrigin => "социальное происхождение";
  @override String get archiveMetaOccupationShort => "род деятельности";
  @override String get archiveFilterTitle => "Фильтрация";
  @override String get archiveFilterClear => "Сбросить";
  @override String get archiveFilterSubmitRequest => "Отправить запрос";
  @override String get archiveOpenFilters => "Фильтры";
  @override String get archiveCatalogEmpty => "Нет записей по заданным условиям.";
  @override String get tabAiAssistantTitle => "AI Assistant";
  @override String get tabAiAssistantSubtitle => "Здесь будет помощник.";
  @override String get tabAddEntryTitle => "Новая запись";
  @override String get tabAddEntrySubtitle => "Форма добавления записи в архив.";
  @override String get navArchive => "АРХИВ";
  @override String get navAiAssistant => "AI АССИСТЕНТ";
  @override String get navAddEntry => "ДОБАВИТЬ";
  @override String get searchHint => "Поиск";
  @override String get tooltipMenu => "Меню";
  @override String get tooltipSearch => "Поиск";
  @override String get drawerLanguage => "Язык";
  @override String get actionLogin => "ВОЙТИ";
  @override String get actionLogout => "ВЫЙТИ";
  @override String get authLoginTitle => "Вход";
  @override String get authRegisterTitle => "Регистрация";
  @override String get authEmailLabel => "Электронная почта";
  @override String get authPasswordLabel => "Пароль";
  @override String get authConfirmPasswordLabel => "Повторите пароль";
  @override String get authFirstNameLabel => "Имя (необязательно)";
  @override String get authLastNameLabel => "Фамилия (необязательно)";
  @override String get authSignIn => "Войти";
  @override String get authSignUp => "Зарегистрироваться";
  @override String get authNoAccount => "Нет аккаунта?";
  @override String get authHaveAccount => "Уже есть аккаунт?";
  @override String get authGoRegister => "Создать аккаунт";
  @override String get authGoLogin => "Войти";
  @override String get authPanelSubtitle => "Сохраняем свидетельства и память.";
  @override String get authEmailRequired => "Введите почту";
  @override String get authEmailInvalid => "Некорректный формат email";
  @override String get authPasswordRequired => "Введите пароль";
  @override String get authPasswordTooShort => "Не менее 8 символов";
  @override String get authConfirmMismatch => "Пароли не совпадают";
  @override String get addEntryEyebrow => "ФОРМА ЗАПИСИ";
  @override String get addEntryTitle => "Добавление новой записи";
  @override String get addEntryWhyTitle => "Почему ваша запись важна";
  @override String get addEntryWhyBody => "Каждая тщательно оформленная карточка возвращает в оборот памяти имена, даты и обстоятельства, которые пытались стереть. Проверяемые факты помогают родственникам, исследователям и широкой аудитории опираться на общую базу.";
  @override String get addEntryHowTitle => "Как пользоваться формой";
  @override String get addEntryHowIntro => "Можно загрузить сканы и фото для автоматического разбора (когда сервис подключён) или заполнить всё вручную — оба способа можно сочетать.";
  @override String get addEntryHowStep1 => "Вкладка «Из файлов»: прикрепите один PDF — текст и поля будут предложены после включения импорта.";
  @override String get addEntryHowStep2 => "Вкладка «Вручную»: введите биографию и ключевые сведения сами и добавьте портретные или документальные фото.";
  @override String get addEntryHowStep3 => "Проверьте черновик, отправьте запись на модерацию и будьте готовы уточнить источники, если с вами свяжутся.";
  @override String get addEntryTabAuto => "ИЗ ФАЙЛОВ";
  @override String get addEntryTabManual => "ВРУЧНУЮ";
  @override String get addEntryDocumentsTitle => "PDF-документ";
  @override String get addEntryDocumentsHint => "Только PDF. Перетащите сюда или выберите файл.";
  @override String get addEntryPhotosTitle => "Фотография";
  @override String get addEntryPhotosHint => "Только JPEG или PNG. Перетащите сюда или выберите файл.";
  @override String get addEntryBrowseFiles => "Выбрать файл";
  @override String get addEntryFileChange => "Заменить";
  @override String get addEntryFileRemove => "Убрать файл";
  @override String get addEntryInvalidFilePdf => "Допускается только файл в формате PDF.";
  @override String get addEntryInvalidFileImage => "Допускаются только изображения JPEG или PNG.";
  @override String get addEntrySendData => "ОТПРАВИТЬ МАТЕРИАЛЫ";
  @override String get addEntryPublish => "ОПУБЛИКОВАТЬ ЗАПИСЬ";
  @override String get addEntryCancel => "ОТМЕНА";
  @override String get addEntryFieldFullName => "Имя и фамилия";
  @override String get addEntryFieldFullNameHint => "например: Иван Иванов";
  @override String get addEntryFieldAccusation => "Обвинение / статья";
  @override String get addEntryFieldLifeYears => "Годы жизни";
  @override String get addEntryYearFrom => "от";
  @override String get addEntryYearTo => "до";
  @override String get addEntryFieldPunishment => "Наказание";
  @override String get addEntryFieldRegion => "Регион проживания";
  @override String get addEntryFieldRegionHint => "например: Чуйская область";
  @override String get addEntryFieldPunishmentDate => "Дата исполнения наказания";
  @override String get addEntryFieldOccupation => "Род деятельности";
  @override String get addEntryFieldRehabDate => "Дата реабилитации";
  @override String get addEntryFieldBiography => "Биография";
  @override String get addEntrySubmitPlaceholder => "Отправка на сервер пока не подключена — черновик остаётся на этом устройстве.";
}

class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr() : super('tr');

  @override String get appTitle => "Arşivden ses";
  @override String get homeHeroEyebrow => "THE LIVING DOSSIER";
  @override String get homeLandingSubtitle => "Kurumsal baskı tarafından silinenlerin tanıklıklarını, kayıtlarını ve kimliklerini korumaya adanmış dijital bir depo.";
  @override String get homeHeroTitleLine1 => "Voices from";
  @override String get homeHeroTitleThe => "the ";
  @override String get homeHeroTitleSilence => "Silence";
  @override String get askAssistantHint => "Bana sor";
  @override String get homeArchiveSectionTitle => "Arşivden";
  @override String get dataSourceSectionTitle => "Veri kaynağı";
  @override String get dataSourceViewFile => "Dosyayı aç";
  @override String get dataSourceSaveCopy => "Kaydet veya paylaş";
  @override String get dataSourceSavedToast => "Dosya kaydetmeye veya paylaşmaya hazır.";
  @override String get dataSourceSaveFailedToast => "Dosya hazırlanamadı.";
  @override String get dataSourcePdfUnavailable => "PDF önizlemesi bu cihazda yok. Dosyayı kaydedip başka bir uygulamada açın.";
  @override String get dataSourceOpenExternalLink => "Tarayıcıda aç";
  @override String get dataSourceLinkOpenFailed => "Bağlantı açılamadı.";
  @override String get archiveSectionTitleLead => "Yakın";
  @override String get archiveSectionTitleTail => " dönenler";
  @override String get archiveViewFullArchive => "TÜM ARŞİVİ GÖRÜNTÜLE";
  @override String get archiveCardBirthLabel => "DOĞUM TARİHİ";
  @override String get archiveCardDeathLabel => "ÖLÜM TARİHİ";
  @override String get archiveCaseNumberPrefix => "Dosya No.";
  @override String get archiveSourceHeading => "KAYNAK";
  @override String get archiveVerdictHeading => "HÜKÜM";
  @override String get archiveFamilyHeading => "AİLE İÇİN SONUÇLAR";
  @override String get archiveTranscriptHeading => "Sorgu tutanağından:";
  @override String get archiveMetaBirthPlace => "doğum yeri";
  @override String get archiveMetaSocialOrigin => "sosyal köken";
  @override String get archiveMetaOccupationShort => "meslek";
  @override String get archiveFilterTitle => "Filtreleme";
  @override String get archiveFilterClear => "Temizle";
  @override String get archiveFilterSubmitRequest => "Sorguyu gönder";
  @override String get archiveOpenFilters => "Filtreler";
  @override String get archiveCatalogEmpty => "Eşleşen kayıt yok.";
  @override String get tabAiAssistantTitle => "Yapay zekâ asistanı";
  @override String get tabAiAssistantSubtitle => "Asistan burada olacak.";
  @override String get tabAddEntryTitle => "Kayıt ekle";
  @override String get tabAddEntrySubtitle => "Arşive kayıt ekleme formu.";
  @override String get navArchive => "ARŞİV";
  @override String get navAiAssistant => "YZ ASİSTAN";
  @override String get navAddEntry => "EKLE";
  @override String get searchHint => "Ara";
  @override String get tooltipMenu => "Menü";
  @override String get tooltipSearch => "Ara";
  @override String get drawerLanguage => "Dil";
  @override String get actionLogin => "GİRİŞ";
  @override String get actionLogout => "ÇIKIŞ";
  @override String get authLoginTitle => "Giriş";
  @override String get authRegisterTitle => "Hesap oluştur";
  @override String get authEmailLabel => "E-posta";
  @override String get authPasswordLabel => "Şifre";
  @override String get authConfirmPasswordLabel => "Şifreyi onayla";
  @override String get authFirstNameLabel => "Ad (isteğe bağlı)";
  @override String get authLastNameLabel => "Soyad (isteğe bağlı)";
  @override String get authSignIn => "Giriş yap";
  @override String get authSignUp => "Kayıt ol";
  @override String get authNoAccount => "Hesabınız yok mu?";
  @override String get authHaveAccount => "Zaten hesabınız var mı?";
  @override String get authGoRegister => "Hesap oluştur";
  @override String get authGoLogin => "Giriş yap";
  @override String get authPanelSubtitle => "Tanıklıkları ve hafızayı koruyoruz.";
  @override String get authEmailRequired => "E-postanızı girin";
  @override String get authEmailInvalid => "Geçersiz e-posta biçimi";
  @override String get authPasswordRequired => "Şifrenizi girin";
  @override String get authPasswordTooShort => "En az 8 karakter";
  @override String get authConfirmMismatch => "Şifreler eşleşmiyor";
  @override String get addEntryEyebrow => "KAYIT FORMU";
  @override String get addEntryTitle => "Yeni kayıt ekle";
  @override String get addEntryWhyTitle => "Katkınız neden önemli";
  @override String get addEntryWhyBody => "Her doğrulanmış kayıt, baskının silmeye çalıştığı isimleri, tarihleri ve bağlamı geri getirir. Aileler, araştırmacılar ve kamu için ortak, güvenilir bir hafıza oluşturur.";
  @override String get addEntryHowTitle => "Formu nasıl kullanırsınız";
  @override String get addEntryHowIntro => "Taramaları ve fotoğrafları içe aktarma hizmeti açıldığında otomatik doldurma için yükleyebilir veya her şeyi elle girebilirsiniz — ikisini birleştirmek de mümkün.";
  @override String get addEntryHowStep1 => "«Dosyalardan» sekmesi: bir PDF yükleyin; içe aktarma etkinleşince metin ve alanlar önerilecek.";
  @override String get addEntryHowStep2 => "«Elle» sekmesi: biyografik bilgileri kendiniz girin; portre veya kanıt fotoğrafları ekleyin.";
  @override String get addEntryHowStep3 => "Taslağı gözden geçirin, moderasyona gönderin; kaynakları netleştirmemiz gerekirse size ulaşırız.";
  @override String get addEntryTabAuto => "DOSYALARDAN";
  @override String get addEntryTabManual => "ELLE";
  @override String get addEntryDocumentsTitle => "PDF belgesi";
  @override String get addEntryDocumentsHint => "Yalnızca PDF. Sürükleyip bırakın veya dosya seçin.";
  @override String get addEntryPhotosTitle => "Fotoğraf";
  @override String get addEntryPhotosHint => "Yalnızca JPEG veya PNG. Sürükleyip bırakın veya dosya seçin.";
  @override String get addEntryBrowseFiles => "Dosya seç";
  @override String get addEntryFileChange => "Değiştir";
  @override String get addEntryFileRemove => "Dosyayı kaldır";
  @override String get addEntryInvalidFilePdf => "Yalnızca PDF dosyaları kabul edilir.";
  @override String get addEntryInvalidFileImage => "Yalnızca JPEG veya PNG görselleri kabul edilir.";
  @override String get addEntrySendData => "MATERYALLERİ GÖNDER";
  @override String get addEntryPublish => "KAYDI YAYINLA";
  @override String get addEntryCancel => "İPTAL";
  @override String get addEntryFieldFullName => "Ad soyad";
  @override String get addEntryFieldFullNameHint => "ör. Ahmet Yılmaz";
  @override String get addEntryFieldAccusation => "Suçlama / madde";
  @override String get addEntryFieldLifeYears => "Yaşam yılları";
  @override String get addEntryYearFrom => "başlangıç";
  @override String get addEntryYearTo => "bitiş";
  @override String get addEntryFieldPunishment => "Ceza";
  @override String get addEntryFieldRegion => "İkamet bölgesi";
  @override String get addEntryFieldRegionHint => "ör. Çüy";
  @override String get addEntryFieldPunishmentDate => "Ceza infaz tarihi";
  @override String get addEntryFieldOccupation => "Meslek veya kamusal rol";
  @override String get addEntryFieldRehabDate => "Rehabilitasyon tarihi";
  @override String get addEntryFieldBiography => "Biyografi";
  @override String get addEntrySubmitPlaceholder => "Sunucuya gönderim henüz yok — taslak bu cihazda kalır.";
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
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
  return AppLocalizationsEn();
}
