import 'package:fatoorah_pay/fatoorah_pay.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/create_payment_intent/widgets/info_row_widget.dart';
import 'package:flutter/material.dart';

/// Payment Link Result Card Widget
///
/// Card displaying the result of payment link creation
class PaymentLinkResultCard extends StatelessWidget {
  final PaymentLink paymentLink;
  final Function(String) onCopyLink;

  const PaymentLinkResultCard({
    super.key,
    required this.paymentLink,
    required this.onCopyLink,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Payment Link Created Successfully!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InfoRowWidget(
              label: 'Payment Link',
              value: paymentLink.paymentLink?.toString() ?? 'N/A',
              onCopy: () =>
                  onCopyLink(paymentLink.paymentLink?.toString() ?? ''),
            ),
            InfoRowWidget(
              label: 'Amount',
              value: '${paymentLink.amount ?? 0} ${paymentLink.currency ?? ''}',
            ),
            if (paymentLink.fullName != null)
              InfoRowWidget(label: 'Customer', value: paymentLink.fullName!),
            if (paymentLink.expiresAt != null)
              InfoRowWidget(
                label: 'Expires At',
                value: paymentLink.expiresAt!.toLocal().toString().split(
                  '.',
                )[0],
              ),
            if (paymentLink.billingData?.email != null && paymentLink.billingData?.email != '')
              InfoRowWidget(
                label: 'Email ',
                value: paymentLink.billingData?.email ?? '',
              ),
            if (paymentLink.billingData?.phoneNumber != null && paymentLink.billingData?.phoneNumber != '')
              InfoRowWidget(
                label: 'Number ',
                value: paymentLink.billingData?.phoneNumber ?? '',
              ),
          ],
        ),
      ),
    );
  }
}
