import 'package:flutterwave/flutterwave.dart';

abstract class TransactionCallBack {
  onTransactionComplete(ChargeResponse? chargeResponse);
}
