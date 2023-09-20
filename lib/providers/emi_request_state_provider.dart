import 'package:flutter/cupertino.dart';
import 'package:qpay/providers/value_update_provider.dart';

class EmiRequestStateProvider extends ChangeNotifier implements ValueHolderUpdateProvider{
  static final EmiRequestStateProvider _singleton =
  EmiRequestStateProvider._internal();

  factory EmiRequestStateProvider() => _singleton;

  EmiRequestStateProvider._internal();
  String _transactionId;
  String _description;
  String _transactionTime;
  String _amount;
  String _amountAcct;
  String _location;
  String _transactionCode;
  String _approvalCode;
  String _terminal;

  void setEmiRequestData(String transactionId,String description, String transactionTime,String amount, String amountAcct,String location, String transactionCode, String approvalCode,String terminal){
    _transactionId = transactionId;
    _description = description;
    _transactionTime = transactionTime;
    _amount = amount;
    _amountAcct = amountAcct;
    _location = location;
    _transactionCode = transactionCode;
    _approvalCode = approvalCode;
    _terminal = terminal;
  }



  @override
  void clear() {
    _transactionId = null;
    _description = null;
    _transactionTime = null;
    _amount = null;
    _amountAcct = null;
    _location = null;
    _transactionCode = null;
    _approvalCode = null;
    _terminal = null;
  }

  String get transactionId => _transactionId;

  String get transactionTime => _transactionTime;

  String get description => _description;

  String get amount => _amount;

  String get amountAcct => _amountAcct;

  String get location => _location;

  String get transactionCode=>_transactionCode;

  String get approvalCode => _approvalCode;

  String get terminal => _terminal;
}