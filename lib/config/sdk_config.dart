import 'package:fatoorah_pay/fatoorah_pay.dart';
/// SDK Configuration
///
/// Centralized configuration for Fatoorah Pay SDK
/// In production, use environment variables for API keys
class SDKConfig {
  static const String apipiKey =
      'YOUR-API-KEY'; // Replace with your actual API key in production;
  static const String baseUrl = 'https://pay.fatoorah.ai';

  /// Initialize Fatoorah Pay SDK
  static FatoorahPay initializeSDK({bool isProduction = true}) {
    return FatoorahPay(
      baseUrl: baseUrl,
      apiKey:
          apipiKey, // In production, use: Platform.environment['FATOORAH_API_KEY'] ?? ''
      debugMode: true, // Enable debug mode to see HTTP requests
    );
  }
}
