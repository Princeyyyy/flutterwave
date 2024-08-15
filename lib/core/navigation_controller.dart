import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutterwave/core/TransactionCallBack.dart';
import 'package:flutterwave/view/FlutterwaveWebView.dart';
import 'package:flutterwave/view/flutterwave_style.dart';
import 'package:http/http.dart';

import '../models/TransactionError.dart';
import '../models/requests/standard_request.dart';
import '../models/responses/standard_response.dart';

class NavigationController {
  Client client;
  final FlutterwaveStyle? style;
  final TransactionCallBack _callBack;

  NavigationController(this.client, this.style, this._callBack);

  /// Initiates initial transaction to get web url
  startTransaction(final StandardRequest request) async {
    try {
      final StandardResponse standardResponse =
          await request.execute(this.client);
      if (standardResponse.status == "error") {
        throw TransactionError(standardResponse.message!);
      }
      openBrowser(standardResponse.data?.link ?? "", request.redirectUrl);
    } catch (error) {
      print("Error: $error");
      throw error;
    }
  }

  /// Opens browser with URL returned from startTransaction()
  openBrowser(final String url, final String redirectUrl,
      [final bool isTestMode = false]) async {
    final FlutterwaveInAppBrowser browser =
        FlutterwaveInAppBrowser(callBack: _callBack);

    InAppBrowserSettings browserSettings = InAppBrowserSettings(
      hideUrlBar: true,
    );

    InAppWebViewSettings webViewSettings = InAppWebViewSettings(
      javaScriptEnabled: true
    );

    InAppBrowserClassSettings settings = InAppBrowserClassSettings(
      browserSettings: browserSettings,
      webViewSettings: webViewSettings,
    );

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(url)),
      settings: settings,
    );
  }
}
