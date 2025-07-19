import 'package:digital_vault/src/core/models/request_model.dart';
import 'package:digital_vault/src/core/services/local_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RequestConsentScreen extends ConsumerWidget {
  final DocumentRequest request;

  const RequestConsentScreen({super.key, required this.request});

  Future<void> _authenticateAndShare(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final authService = ref.read(localAuthServiceProvider);
    final didAuthenticate = await authService.authenticate(
      'Please authenticate to share documents',
    );

    if (didAuthenticate && context.mounted) {
      // In a real app, you would now send the approved documents
      // to the requester.
      context.go('/success', extra: 'Documents shared successfully!');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Request'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRequesterHeader(context, theme),
            const SizedBox(height: 24),
            Text(
              'Requested Documents'.toUpperCase(),
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: ListView.separated(
                  itemCount: request.requestedDocuments.length,
                  itemBuilder: (context, index) {
                    final doc = request.requestedDocuments[index];
                    return ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: Text(doc.name),
                      subtitle: Text(doc.type),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(indent: 16, endIndent: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildActionButtons(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildRequesterHeader(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: theme.colorScheme.secondaryContainer,
          child: Text(
            request.requesterName.isNotEmpty ? request.requesterName[0] : '',
            style: TextStyle(
              fontSize: 24,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          request.requesterName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'is requesting documents',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Deny'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _authenticateAndShare(context, ref),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Allow & Share'),
          ),
        ),
      ],
    );
  }
}
