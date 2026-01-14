# Create Payment Link

Payment links are shareable URLs that allow customers to complete payments without requiring integration on your side.

## Basic Example

```dart
final request = PaymentLinkRequest(
  isLive: false,
  amountCents: 10000,
  fullName: 'Ahmed Al-Salem',
  email: 'customer@example.com',
  phoneNumber: '+966555123456',
  description: 'Invoice #INV-2025-001',
  expiresAt: DateTime.now().toUtc().add(Duration(hours: 24)),
);

final result = await sdk.createPaymentLink(request);

result.when(
  onSuccess: (link) {
    print('Payment Link Created!');
    print('URL: ${link.paymentUrl}');
  },
  onFailure: (error) {
    print('Error: ${error.message}');
  },
);
```

## Minimal Example (Only 3 Required Fields!)

```dart
final request = PaymentLinkRequest(
  isLive: false,
  amountCents: 10000,
  fullName: 'Ahmed Al-Salem',
);

final result = await sdk.createPaymentLink(request);
```

## Date Format

The SDK accepts **any** `DateTime` object (UTC or local time) and handles conversion automatically:

```dart
// Recommended - uses UTC (consistent with backend)
expiresAt: DateTime.now().toUtc().add(Duration(hours: 24))

// Also works - uses local time (SDK converts automatically)
expiresAt: DateTime.now().add(Duration(hours: 24))

// Also works - from date picker (with UTC conversion)
expiresAt: selectedDate?.toUtc()

// Also works - from date picker (SDK converts automatically)
expiresAt: selectedDate
```

**Requirements:**
- Must be ≥1 hour in the future
- **Any `DateTime` object works** - UTC, local time, from picker, or manually created
- SDK automatically converts to UTC, removes milliseconds/microseconds, and formats correctly
- Backend receives clean ISO8601 format: `YYYY-MM-DDTHH:mm:ssZ`

## Required Fields

| Field | Type | Notes |
|-------|------|-------|
| `isLive` | `bool` | `true` or `false` |
| `amountCents` | `int`, `double`, or `String` | Amount in cents |
| `fullName` | `String` | Customer's full name |

**All other fields are optional!**

