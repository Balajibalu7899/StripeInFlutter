import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

const platform = const MethodChannel("razorpay_flutter");

late Razorpay _razorpay = Razorpay();

TextEditingController _ammount = new TextEditingController();
@override
void initState() {
  _razorpay = Razorpay();
  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
}

@override
void dispose() {
  _razorpay.clear();
}

RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
double money = double.parse(_ammount.text);
double tMoney = money * 100;
String stringMoney = tMoney.toString().replaceAll(regex, '');
int totalMoney = int.parse(stringMoney);
void openCheckout() async {
  var options = {
    'key': 'rzp_test_rXr14Kq1wkl3rW',
    'amount': (int.parse(_ammount.text) * 100).toString(),
    'name': 'Acme Corp.',
    'description': 'Fine T-Shirt',
    'prefill': {'contact': '7899604625', 'email': 'balajibalu7899@gmail.com'},
    'external': {
      'wallets': ['paytm']
    }
  };

  try {
    _razorpay.open(options);
  } catch (e) {
    print(e);
  }
}

void _handlePaymentSuccess(PaymentSuccessResponse response) {
  print(response.paymentId!);
  
}

void _handlePaymentError(PaymentFailureResponse response) {
  print(response.code.toString() + response.message!);
}

void _handleExternalWallet(ExternalWalletResponse response) {
  print(response.walletName!);
}

class _HomeMainState extends State<HomeMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _ammount,
              ),
              ElevatedButton(
                onPressed: () {
                  openCheckout();
                },
                child: Text("Pay Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
