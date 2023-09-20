import 'dart:collection';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpay/net/contract/bank_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/transaction_limit_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/providers/value_update_provider.dart';

class CachedBanks {
  static final CachedBanks _singleton = CachedBanks._internal();

  factory CachedBanks() => _singleton;

  CachedBanks._internal();

  var _banks = Map<String, List<BankViewModel>>();

  List<BankViewModel> getBanks(String type){
    return _banks[type] ?? <BankViewModel>[];
  }

  void set(List<BankViewModel> bankList, String linkType) {
    this._banks[linkType] = bankList;
  }
  void clear(){
    this._banks.clear();
  }
}

class CachedAllLinkedAccounts extends ChangeNotifier
    implements ValueHolderUpdateProvider {
  static final CachedAllLinkedAccounts _singleton =
      CachedAllLinkedAccounts._internal();

  List<LinkedAccountViewModel> _accounts = <LinkedAccountViewModel>[];

  get accounts => _accounts;

  factory CachedAllLinkedAccounts() => _singleton;

  CachedAllLinkedAccounts._internal();

  void set(List<LinkedAccountViewModel> accounts) {
    this._accounts = accounts;
  }

  void reload(){
    this._accounts.clear();
    notifyListeners();
  }

  void clear(){
    this._accounts.clear();
  }

}

/*class CachedTransactionsLimit {
  static final CachedTransactionsLimit _singleton =
  CachedTransactionsLimit._internal();

 List<TransactionLimitViewModel> _limitViewModel = List<TransactionLimitViewModel>();

 get limitViewModel => _limitViewModel;

  factory CachedTransactionsLimit() => _singleton;

  CachedTransactionsLimit._internal();

  void set(List<TransactionLimitViewModel> limitViewModel) {
    this._limitViewModel = limitViewModel;
  }

  void clear() {
    this._limitViewModel = null;
  }
}*/

class CachedTransactionsCategory {
  static final CachedTransactionsCategory _singleton =
  CachedTransactionsCategory._internal();

  List<TransactionCategoryViewModel> _categoryViewModel = List<TransactionCategoryViewModel>();

  get categoryViewModel => _categoryViewModel;

  factory CachedTransactionsCategory() => _singleton;

  CachedTransactionsCategory._internal();

  void set(List<TransactionCategoryViewModel> categoryViewModel) {
    this._categoryViewModel = categoryViewModel;
  }

  void clear() {
    this._categoryViewModel = null;
  }
}
  class CachedQrCode {
  static final CachedQrCode _singleton =
  CachedQrCode._internal();

  String _qrData;

  String get qrData => _qrData;

  factory CachedQrCode() => _singleton;

  CachedQrCode._internal();

  void set(String qrData) {
  this._qrData = qrData;
  }

  void clear(){
  this._qrData = null;
  }
}

class CachedContact {
  static final CachedContact _singleton =
  CachedContact._internal();

  List<Contact> _contactData;

  List<Contact> get contactData => _contactData;

  factory CachedContact() => _singleton;

  CachedContact._internal();

  void set(List<Contact> contactData) {
    this._contactData = contactData;
  }

  void clear(){
    this._contactData = null;
  }
}

class StaticKeyValueStore {
  static final StaticKeyValueStore _singleton =
  StaticKeyValueStore._internal();

  HashMap<String, dynamic> _keyStore = new HashMap<String, dynamic>();

  factory StaticKeyValueStore() => _singleton;

  StaticKeyValueStore._internal();

  void set(String key,dynamic value){
    this._keyStore[key] = value;
  }

  dynamic get (String key){
    if(_keyStore.containsKey(key)){
      return _keyStore[key];
    }
    return null;
  }

  void clear() {
    this._keyStore = null;
  }
}

