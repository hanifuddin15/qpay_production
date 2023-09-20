
import 'package:flutter/material.dart';

import 'i_lifecycle.dart';

abstract class IMvpView {

  BuildContext getContext();
  void showProgress();

  void closeProgress();

  void showToast(String string);
  void showSnackBar(String string);
  void showErrorDialog(String string);
  void showSuccessDialog(String string);
}

abstract class IPresenter extends ILifecycle {}