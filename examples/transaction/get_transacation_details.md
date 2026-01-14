# Get Single Transaction

Retrieve details of a specific transaction by its ID or display ID.

## Example

```dart
final result = await sdk.getTransaction(
  transactionId: 'transaction-uuid-here',
);

result.when(
  onSuccess: (transaction) {
    print('ID: ${transaction.id}');
    print('Amount: ${transaction.amount} ${transaction.currency}');
    print('Customer: ${transaction.fullName}');
    print('Status: ${transaction.transactionStatus}');
    
    // Access child transactions if available
    if (transaction.childTransactions != null) {
      print('Child Transactions: ${transaction.childTransactions!.length}');
      for (var child in transaction.childTransactions!) {
        print('  - ${child.id}: ${child.amountCents} ${child.currency}');
      }
    }
  },
  onFailure: (error) => print('Error: ${error.message}'),
);
```

