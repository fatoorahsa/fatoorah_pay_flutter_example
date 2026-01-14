import 'package:fatoorah_pay/fatoorah_pay.dart';
import 'package:fatoorah_pay_example/config/sdk_config.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/create_payment_intent/widgets/amount_input_card.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/create_payment_intent/widgets/billing_info_card.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/create_payment_intent/widgets/error_card.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/create_payment_intent/widgets/expiration_date_picker.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/create_payment_intent/widgets/items_form_card.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/create_payment_intent/widgets/items_list_card.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/create_payment_intent/widgets/payment_intent_options_card.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/create_payment_intent/widgets/payment_intent_result_card.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Payment Intent Screen
///
/// Screen for creating payment intents with multiple items, billing data, and expiration dates
class CreatePaymentIntentScreen extends StatefulWidget {
  const CreatePaymentIntentScreen({super.key});

  @override
  State<CreatePaymentIntentScreen> createState() => _CreatePaymentIntentScreenState();
}

class _CreatePaymentIntentScreenState extends State<CreatePaymentIntentScreen> {
  late final FatoorahPay sdk;

  final List<PaymentItem> items = [];
  final TextEditingController amountController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemDescriptionController =
      TextEditingController();
  final TextEditingController itemQuantityController = TextEditingController();
  final TextEditingController itemAmountController = TextEditingController();
  final TextEditingController billFirstNameController = TextEditingController();
  final TextEditingController billLastNameController = TextEditingController();
  final TextEditingController billEmailController = TextEditingController();
  final TextEditingController billPhoneNumberController =
      TextEditingController();
  String currency = 'SAR';
  final TextEditingController platformController = TextEditingController();
  final TextEditingController extrasController = TextEditingController();

  bool isLive = false;
  DateTime? expirationDate;
  bool isLoading = false;
  PaymentIntent? paymentIntent;
  FatoorahException? fatoorahException;

  @override
  void initState() {
    super.initState();
    sdk = SDKConfig.initializeSDK();
  }

  @override
  void dispose() {
    amountController.dispose();
    itemNameController.dispose();
    itemDescriptionController.dispose();
    itemQuantityController.dispose();
    itemAmountController.dispose();
    billFirstNameController.dispose();
    billLastNameController.dispose();
    billEmailController.dispose();
    billPhoneNumberController.dispose();
    platformController.dispose();
    extrasController.dispose();
    super.dispose();
  }

  void _addItem() {
    // Only amount is required, name is optional
    if (itemAmountController.text.isNotEmpty) {
      setState(() {
        items.add(
          PaymentItem(
            amount: itemAmountController.text,
            quantity: int.tryParse(itemQuantityController.text) ?? 1,
            name: itemNameController.text.isEmpty
                ? null
                : itemNameController.text,
            description: itemDescriptionController.text.isEmpty
                ? null
                : itemDescriptionController.text,
          ),
        );
        itemNameController.clear();
        itemDescriptionController.clear();
        itemQuantityController.clear();
        itemAmountController.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _copyPaymentLink(String? link) {
    if (link != null && link.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: link));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment link copied to clipboard')),
      );
    }
  }

  Future<void> _createPaymentIntent() async {
    setState(() {
      isLoading = true;
      fatoorahException = null;
      paymentIntent = null;
    });

    try {
      // Parse extras if provided
      Map<String, dynamic>? extras;
      if (extrasController.text.trim().isNotEmpty) {
        try {
          final decoded = json.decode(extrasController.text);
          if (decoded is Map) {
            extras = Map<String, dynamic>.from(decoded);
          }
        } catch (e) {
          // If JSON parsing fails, show error and return early
          setState(() {
            isLoading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid JSON in Extras field: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      final result = await sdk.createPaymentIntent(
        PaymentIntentRequest(
          isLive: isLive,
          amount: amountController.text,
          currency: currency,
          items: items,
          billingData: BillingData(
            firstName: billFirstNameController.text,
            lastName: billLastNameController.text,
            email: billEmailController.text,
            phoneNumber: billPhoneNumberController.text,
          ),
          platform: platformController.text.trim().isEmpty
              ? null
              : platformController.text.trim(),

          expiresAt: expirationDate,
          extras: extras,
        ),
      );

      result.when(
        onSuccess: (intent) {
          setState(() {
            isLoading = false;
            paymentIntent = intent;
          });
        },
        onFailure: (error) {
          setState(() {
            isLoading = false;
            fatoorahException = error;
          });
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (mounted) {
        _showErrorDialog(context, e);
      }
    }
  }

  void _showErrorDialog(BuildContext context, dynamic error) {
    final String errorMessage = error.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(child: Text('Package Exception')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Package experiencing exception with the payment intent. Please try again.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Error details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(errorMessage, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Intent')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AmountInputCard(controller: amountController),
            const SizedBox(height: 16),
            ItemsFormCard(
              nameController: itemNameController,
              descriptionController: itemDescriptionController,
              quantityController: itemQuantityController,
              amountController: itemAmountController,
              onAdd: _addItem,
            ),
            const SizedBox(height: 16),
            ItemsListCard(items: items, onRemove: _removeItem),
            const SizedBox(height: 16),
            PaymentIntentOptionsCard(
              currency: currency,
              onCurrencyChanged: (value) {
                setState(() {
                  currency = value;
                });
              },
              platformController: platformController,
              extrasController: extrasController,
              isLive: isLive,
              onIsLiveChanged: (value) {
                setState(() {
                  isLive = value;
                });
              },
            ),
            const SizedBox(height: 16),
            BillingInfoCard(
              firstNameController: billFirstNameController,
              lastNameController: billLastNameController,
              emailController: billEmailController,
              phoneController: billPhoneNumberController,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ExpirationDatePicker(
                  expirationDate: expirationDate,
                  onDateSelected: (date) {
                    setState(() {
                      expirationDate = date;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: isLoading ? null : _createPaymentIntent,
              child: const Text('Create Payment Intent'),
            ),
            if (isLoading) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
            if (paymentIntent != null) ...[
              const SizedBox(height: 24),
              PaymentIntentResultCard(
                paymentIntent: paymentIntent!,
                onCopyLink: _copyPaymentLink,
              ),
            ],
            if (fatoorahException != null) ...[
              const SizedBox(height: 24),
              ErrorCard(error: fatoorahException!),
            ],
          ],
        ),
      ),
    );
  }
}
