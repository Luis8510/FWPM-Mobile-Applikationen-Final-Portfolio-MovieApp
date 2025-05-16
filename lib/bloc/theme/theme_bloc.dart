import 'package:bloc/bloc.dart';
import 'package:finalportfolio/bloc/theme/theme_event.dart';
import 'package:finalportfolio/bloc/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'theme_event.dart';
export 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static Future<ThemeBloc> create() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_key) ?? false;
    return ThemeBloc._(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  ThemeBloc._(ThemeMode start) : super(ThemeState(start)) {
    on<ToggleTheme>(_onToggleTheme);
  }

  static const _key = 'isDark';

  Future<void> _onToggleTheme(
      ToggleTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, event.isDark);
    emit(ThemeState(event.isDark ? ThemeMode.dark : ThemeMode.light));
  }
}
