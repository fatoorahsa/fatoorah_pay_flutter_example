# Fatoorah Pay SDK

[![pub package](https://img.shields.io/pub/v/fatoorah_pay.svg)](https://pub.dev/packages/fatoorah_pay)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Dart SDK](https://img.shields.io/badge/Dart-3.9.2%2B-blue.svg)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-1.17.0%2B-blue.svg)](https://flutter.dev)
[![Null Safety](https://img.shields.io/badge/null--safety-enabled-brightgreen.svg)](https://dart.dev/null-safety)

Flutter Package to integrate with Fatoorah Pay

---

## Getting Started

Welcome to Fatoorah Pay! This guide will help you integrate payment processing into your application in just a few steps.

### Overview

Fatoorah Pay is a payment gateway service that enables you to:

- Accept card payments from customers
- Create shareable payment links
- Process payments programmatically
- Receive real-time webhook notifications
- Query transaction history

### Quick Start

To know exactly how to start your integration with Fatoorah Pay before integrating this package to your app, please visit this README documentation:

**[Getting Started Guide](https://fatoorah-pay.readme.io/reference/getting-started-1)**



---

## Features

- **Type-Safe Models** - Full IDE support with autocomplete
- **Automatic Validation** - Catch errors before API calls
- **Payment Intents** - Custom checkout with item tracking
- **Payment Links** - Simple redirect-based payments
- **Transactions** - Payment history and management
- **Clean Error Handling** - `ApiResult<T>` pattern
- **Null-Safe** - Fully null-safety compliant (Dart 3.9.2+)

---

## Requirements

- **Dart SDK**: `^3.9.2` or higher
- **Flutter**: `>=1.17.0`
- **Null Safety**: Enabled (fully compliant)

---

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  fatoorah_pay: ^1.0.0
```

Then run:

```bash
flutter pub get
```


## Payment Links

Simply create a link, share it with your customer, and they can pay directly.

### What are Payment Links?

Payment links are pre-configured payment pages that you can share with customers via:

- Email
- SMS
- Social media
- Your website
- QR codes

Customers click the link, enter their payment details, and complete the payment - no coding required on your end.

### When to Use Payment Links

Payment links are ideal for:

✅ **Invoices** - Send payment links with invoices
✅ **One-time payments** - Simple, quick payments
✅ **Email/SMS campaigns** - Share links in messages
✅ **Manual order processing** - Create links on-demand
✅ **Non-integrated scenarios** - When you can't integrate directly

**Not ideal for:**

❌ Real-time checkout flows (use Payment Intentions instead)
❌ Recurring subscriptions (use subscription endpoints)
❌ Complex multi-step processes

### Create Payment Link

Creates a new payment link that can be shared with customers. Payment links allow customers to complete payments without requiring integration on your side.

**Key Features:**

- Shareable URL for customers
- Automatic expiration (default 24 hours)
- Webhook notifications on payment status changes
- Support for external references (invoice IDs, order IDs, etc.)

**For complete code examples, see [Payment Link Examples](examples/payment_link/create_payment_link.md)**

### List Payment Links

Retrieve a paginated list of all payment links for your account.

Supports filtering and sorting by various fields.

**Note:** 
- Pagination starts from page 0 (not 1)
- `page`, `size`, `sortBy`, and `sortDirection` parameters are optional - if not provided, they won't be sent in the request

**For complete code examples, see [Payment Link Examples](examples/payment_link/payment_link_listing.md)**

### Get Single Payment Link

Retrieve details of a specific payment link by its ID.

**For complete code examples, see [Payment Link Examples](examples/payment_link/get_payment_link_details.md)**

---

## Payment Intentions

Payment intentions represent the lifecycle of a payment from creation to completion. Use payment intentions when you want to integrate payments directly into your application flow with full programmatic control.

### What are Payment Intentions?

Payment intentions are payment objects that you create programmatically and manage through their lifecycle. Unlike payment links (which are shareable URLs), payment intentions give you:

- Full control over the payment flow
- Detailed line items and billing information
- Programmatic status management
- Integration with your checkout process

### When to Use Payment Intentions

Payment intentions are ideal for:

✅ **E-commerce checkouts** - Integrated checkout flows
✅ **In-app payments** - Mobile and web applications
✅ **Custom checkout pages** - Your own payment UI
✅ **Multi-step processes** - Complex payment flows
✅ **Real-time status updates** - Immediate payment confirmation

**Not ideal for:**

❌ Simple email/SMS payments (use Payment Links instead)
❌ Manual order processing (use Payment Links instead)

### Key Features

- Programmatic payment processing
- Support for multiple line items
- Detailed billing information
- Webhook notifications
- Automatic expiration (default 24 hours)

### Create Payment Intent

Creates a payment intention for processing a payment programmatically.

Payment intentions represent the lifecycle of a payment from creation to completion. Use this endpoint when you want to integrate payments directly into your application flow.

**Key Features:**

- Programmatic payment processing
- Support for multiple line items
- Detailed billing information
- Webhook notifications
- Automatic expiration (default 24 hours)

**For complete code examples, see [Payment Intent Examples](examples/payment_intent/create_payment_intent.md)**

### List Payment Intentions

Retrieve a paginated list of all payment intentions for your account.

**Note:** 
- Pagination starts from page 0 (not 1)
- `page`, `size`, `sortBy`, and `sortDirection` parameters are optional - if not provided, they won't be sent in the request

**For complete code examples, see [Payment Intent Examples](examples/payment_intent/payment_intent_listing.md)**

### Get Single Payment Intention

Retrieve details of a specific payment intention by its ID.

**For complete code examples, see [Payment Intent Examples](examples/payment_intent/get_payment_intent_details.md)**

---

## Transactions

### List Transactions

Retrieve a paginated list of all transactions for your account with advanced filtering and search capabilities.

**Note:** 
- Pagination starts from page 0 (not 1)
- `page` and `size` parameters are optional - if not provided, they won't be sent in the request
- Supports filtering by status, type, payment method, card type, date range, and text search across customer details

**For complete code examples, see [Transaction Examples](examples/transaction/transacations_listing.md)**

### Get Single Transaction

Retrieve details of a specific transaction by its ID or display ID.

**For complete code examples, see [Transaction Examples](examples/transaction/get_transacation_details.md)**

### Refund Transaction

Initiates a refund for a previously successful transaction.

**Key Features:**

- Full or partial refunds supported
- Refund amount cannot exceed original transaction amount
- Creates a new refund transaction linked to the original
- Webhook notification sent when refund completes

**For complete code examples, see [Transaction Examples](examples/transaction/refund_transacation.md)**

### Void Transaction

Voids a previously authorized but not captured transaction.

**Key Features:**

- Cancels authorization before capture
- No money is transferred
- Creates a new void transaction linked to the original
- Webhook notification sent when void completes

**For complete code examples, see [Transaction Examples](examples/transaction/void_transacation.md)**

---

## Documentation

- **[Examples Directory](examples/README.md)** - Complete code examples for all features organized by section
- **Dashboard**: [https://app.fatoorah.sa](https://app.fatoorah.sa)
- **Documentation**: [https://fatoorah-pay.readme.io/](https://fatoorah-pay.readme.io)
- **Full Project Example**: See the complete Flutter project example on [GitHub](https://github.com/fatoorahsa/fatoorah_pay_flutter_example) for detailed implementation
- **Issue Tracker**: Report bugs, request features, or ask integration questions via the GitHub Issues page: [https://github.com/fatoorahsa/fatoorah_pay_flutter_example/issues](https://github.com/fatoorahsa/fatoorah_pay_flutter_example/issues)


---

## Error Handling

The SDK uses an `ApiResult<T>` pattern for all operations:

```dart
result.when(
  onSuccess: (data) {
    // Handle success
  },
  onFailure: (error) {
    if (error is AuthenticationException) {
      // Invalid API key
    } else if (error is ValidationException) {
      // Validation failed
    } else if (error is NetworkException) {
      // Network issue
    } else if (error is ServerException) {
      // Server error (500, etc.)
    }
  },
);
```

---

## Security

**Never commit API keys!**

```dart
final apiKey = Platform.environment['FATOORAH_API_KEY'] ?? '';
```

---

## Support

Need help? We're here for you:

- **Email**: support@fatoorah.ai


---

## License

MIT License - See [LICENSE](LICENSE) file

---

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.