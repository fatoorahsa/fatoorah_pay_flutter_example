import 'package:fatoorah_pay/fatoorah_pay.dart';
import 'package:fatoorah_pay_example/config/sdk_config.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/payment_intent_details/widgets/paymnet_intent_amount_card.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/payment_intent_details/widgets/payment_intent_items_card.dart';
import 'package:fatoorah_pay_example/screens/transaction_details/widgets/transaction_detail_card.dart';
import 'package:fatoorah_pay_example/widgets/error_state_widget.dart';
import 'package:flutter/material.dart';

/// Payment Intent Details Screen
///
/// Screen for displaying detailed transaction information
class PaymentIntentDetailsScreen extends StatefulWidget {
  final String id;

  const PaymentIntentDetailsScreen({super.key, required this.id});

  @override
  State<PaymentIntentDetailsScreen> createState() =>
      _PaymentIntentDetailsScreenState();
}

class _PaymentIntentDetailsScreenState
    extends State<PaymentIntentDetailsScreen> {
  late final FatoorahPay sdk;
  FatoorahException? fatoorahException;
  bool isLoading = false;
  PaymentIntent? paymentIntent;

  @override
  void initState() {
    super.initState();
    sdk = SDKConfig.initializeSDK();
    _loadPaymentIntentDetails();
  }

  Future<void> _loadPaymentIntentDetails() async {
    setState(() {
      isLoading = true;
      fatoorahException = null;
    });

    final result = await sdk.getPaymentIntention(
      intentionId: widget.id,
    );

    result.when(
      onSuccess: (paymentIntention) {
        setState(() {
          isLoading = false;
          paymentIntent = paymentIntention;
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
      appBar: AppBar(title: const Text('Payment Intent Details')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : fatoorahException != null
          ? ErrorStateWidget(error: fatoorahException!)
          : paymentIntent != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaymentIntentAmountCard(paymentIntent: paymentIntent!),
                    const SizedBox(height: 16),
                    if (paymentIntent!.items != null && paymentIntent!.items!.isNotEmpty) ...[
                      PaymentIntentItemsCard(items: paymentIntent!.items!),
                      const SizedBox(height: 16),
                    ],
                    TransactionDetailCard(
                      label: 'Status',
                      value: paymentIntent!.status?.toString() ?? 'Unknown',
                      icon: Icons.info_outline,
                    ),
                    if (paymentIntent!.billingData?.firstName != null) ...[
                      const SizedBox(height: 8),
                      TransactionDetailCard(
                        label: 'First Name',
                        value:
                            paymentIntent!.billingData?.firstName.toString() ??
                            'Unknown',
                        icon: Icons.category_outlined,
                      ),
                    ],
                    if (paymentIntent!.billingData?.lastName != null) ...[
                      const SizedBox(height: 8),
                      TransactionDetailCard(
                        label: 'Last Name',
                        value:
                            paymentIntent!.billingData?.lastName.toString() ??
                            'Unknown',
                        icon: Icons.category_outlined,
                      ),
                    ],
                    if (paymentIntent!.billingData?.email != null) ...[
                      const SizedBox(height: 8),
                      TransactionDetailCard(
                        label: 'Email',
                        value:
                            paymentIntent!.billingData?.email.toString() ??
                            'Unknown',
                        icon: Icons.category_outlined,
                      ),
                    ],

                    if (paymentIntent!.billingData?.phoneNumber != null) ...[
                      const SizedBox(height: 8),
                      TransactionDetailCard(
                        label: 'Phone',
                        value:
                            paymentIntent!.billingData?.phoneNumber
                                .toString() ??
                            'Unknown',
                        icon: Icons.category_outlined,
                      ),
                    ],

                    const SizedBox(height: 8),
                    TransactionDetailCard(
                      label: 'Created At',
                      value: paymentIntent!.createdAt?.toString() ?? 'Unknown',
                      icon: Icons.calendar_today,
                    ),
                    const SizedBox(height: 8),
                    TransactionDetailCard(
                      label: 'Transaction ID',
                      value: paymentIntent!.id?.toString() ?? 'Unknown',
                      icon: Icons.tag,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text(
                'No payment intent data',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
    );
  }
}
