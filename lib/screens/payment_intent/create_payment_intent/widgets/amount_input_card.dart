import 'package:flutter/material.dart';

/// Amount Input Card Widget
/// 
/// Card for entering the total payment amount
class AmountInputCard extends StatelessWidget {
  final TextEditingController controller;

  const AmountInputCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Amount (in cents)',
                hintText: 'e.g., 10000',
              ),
              controller: controller,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}

