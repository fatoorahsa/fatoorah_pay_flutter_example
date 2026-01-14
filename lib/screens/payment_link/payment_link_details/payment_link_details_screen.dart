import 'package:fatoorah_pay/fatoorah_pay.dart';
import 'package:fatoorah_pay_example/config/sdk_config.dart';
import 'package:fatoorah_pay_example/screens/payment_link/payment_link_details/widgets/payment_link_amount_widget.dart';
import 'package:fatoorah_pay_example/screens/payment_link/payment_link_details/widgets/payment_link_items_card.dart';
import 'package:fatoorah_pay_example/screens/transaction_details/widgets/transaction_detail_card.dart';
import 'package:fatoorah_pay_example/widgets/error_state_widget.dart';
import 'package:flutter/material.dart';

/// Payment Intent Details Screen
///
/// Screen for displaying detailed transaction information
class PaymentLinkDetailsScreen extends StatefulWidget {
  final String id;

  const PaymentLinkDetailsScreen({super.key, required this.id});

  @override
  State<PaymentLinkDetailsScreen> createState() =>
      _PaymentLinkDetailsScreenState();
}

class _PaymentLinkDetailsScreenState extends State<PaymentLinkDetailsScreen> {
  late final FatoorahPay sdk;
  FatoorahException? fatoorahException;
  bool isLoading = false;
  PaymentLink? paymentLink;

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

    final result = await sdk.getPaymentLink(paymentLinkId: widget.id);

    result.when(
      onSuccess: (link) {
        setState(() {
          isLoading = false;
          paymentLink = link;
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
      appBar: AppBar(title: const Text('Payment Link Details')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : fatoorahException != null
          ? ErrorStateWidget(error: fatoorahException!)
          : paymentLink != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaymentLinkAmountWidget(paymentLink: paymentLink!),
                    const SizedBox(height: 16),
                    if (paymentLink!.items != null &&
                        paymentLink!.items!.isNotEmpty) ...[
                      PaymentLinkItemsCard(items: paymentLink!.items!),
                      const SizedBox(height: 16),
                    ],
                    TransactionDetailCard(
                      label: 'Status',
                      value: paymentLink!.status?.toString() ?? 'Unknown',
                      icon: Icons.info_outline,
                    ),
                    if (paymentLink!.billingData?.firstName != null) ...[
                      const SizedBox(height: 8),
                      TransactionDetailCard(
                        label: 'First Name',
                        value:
                            paymentLink!.billingData?.firstName.toString() ??
                            'Unknown',
                        icon: Icons.category_outlined,
                      ),
                    ],

                    if (paymentLink!.billingData?.lastName != null &&
                        paymentLink!.billingData?.lastName != '') ...[
                      const SizedBox(height: 8),
                      TransactionDetailCard(
                        label: 'Last Name',
                        value:
                            paymentLink!.billingData?.lastName.toString() ??
                            'Unknown',
                        icon: Icons.category_outlined,
                      ),
                    ],
                    if (paymentLink!.billingData?.email != null &&
                        paymentLink!.billingData?.email != '') ...[
                      const SizedBox(height: 8),
                      TransactionDetailCard(
                        label: 'Email',
                        value:
                            paymentLink!.billingData?.email.toString() ??
                            'Unknown',
                        icon: Icons.category_outlined,
                      ),
                    ],

                    if (paymentLink!.billingData?.phoneNumber != null &&
                        paymentLink!.billingData?.phoneNumber != '') ...[
                      const SizedBox(height: 8),
                      TransactionDetailCard(
                        label: 'Phone',
                        value:
                            paymentLink!.billingData?.phoneNumber.toString() ??
                            'Unknown',
                        icon: Icons.category_outlined,
                      ),
                    ],

                    const SizedBox(height: 8),
                    TransactionDetailCard(
                      label: 'Created At',
                      value: paymentLink!.createdAt?.toString() ?? 'Unknown',
                      icon: Icons.calendar_today,
                    ),
                    const SizedBox(height: 8),
                    TransactionDetailCard(
                      label: 'Transaction ID',
                      value: paymentLink!.id?.toString() ?? 'Unknown',
                      icon: Icons.tag,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text(
                'No payment link data',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
    );
  }
}
