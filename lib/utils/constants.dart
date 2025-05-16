import 'package:flutter/material.dart';

class Constants {
  // TMDB API
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // Firestore
  static const String ratingsCollection = 'ratings';
  static const String userRatingsSubcollection = 'userRatings';

  static const Map<String, int> genreIds = {
    'Action': 28,
    'Animation': 16,
    'Comedy': 35,
    'Drama': 18,
    'Horror': 27,
    'Science Fiction': 878,
    'Thriller': 53,
  };

  static const darkThemeBackgroundGradient = [
    Color(0xFF0E2261),
    Color(0xFF5B2A7F),
  ];

  static const lightThemeBackgroundGradient = [
    Color(0xFF74ABE2),
    Color(0xFFF6D365),
  ];
}

class AppTheme {
  static final ThemeData dark = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF74ABE2),
      secondary: Color(0xFF74ABE2),
      surface: Color(0xFF1C1C1E),
      error: Colors.red,
    ),
    chipTheme: const ChipThemeData(
      selectedColor: Color(0xFF74ABE2),
      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      checkmarkColor: Colors.white,
      secondarySelectedColor: Color(0xFF74ABE2),
      selectedShadowColor: Colors.transparent,
    ),
  );

  static final ThemeData light = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF5B2A7F),
      secondary: Color(0xFF5B2A7F),
      surface: Colors.white,
      error: Colors.red,
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
      elevation: 4,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: Color(0xEE5B2A7F),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      secondarySelectedColor: Color(0xFF5B2A7F),
      disabledColor: Colors.grey,
      selectedShadowColor: Colors.transparent,
    ),
  );
}
