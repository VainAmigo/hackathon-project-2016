// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Голос из архива';

  @override
  String get homeHeroEyebrow => 'THE LIVING DOSSIER';

  @override
  String get homeLandingSubtitle =>
      'Цифровой репозиторий, посвящённый сохранению свидетельств, записей и личностей тех, кого когда-то стёрла институциональная репрессия.';

  @override
  String get homeHeroTitleLine1 => 'Voices from';

  @override
  String get homeHeroTitleThe => 'the ';

  @override
  String get homeHeroTitleSilence => 'Silence';

  @override
  String get askAssistantHint => 'Спросите меня';

  @override
  String get placeholderSectionBody => 'Плейсхолдер контента';

  @override
  String get homeSectionArchiveTitle => 'Материалы архива';

  @override
  String get homeSectionArchiveSubtitle =>
      'Здесь будет каталог документов, записей и воспоминаний.';

  @override
  String get homeSectionStoriesTitle => 'Истории и свидетельства';

  @override
  String get homeSectionStoriesSubtitle =>
      'Раздел для личных историй и связанных с ними материалов.';

  @override
  String get homeSectionHelpTitle => 'Как помочь проекту';

  @override
  String get homeSectionHelpSubtitle =>
      'Плейсхолдер: волонтёрство, пожертвования, распространение.';

  @override
  String get homeSectionLegalTitle => 'Контакты и правовая информация';

  @override
  String get homeSectionLegalSubtitle =>
      'Плейсхолдер: реквизиты, политика конфиденциальности, связь.';

  @override
  String get tabAiAssistantTitle => 'AI Assistant';

  @override
  String get tabAiAssistantSubtitle => 'Здесь будет помощник.';

  @override
  String get tabAddEntryTitle => 'Новая запись';

  @override
  String get tabAddEntrySubtitle => 'Форма добавления записи в архив.';

  @override
  String get navArchive => 'АРХИВ';

  @override
  String get navAiAssistant => 'AI АССИСТЕНТ';

  @override
  String get navAddEntry => 'ДОБАВИТЬ';

  @override
  String get searchHint => 'Поиск';

  @override
  String get tooltipMenu => 'Меню';

  @override
  String get tooltipSearch => 'Поиск';

  @override
  String get drawerLanguage => 'Язык';

  @override
  String get actionLogin => 'ВОЙТИ';

  @override
  String get actionLogout => 'ВЫЙТИ';

  @override
  String get authLoginTitle => 'Вход';

  @override
  String get authRegisterTitle => 'Регистрация';

  @override
  String get authEmailLabel => 'Электронная почта';

  @override
  String get authPasswordLabel => 'Пароль';

  @override
  String get authConfirmPasswordLabel => 'Повторите пароль';

  @override
  String get authFirstNameLabel => 'Имя (необязательно)';

  @override
  String get authLastNameLabel => 'Фамилия (необязательно)';

  @override
  String get authSignIn => 'Войти';

  @override
  String get authSignUp => 'Зарегистрироваться';

  @override
  String get authNoAccount => 'Нет аккаунта?';

  @override
  String get authHaveAccount => 'Уже есть аккаунт?';

  @override
  String get authGoRegister => 'Создать аккаунт';

  @override
  String get authGoLogin => 'Войти';

  @override
  String get authPanelSubtitle => 'Сохраняем свидетельства и память.';

  @override
  String get authEmailRequired => 'Введите почту';

  @override
  String get authEmailInvalid => 'Некорректный формат email';

  @override
  String get authPasswordRequired => 'Введите пароль';

  @override
  String get authPasswordTooShort => 'Не менее 8 символов';

  @override
  String get authConfirmMismatch => 'Пароли не совпадают';

  @override
  String get addEntryEyebrow => 'ФОРМА ЗАПИСИ';

  @override
  String get addEntryTitle => 'Добавление новой записи';

  @override
  String get addEntryWhyTitle => 'Почему ваша запись важна';

  @override
  String get addEntryWhyBody =>
      'Каждая тщательно оформленная карточка возвращает в оборот памяти имена, даты и обстоятельства, которые пытались стереть. Проверяемые факты помогают родственникам, исследователям и широкой аудитории опираться на общую базу.';

  @override
  String get addEntryHowTitle => 'Как пользоваться формой';

  @override
  String get addEntryHowIntro =>
      'Можно загрузить сканы и фото для автоматического разбора (когда сервис подключён) или заполнить всё вручную — оба способа можно сочетать.';

  @override
  String get addEntryHowStep1 =>
      'Вкладка «Из файлов»: прикрепите один PDF — текст и поля будут предложены после включения импорта.';

  @override
  String get addEntryHowStep2 =>
      'Вкладка «Вручную»: введите биографию и ключевые сведения сами и добавьте портретные или документальные фото.';

  @override
  String get addEntryHowStep3 =>
      'Проверьте черновик, отправьте запись на модерацию и будьте готовы уточнить источники, если с вами свяжутся.';

  @override
  String get addEntryTabAuto => 'ИЗ ФАЙЛОВ';

  @override
  String get addEntryTabManual => 'ВРУЧНУЮ';

  @override
  String get addEntryDocumentsTitle => 'PDF-документ';

  @override
  String get addEntryDocumentsHint =>
      'Только PDF. Перетащите сюда или выберите файл.';

  @override
  String get addEntryPhotosTitle => 'Фотография';

  @override
  String get addEntryPhotosHint =>
      'Только JPEG или PNG. Перетащите сюда или выберите файл.';

  @override
  String get addEntryBrowseFiles => 'Выбрать файл';

  @override
  String get addEntryFileChange => 'Заменить';

  @override
  String get addEntryFileRemove => 'Убрать файл';

  @override
  String get addEntryInvalidFilePdf => 'Допускается только файл в формате PDF.';

  @override
  String get addEntryInvalidFileImage =>
      'Допускаются только изображения JPEG или PNG.';

  @override
  String get addEntrySendData => 'ОТПРАВИТЬ МАТЕРИАЛЫ';

  @override
  String get addEntryPublish => 'ОПУБЛИКОВАТЬ ЗАПИСЬ';

  @override
  String get addEntryCancel => 'ОТМЕНА';

  @override
  String get addEntryFieldFullName => 'Имя и фамилия';

  @override
  String get addEntryFieldFullNameHint => 'например: Иван Иванов';

  @override
  String get addEntryFieldAccusation => 'Обвинение / статья';

  @override
  String get addEntryFieldLifeYears => 'Годы жизни';

  @override
  String get addEntryYearFrom => 'от';

  @override
  String get addEntryYearTo => 'до';

  @override
  String get addEntryFieldPunishment => 'Наказание';

  @override
  String get addEntryFieldRegion => 'Регион проживания';

  @override
  String get addEntryFieldRegionHint => 'например: Чуйская область';

  @override
  String get addEntryFieldPunishmentDate => 'Дата исполнения наказания';

  @override
  String get addEntryFieldOccupation => 'Род деятельности';

  @override
  String get addEntryFieldRehabDate => 'Дата реабилитации';

  @override
  String get addEntryFieldBiography => 'Биография';

  @override
  String get addEntrySubmitPlaceholder =>
      'Отправка на сервер пока не подключена — черновик остаётся на этом устройстве.';
}
