import 'package:fatoorah_pay/fatoorah_pay.dart';
import 'package:fatoorah_pay_example/config/sdk_config.dart';
import 'package:fatoorah_pay_example/screens/payment_link/payment_link_listing/widget/payment_link_card.dart';
import 'package:fatoorah_pay_example/screens/payment_link/payment_link_details/payment_link_details_screen.dart';
import 'package:fatoorah_pay_example/widgets/error_state_widget.dart';
import 'package:flutter/material.dart';

/// Payment Link Listing Screen
///
/// Screen for listing all payment links
class PaymentLinkListingScreen extends StatefulWidget {
  const PaymentLinkListingScreen({super.key});

  @override
  State<PaymentLinkListingScreen> createState() =>
      _PaymentLinkListingScreenState();
}

class _PaymentLinkListingScreenState extends State<PaymentLinkListingScreen> {
  late final FatoorahPay sdk;
  PaymentLinkListResponse? paymentLinks;
  FatoorahException? fatoorahException;
  bool isLoading = false;

  final TextEditingController pageController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  PaymentLinkSortBy? selectedSortBy;
  SortDirection? selectedSortDirection;
  List<PaymentLinkSortBy> sortBy = [
    PaymentLinkSortBy.createdAt,
    PaymentLinkSortBy.amountCents,
    PaymentLinkSortBy.status,
    PaymentLinkSortBy.expiresAt,
  ];
  List<SortDirection> sortDirection = [SortDirection.ASC, SortDirection.DESC];
  @override
  void initState() {
    super.initState();
    sdk = SDKConfig.initializeSDK();

    _loadTransactions();
  }

  @override
  void dispose() {
    pageController.dispose();
    sizeController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
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
    final result = await sdk.listPaymentLinks(
      page: page, // First page (pagination starts at 0)
      size: size, // Number of items per page
      sortBy:
          selectedSortBy, // Optional: createdAt, amountCents, status, or expiresAt
      sortDirection: selectedSortDirection, // Optional: ASC or DESC
    );

    result.when(
      onSuccess: (response) {
        setState(() {
          isLoading = false;
          paymentLinks = response;
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

  void showFilterDialog() {
    PaymentLinkSortBy? tempSortBy = selectedSortBy;
    SortDirection? tempSortDirection = selectedSortDirection;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Expanded(child: const Text('Filter Payment Links')),
                  IconButton(
                    icon: const Icon(Icons.filter_alt_off_outlined),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setDialogState(() {
                        tempSortBy = null;
                        tempSortDirection = null;
                      });
                    },
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sort By',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final sortByOption in sortBy)
                      RadioListTile<PaymentLinkSortBy>(
                        title: Text(sortByOption.toString().split('.').last),
                        value: sortByOption,
                        groupValue: tempSortBy,
                        onChanged: (value) {
                          setDialogState(() {
                            tempSortBy = value;
                          });
                        },
                      ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Sort Direction',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final direction in sortDirection)
                      RadioListTile<SortDirection>(
                        title: Text(direction.toString().split('.').last),
                        value: direction,
                        groupValue: tempSortDirection,
                        onChanged: tempSortBy != null
                            ? (value) {
                                setDialogState(() {
                                  tempSortDirection = value;
                                });
                              }
                            : null, // Disable if sortBy is not selected
                      ),
                    if (tempSortBy == null)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                        child: Text(
                          'Please select a Sort By option first',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedSortBy = tempSortBy;
                      selectedSortDirection = tempSortDirection;
                    });
                    Navigator.pop(context);
                    _loadTransactions();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Links'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTransactions,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: showFilterDialog,
            tooltip: 'Filter',
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
                    onPressed: _loadTransactions,
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
                : paymentLinks != null && paymentLinks!.content.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: _loadTransactions,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: paymentLinks!.content.length,
                      itemBuilder: (context, index) {
                        return PaymentLinkCard(
                          paymentLink: paymentLinks!.content[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentLinkDetailsScreen(
                                  id: paymentLinks!.content[index].id ?? '',
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
                      'No transactions found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
