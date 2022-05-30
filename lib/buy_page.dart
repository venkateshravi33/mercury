import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BuyPage extends StatefulWidget {
  final String productUrl;
  final String productName;

  const BuyPage({Key? key, required this.productUrl, required this.productName})
      : super(key: key);

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  late WebViewController myWebViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        backgroundColor: Colors.black,
        title: Text(
          widget.productName,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.productUrl,
        onWebViewCreated: (controller) {
          myWebViewController = controller;
        },
      ),
    );
  }
}
