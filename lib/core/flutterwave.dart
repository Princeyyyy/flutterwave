import 'package:flutter/material.dart';
import 'package:flutterwave/models/requests/customer.dart';
import 'package:flutterwave/models/requests/customizations.dart';
import 'package:flutterwave/models/requests/standard_request.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/models/subaccount.dart';
import 'package:flutterwave/view/flutterwave_style.dart';
import 'package:http/http.dart' as http;
import 'package:flutterwave/core/TransactionCallBack.dart';

import '../view/view_utils.dart';
import 'navigation_controller.dart';

class Flutterwave implements TransactionCallBack {
  BuildContext context;
  String txRef;
  String amount;
  Customization customization;
  Customer customer;
  bool isTestMode;
  String publicKey;
  String paymentOptions;
  String? currency;
  String? paymentPlanId;
  String redirectUrl;
  List<SubAccount>? subAccounts;
  Map<dynamic, dynamic>? meta;
  FlutterwaveStyle? style;

  Flutterwave({
    required this.context,
    required this.publicKey,
    required this.txRef,
    required this.amount,
    required this.customer,
    required this.paymentOptions,
    required this.customization,
    required this.isTestMode,
    this.currency,
    this.paymentPlanId,
    required this.redirectUrl,
    this.subAccounts,
    this.meta,
    this.style,
  });

  Future<ChargeResponse> charge() async {
    final request = StandardRequest(
      txRef: txRef,
      amount: amount,
      customer: customer,
      paymentOptions: paymentOptions,
      customization: customization,
      isTestMode: isTestMode,
      publicKey: publicKey,
      currency: currency,
      paymentPlanId: paymentPlanId,
      redirectUrl: redirectUrl,
      subAccounts: subAccounts,
      meta: meta,
    );

    final navigationController =
        NavigationController(http.Client(), style, this);
    await navigationController.startTransaction(request);

    // We'll return a placeholder ChargeResponse here.
    // The actual response will be handled in the callback methods.
    return ChargeResponse(
      status: "pending",
      success: false,
      transactionId: "",
      txRef: txRef,
    );
  }

  @override
  onTransactionSuccess(String id, String txRef) {
    // Handle successful transaction
    print("Transaction successful!");
  }

  @override
  onCancelled() {
    // Handle cancelled transaction
    print("Transaction cancelled!");
  }

  @override
  onTransactionError() {
    // Handle transaction error
    print("Transaction error occurred");

    _showErrorAndClose("transaction error");
  }

  void _showErrorAndClose(final String errorMessage) {
    FlutterwaveViewUtils.showToast(context, errorMessage);
  }
}
