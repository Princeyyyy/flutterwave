import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutterwave/core/TransactionCallBack.dart';
import 'package:flutterwave/models/responses/charge_response.dart';

import 'flutterwave_in_app_browser.dart';

class StandardPaymentWidget extends StatefulWidget {
  final String webUrl;

  StandardPaymentWidget({required this.webUrl});

  @override
  _StandardPaymentWidgetAppState createState() =>
      new _StandardPaymentWidgetAppState();
}

class _StandardPaymentWidgetAppState extends State<StandardPaymentWidget>
    implements TransactionCallBack {
  InAppBrowserSettings browserSettings = InAppBrowserSettings(
    hideUrlBar: true,
  );

  InAppWebViewSettings webViewSettings =
      InAppWebViewSettings(javaScriptEnabled: true);

  @override
  void initState() {
    super.initState();
    final browser = FlutterwaveInAppBrowser(callBack: this);

    InAppBrowserClassSettings settings = InAppBrowserClassSettings(
      browserSettings: browserSettings,
      webViewSettings: webViewSettings,
    );

    browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(widget.webUrl)),
      settings: settings,
    );
  }

  @override
  onTransactionComplete(ChargeResponse? chargeResponse) {
    Navigator.pop(context, chargeResponse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      backgroundColor: Colors.white,
    );
  }
}
