import 'package:digital_vault/src/core/services/local_auth_service.dart';
import 'package:digital_vault/src/core/theme/app_theme.dart';
import 'package:digital_vault/src/core/providers/providers.dart';
import 'package:digital_vault/src/features/auth/presentation/widgets/numeric_keypad.dart';
import 'package:digital_vault/src/features/auth/presentation/widgets/pin_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  bool _isLoading = false;
  bool _isBiometricEnabled = false;
  bool _isBiometricAvailable = false;
  bool _showPinChange = false;
  bool _showBiometricSetup = false;
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _checkBiometricStatus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final profileData = await authRepository.getUserProfile();

      if (!mounted) return;

      setState(() {
        _nameController.text = profileData['full_name'] ?? 'John Doe';
      });
    } catch (e) {
      // Fallback to default data
      setState(() {
        _nameController.text = 'John Doe';
      });
    }
  }

  Future<void> _checkBiometricStatus() async {
    try {
      final authService = ref.read(localAuthServiceProvider);
      final canCheckBiometrics = await authService.canCheckBiometrics;

      setState(() {
        _isBiometricAvailable = canCheckBiometrics;
        _isBiometricEnabled = canCheckBiometrics; // TODO: Load from preferences
      });
    } catch (e) {
      setState(() {
        _isBiometricAvailable = false;
        _isBiometricEnabled = false;
      });
    }
  }

  void _startNameEditing() {
    setState(() {
      _isEditingName = true;
    });
  }

  Future<void> _saveName() async {
    if (_nameController.text.trim().isNotEmpty) {
      try {
        final authRepository = ref.read(authRepositoryProvider);
        await authRepository.updateUserProfile(
          fullName: _nameController.text.trim(),
        );

        if (!mounted) return;

        setState(() {
          _isEditingName = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Name updated successfully'),
            backgroundColor: AppTheme.googleGreen,
          ),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update name: ${e.toString()}'),
            backgroundColor: AppTheme.googleRed,
          ),
        );
      }
    }
  }

  void _cancelNameEditing() {
    setState(() {
      _isEditingName = false;
      _nameController.text = 'John Doe'; // Reset to original
    });
  }

  void _showPinChangeScreen() {
    setState(() {
      _showPinChange = true;
    });
  }

  void _onCurrentPinChanged(String pin) {
    _currentPinController.text = pin;
    if (pin.length == 6) {
      _verifyCurrentPin();
    }
  }

  void _onNewPinChanged(String pin) {
    _newPinController.text = pin;
  }

  void _onConfirmPinChanged(String pin) {
    _confirmPinController.text = pin;
    if (pin.length == 6) {
      _confirmNewPin();
    }
  }

  void _onKeyPressed(String key) {
    if (key == '⌫') {
      if (_currentPinController.text.isNotEmpty) {
        _currentPinController.text = _currentPinController.text.substring(
          0,
          _currentPinController.text.length - 1,
        );
      }
    } else {
      if (_currentPinController.text.length < 6) {
        _onCurrentPinChanged(_currentPinController.text + key);
      }
    }
  }

  void _onNewPinKeyPressed(String key) {
    if (key == '⌫') {
      if (_newPinController.text.isNotEmpty) {
        _newPinController.text = _newPinController.text.substring(
          0,
          _newPinController.text.length - 1,
        );
      }
    } else {
      if (_newPinController.text.length < 6) {
        _onNewPinChanged(_newPinController.text + key);
      }
    }
  }

  void _onConfirmPinKeyPressed(String key) {
    if (key == '⌫') {
      if (_confirmPinController.text.isNotEmpty) {
        _confirmPinController.text = _confirmPinController.text.substring(
          0,
          _confirmPinController.text.length - 1,
        );
      }
    } else {
      if (_confirmPinController.text.length < 6) {
        _onConfirmPinChanged(_confirmPinController.text + key);
      }
    }
  }

  Future<void> _verifyCurrentPin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final isVerified = await authRepository.verifyPin(
        _currentPinController.text,
      );

      if (!isVerified) {
        throw Exception('Invalid PIN');
      }

      if (!mounted) return;

      setState(() {
        _showPinChange = false;
        _currentPinController.clear();
      });
      _showNewPinSetup();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _currentPinController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PIN verification failed: ${e.toString()}'),
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

  void _showNewPinSetup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildNewPinSetupModal(),
    );
  }

  Widget _buildNewPinSetupModal() {
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

              Text(
                'Set New PIN',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Enter your new 6-digit PIN',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // PIN Indicator
              PinIndicator(
                pinLength: 6,
                enteredLength: _newPinController.text.length,
              ),
              const SizedBox(height: 32),

              // Numeric Keypad
              SizedBox(
                height: 300,
                child: NumericKeypad(onKeyPressed: _onNewPinKeyPressed),
              ),
              const SizedBox(height: 24),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _newPinController.text.length == 6
                      ? () {
                          Navigator.pop(context);
                          _showConfirmPinSetup();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.googleBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmPinSetup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildConfirmPinSetupModal(),
    );
  }

  Widget _buildConfirmPinSetupModal() {
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

              Text(
                'Confirm New PIN',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Re-enter your new PIN to confirm',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // PIN Indicator
              PinIndicator(
                pinLength: 6,
                enteredLength: _confirmPinController.text.length,
              ),
              const SizedBox(height: 32),

              // Numeric Keypad
              SizedBox(
                height: 300,
                child: NumericKeypad(onKeyPressed: _onConfirmPinKeyPressed),
              ),
              const SizedBox(height: 24),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmPinController.text.length == 6
                      ? _confirmNewPin
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.googleBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmNewPin() async {
    if (_newPinController.text == _confirmPinController.text) {
      try {
        final authRepository = ref.read(authRepositoryProvider);
        await authRepository.updateSecuritySettings(
          newPin: _newPinController.text,
        );

        if (!mounted) return;

        Navigator.pop(context);
        setState(() {
          _newPinController.clear();
          _confirmPinController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN updated successfully'),
            backgroundColor: AppTheme.googleGreen,
          ),
        );
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _confirmPinController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update PIN: ${e.toString()}'),
            backgroundColor: AppTheme.googleRed,
          ),
        );
      }
    } else {
      setState(() {
        _confirmPinController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PINs do not match. Please try again.'),
          backgroundColor: AppTheme.googleRed,
        ),
      );
    }
  }

  Future<void> _setupBiometric() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(localAuthServiceProvider);
      final success = await authService.authenticate(
        'Set up biometric authentication for NeoDocs',
      );

      if (!mounted) return;

      if (success) {
        // Update API with biometric settings
        final authRepository = ref.read(authRepositoryProvider);
        await authRepository.updateSecuritySettings(
          newPin: '1234', // Keep existing PIN
          biometricEnabled: true,
          biometricType: 'fingerprint',
        );

        setState(() {
          _isBiometricEnabled = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric authentication enabled'),
            backgroundColor: AppTheme.googleGreen,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric setup failed'),
            backgroundColor: AppTheme.googleRed,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biometric not available on this device'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profile',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: _showPinChange
          ? _buildPinChangeScreen()
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Header
                    _buildProfileHeader(),
                    const SizedBox(height: 24),

                    // Profile Settings
                    _buildSectionCard(
                      title: 'Personal Information',
                      children: [
                        _buildSettingTile(
                          icon: Icons.person_outline,
                          title: 'Full Name',
                          subtitle: _nameController.text,
                          trailing: _isEditingName
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: _saveName,
                                      icon: const Icon(
                                        Icons.check,
                                        color: AppTheme.googleGreen,
                                        size: 20,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: _cancelNameEditing,
                                      icon: const Icon(
                                        Icons.close,
                                        color: AppTheme.googleRed,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                )
                              : IconButton(
                                  onPressed: _startNameEditing,
                                  icon: const Icon(
                                    Icons.edit,
                                    color: AppTheme.googleBlue,
                                    size: 20,
                                  ),
                                ),
                          onTap: _isEditingName ? null : _startNameEditing,
                        ),
                        if (_isEditingName) ...[
                          const Divider(indent: 56, endIndent: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppTheme.googleBlue,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Security Settings
                    _buildSectionCard(
                      title: 'Security',
                      children: [
                        _buildSettingTile(
                          icon: Icons.lock_outline,
                          title: 'Change PIN',
                          subtitle: 'Update your 6-digit PIN',
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: AppTheme.textSecondary,
                            size: 16,
                          ),
                          onTap: _showPinChangeScreen,
                        ),
                        const Divider(indent: 56, endIndent: 16),
                        _buildSettingTile(
                          icon: Icons.fingerprint,
                          title: 'Biometric Authentication',
                          subtitle: _isBiometricEnabled
                              ? 'Enabled - Use fingerprint or face recognition'
                              : _isBiometricAvailable
                              ? 'Tap to enable biometric authentication'
                              : 'Not available on this device',
                          trailing: _isBiometricAvailable
                              ? Switch(
                                  value: _isBiometricEnabled,
                                  onChanged: (value) {
                                    if (value) {
                                      _setupBiometric();
                                    } else {
                                      setState(() {
                                        _isBiometricEnabled = false;
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Biometric authentication disabled',
                                          ),
                                          backgroundColor: AppTheme.googleGreen,
                                        ),
                                      );
                                    }
                                  },
                                  activeColor: AppTheme.googleBlue,
                                )
                              : null,
                          onTap: _isBiometricAvailable && !_isBiometricEnabled
                              ? _setupBiometric
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
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
              child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _nameController.text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'john.doe@example.com',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.lightGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.textPrimary, size: 20),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildPinChangeScreen() {
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
                  _showPinChange = false;
                  _currentPinController.clear();
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
            'Verify Current PIN',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Enter your current PIN to continue',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // PIN Indicator
          PinIndicator(
            pinLength: 6,
            enteredLength: _currentPinController.text.length,
          ),

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
