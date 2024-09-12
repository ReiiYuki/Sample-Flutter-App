import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowsePage extends StatefulWidget {
  BrowsePage({Key? key}) : super(key: key);

  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  WebViewController? controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('something',
          onMessageReceived: (JavaScriptMessage message) {
          print(message);
          controller?.runJavaScriptReturningResult('console.log("hello")');
        })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://wechatfe.github.io/vconsole/demo.html'));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller!);
  }
}
