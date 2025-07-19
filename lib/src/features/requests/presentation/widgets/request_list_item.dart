import 'package:digital_vault/src/core/models/request_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RequestListItem extends StatelessWidget {
  final DocumentRequest request;

  const RequestListItem({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPending = request.status == RequestStatus.pending;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () => context.go('/requests/consent', extra: request),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.secondaryContainer,
                child: Text(
                  request.requesterName.isNotEmpty ? request.requesterName[0] : '',
                  style: TextStyle(color: theme.colorScheme.onSecondaryContainer),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.requesterName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${request.requestedDocuments.length} documents requested',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Chip(
                label: Text(request.status.name[0].toUpperCase() + request.status.name.substring(1)),
                backgroundColor: isPending ? Colors.blue.shade100 : Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: isPending ? Colors.blue.shade800 : Colors.grey.shade800,
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
}
