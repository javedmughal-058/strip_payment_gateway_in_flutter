import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentUtils{

  static var publishKey = 'pk_test_51MqVoLCN9jYjfKrC8oH0DsnFCBTYifOXhRoIGtBvnqHq4xwxZqjv1QoepI0nfZdqLLL5W4G0t7DNHtm31qoq1LfH00LtKWM3hO';
  static var secretKey  = 'sk_test_51MqVoLCN9jYjfKrCQpOcZ5jibdfIrKCadwt7bLfi2B8BtPEbYWsbtZR1SL6c0m0TO1nTnFpIEy1hczbMk4TFYojE00iCEBz6sK';

  static Map<String, dynamic>? paymentIntentData;

  static Future<void> makePayment(
  context, {required String amount, required String currency}) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              merchantDisplayName: 'Prospects',
              customerId: paymentIntentData!['customer'],
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
            ));
        displayPaymentSheet(context);
      }
    } catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("exception:$e$s"),
          ));
    }
  }

  static displayPaymentSheet(context) async {
    try {
      await Stripe.instance.presentPaymentSheet(
        options: const PaymentSheetPresentOptions(timeout: 1200000),
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Payment Success', style: TextStyle(color: Colors.white),),
          ));

    } on Exception catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error from Stripe: ${e.error.localizedMessage}"),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Unforeseen error: $e"),
            ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("exception:$e"),
          ));
    }
  }

  //  Future<Map<String, dynamic>>
  static createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization' : 'Bearer $secretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      debugPrint('err charging user: ${err.toString()}');
    }
  }


}
