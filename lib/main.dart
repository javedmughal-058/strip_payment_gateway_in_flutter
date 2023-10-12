import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:strip_payment_gateway_in_flutter/payment_utils.dart';
import 'package:strip_payment_gateway_in_flutter/theme_provider.dart';

void main() {
  Stripe.publishableKey = PaymentUtils.publishKey;

  runApp(
      ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.cyan,
        useMaterial3: true,
      ),
      themeMode: themeProvider.themeMode,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const Payment(),
    );
  }
}


class Payment extends StatelessWidget {
  const Payment({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Strip Payment Gateway', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          Switch.adaptive(
              activeColor: Theme.of(context).secondaryHeaderColor,
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme(); // Update the theme using the provider
              }),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Pay Via Card',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            CardField(

              onCardChanged: (card) {
                // Handle card input changes
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                try {
                  PaymentUtils.makePayment(context, amount: '200', currency: 'USD');
                } catch (e) {
                  // Handle errors
                }
              },
              child: Text('Stripe Payment',
                  style: Theme.of(context).textTheme.bodyMedium),
            ),

          ],
        ),
      ),
    );
  }
}


