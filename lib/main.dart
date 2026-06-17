import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Diary',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Dark mode is structurally supported but not yet used — force light.
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Fuel Diary',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
