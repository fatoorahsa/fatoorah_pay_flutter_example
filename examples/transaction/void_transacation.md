# Void Transaction

Voids a previously authorized but not captured transaction.

## Key Features

- Cancels authorization before capture
- No money is transferred
- Creates a new void transaction linked to the original
- Webhook notification sent when void completes

## Example

```dart
final request = VoidRequest(
  transactionId: '25734d77-7b98-4ce6-9936-034fb29f9f5b',
);

final result = await sdk.voidTransaction(request: request);

result.when(
  onSuccess: (response) {
    if (response.isSuccess) {
      print('Void successful: ${response.message}');
      print('Transaction ID: ${response.transaction?.id}');
    } else {
      print('Void failed: ${response.errorMessage}');
    }
  },
  onFailure: (error) => print('Error: ${error.message}'),
);
```

