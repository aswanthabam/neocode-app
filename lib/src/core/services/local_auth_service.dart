import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_auth_service.g.dart';

class LocalAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      // Handle exceptions (e.g., user has no biometrics setup)
      print('Error during authentication: $e');
      return false;
    }
  }

  Future<bool> get canCheckBiometrics async => _auth.canCheckBiometrics;
}

@riverpod
LocalAuthService localAuthService(LocalAuthServiceRef ref) {
  return LocalAuthService();
}
