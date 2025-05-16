import 'package:finalportfolio/ui/screens/your_movies_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../utils/constants.dart';
import '../widgets/custom_navigation_bar.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    final gradientColors = isDarkMode
        ? Constants.darkThemeBackgroundGradient
        : Constants.lightThemeBackgroundGradient;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: CustomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            }
          },
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              const HomeScreen(),
              YourMoviesScreen(
                isActive: _selectedIndex == 1,
              ),
              const SettingsScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
