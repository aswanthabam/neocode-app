import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: Colors.grey),
              hintText: 'Search documents, requests, etc.',
              border: InputBorder.none,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text('A', style: TextStyle(color: theme.colorScheme.onPrimaryContainer)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Promotional Card
          _buildPromoCard(theme),
          const SizedBox(height: 24),
          // Quick Actions Grid
          _buildQuickActions(context),
          const SizedBox(height: 24),
          // Recent Activity
          Text('Recent Activity', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          _buildRecentActivityList(),
        ],
      ),
    );
  }

  Widget _buildPromoCard(ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const Icon(Icons.shield_outlined, size: 40, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Secure Your Digital Life', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Add your first document to get started.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Add Document'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 16,
      children: const [
        _ActionItem(icon: Icons.qr_code_scanner, label: 'Scan QR'),
        _ActionItem(icon: Icons.add_to_drive, label: 'Upload'),
        _ActionItem(icon: Icons.send_outlined, label: 'Share'),
        _ActionItem(icon: Icons.history_outlined, label: 'History'),
        _ActionItem(icon: Icons.person_add_alt_1_outlined, label: 'Request'),
        _ActionItem(icon: Icons.verified_user_outlined, label: 'Verified'),
        _ActionItem(icon: Icons.settings_outlined, label: 'Settings'),
        _ActionItem(icon: Icons.help_outline, label: 'Help'),
      ],
    );
  }

  Widget _buildRecentActivityList() {
    // Placeholder data
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.file_upload)),
          title: const Text('Passport Uploaded'),
          subtitle: const Text('Marked as verified'),
          trailing: Text('Today', style: TextStyle(color: Colors.grey.shade600)),
        ),
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: const Text('Request from HealthCorp'),
          subtitle: const Text('Approved and shared 2 documents'),
          trailing: Text('Yesterday', style: TextStyle(color: Colors.grey.shade600)),
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
