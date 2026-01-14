import 'package:fatoorah_pay/fatoorah_pay.dart';
import 'package:flutter/material.dart';

/// Error State Widget
/// 
/// Widget displayed when an error occurs
class ErrorStateWidget extends StatelessWidget {
  final FatoorahException error;

  const ErrorStateWidget({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Error',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(error.message),
          ],
        ),
      ),
    );
  }
}

