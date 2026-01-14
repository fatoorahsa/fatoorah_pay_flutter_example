# List Payment Intentions

Retrieve a paginated list of all payment intentions for your account.

## Basic Usage

```dart
// Without pagination (uses defaults)
final result = await sdk.listPaymentIntentions();
```

## With Pagination and Sorting

**Note:** 
- Pagination starts from page 0 (not 1)
- `page`, `size`, `sortBy`, and `sortDirection` parameters are **optional** - if not provided, they won't be sent in the request
- `sortDirection` is an enum (`SortDirection.ASC` or `SortDirection.DESC`)

```dart
final result = await sdk.listPaymentIntentions(
  page: 0, // First page (pagination starts at 0)
  size: 20, // Number of items per page
  sortBy: 'createdAt', // Optional: field to sort by
  sortDirection: SortDirection.DESC, // Optional: ASC or DESC
);

result.when(
  onSuccess: (response) {
    print('Total intentions: ${response.totalElements}');
    print('Total pages: ${response.totalPages}');
    print('Current page: ${response.number}');
    print('Is first page: ${response.first}');
    print('Is last page: ${response.last}');
    
    for (var intent in response.content) {
      print('Intent: ${intent.displayId}');
      print('  Status: ${intent.status}');
      print('  Amount: ${intent.amountCents} ${intent.currency}');
      print('  Created: ${intent.createdAt}');
      print('  Payment URL: ${intent.paymentLink}');
      
      // Access items if available
      if (intent.items != null) {
        for (var item in intent.items!) {
          print('    Item: ${item.name} - ${item.amount} x ${item.quantity}');
        }
      }
    }
  },
  onFailure: (error) => print('Error: ${error.message}'),
);
```

