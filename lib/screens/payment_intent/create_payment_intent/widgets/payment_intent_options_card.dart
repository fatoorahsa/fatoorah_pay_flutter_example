import 'package:flutter/material.dart';

/// Payment Intent Options Card Widget
/// 
/// Card for payment intent additional options (currency, platform, isLive, extras)
class PaymentIntentOptionsCard extends StatelessWidget {
  final String currency;
  final Function(String) onCurrencyChanged;
  final TextEditingController platformController;
  final TextEditingController extrasController;
  final bool isLive;
  final Function(bool) onIsLiveChanged;

  const PaymentIntentOptionsCard({
    super.key,
    required this.currency,
    required this.onCurrencyChanged,
    required this.platformController,
    required this.extrasController,
    required this.isLive,
    required this.onIsLiveChanged,
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
              'Payment Intent Options',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Live Mode:'),
                const SizedBox(width: 16),
                Switch(
                  value: isLive,
                  onChanged: onIsLiveChanged,
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Currency'),
              value: currency,
              items: const [
                DropdownMenuItem(value: 'SAR', child: Text('SAR')),
                DropdownMenuItem(value: 'USD', child: Text('USD')),
                DropdownMenuItem(value: 'EGP', child: Text('EGP')),
                DropdownMenuItem(value: 'AED', child: Text('AED')),
                DropdownMenuItem(value: 'KWD', child: Text('KWD')),
                DropdownMenuItem(value: 'BHD', child: Text('BHD')),
              ],
              onChanged: (value) {
                if (value != null) {
                  onCurrencyChanged(value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Platform (Optional)',
                hintText: 'e.g., PAYMOB',
              ),
              controller: platformController,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Extras (Optional JSON)',
                hintText: '{"order_id": "12345", "source": "mobile_app"}',
                helperText: 'Enter JSON format key-value pairs',
              ),
              controller: extrasController,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}

