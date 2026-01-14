import 'package:fatoorah_pay/fatoorah_pay.dart';
import 'package:fatoorah_pay_example/config/sdk_config.dart';
import 'package:fatoorah_pay_example/screens/transaction_details/transaction_details_screen.dart';
import 'package:fatoorah_pay_example/screens/transactions/widgets/transaction_card.dart';
import 'package:fatoorah_pay_example/widgets/error_state_widget.dart';
import 'package:flutter/material.dart';

/// Transactions Screen
///
/// Screen for listing all transactions
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late final FatoorahPay sdk;
  TransactionListResponse? transactions;
  FatoorahException? fatoorahException;
  bool isLoading = false;

  final TextEditingController pageController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();

  FatoorahTransactionStatus? selectedTransactionStatus;
  FatoorahTransactionType? selectedTransactionType;
  FatoorahCardType? selectedCardType;
  FatoorahPaymentMethod? selectedPaymentMethod;
  TransactionSortBy? selectedSortBy;
  SortDirection? selectedSortDirection;
  String? search;
  String? dateFrom;
  String? dateTo;

  List<FatoorahTransactionStatus> transactionStatus = [
    FatoorahTransactionStatus.success,
    FatoorahTransactionStatus.isCaptured,
    FatoorahTransactionStatus.failed,
    FatoorahTransactionStatus.isAuthorized,
    FatoorahTransactionStatus.isRefunded,
    FatoorahTransactionStatus.isVoided,
  ];
  List<FatoorahTransactionType> transactionTypes = [
    FatoorahTransactionType.INTENTION_PAYMENT,
    FatoorahTransactionType.PAYMENT_LINK_PAYMENT,
    FatoorahTransactionType.SUBSCRIPTION_PAYMENT,
    FatoorahTransactionType.VOID,
    FatoorahTransactionType.CAPTURE,
    FatoorahTransactionType.REFUND,
    FatoorahTransactionType.AUTH,
  ];

  List<FatoorahCardType> cardTypes = [
    FatoorahCardType.visa,
    FatoorahCardType.mastercard,
    FatoorahCardType.amex,
  ];

  List<FatoorahPaymentMethod> paymentMethodsList = [
    FatoorahPaymentMethod.card,
    FatoorahPaymentMethod.apple_pay,
  ];

  List<TransactionSortBy> sortByOptions = [
    TransactionSortBy.amountCents,
    TransactionSortBy.createdAt,
  ];

  List<SortDirection> sortDirectionOptions = [
    SortDirection.ASC,
    SortDirection.DESC,
  ];

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

    final result = await sdk.listTransactions(
      page: page,
      size: size,
      status: selectedTransactionStatus,
      searchText: search,
      cardType: selectedCardType,
      parentOnly: true,
      paymentMethod: selectedPaymentMethod,
      type: selectedTransactionType,
      fromDate: dateFromController.text.isNotEmpty
          ? dateFromController.text
          : null,
      toDate: dateToController.text.isNotEmpty ? dateToController.text : null,
      sortBy: selectedSortBy,
      sortDir: selectedSortDirection,
    );

    result.when(
      onSuccess: (response) {
        setState(() {
          isLoading = false;
          transactions = response;
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

  void showStatusFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: const Text('Filter Status type')),
              IconButton(
                icon: const Icon(Icons.filter_alt_off_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pop(context);
                  if (selectedTransactionStatus != null) {
                    setState(() {
                      selectedTransactionStatus = null;
                    });
                    _loadTransactions();
                  }
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final status in transactionStatus)
                  ...[
                    if (selectedTransactionStatus == status)
                      ListTile(
                        title: Text(status.toString().split('.').last),
                        leading: Icon(Icons.radio_button_checked, color: Colors.blue),
                        onTap: () {
                          Navigator.pop(context);
                          _loadTransactions();
                        },
                      ),
                    if (selectedTransactionStatus != status)
                      ListTile(
                        title: Text(status.toString().split('.').last),
                        leading: Icon(Icons.radio_button_unchecked),
                        onTap: () {
                          setState(() {
                            selectedTransactionStatus = status;
                          });
                          Navigator.pop(context);
                          _loadTransactions();
                        },
                      ),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }

  void showTypeFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: const Text('Filter Payment type')),
              IconButton(
                icon: const Icon(Icons.filter_alt_off_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pop(context);
                  if (selectedTransactionType != null) {
                    setState(() {
                      selectedTransactionType = null;
                    });
                    _loadTransactions();
                  }
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final type in transactionTypes)
                  ...[
                    if (selectedTransactionType == type)
                      ListTile(
                        title: Text(
                          type.toString().split('.').last,
                          style: TextStyle(fontSize: 14),
                        ),
                        leading: Icon(Icons.radio_button_checked, color: Colors.blue),
                        onTap: () {
                          Navigator.pop(context);
                          _loadTransactions();
                        },
                      ),
                    if (selectedTransactionType != type)
                      ListTile(
                        title: Text(
                          type.toString().split('.').last,
                          style: TextStyle(fontSize: 14),
                        ),
                        leading: Icon(Icons.radio_button_unchecked),
                        onTap: () {
                          setState(() {
                            selectedTransactionType = type;
                          });
                          Navigator.pop(context);
                          _loadTransactions();
                        },
                      ),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }

  void showPaymentMethodFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: const Text('Filter payment method')),
              IconButton(
                icon: const Icon(Icons.filter_alt_off_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pop(context);
                  if (selectedPaymentMethod != null) {
                    setState(() {
                      selectedPaymentMethod = null;
                    });
                    _loadTransactions();
                  }
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final method in paymentMethodsList)
                  ...[
                    if (selectedPaymentMethod == method)
                      ListTile(
                        title: Text(method.toString().split('.').last),
                        leading: Icon(Icons.radio_button_checked, color: Colors.blue),
                        onTap: () {
                          Navigator.pop(context);
                          _loadTransactions();
                        },
                      ),
                    if (selectedPaymentMethod != method)
                      ListTile(
                        title: Text(method.toString().split('.').last),
                        leading: Icon(Icons.radio_button_unchecked),
                        onTap: () {
                          setState(() {
                            selectedPaymentMethod = method;
                          });
                          Navigator.pop(context);
                          _loadTransactions();
                        },
                      ),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }

  void showCardTypeFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: const Text('Filter card type')),
              IconButton(
                icon: const Icon(Icons.filter_alt_off_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pop(context);
                  if (selectedCardType != null) {
                    setState(() {
                      selectedCardType = null;
                    });
                    _loadTransactions();
                  }
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final card in cardTypes)
                  ...[
                    if (selectedCardType == card)
                      ListTile(
                        title: Text(card.toString().split('.').last),
                        leading: Icon(Icons.radio_button_checked, color: Colors.blue),
                        onTap: () {
                          Navigator.pop(context);
                          _loadTransactions();
                        },
                      ),
                    if (selectedCardType != card)
                      ListTile(
                        title: Text(card.toString().split('.').last),
                        leading: Icon(Icons.radio_button_unchecked),
                        onTap: () {
                          setState(() {
                            selectedCardType = card;
                          });
                          Navigator.pop(context);
                          _loadTransactions();
                        },
                      ),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }

  void showDateFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter date'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'From',
                  hintText: 'From',
                ),
                controller: dateFromController,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      dateFromController.text = picked.toString();
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'To',
                  hintText: 'To',
                ),
                controller: dateToController,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      dateToController.text = picked.toString();
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Apply'),
              onPressed: () {
                Navigator.pop(context);
                _loadTransactions();
              },
            ),
          ],
        );
      },
    );
  }

  void showSortByDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: const Text('Sort By')),
              IconButton(
                icon: const Icon(Icons.filter_alt_off_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pop(context);
                  if (selectedSortBy != null) {
                    setState(() {
                      selectedSortBy = null;
                    });
                    _loadTransactions();
                  }
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final sortBy in sortByOptions)
                  ...[
                    if (selectedSortBy == sortBy)
                      ListTile(
                        title: Text(sortBy.toString().split('.').last),
                        leading: Icon(Icons.radio_button_checked, color: Colors.blue),
                        onTap: () {
                          Navigator.pop(context);
                          _loadTransactions();
                        },
                      ),
                    if (selectedSortBy != sortBy)
                      ListTile(
                        title: Text(sortBy.toString().split('.').last),
                        leading: Icon(Icons.radio_button_unchecked),
                        onTap: () {
                          setState(() {
                            selectedSortBy = sortBy;
                          });
                          Navigator.pop(context);
                          _loadTransactions();
                        },
                      ),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }

  void showSortDirectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: const Text('Sort Order')),
              IconButton(
                icon: const Icon(Icons.filter_alt_off_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pop(context);
                  if (selectedSortDirection != null) {
                    setState(() {
                      selectedSortDirection = null;
                    });
                    _loadTransactions();
                  }
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final sortDir in sortDirectionOptions)
                  ...[
                    if (selectedSortDirection == sortDir)
                      ListTile(
                        title: Text(sortDir.toString().split('.').last),
                        leading: Icon(Icons.radio_button_checked, color: Colors.blue),
                        onTap: () {
                          Navigator.pop(context);
                          _loadTransactions();
                        },
                      ),
                    if (selectedSortDirection != sortDir)
                      ListTile(
                        title: Text(sortDir.toString().split('.').last),
                        leading: Icon(Icons.radio_button_unchecked),
                        onTap: () {
                          setState(() {
                            selectedSortDirection = sortDir;
                          });
                          Navigator.pop(context);
                          _loadTransactions();
                        },
                      ),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTransactions,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: showDateFilterDialog,
            tooltip: 'Filter',
          ),
          // IconButton(
          //   icon: const Icon(Icons.payment),
          //   onPressed: showPaymentMethodFilterDialog,
          //   tooltip: 'Filter',
          // ),
          // IconButton(
          //   icon: const Icon(Icons.card_travel),
          //   onPressed: showCardTypeFilterDialog,
          //   tooltip: 'Filter',
          // ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Search For Transaction',
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  search = null;
                  _loadTransactions();
                  return;
                }
                search = value;
                _loadTransactions();
              },
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Filter By:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: showStatusFilterDialog,
                  child: const Text('Type'),
                ),
                TextButton(
                  onPressed: showTypeFilterDialog,
                  child: const Text('Payment Type'),
                ),
                TextButton(
                  onPressed: showPaymentMethodFilterDialog,
                  child: const Text('Payment Method'),
                ),
                TextButton(
                  onPressed: showCardTypeFilterDialog,
                  child: const Text('Card Type'),
                ),
                TextButton(
                  onPressed: showSortByDialog,
                  child: const Text('Sort By'),
                ),
                TextButton(
                  onPressed: showSortDirectionDialog,
                  child: const Text('Sort Order'),
                ),
              ],
            ),
          ),
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
                : transactions != null && transactions!.content.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: _loadTransactions,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: transactions!.content.length,
                      itemBuilder: (context, index) {
                        return TransactionCard(
                          transaction: transactions!.content[index],
                          onTap: () {
                            debugPrint(transactions!.content[index].id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionDetailsScreen(
                                  id: transactions!.content[index].id ?? '',
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
