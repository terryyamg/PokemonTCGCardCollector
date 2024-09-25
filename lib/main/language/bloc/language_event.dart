

// Events
abstract class LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final String languageCode;

  ChangeLanguage(this.languageCode);
}

class LoadSavedLanguage extends LanguageEvent {}
