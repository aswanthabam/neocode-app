import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(context, 'Account'),
          _buildSettingsCard(
            context,
            [
              _buildSettingsItem(
                context,
                icon: Icons.person_outline,
                title: 'Profile',
                onTap: () => context.go('/settings/profile'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionHeader(context, 'Security'),
          _buildSettingsCard(
            context,
            [
              _buildSettingsItem(
                context,
                icon: Icons.security_outlined,
                title: 'Security Settings',
                onTap: () => context.go('/settings/security'),
              ),
              _buildSettingsItem(
                context,
                icon: Icons.history_outlined,
                title: 'Activity History',
                onTap: () => context.go('/settings/activity-history'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionHeader(context, 'General'),
          _buildSettingsCard(
            context,
            [
              _buildSettingsItem(
                context,
                icon: Icons.logout,
                title: 'Logout',
                color: Colors.red.shade700,
                onTap: () {
                  // Handle Logout
                  context.go('/login');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> items) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(children: items),
    );
  }

  Widget _buildSettingsItem(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final itemColor = color ?? Theme.of(context).textTheme.bodyLarge?.color;
    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Text(title, style: TextStyle(color: itemColor, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade500),
      onTap: onTap,
    );
  }
}
