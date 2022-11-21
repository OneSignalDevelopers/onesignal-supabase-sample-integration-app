import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final stripePublishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;

// If you are using a real device to test the integration replace this url
// with the endpoint of your test server (it usually should be the IP of your computer)
final paymentProcessorUrl = defaultTargetPlatform == TargetPlatform.android
    ? dotenv.env['PAYMENT_PROCESSOR_ENDPOINT']
    : 'http://localhost:4242';
