import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override
  List<Object?> get props => [];
}

class ToggleTheme extends ThemeEvent {
  final bool isDark;
  const ToggleTheme(this.isDark);

  @override
  List<Object?> get props => [isDark];
}
