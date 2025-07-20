import 'package:digital_vault/src/core/theme/app_theme.dart';
import 'package:digital_vault/src/core/providers/providers.dart';
import 'package:digital_vault/src/features/auth/presentation/widgets/numeric_keypad.dart';
import 'package:digital_vault/src/features/auth/presentation/widgets/pin_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  String _pin = '';
  bool _isConfirming = false;
  String _confirmPin = '';

  void _onKeyPressed(String value) {
    if (value == '⌫') {
      if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          setState(() {
            _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
          });
        }
      } else {
        if (_pin.isNotEmpty) {
          setState(() {
            _pin = _pin.substring(0, _pin.length - 1);
          });
        }
      }
    } else {
      if (_isConfirming) {
        if (_confirmPin.length < 4) {
          setState(() {
            _confirmPin += value;
          });

          if (_confirmPin.length == 4) {
            _verifyPins();
          }
        }
      } else {
        if (_pin.length < 4) {
          setState(() {
            _pin += value;
          });

          if (_pin.length == 4) {
            setState(() {
              _isConfirming = true;
            });
          }
        }
      }
    }
  }

  Future<void> _verifyPins() async {
    if (_pin == _confirmPin) {
      // PINs match, save to API and proceed to biometric setup
      try {
        final authRepository = ref.read(authRepositoryProvider);
        await authRepository.setSecuritySettings(
          newPin: _pin,
          biometricEnabled: false, // Will be set up later
        );

        if (!mounted) return;

        _showBiometricSetup();
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _confirmPin = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save PIN: ${e.toString()}'),
            backgroundColor: AppTheme.googleRed,
          ),
        );
      }
    } else {
      // PINs don't match, reset confirmation
      setState(() {
        _confirmPin = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PINs do not match. Please try again.'),
          backgroundColor: AppTheme.googleRed,
        ),
      );
    }
  }

  void _showBiometricSetup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBiometricSetupModal(),
    );
  }

  Widget _buildBiometricSetupModal() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.mediumGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.googleGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.fingerprint,
                  color: AppTheme.googleGreen,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Secure NeoDocs',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Text(
                'Set up biometric authentication for quick and secure access',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Security options
              _buildSecurityOption(
                context,
                icon: Icons.lock_outline,
                title: 'Use your screen lock',
                subtitle:
                    'Protect NeoDocs by using your existing phone screen lock',
                isSelected: true,
                onTap: () {
                  Navigator.pop(context);
                  _proceedToHome();
                },
              ),
              const SizedBox(height: 16),
              _buildSecurityOption(
                context,
                icon: Icons.pin_outlined,
                title: 'Use NeoDocs PIN',
                subtitle: 'Use your 4-digit PIN for authentication',
                isSelected: false,
                onTap: () {
                  Navigator.pop(context);
                  _proceedToHome();
                },
              ),
              const SizedBox(height: 24),

              // Skip button
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _proceedToHome();
                },
                child: Text(
                  'Skip for now',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.googleBlue.withOpacity(0.1)
              : AppTheme.lightGrey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.googleBlue : AppTheme.mediumGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.googleBlue.withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppTheme.googleBlue
                    : AppTheme.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppTheme.googleBlue
                          : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppTheme.googleBlue, size: 24),
          ],
        ),
      ),
    );
  }

  void _proceedToHome() {
    // In a real app, you would save the PIN securely here
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section with proper spacing
            Expanded(
              flex: 3,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.googleBlue,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.googleBlue.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isConfirming
                              ? Icons.lock_outline
                              : Icons.pin_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _isConfirming ? 'Confirm your PIN' : 'Create a PIN',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isConfirming
                            ? 'Enter the same PIN again to confirm'
                            : 'You will use this to unlock NeoDocs',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // PIN Indicator Section
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PinIndicator(
                      enteredLength: _isConfirming
                          ? _confirmPin.length
                          : _pin.length,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_isConfirming ? _confirmPin.length : _pin.length}/4',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Numeric Keypad Section
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: NumericKeypad(onKeyPressed: _onKeyPressed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
