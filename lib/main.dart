import 'package:digital_vault/src/core/navigation/app_router.dart';
import 'package:digital_vault/src/core/theme/app_theme.dart';
// main.dart: The entry point of the NeoDocs application.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // runApp() is the entry point for the Flutter application.
  // We wrap the entire app in a ProviderScope to make Riverpod providers
  // available throughout the widget tree.
  runApp(const ProviderScope(child: MyApp()));
}

/// MyApp is the root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp.router is used to integrate GoRouter for navigation.
    return MaterialApp.router(
      // The title of the application, used by the OS.
      title: 'NeoDocs',

      // The theme of the application. We use Material 3 for a modern look.
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // The router configuration from our app_router.dart file.
      routerConfig: appRouter,

      // Disable the debug banner in the top-right corner.
      debugShowCheckedModeBanner: false,
    );
  }
}
