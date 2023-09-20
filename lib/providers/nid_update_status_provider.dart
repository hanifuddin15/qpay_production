import 'package:flutter/cupertino.dart';
import 'package:qpay/net/contract/nid_update_dto.dart';
import 'package:qpay/providers/value_update_provider.dart';

class NidUpdateDataHolder extends ChangeNotifier implements ValueHolderUpdateProvider{
  static final NidUpdateDataHolder _singleton = NidUpdateDataHolder._internal();

  factory NidUpdateDataHolder() => _singleton;

  NidUpdateDataHolder._internal();

  String _nidFrontImagePath;
  String _nidBackImagePath;

  void setFrontImage(String imagePath) {
    _nidFrontImagePath = imagePath;
    notifyListeners();
  }

  bool isNidFrontProvided() {
    return _nidFrontImagePath != null;
  }

  bool isNidBackProvided() {
    return _nidBackImagePath != null;
  }

  void setBackImage(String imagePath) {
    _nidBackImagePath = imagePath;
    notifyListeners();
  }

  bool isComplete() {
    return
        _nidFrontImagePath != null &&
        _nidBackImagePath != null;
  }



  NidUpdateDto getData() {
   if (isComplete()) {
      return NidUpdateDto(_nidFrontImagePath,_nidBackImagePath);
   }
   return null;
  }

  void clear(){
    _nidFrontImagePath = null;
    _nidBackImagePath = null;
  }
}
