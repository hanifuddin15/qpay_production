import 'package:flutter/material.dart';
import 'package:qpay/net/contract/profile_vm.dart';
import 'package:qpay/providers/value_update_provider.dart';
import 'package:qpay/utils/toast.dart';

class DashboardProvider extends ChangeNotifier implements ValueHolderUpdateProvider{
  static final DashboardProvider _singleton =
  DashboardProvider._internal();

  ProfileViewModel _user = ProfileViewModel();
  List<ProfileErrorViewModel> _errors = List<ProfileErrorViewModel>();

  ProfileViewModel get user => _user;
  List<ProfileErrorViewModel> get errors => _errors;

  factory DashboardProvider() => _singleton;

  DashboardProvider._internal();

  String get firstName => user?.name.toString().split(" ").first ?? "";
  String get mobileNumber => user?.phoneNumber.toString().split(" ").first ?? "";

  void setUser(ProfileViewModel user) async {
   this._user = user;
    notifyListeners();
  }

  void setErrors(List<ProfileErrorViewModel> errors) {
    this._errors = errors;
    notifyListeners();
  }

  @override
  void clear() {
    //no need for this one.
  }
}
