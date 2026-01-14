import 'package:fatoorah_pay/fatoorah_pay.dart';
import 'package:flutter/material.dart';

/// Error Card Widget
///
/// Card displaying error messages
class ErrorCard extends StatelessWidget {
  final FatoorahException error;

  const ErrorCard({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error.message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
