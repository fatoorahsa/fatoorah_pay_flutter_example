# Get Single Payment Intention

Retrieve details of a specific payment intention by its ID.

## Example

```dart
final result = await sdk.getPaymentIntention(
  intentionId: '713992ae-4450-46ad-9468-12299fe30354',
);

result.when(
  onSuccess: (intent) {
    print('Payment Intent ID: ${intent.id}');
    print('Display ID: ${intent.displayId}');
    print('Status: ${intent.status}');
    print('Amount: ${intent.amountCents} ${intent.currency}');
    print('Full Name: ${intent.fullName}');
    print('Email: ${intent.email}');
    print('Phone: ${intent.phoneNumber}');
    print('Payment URL: ${intent.paymentLink}');
    print('Expires At: ${intent.expiresAt}');
    print('Is Expired: ${intent.isExpired}');
    
    // Access items if available
    if (intent.items != null) {
      for (var item in intent.items!) {
        print('  Item: ${item.name} - ${item.amount} x ${item.quantity}');
        if (item.description != null) {
          print('    Description: ${item.description}');
        }
      }
    }
    
    // Access billing data if available
    if (intent.billingData != null) {
      print('Billing: ${intent.billingData!.firstName} ${intent.billingData!.lastName}');
      print('  City: ${intent.billingData!.city}');
      print('  Country: ${intent.billingData!.country}');
    }
    
    // Access transactions if available
    if (intent.transactions != null && intent.transactions!.isNotEmpty) {
      print('Transactions: ${intent.transactions!.length}');
    }
  },
  onFailure: (error) => print('Error: ${error.message}'),
);
```

