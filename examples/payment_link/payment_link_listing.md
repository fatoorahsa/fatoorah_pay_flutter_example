# List Payment Links

Retrieve a paginated list of all payment links for your account.

## Basic Usage

```dart
// Without pagination (uses defaults)
final result = await sdk.listPaymentLinks();
```

## With Pagination and Sorting

**Note:** 
- Pagination starts from page 0 (not 1)
- `page`, `size`, `sortBy`, and `sortDir` parameters are **optional** - if not provided, they won't be sent in the request
- `sortBy` is an enum (`PaymentLinkSortBy.createdAt`, `PaymentLinkSortBy.amountCents`, `PaymentLinkSortBy.status`, or `PaymentLinkSortBy.expiresAt`)
- `sortDirection` is an enum (`SortDirection.ASC` or `SortDirection.DESC`)

```dart
final result = await sdk.listPaymentLinks(
  page: 0, // First page (pagination starts at 0)
  size: 20, // Number of items per page
  sortBy: PaymentLinkSortBy.createdAt, // Optional: createdAt, amountCents, status, or expiresAt
  sortDirection: SortDirection.DESC, // Optional: ASC or DESC
);

result.when(
  onSuccess: (response) {
    print('Total links: ${response.totalElements}');
    print('Total pages: ${response.totalPages}');
    print('Current page: ${response.number}');
    print('Is first page: ${response.first}');
    print('Is last page: ${response.last}');
    
    for (var link in response.content) {
      print('Link: ${link.displayId}');
      print('  Status: ${link.status}');
      print('  Amount: ${link.amountCents} ${link.currency}');
      print('  Created: ${link.createdAt}');
      print('  Payment URL: ${link.paymentLink}');
    }
  },
  onFailure: (error) => print('Error: ${error.message}'),
);
```

