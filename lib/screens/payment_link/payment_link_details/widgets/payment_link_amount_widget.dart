import 'package:fatoorah_pay/fatoorah_pay.dart';
import 'package:flutter/material.dart';

/// Payment Link Amount Widget
///
/// Prominent card displaying the payment link amount
class PaymentLinkAmountWidget extends StatelessWidget {
  final PaymentLink paymentLink;

  const PaymentLinkAmountWidget({super.key, required this.paymentLink});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${paymentLink.amount ?? 0} ${paymentLink.currency ?? ''}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
