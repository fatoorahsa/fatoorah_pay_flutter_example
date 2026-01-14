import 'package:fatoorah_pay_example/screens/home/widgets/dashboard_card.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/create_payment_intent/create_payment_intent_screen.dart';
import 'package:fatoorah_pay_example/screens/payment_intent/payment_intent_listing/payment_intent_listing_screen.dart';
import 'package:fatoorah_pay_example/screens/payment_link/create_payment_link/create_payment_link_screen.dart';
import 'package:fatoorah_pay_example/screens/payment_link/payment_link_listing/payment_link_listing.dart';
import 'package:fatoorah_pay_example/screens/transactions/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Home Screen - Dashboard
///
/// Main entry point showing feature cards:
/// - Create Payment Intent
/// - List Payment Intents
/// - Create Payment Link
/// - List Payment Links
/// - Transactions
/// - About
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fatoorah Pay SDK'), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Select a feature to get started',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              // Payment Intent Section
              _buildSectionHeader('Payment Intent', Icons.payment, Colors.blue),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
                children: [
                  DashboardCard(
                    title: 'Create',
                    description: 'Create new payment intent',
                    icon: Icons.add_circle_outline,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const CreatePaymentIntentScreen(),
                        ),
                      );
                    },
                  ),
                  DashboardCard(
                    title: 'List All',
                    description: 'View all payment intents',
                    icon: Icons.list_alt,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PaymentIntentListingScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Payment Link Section
              _buildSectionHeader('Payment Link', Icons.link, Colors.green),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
                children: [
                  DashboardCard(
                    title: 'Create',
                    description: 'Generate payment link',
                    icon: Icons.add_circle_outline,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreatePaymentLinkScreen(),
                        ),
                      );
                    },
                  ),
                  DashboardCard(
                    title: 'List All',
                    description: 'View all payment links',
                    icon: Icons.list_alt,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PaymentLinkListingScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Transactions Section
              _buildSectionHeader('Transactions', Icons.history, Colors.orange),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
                children: [
                  DashboardCard(
                    title: 'Transactions',
                    description: 'View payment history',
                    icon: Icons.history,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransactionsScreen(),
                        ),
                      );
                    },
                  ),
                  DashboardCard(
                    title: 'About',
                    description: 'SDK information',
                    icon: Icons.info,
                    color: Colors.purple,
                    onTap: () {
                      _openDocumentation(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Future<void> _openDocumentation(BuildContext context) async {
    final Uri url = Uri.parse(
      'https://fatoorah-pay.readme.io/reference/getting-started-1',
    );

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open documentation URL')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error opening URL: $e')));
      }
    }
  }
}
