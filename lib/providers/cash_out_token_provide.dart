import 'package:flutter/cupertino.dart';
import 'package:qpay/net/contract/cash_out_token_model.dart';
import 'package:qpay/providers/value_update_provider.dart';

class CashOutTokenProvider extends ChangeNotifier implements ValueHolderUpdateProvider{
  static final CashOutTokenProvider _singleton =
  CashOutTokenProvider._internal();

  factory CashOutTokenProvider() => _singleton;
  CashOutTokenProvider._internal();

  List<CashOutTokenViewModel> _cashOutTokenViewModel;
  get selectCashOutToken => _cashOutTokenViewModel;

  void setCashOutToken(List<CashOutTokenViewModel> token){
    _cashOutTokenViewModel = token;

  }

  void reload(){
    _cashOutTokenViewModel.clear();
    notifyListeners();
  }

  void clear() {
    this._cashOutTokenViewModel.clear();
  }

}