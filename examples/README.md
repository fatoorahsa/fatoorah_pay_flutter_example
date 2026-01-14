# Fatoorah Pay - Code Examples

Complete code examples organized by feature.

> **Full Project Example**: See the complete Flutter project example on [GitHub](https://github.com/fatoorahsa/fatoorah_pay_flutter_example/tree/main/examples) for detailed implementation.

---

## Initialize SDK

```dart
import 'package:fatoorah_pay/fatoorah_pay.dart';

final sdk = FatoorahPay(
  baseUrl: 'https://pay.fatoorah.ai',
  apiKey: 'your_api_key',
  debugMode: true,
);
```

---

## Payment Links

- **[Create Payment Link](payment_link/create_payment_link.md)** - Create a new payment link
- **[List Payment Links](payment_link/payment_link_listing.md)** - Retrieve paginated list of payment links
- **[Get Single Payment Link](payment_link/get_payment_link_details.md)** - Get details of a specific payment link

---

## Payment Intentions

- **[Create Payment Intent](payment_intent/create_payment_intent.md)** - Create a new payment intention
- **[List Payment Intentions](payment_intent/payment_intent_listing.md)** - Retrieve paginated list of payment intentions
- **[Get Single Payment Intent](payment_intent/get_payment_intent_details.md)** - Get details of a specific payment intention

---

## Transactions

- **[List Transactions](transaction/transacations_listing.md)** - Retrieve paginated list of transactions
- **[Get Single Transaction](transaction/get_transacation_details.md)** - Get details of a specific transaction
- **[Refund Transaction](transaction/refund_transacation.md)** - Refund a transaction
- **[Void Transaction](transaction/void_transacation.md)** - Void a transaction

---

## Additional Resources

- **Email**: support@fatoorah.ai
- **[Main README](../README.md)** - Installation and quick start
- **[Full Project Example](https://github.com/fatoorahsa/fatoorah_pay_flutter_example/tree/main/examples)** - Complete Flutter implementation
- **[API Documentation](https://fatoorah-pay.readme.io/)** - Official API reference

---

**Made with ❤️ for All Flutter developers**

