import 'package:fatoorah_pay/fatoorah_pay.dart';
import 'package:fatoorah_pay_example/config/sdk_config.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/create_payment_intent/widgets/expiration_date_picker.dart';
import 'package:fatoorah_pay_example/screens/payment_link/create_payment_link/widgets/error_card.dart';
import 'package:fatoorah_pay_example/screens/payment_link/create_payment_link/widgets/payment_link_form_card.dart';
import 'package:fatoorah_pay_example/screens/payment_link/create_payment_link/widgets/payment_link_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Payment Link Screen
///
/// Screen for creating simple payment links
class CreatePaymentLinkScreen extends StatefulWidget {
  const CreatePaymentLinkScreen({super.key});

  @override
  State<CreatePaymentLinkScreen> createState() => _CreatePaymentLinkScreenState();
}

class _CreatePaymentLinkScreenState extends State<CreatePaymentLinkScreen> {
  late final FatoorahPay sdk;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  DateTime? expirationDate;
  bool isLoading = false;
  PaymentLink? paymentLink;
  FatoorahException? fatoorahException;

  @override
  void initState() {
    super.initState();
    sdk = SDKConfig.initializeSDK();
  }

  @override
  void dispose() {
    amountController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _copyPaymentLink(String? link) {
    if (link != null && link.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: link));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment link copied to clipboard')),
      );
    }
  }

  Future<void> _createPaymentLink() async {
    setState(() {
      isLoading = true;
      fatoorahException = null;
      paymentLink = null;
    });
    try {
      final result = await sdk.createPaymentLink(
        PaymentLinkRequest(
          isLive: false,
          amountCents: amountController.text,
          fullName: nameController.text,
          email: emailController.text,
          phoneNumber: phoneController.text,
          expiresAt: expirationDate,
        ),
      );

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
                'Package experiencing exception with the payment link. Please try again.',
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
      appBar: AppBar(title: const Text('Payment Link')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PaymentLinkFormCard(
              amountController: amountController,
              nameController: nameController,
              emailController: emailController,
              phoneController: phoneController,
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
              onPressed: isLoading ? null : _createPaymentLink,
              child: const Text('Create Payment Link'),
            ),
            if (isLoading) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
            if (paymentLink != null) ...[
              const SizedBox(height: 24),
              PaymentLinkResultCard(
                paymentLink: paymentLink!,
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
