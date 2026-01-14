import 'package:fatoorah_pay/fatoorah_pay.dart';
import 'package:fatoorah_pay_example/config/sdk_config.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/create_payment_intent/widgets/info_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Void Transaction Widget
///
/// Bottom sheet widget for voiding a transaction
class RefundTransaction extends StatefulWidget {
  final String transactionId;
  const RefundTransaction({super.key, required this.transactionId});

  @override
  State<RefundTransaction> createState() => _RefundTransactionState();
}

class _RefundTransactionState extends State<RefundTransaction> {
  late final FatoorahPay sdk;
  String? errorMessage;
  bool isLoading = false;
  bool isSuccess = false;
  Transaction? refundedTransaction;

  final TextEditingController amountController = TextEditingController();

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

    final result = await sdk.refundTransaction(
      request: RefundRequest(
        transactionId: transactionId,
        amountCents: int.tryParse(amountController.text) ?? 0,
      ),
    );

    result.when(
      onSuccess: (response) {
        setState(() {
          isLoading = false;
          if (response.isSuccess) {
            isSuccess = true;
            refundedTransaction = response.transaction;
          } else {
            errorMessage = response.errorMessage ?? 'Transaction refund was not successful';
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
                'Refund Transaction',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Amount (in cents)'),
            controller: amountController,
            keyboardType: TextInputType.number,
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
                  else if (isSuccess && refundedTransaction != null)
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
                                    'Transaction Refunded Successfully!',
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
                              value: refundedTransaction!.id?.toString() ?? 'N/A',
                              onCopy: refundedTransaction!.id != null
                                  ? () => _copyToClipboard(refundedTransaction!.id.toString())
                                  : null,
                            ),
                            InfoRowWidget(
                              label: 'Amount',
                              value: '${refundedTransaction!.amount ?? 0} ${refundedTransaction!.currency ?? ''}',
                            ),
                            if (refundedTransaction!.transactionStatus != null)
                              InfoRowWidget(
                                label: 'Status',
                                value: refundedTransaction!.transactionStatus.toString(),
                              ),
                            if (refundedTransaction!.transactionType != null)
                              InfoRowWidget(
                                label: 'Type',
                                value: refundedTransaction!.transactionType.toString(),
                              ),
                            if (refundedTransaction!.createdAt != null)
                              InfoRowWidget(
                                label: 'Created At',
                                value: refundedTransaction!.createdAt!.toLocal().toString().split('.')[0],
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
                                'Transaction refunded successfully!',
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
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Are you sure you want to refund this transaction? This action cannot be undone.',
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
              child: const Text('Refund Transaction'),
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
