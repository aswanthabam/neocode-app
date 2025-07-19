import 'package:digital_vault/src/core/models/document_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DocumentListItem extends StatelessWidget {
  final Document document;

  const DocumentListItem({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isVerified = document.trustLevel == TrustLevel.issuerVerified;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () => context.go('/documents/detail', extra: document),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.description_outlined, size: 40, color: theme.colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      document.type,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Chip(
                label: Text(isVerified ? 'Verified' : 'Uploaded'),
                backgroundColor: isVerified ? Colors.green.shade100 : Colors.orange.shade100,
                labelStyle: TextStyle(
                  color: isVerified ? Colors.green.shade800 : Colors.orange.shade800,
                  fontWeight: FontWeight.w500,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustIcon(TrustLevel trustLevel) {
    switch (trustLevel) {
      case TrustLevel.issuerVerified:
        return const Icon(Icons.verified_user_rounded, color: Colors.green, semanticLabel: 'Issuer-Verified');
      case TrustLevel.userUploaded:
        return const Icon(Icons.cloud_upload_rounded, color: Colors.orange, semanticLabel: 'User-Uploaded');
    }
  }
}
