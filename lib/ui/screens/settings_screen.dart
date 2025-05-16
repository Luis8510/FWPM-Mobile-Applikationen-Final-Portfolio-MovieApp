import 'package:finalportfolio/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../bloc/auth/auth_bloc.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final state = context.watch<ThemeBloc>().state;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (user != null) ...[
            Center(
              child: CircleAvatar(
                radius: 40,
                child: Text(
                  (user.displayName?.isNotEmpty ?? false)
                      ? user.displayName![0].toUpperCase()
                      : 'U',
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                user.displayName ?? user.email ?? 'Unknown User',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const Divider(height: 32),
          ],
          Card(
            child: SwitchListTile(
              title: const Text('Dark Theme'),
              value: state.themeMode == ThemeMode.dark,
              onChanged: (value) =>
                  context.read<ThemeBloc>().add(ToggleTheme(value)),
              secondary: const Icon(Icons.brightness_6),
            ),
          ),
          const Divider(height: 32),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => context.read<AuthBloc>().add(LoggedOut()),
            ),
          ),
        ],
      ),
    );
  }
}
