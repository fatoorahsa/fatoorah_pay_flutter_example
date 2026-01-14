import 'package:flutter/material.dart';

/// Payment Link Form Card Widget
/// 
/// Card for entering payment link information
class PaymentLinkFormCard extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const PaymentLinkFormCard({
    super.key,
    required this.amountController,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
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
              'Payment Link Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Amount (in cents)'),
              controller: amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Full Name'),
              controller: nameController,
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Phone Number'),
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}

