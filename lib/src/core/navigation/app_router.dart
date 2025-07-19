// app_router.dart: Defines the navigation structure of the app using GoRouter.

import 'package:digital_vault/src/core/models/document_model.dart';
import 'package:digital_vault/src/core/models/request_model.dart';
import 'package:digital_vault/src/core/widgets/success_confirmation_screen.dart';
import 'package:digital_vault/src/features/auth/presentation/screens/login_screen.dart';
import 'package:digital_vault/src/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:digital_vault/src/features/auth/presentation/screens/authentication_screen.dart';
import 'package:digital_vault/src/features/auth/presentation/screens/pin_setup_screen.dart';
import 'package:digital_vault/src/features/auth/presentation/screens/registration_screen.dart';
import 'package:digital_vault/src/features/auth/presentation/screens/splash_screen.dart';
import 'package:digital_vault/src/features/dashboard/presentation/screens/home_dashboard_screen.dart';
import 'package:digital_vault/src/features/documents/presentation/screens/document_detail_screen.dart';
import 'package:digital_vault/src/features/documents/presentation/screens/documents_screen.dart';
import 'package:digital_vault/src/features/requests/presentation/screens/request_consent_screen.dart';
import 'package:digital_vault/src/features/requests/presentation/screens/requests_screen.dart';
import 'package:digital_vault/src/features/settings/presentation/screens/activity_history_screen.dart';
import 'package:digital_vault/src/features/settings/presentation/screens/profile_screen.dart';
import 'package:digital_vault/src/features/settings/presentation/screens/security_screen.dart';
import 'package:digital_vault/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:digital_vault/src/features/sharing/presentation/screens/qr_scanner_screen.dart';
import 'package:digital_vault/src/features/documents/presentation/screens/upload_document_screen.dart';
import 'package:digital_vault/src/features/documents/presentation/screens/file_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// A global key for the root navigator. This is used to access the navigator
// from anywhere in the app, which can be useful for complex navigation scenarios.
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// The main router configuration for the app.
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // --- Top-level routes --- //
    // These routes are not part of the main app's bottom navigation bar.
    // They are typically used for authentication, onboarding, or splash screens.
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthenticationScreen(),
    ),
    GoRoute(
      path: '/qr-scanner',
      builder: (context, state) => const QRScannerScreen(),
    ),
    GoRoute(
      path: '/upload-document',
      builder: (context, state) => const UploadDocumentScreen(),
    ),
    GoRoute(
      path: '/view-file',
      builder: (context, state) {
        final params = state.uri.queryParameters;
        return FileViewerScreen(
          filePath: params['path'] ?? '',
          fileName: params['name'] ?? 'Document',
          fileType: params['type'],
        );
      },
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OtpVerificationScreen(),
    ),
    GoRoute(
      path: '/registration',
      builder: (context, state) => const RegistrationScreen(),
    ),
    GoRoute(
      path: '/pin-setup',
      builder: (context, state) => const PinSetupScreen(),
    ),
    GoRoute(
      path: '/success',
      pageBuilder: (context, state) {
        final message = state.extra as String? ?? 'Success!';
        return CustomTransitionPage(
          child: SuccessConfirmationScreen(
            message: message,
            onFinish: () => context.go('/home'),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    ),

    // --- Main Application Shell --- //
    // StatefulShellRoute is used to create a UI with a bottom navigation bar
    // that preserves the state of each tab (branch).
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // The `HomeDashboardScreen` acts as the shell for the navigation.
        return HomeDashboardScreen(navigationShell: navigationShell);
      },
      branches: [
        // Each branch represents a tab in the bottom navigation bar.

        // Branch for the Home tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeTab(),
            ),
          ],
        ),

        // Branch for the Documents tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/documents',
              builder: (context, state) => const DocumentsScreen(),
              // Nested routes for the documents tab.
              routes: [
                GoRoute(
                  path: 'detail', // e.g., /documents/detail
                  builder: (context, state) {
                    final document = state.extra as Document;
                    return DocumentDetailScreen(document: document);
                  },
                ),
              ],
            ),
          ],
        ),

        // Branch for the Requests tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/requests',
              builder: (context, state) => const RequestsScreen(),
              routes: [
                GoRoute(
                  path: 'consent', // e.g., /requests/consent
                  builder: (context, state) {
                    final request = state.extra as DocumentRequest;
                    return RequestConsentScreen(request: request);
                  },
                ),
              ],
            ),
          ],
        ),

        // Branch for the Settings tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: 'profile', // e.g., /settings/profile
                  builder: (context, state) => const ProfileScreen(),
                ),
                GoRoute(
                  path: 'security', // e.g., /settings/security
                  builder: (context, state) => const SecurityScreen(),
                ),
                GoRoute(
                  path: 'activity-history', // e.g., /settings/activity-history
                  builder: (context, state) => const ActivityHistoryScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
