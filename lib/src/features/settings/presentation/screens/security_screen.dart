import 'package:digital_vault/src/core/services/local_auth_service.dart';
import 'package:digital_vault/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  bool _isBiometricEnabled = false;
  bool _isBiometricAvailable = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final authService = ref.read(localAuthServiceProvider);
      final canCheckBiometrics = await authService.canCheckBiometrics;

      if (!mounted) return;

      setState(() {
        _isBiometricAvailable = canCheckBiometrics;
        _isBiometricEnabled =
            canCheckBiometrics; // Default to enabled if available
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isBiometricAvailable = false;
        _isBiometricEnabled = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    if (!_isBiometricAvailable) return;

    setState(() {
      _isBiometricEnabled = value;
    });

    // TODO: Save preference to secure storage
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Biometric authentication enabled'
              : 'Biometric authentication disabled',
        ),
        backgroundColor: AppTheme.googleGreen,
      ),
    );
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
          'Security',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Biometric Authentication Section
                    _buildSectionCard(
                      title: 'Authentication',
                      children: [
                        _buildSettingTile(
                          icon: Icons.fingerprint,
                          title: 'Biometric Authentication',
                          subtitle: _isBiometricAvailable
                              ? 'Use fingerprint or face recognition to sign in'
                              : 'Biometric authentication not available on this device',
                          trailing: _isBiometricAvailable
                              ? Switch(
                                  value: _isBiometricEnabled,
                                  onChanged: _toggleBiometric,
                                  activeColor: AppTheme.googleBlue,
                                )
                              : null,
                        ),
                        if (_isBiometricAvailable) ...[
                          const Divider(indent: 56, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.lock_outline,
                            title: 'PIN Authentication',
                            subtitle:
                                'Use 6-digit PIN as backup authentication',
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppTheme.textSecondary,
                              size: 16,
                            ),
                            onTap: () {
                              // TODO: Navigate to PIN settings
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('PIN settings coming soon!'),
                                  backgroundColor: AppTheme.googleBlue,
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Privacy Section
                    _buildSectionCard(
                      title: 'Privacy',
                      children: [
                        _buildSettingTile(
                          icon: Icons.visibility_off,
                          title: 'Hide Document Names',
                          subtitle: 'Hide document names in the app',
                          trailing: Switch(
                            value: false, // TODO: Load from preferences
                            onChanged: (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Privacy settings coming soon!',
                                  ),
                                  backgroundColor: AppTheme.googleBlue,
                                ),
                              );
                            },
                            activeColor: AppTheme.googleBlue,
                          ),
                        ),
                        const Divider(indent: 56, endIndent: 16),
                        _buildSettingTile(
                          icon: Icons.auto_delete,
                          title: 'Auto-Lock',
                          subtitle: 'Lock app after 5 minutes of inactivity',
                          trailing: Switch(
                            value: true, // TODO: Load from preferences
                            onChanged: (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Auto-lock settings coming soon!',
                                  ),
                                  backgroundColor: AppTheme.googleBlue,
                                ),
                              );
                            },
                            activeColor: AppTheme.googleBlue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Data Section
                    _buildSectionCard(
                      title: 'Data & Storage',
                      children: [
                        _buildSettingTile(
                          icon: Icons.delete_forever,
                          title: 'Clear All Data',
                          subtitle: 'Delete all documents and settings',
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: AppTheme.googleRed,
                            size: 16,
                          ),
                          onTap: () {
                            _showClearDataDialog();
                          },
                        ),
                        const Divider(indent: 56, endIndent: 16),
                        _buildSettingTile(
                          icon: Icons.download,
                          title: 'Export Data',
                          subtitle: 'Export your documents and settings',
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: AppTheme.textSecondary,
                            size: 16,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Export feature coming soon!'),
                                backgroundColor: AppTheme.googleBlue,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Clear All Data',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'This will permanently delete all your documents, settings, and account data. This action cannot be undone.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data cleared successfully'),
                  backgroundColor: AppTheme.googleGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.googleRed,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Clear Data',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
