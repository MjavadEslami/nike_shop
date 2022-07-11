import 'package:flutter/material.dart';
import 'package:nike_shop/ui/payment/payment.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:webview_flutter/webview_flutter.dart';

class PaymentGateWayScreen extends StatelessWidget {
  final String bankGateWayUrl;
  const PaymentGateWayScreen({Key? key, required this.bankGateWayUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: bankGateWayUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (url) {
        final uri = Uri.parse(url);
        debugPrint(uri.pathSegments.toString());
        if (uri.pathSegments .contains('appCheckout')  &&
            uri.host == 'expertdevelopers.ir') {
          final orderId = int.parse(uri.queryParameters['order_id']!);
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PaymentScreen(orderId: orderId)));
        }
      },
    );
  }
}
