import 'package:flutter/cupertino.dart';

class CashOutTokenViewModel {
  String _amount;
  String _expirationTime;
  bool _isExtendable;
  String _transactionId;
  String _status;
  String _token;

  String get amount => _amount;
  String get expirationTime => _expirationTime;
  bool get isExtendable => _isExtendable;
  String get transactionId => _transactionId;
  String get token => _token;
  String get status => _status;

  CashOutTokenViewModel({
      String amount, 
      String expirationTime, 
      bool isUsed,
      bool isExpired,
      String token,
      String status}){
    _amount = amount;
    _expirationTime = expirationTime;
    _isExtendable = isExtendable;
    _transactionId = transactionId;
    _token = token;
    _status = status;
}

  CashOutTokenViewModel.fromJson(dynamic json) {
    _amount = json["amount"];
    _expirationTime = json["expiresOn"];
    _isExtendable = json["isExtendable"];
    _transactionId = json["transactionId"];
    _token = json["token"];
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["amount"] = _amount;
    map["expiresOn"] = _expirationTime;
    map["isExtended"] = _isExtendable;
    map["transactionId"] = _transactionId;
    map["token"] = _token;
    map["status"] = _status;
    return map;
  }

}