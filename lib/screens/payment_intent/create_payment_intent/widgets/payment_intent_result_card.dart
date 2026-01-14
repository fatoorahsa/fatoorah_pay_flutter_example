import 'package:fatoorah_pay/fatoorah_pay.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/create_payment_intent/widgets/info_row_widget.dart';
import 'package:flutter/material.dart';

/// Payment Intent Result Card Widget
///
/// Card displaying the result of payment intent creation
class PaymentIntentResultCard extends StatelessWidget {
  final PaymentIntent paymentIntent;
  final Function(String) onCopyLink;

  const PaymentIntentResultCard({
    super.key,
    required this.paymentIntent,
    required this.onCopyLink,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> infoRows = [
      InfoRowWidget(
        label: 'Payment Link',
        value: paymentIntent.paymentLink?.toString() ?? 'N/A',
        onCopy: () => onCopyLink(paymentIntent.paymentLink?.toString() ?? ''),
      ),
      InfoRowWidget(
        label: 'Amount',
        value: '${paymentIntent.amount ?? 0} ${paymentIntent.currency ?? ''}',
      ),
      InfoRowWidget(label: 'ID', value: paymentIntent.id ?? 'N/A'),
    ];

    if (paymentIntent.billingData != null) {
      infoRows.add(
        InfoRowWidget(
          label: 'Customer',
          value:
              '${paymentIntent.billingData!.firstName} ${paymentIntent.billingData!.lastName}',
        ),
      );

      infoRows.add(
        InfoRowWidget(label: 'Email', value: paymentIntent.billingData!.email),
      );
    }

    if (paymentIntent.expiresAt != null) {
      infoRows.add(
        InfoRowWidget(
          label: 'Expires At',
          value: paymentIntent.expiresAt!.toLocal().toString().split('.')[0],
        ),
      );
    }

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
                    'Payment Intent Created Successfully!',
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentIntent.items?.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding:  EdgeInsets.only(bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        if (paymentIntent.items?[index].name != null) InfoRowWidget(
                          label: 'Item Name',
                          value: paymentIntent.items?[index].name ?? '',
                        ),
                        InfoRowWidget(
                          label: 'Item Quantity',
                          value:
                              paymentIntent.items?[index].quantity.toString() ??
                              '',
                        ),
                        InfoRowWidget(
                          label: 'Item Amount',
                          value:
                              paymentIntent.items?[index].amount.toString() ?? '',
                        ),
                        if (paymentIntent.items?[index].description != null) InfoRowWidget(
                          label: 'Item Description',
                          value:
                              paymentIntent.items?[index].description
                                  .toString() ??
                              '',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ...infoRows,
          ],
        ),
      ),
    );
  }
}
