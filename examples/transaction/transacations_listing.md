# List Transactions

Retrieve a paginated list of all transactions for your account.

## Basic Usage

```dart
// Without pagination (uses defaults: page=0, size=10)
final result = await sdk.listTransactions();
```

## With Advanced Filtering and Search

**Note:** 
- Pagination starts from page 0 (not 1)
- All parameters are **optional** - if not provided, they won't be sent in the request
- Search text searches across multiple fields: displayId, fullName, email, phoneNumber, cardLastFour, externalTransactionId

```dart
// Filter by status only
final result = await sdk.listTransactions(
  status: FatoorahTransactionStatus.PAID,
);

// Search by customer information
// Note: When searchText is provided, all filter parameters (status, type, paymentMethod, etc.) are ignored
// Only search text is used for searching across multiple fields
final result = await sdk.listTransactions(
  searchText: 'john@example.com', // Searches email, name, phone, etc.
);

// Combine multiple filters (without searchText)
// Note: To use filters, do NOT pass searchText parameter
final result = await sdk.listTransactions(
  page: 0,
  size: 20,
  status: FatoorahTransactionStatus.PAID,
  type: FatoorahTransactionType.SALE,
  paymentMethod: FatoorahPaymentMethod.CARD,
  cardType: FatoorahCardType.VISA,
  fromDate: '2026-01-01',
  toDate: '2026-12-31',
  parentOnly: true, // Only parent transactions
);

// ⚠️ IMPORTANT: If you pass both searchText AND filter parameters, 
// only searchText will be used and all filters will be ignored!

result.when(
  onSuccess: (response) {
    print('Total: ${response.totalElements}');
    for (var txn in response.content) {
      print('${txn.displayId}: ${txn.amount} ${txn.currency} - ${txn.transactionStatus}');
      
      // Access child transactions if available
      if (txn.childTransactions != null) {
        for (var child in txn.childTransactions!) {
          print('  Child: ${child.displayId} - ${child.transactionType}');
        }
      }
    }
  },
  onFailure: (error) => print('Error: ${error.message}'),
);

## Available Filter Options

- **status**: `FatoorahTransactionStatus` - Filter by transaction status
- **type**: `FatoorahTransactionType` - Filter by transaction type
- **paymentMethod**: `FatoorahPaymentMethod` - Filter by payment method
- **cardType**: `FatoorahCardType` - Filter by card brand
- **searchText**: `String` - Search across customer details and transaction identifiers
- **fromDate**: `String` - Filter transactions from date (YYYY-MM-DD format)
- **toDate**: `String` - Filter transactions to date (YYYY-MM-DD format)
- **parentOnly**: `bool` - Filter to show only parent transactions (true) or include child transactions (false)
- **sortBy**: `TransactionSortBy` - Sort by field (amountCents, createdAt)
- **sortDir**: `SortDirection` - Sort direction (ASC, DESC)

## Available Enum Values

### Transaction Status
```dart
List<FatoorahTransactionStatus> transactionStatus = [
  FatoorahTransactionStatus.success,
  FatoorahTransactionStatus.isCaptured,
  FatoorahTransactionStatus.failed,
  FatoorahTransactionStatus.isAuthorized,
  FatoorahTransactionStatus.isRefunded,
  FatoorahTransactionStatus.isVoided,
];
```

### Transaction Types
```dart
List<FatoorahTransactionType> transactionTypes = [
  FatoorahTransactionType.INTENTION_PAYMENT,
  FatoorahTransactionType.PAYMENT_LINK_PAYMENT,
  FatoorahTransactionType.SUBSCRIPTION_PAYMENT,
  FatoorahTransactionType.VOID,
  FatoorahTransactionType.CAPTURE,
  FatoorahTransactionType.REFUND,
  FatoorahTransactionType.AUTH,
];
```

### Card Types
```dart
List<FatoorahCardType> cardTypes = [
  FatoorahCardType.visa,
  FatoorahCardType.mastercard,
  FatoorahCardType.amex,
];
```

### Payment Methods
```dart
List<FatoorahPaymentMethod> paymentMethodsList = [
  FatoorahPaymentMethod.card,
  FatoorahPaymentMethod.apple_pay,
];
```

### Sort Options
```dart
// Sort by field
List<TransactionSortBy> sortByOptions = [
  TransactionSortBy.amountCents,
  TransactionSortBy.createdAt,
];

// Sort direction
List<SortDirection> sortDirectionOptions = [
  SortDirection.ASC,
  SortDirection.DESC,
];
```

## Sorting Examples

```dart
// Sort by creation date (newest first)
final result = await sdk.listTransactions(
  sortBy: TransactionSortBy.createdAt,
  sortDir: SortDirection.DESC,
);

// Sort by amount (lowest first)
final result = await sdk.listTransactions(
  sortBy: TransactionSortBy.amountCents,
  sortDir: SortDirection.ASC,
);

// Combine filtering with sorting
final result = await sdk.listTransactions(
  status: FatoorahTransactionStatus.success,
  fromDate: '2026-01-01',
  sortBy: TransactionSortBy.createdAt,
  sortDir: SortDirection.DESC,
  page: 0,
  size: 20,
);