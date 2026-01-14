import 'package:fatoorah_pay_example/config/sdk_config.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/payment_intent_details/payment_intent_details_screen.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/payment_intent_listing/widgets/payment_intent_card.dart';
import 'package:fatoorah_pay_example/widgets/error_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:fatoorah_pay/fatoorah_pay.dart';

class PaymentIntentListingScreen extends StatefulWidget {
  const PaymentIntentListingScreen({super.key});

  @override
  State<PaymentIntentListingScreen> createState() =>
      _PaymentIntentListingScreenState();
}

class _PaymentIntentListingScreenState
    extends State<PaymentIntentListingScreen> {
  late final FatoorahPay sdk;
  PaymentIntentListResponse? paymentIntents;
  FatoorahException? fatoorahException;
  bool isLoading = false;
  final TextEditingController pageController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sdk = SDKConfig.initializeSDK();
    _loadPaymentIntents();
  }

  @override
  void dispose() {
    pageController.dispose();
    sizeController.dispose();
    super.dispose();
  }

  Future<void> _loadPaymentIntents() async {
    setState(() {
      isLoading = true;
      fatoorahException = null;
    });

    int? page;
    int? size;

    if (pageController.text.trim().isNotEmpty) {
      page = int.tryParse(pageController.text.trim());
    }

    if (sizeController.text.trim().isNotEmpty) {
      size = int.tryParse(sizeController.text.trim());
    }

    final result = await sdk.listPaymentIntentions(
      page: page,
      size: size,
    );

    result.when(
      onSuccess: (response) {
        setState(() {
          isLoading = false;
          paymentIntents = response;
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
      appBar: AppBar(
        title: const Text('Payment Intents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPaymentIntents,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Page (Optional)',
                        hintText: 'Leave empty for default',
                      ),
                      controller: pageController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Size (Optional)',
                        hintText: 'Leave empty for default',
                      ),
                      controller: sizeController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _loadPaymentIntents,
                    child: const Text('Load'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : fatoorahException != null
                ? ErrorStateWidget(error: fatoorahException!)
                : paymentIntents != null && paymentIntents!.content.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: _loadPaymentIntents,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: paymentIntents!.content.length,
                      itemBuilder: (context, index) {
                        return PaymentIntentCard(
                          paymentIntent: paymentIntents!.content[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PaymentIntentDetailsScreen(
                                      id:
                                          paymentIntents!.content[index].id ??
                                          '',
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Text(
                      'No payment intents found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
