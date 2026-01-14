# Create Payment Intent

Creates a payment intention for processing a payment programmatically.

## Basic Example

```dart
final request = PaymentIntentRequest(
  isLive: false,
  amount: 10000,
  currency: 'SAR',
  items: [
    PaymentItem(
      amount: 5000,
      quantity: 1,
      name: 'Premium Subscription',
    ),
    PaymentItem(
      amount: 5000,
      quantity: 1,
      name: 'Support Package',
    ),
  ],
  billingData: BillingData(
    firstName: 'Ahmed',
    lastName: 'Al-Salem',
    email: 'customer@example.com',
    phoneNumber: '+966555123456',
  ),
  expiresAt: DateTime.now().toUtc().add(Duration(hours: 24)),
);

final result = await sdk.createPaymentIntent(request);

result.when(
  onSuccess: (intent) {
    print('Payment Intent Created!');
    print('ID: ${intent.id}');
    print('Key: ${intent.keyOrSecret}');
  },
  onFailure: (error) {
    print('Error: ${error.message}');
  },
);
```

## Minimal Example

```dart
final request = PaymentIntentRequest(
  isLive: false,
  amount: 10000,
  currency: 'SAR',
  items: [
    PaymentItem(amount: 10000, quantity: 1),
  ],
  billingData: BillingData(
    firstName: 'Ahmed',
    lastName: 'Al-Salem',
    email: 'customer@example.com',
    phoneNumber: '+966555123456',
  ),
);
```

## Multiple Items with Quantity

```dart
final request = PaymentIntentRequest(
  isLive: false,
  amount: 25000, // Total: (5000 × 2) + (15000 × 1) = 25000
  currency: 'SAR',
  items: [
    PaymentItem(
      amount: 5000,
      quantity: 2, // 2 units
      name: 'Basic Plan',
    ),
    PaymentItem(
      amount: 15000,
      quantity: 1,
      name: 'Premium Add-on',
    ),
  ],
  billingData: BillingData(
    firstName: 'Ahmed',
    lastName: 'Al-Salem',
    email: 'customer@example.com',
    phoneNumber: '+966555123456',
  ),
);
```

## Custom Expiration & Payment Methods

```dart
final request = PaymentIntentRequest(
  isLive: false,
  amount: 10000,
  currency: 'SAR',
  items: [PaymentItem(amount: 10000, quantity: 1)],
  billingData: BillingData(/* ... */),
  // Restrict to specific payment methods
  paymentMethods: [
    'a5193fb0-906a-4324-a356-fbf8d9b9f2bf', // Card
    'b1234fb0-906a-4324-a356-fbf8d9b9f2bf', // Apple Pay
  ],
  // Custom expiration (must be ≥1 hour in future)
  expiresAt: DateTime.now().toUtc().add(Duration(hours: 48)),
  // Custom metadata
  extras: {
    'order_id': 'ORD-12345',
    'customer_tier': 'premium',
  },
);
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
| `amount` | `int` or `String` | Must equal sum of `items[i].amount × items[i].quantity` |
| `currency` | `String` | 3-letter code (SAR, USD, EGP, etc.) |
| `items` | `List<PaymentItem>` | At least 1 item required |
| `billingData` | `BillingData` | See BillingData below |

### BillingData Required Fields

| Field | Type | Notes |
|-------|------|-------|
| `firstName` | `String` | - |
| `lastName` | `String` | - |
| `email` | `String` | Must be valid email format |
| `phoneNumber` | `String` | Cannot contain letters |

Optional fields (`apartment`, `street`, `building`, `city`, `country`, `floor`, `state`) default to `"NA"` if not provided.

