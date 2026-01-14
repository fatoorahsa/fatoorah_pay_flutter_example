# Get Single Payment Link

Retrieve details of a specific payment link by its ID.

## Example

```dart
final result = await sdk.getPaymentLink(
  paymentLinkId: '5bf49782-cae2-417e-b3ed-823aa9243c98',
);

result.when(
  onSuccess: (link) {
    print('Payment Link ID: ${link.id}');
    print('Display ID: ${link.displayId}');
    print('Status: ${link.status}');
    print('Amount: ${link.amountCents} ${link.currency}');
    print('Full Name: ${link.fullName}');
    print('Email: ${link.email}');
    print('Phone: ${link.phoneNumber}');
    print('Payment URL: ${link.paymentLink}');
    print('Expires At: ${link.expiresAt}');
    print('Is Expired: ${link.isExpired}');
    print('Is Cancellable: ${link.isCancellable}');
    
    // Access items if available
    if (link.items != null) {
      for (var item in link.items!) {
        print('  Item: ${item.name} - ${item.amount} x ${item.quantity}');
      }
    }
    
    // Access billing data if available
    if (link.billingData != null) {
      print('Billing: ${link.billingData!.firstName} ${link.billingData!.lastName}');
    }
  },
  onFailure: (error) => print('Error: ${error.message}'),
);
```

