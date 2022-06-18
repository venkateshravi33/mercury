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
  bool isLoading = true;
  double loadingProgress = 0;
  late WebViewController myWebViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
      body: Stack(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.productUrl,
            onWebViewCreated: (controller) {
              myWebViewController = controller;
            },
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
            onProgress: (value) {
              setState(() {
                loadingProgress = value.toDouble();
              });
            },
          ),
          isLoading
              ? LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation(Colors.blueAccent),
                  value: (loadingProgress * 0.01),
                )
              : Stack(),
        ],
      ),
    );
  }
}
