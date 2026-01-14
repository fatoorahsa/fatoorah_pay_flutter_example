import 'package:fatoorah_pay/fatoorah_pay.dart';
import 'package:fatoorah_pay_example/config/sdk_config.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/create_payment_intent/widgets/info_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Void Transaction Widget
///
/// Bottom sheet widget for voiding a transaction
class VoidTransaction extends StatefulWidget {
  final String transactionId;
  const VoidTransaction({super.key, required this.transactionId});

  @override
  State<VoidTransaction> createState() => _VoidTransactionState();
}

class _VoidTransactionState extends State<VoidTransaction> {
  late final FatoorahPay sdk;
  String? errorMessage;
  bool isLoading = false;
  bool isSuccess = false;
  Transaction? voidedTransaction;

  @override
  void initState() {
    super.initState();
    sdk = SDKConfig.initializeSDK();
  }

  Future<void> voidTransacation(String transactionId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      isSuccess = false;
    });

    final result = await sdk.voidTransaction(
      request: VoidRequest(transactionId: transactionId),
    );

    result.when(
      onSuccess: (response) {
        setState(() {
          isLoading = false;
          if (response.isSuccess) {
            isSuccess = true;
            voidedTransaction = response.transaction;
          } else {
            errorMessage = response.errorMessage ?? 'Transaction void was not successful';
          }
        });
      },
      onFailure: (err) {
        setState(() {
          isLoading = false;
          errorMessage = err.message;
          isSuccess = false;
        });
      },
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Row(
            children: [
              const Text(
                'Void Transaction',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (isSuccess && voidedTransaction != null)
                    Card(
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Transaction Voided Successfully!',
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
                              label: 'Transaction ID',
                              value: voidedTransaction!.id?.toString() ?? 'N/A',
                              onCopy: voidedTransaction!.id != null
                                  ? () => _copyToClipboard(voidedTransaction!.id.toString())
                                  : null,
                            ),
                            InfoRowWidget(
                              label: 'Amount',
                              value: '${voidedTransaction!.amount ?? 0} ${voidedTransaction!.currency ?? ''}',
                            ),
                            if (voidedTransaction!.transactionStatus != null)
                              InfoRowWidget(
                                label: 'Status',
                                value: voidedTransaction!.transactionStatus.toString(),
                              ),
                            if (voidedTransaction!.transactionType != null)
                              InfoRowWidget(
                                label: 'Type',
                                value: voidedTransaction!.transactionType.toString(),
                              ),
                            if (voidedTransaction!.createdAt != null)
                              InfoRowWidget(
                                label: 'Created At',
                                value: voidedTransaction!.createdAt!.toLocal().toString().split('.')[0],
                              ),
                          ],
                        ),
                      ),
                    )
                  else if (isSuccess)
                    Card(
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Transaction voided successfully!',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
          else if (errorMessage != null)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Error',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaction ID: ${widget.transactionId}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Are you sure you want to void this transaction? This action cannot be undone.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
                ],
              ),
            ),
          ),
          if (!isLoading && !isSuccess) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => voidTransacation(widget.transactionId),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Void Transaction'),
            ),
          ] else if (isSuccess) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Close'),
            ),
          ],
        ],
        ),
      ),
    );
  }
}
