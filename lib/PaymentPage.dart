import 'dart:async';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;
  TextEditingController _amountController = TextEditingController();

  void openCheckout(int amount) {
    var options = {
      'key': 'Get your own :)',
      'amount': amount * 100,
      'name': 'Health Sync Hub',
      'description': 'Dr J Appointment',
      'prefill': {'contact': '6969696969', 'email': 'rv@gmail.com'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    showDialogWithTimer(
      context,
      paymentId: 'Payment Successful ' + response.paymentId!,
      amount: "100.00",
      description: 'Dr J appointment',
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {
    showDialogWithTimer(
      context,
      paymentId: 'Payment Failed ! ' + response.message!,
      amount: "100.00",
      description: 'Dr J appointment',
    );
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    final snackBar = SnackBar(
      content: Text('External Wallet: ${response.walletName}'),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Code to handle the action
        },
      ),
    );

    // Show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showDialogWithTimer(
    BuildContext context, {
    required String paymentId,
    required String amount,
    required String description,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment ID: $paymentId'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Amount: $amount'),
              Text('Description: $description'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        children: [
          // Background Image with Opacity
          Opacity(
            opacity: 0.7,
            child: Image.asset(
              'assets/health_imagep.png',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Overlay with Text Field and Payment Button
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.black.withOpacity(0.3), // Adjust opacity as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Text(
                  'Welcome to Health Hub',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                TextFormField(
                  cursorColor: Colors.blue,
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Enter amount',
                    labelStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.4),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.4),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                    ),
                  ),
                  controller: _amountController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 33),
                ElevatedButton(
                  onPressed: () {
                    if (_amountController.text.toString().isNotEmpty) {
                      setState(() {
                        int amt = int.parse(_amountController.text.toString());
                        openCheckout(amt);
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Pay Now'),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
