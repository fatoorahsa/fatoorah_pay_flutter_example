import 'package:flutter/material.dart';

/// Info Row Widget
/// 
/// Reusable widget for displaying key-value pairs with optional copy functionality
class InfoRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onCopy;

  const InfoRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
          if (onCopy != null)
            IconButton(
              icon: const Icon(Icons.copy, size: 20),
              onPressed: onCopy,
              tooltip: 'Copy',
            ),
        ],
      ),
    );
  }
}

