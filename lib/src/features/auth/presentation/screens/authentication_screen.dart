import 'package:digital_vault/src/core/services/local_auth_service.dart';
import 'package:digital_vault/src/core/theme/app_theme.dart';
import 'package:digital_vault/src/features/auth/presentation/screens/pin_setup_screen.dart';
import 'package:digital_vault/src/features/auth/presentation/widgets/numeric_keypad.dart';
import 'package:digital_vault/src/features/auth/presentation/widgets/pin_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  ConsumerState<AuthenticationScreen> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _isLoading = false;
  bool _isBiometricEnabled = true; // This would be loaded from preferences
  bool _showPinInput = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    final authService = ref.read(localAuthServiceProvider);
    final canCheckBiometrics = await authService.canCheckBiometrics;

    if (!mounted) return;

    setState(() {
      _isBiometricEnabled = canCheckBiometrics;
    });
  }

  Future<void> _authenticateWithBiometric() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(localAuthServiceProvider);
      final success = await authService.authenticate(
        'Authenticate to access NeoDocs',
      );

      if (!mounted) return;

      if (success) {
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric authentication failed'),
            backgroundColor: AppTheme.googleRed,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Authentication error: $e'),
          backgroundColor: AppTheme.googleRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showPinInputScreen() {
    setState(() {
      _showPinInput = true;
    });
  }

  void _onPinChanged(String pin) {
    _pinController.text = pin;

    // Auto-submit when PIN is complete (assuming 6-digit PIN)
    if (pin.length == 6) {
      _authenticateWithPin();
    }
  }

  void _onKeyPressed(String key) {
    if (key == '⌫') {
      if (_pinController.text.isNotEmpty) {
        _pinController.text = _pinController.text.substring(
          0,
          _pinController.text.length - 1,
        );
      }
    } else {
      if (_pinController.text.length < 6) {
        _onPinChanged(_pinController.text + key);
      }
    }
  }

  Future<void> _authenticateWithPin() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate PIN verification
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Replace with actual PIN verification
    const correctPin = '123456'; // This should be stored securely

    if (!mounted) return;

    if (_pinController.text == correctPin) {
      context.go('/home');
    } else {
      setState(() {
        _pinController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect PIN'),
          backgroundColor: AppTheme.googleRed,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _goBackToLogin() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      body: SafeArea(
        child: _showPinInput ? _buildPinInput() : _buildAuthOptions(),
      ),
    );
  }

  Widget _buildAuthOptions() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),

          // App Logo and Title
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.googleBlue.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Choose your authentication method',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          // Authentication Options
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Biometric Authentication Button
                if (_isBiometricEnabled) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _authenticateWithBiometric,
                      icon: Icon(
                        Icons.fingerprint,
                        color: Colors.white,
                        size: 24,
                      ),
                      label: Text(
                        'Use Biometric',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.googleBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Divider
                if (_isBiometricEnabled) ...[
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppTheme.mediumGrey)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.textSecondary),
                        ),
                      ),
                      Expanded(child: Divider(color: AppTheme.mediumGrey)),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // PIN Authentication Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _showPinInputScreen,
                    icon: Icon(
                      Icons.lock_outline,
                      color: AppTheme.textPrimary,
                      size: 24,
                    ),
                    label: Text(
                      'Use PIN',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textPrimary,
                      side: BorderSide(color: AppTheme.mediumGrey),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Back to Login
          TextButton(
            onPressed: _goBackToLogin,
            child: Text(
              'Back to Login',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.googleBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Spacer(),

          // Loading indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.googleBlue),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPinInput() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),

          // Back button
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _showPinInput = false;
                  _pinController.clear();
                });
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppTheme.textPrimary,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            'Enter PIN',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Enter your 6-digit PIN to continue',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // PIN Indicator
          PinIndicator(pinLength: 6, enteredLength: _pinController.text.length),

          const SizedBox(height: 60),

          // Numeric Keypad
          SizedBox(
            height: 300,
            child: NumericKeypad(onKeyPressed: _onKeyPressed),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
