/*
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/utils/helper_utils.dart';

class SmartCardParser {
  Map<String, String> parse(List<TextBlock> list) {
    var items = Map<String, String>();

    if(list.isEmpty) return items;
//    var name = list
//        .firstWhere(
//            (element) => HelperUtils.isPersonNameInSmartCard(element.text))
//        .text;

    var name = "name";
    if (name.isNotEmpty) items[Constant.nameKey] = name;

    try {
      var nid = list
          .firstWhere((element) => HelperUtils.isNumber(element.text))
          .text
          .replaceAll(HelperUtils.whiteSpaceRemovalExpression(), "");
      if (nid
          .trim()
          .length >= 10) {
        items[Constant.nidKey] = nid;
      }
    }catch(Exception){

    }
    return items;
  }
}
*/
