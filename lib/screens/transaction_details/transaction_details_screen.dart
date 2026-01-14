import 'package:fatoorah_pay/fatoorah_pay.dart';
import 'package:fatoorah_pay_example/config/sdk_config.dart';
import 'package:fatoorah_pay_example/screens/transaction_details/widgets/amount_card.dart';
import 'package:fatoorah_pay_example/screens/transaction_details/widgets/transaction_detail_card.dart';
import 'package:fatoorah_pay_example/widgets/error_state_widget.dart';
import 'package:fatoorah_pay_example/screens/transactions/widgets/refund_transcation.dart';
import 'package:fatoorah_pay_example/screens/transactions/widgets/void_transacation.dart';
import 'package:flutter/material.dart';

/// Transaction Details Screen
///
/// Screen for displaying detailed transaction information
class TransactionDetailsScreen extends StatefulWidget {
  final String id;

  const TransactionDetailsScreen({super.key, required this.id});

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  late final FatoorahPay sdk;
  FatoorahException? fatoorahException;
  bool isLoading = false;
  Transaction? transaction;

  @override
  void initState() {
    super.initState();
    sdk = SDKConfig.initializeSDK();
    _loadTransactionDetails();
  }

  Future<void> _loadTransactionDetails() async {
    setState(() {
      isLoading = true;
      fatoorahException = null;
    });

    final result = await sdk.getTransaction(transactionId: widget.id);

    result.when(
      onSuccess: (txn) {
        setState(() {
          isLoading = false;
          transaction = txn;
        });
      },
      onFailure: (error) {
        setState(() {
          isLoading = false;
          fatoorahException = error;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : fatoorahException != null
          ? ErrorStateWidget(error: fatoorahException!)
          : transaction != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AmountCard(transaction: transaction!),
                    const SizedBox(height: 16),
                    TransactionDetailCard(
                      label: 'Transaction ID',
                      value: transaction!.displayId?.toString() ?? 'Unknown',
                      icon: Icons.tag,
                    ),
                    const SizedBox(height: 8),
                    TransactionDetailCard(
                      label: 'Status',
                      value:
                          transaction!.transactionStatus?.toString() ??
                          'Unknown',
                      icon: Icons.info_outline,
                    ),
                    const SizedBox(height: 8),
                    TransactionDetailCard(
                      label: 'Type',
                      value:
                          transaction!.transactionType?.toString() ?? 'Unknown',
                      icon: Icons.category_outlined,
                    ),
                    const SizedBox(height: 8),
                    TransactionDetailCard(
                      label: 'Created At',
                      value: transaction!.createdAt?.toString() ?? 'Unknown',
                      icon: Icons.calendar_today,
                    ),

                    const SizedBox(height: 8),
                    TransactionDetailCard(
                      label: 'Email',
                      value: transaction!.email?.toString() ?? 'Unknown',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 8),
                    TransactionDetailCard(
                      label: 'Full Name',
                      value: transaction!.fullName?.toString() ?? 'Unknown',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 8),
                    TransactionDetailCard(
                      label: 'Phone Number',
                      value: transaction!.phoneNumber?.toString() ?? 'Unknown',
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 1,
                            child: TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return RefundTransaction(
                                      transactionId: widget.id,
                                    );
                                  },
                                );
                              },
                              child: Text("Refund Transaction"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 1,
                            child: TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return VoidTransaction(
                                      transactionId: widget.id,
                                    );
                                  },
                                );
                              },
                              child: Text("Void Transaction"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text(
                'No transaction data',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
    );
  }
}
