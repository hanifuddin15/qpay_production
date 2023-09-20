import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpay/net/contract/bill_vendor_vm.dart';
import 'package:qpay/providers/value_update_provider.dart';

class VendorIdListener extends ChangeNotifier implements ValueHolderUpdateProvider{
  static final VendorIdListener _singleton =
  VendorIdListener._internal();

  factory VendorIdListener() => _singleton;
  VendorIdListener._internal();

  BillVendorViewModel _selectedVendor;
  get selectedVendor => _selectedVendor;

  void setVendorId(BillVendorViewModel vendor){
    _selectedVendor = vendor;
    notifyListeners();
  }

  @override
  void clear() {
    _selectedVendor = null;
  }

}