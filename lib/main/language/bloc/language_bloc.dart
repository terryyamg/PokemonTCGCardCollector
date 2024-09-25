import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState('en_US')) {
    on<ChangeLanguage>((event, emit) async {
      await _saveLanguage(event.languageCode);
      emit(LanguageState(event.languageCode));
    });
    on<LoadSavedLanguage>((event, emit) async {
      final savedLanguage = await _loadSavedLanguage();
      emit(LanguageState(savedLanguage));
    });
  }

  Future<void> _saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
  }

  Future<String> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language') ?? 'en_US';
  }

  void loadSavedLanguage() {
    add(LoadSavedLanguage());
  }
}
