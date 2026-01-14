# Refund Transaction

Initiates a refund for a previously successful transaction.

## Key Features

- Full or partial refunds supported
- Refund amount cannot exceed original transaction amount
- Creates a new refund transaction linked to the original
- Webhook notification sent when refund completes

## Example

```dart
final request = RefundRequest(
  transactionId: 'a18c16b2-c407-446b-9b5f-1d9cf91b57c3',
  amountCents: 1000,
);

final result = await sdk.refundTransaction(request: request);

result.when(
  onSuccess: (response) {
    if (response.isSuccess) {
      print('Refund successful: ${response.message}');
      print('Transaction ID: ${response.transaction?.id}');
      print('Amount: ${response.transaction?.amountCents}');
    } else {
      print('Refund failed: ${response.errorMessage}');
    }
  },
  onFailure: (error) => print('Error: ${error.message}'),
);
```

