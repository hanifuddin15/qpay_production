import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpay/net/contract/bank_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/providers/value_update_provider.dart';

class TransactionAccountSelectionListener extends ChangeNotifier implements ValueHolderUpdateProvider{
  static final TransactionAccountSelectionListener _singleton =
  TransactionAccountSelectionListener._internal();

  factory TransactionAccountSelectionListener() => _singleton;
  TransactionAccountSelectionListener._internal();

  LinkedAccountViewModel _selectedAccount;
  get selectedAccount => _selectedAccount;

  void setAccount(LinkedAccountViewModel account){
    _selectedAccount = account;
    notifyListeners();
  }

  @override
  void clear() {
   _selectedAccount = null;
  }

}

class StatementAccountSelectionListener extends ChangeNotifier implements ValueHolderUpdateProvider {
  static final StatementAccountSelectionListener _singleton =
  StatementAccountSelectionListener._internal();

  factory StatementAccountSelectionListener() => _singleton;

  StatementAccountSelectionListener._internal();

  LinkedAccountViewModel _selectedAccount;

  get selectedAccount => _selectedAccount;

  void setAccount(LinkedAccountViewModel account) {
    _selectedAccount = account;
    notifyListeners();
  }

  @override
  void clear() {
    _selectedAccount = null;
  }
}
  class AccountSelectionListener extends ChangeNotifier implements ValueHolderUpdateProvider {
    static final AccountSelectionListener _singleton =
    AccountSelectionListener._internal();

    factory AccountSelectionListener() => _singleton;

    AccountSelectionListener._internal();

    LinkedAccountViewModel _selectedAccount;

    get selectedAccount => _selectedAccount;

    void setAccount(LinkedAccountViewModel account) {
      _selectedAccount = account;
      notifyListeners();
    }

    @override
    void clear() {
      _selectedAccount = null;
    }
  }

class QpayTransactionSelectorAccountSelectionListener extends ChangeNotifier
    implements ValueHolderUpdateProvider {
  static final QpayTransactionSelectorAccountSelectionListener _singleton =
      QpayTransactionSelectorAccountSelectionListener._internal();

  factory QpayTransactionSelectorAccountSelectionListener() => _singleton;

  QpayTransactionSelectorAccountSelectionListener._internal();

  LinkedAccountViewModel _selectedAccount;

  get selectedAccount => _selectedAccount;

  void setAccount(LinkedAccountViewModel account) {
    _selectedAccount = account;
    notifyListeners();
  }

  @override
  void clear() {
    _selectedAccount = null;
  }
}

class BankListSelectionListener extends ChangeNotifier
    implements ValueHolderUpdateProvider {
  static final BankListSelectionListener _singleton =
  BankListSelectionListener._internal();

  factory BankListSelectionListener() => _singleton;

  BankListSelectionListener._internal();

  BankViewModel _selectedBank;

  get selectedBank => _selectedBank;

  void setBank(BankViewModel bank) {
    _selectedBank = bank;
    notifyListeners();
  }

  @override
  void clear() {
    _selectedBank = null;
  }
}
