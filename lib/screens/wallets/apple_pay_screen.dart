import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:app/widgets/example_scaffold.dart';

import '../../config.dart';

class ApplePayScreen extends StatefulWidget {
  @override
  _ApplePayScreenState createState() => _ApplePayScreenState();
}

class _ApplePayScreenState extends State<ApplePayScreen> {
  @override
  void initState() {
    Stripe.instance.isApplePaySupported.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    Stripe.instance.isApplePaySupported.removeListener(update);
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Apple Pay',
      tags: ['iOS'],
      padding: EdgeInsets.all(16),
      children: [
        if (Stripe.instance.isApplePaySupported.value)
          ApplePayButton(
            onPressed: _handlePayPress,
          )
        else
          Text('Apple Pay is not available in this device'),
      ],
    );
  }

  Future<void> _handlePayPress() async {
    try {
      // 1. Present Apple Pay sheet
      await Stripe.instance.presentApplePay(
        params: ApplePayPresentParams(
          cartItems: [
            ApplePayCartSummaryItem.immediate(
              label: 'Product Test',
              amount: '0.01',
            ),
          ],
          requiredShippingAddressFields: [
            ApplePayContactFieldsType.postalAddress,
          ],
          shippingMethods: [
            ApplePayShippingMethod(
              identifier: 'free',
              detail: 'Arrives by July 2',
              label: 'Free Shipping',
              amount: '0.0',
            ),
            ApplePayShippingMethod(
              identifier: 'standard',
              detail: 'Arrives by June 29',
              label: 'Standard Shipping',
              amount: '3.21',
            ),
          ],
          country: 'Es',
          currency: 'EUR',
        ),
        onDidSetShippingContact: (contact) {
          if (kDebugMode) {
            print('shipping contact provided $contact ');
          }
        },
        onDidSetShippingMethod: (method) {
          if (kDebugMode) {
            print('shipping method provided $method ');
          }
        },
      );

      // 2. fetch Intent Client Secret from backend
      final response = await fetchPaymentIntentClientSecret();
      final clientSecret = response['clientSecret'];

      // 2. Confirm apple pay payment
      await Stripe.instance.confirmApplePayPayment(clientSecret);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Apple Pay payment succesfully completed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<Map<String, dynamic>> fetchPaymentIntentClientSecret() async {
    final url = Uri.parse('$kApiUrl/create-payment-intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': 'example@gmail.com',
        'currency': 'usd',
        'items': ['id-1'],
        'request_three_d_secure': 'any',
      }),
    );
    return json.decode(response.body);
  }
}
