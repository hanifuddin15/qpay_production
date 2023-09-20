import 'package:qpay/common/appconstants.dart';
import 'dart:convert';

import 'package:qpay/net/error_handler.dart';

class BaseEntity<T> {
  int code;
  String message;
  T data;
  List<T> listData = [];

  BaseEntity(this.code, this.message, this.data);

  BaseEntity.fromJson(Map<String, dynamic> json) {
    code = json[Constant.code] as int;
    message = code == ExceptionHandler.server_failure
        ? "Please try again"
        : json[Constant.message] as String;
    if (json.containsKey(Constant.data)) {
      if (json[Constant.data] is List) {
        json[Constant.data].forEach((Object item) {
          listData.add(parseData<T>(item));
        });
      } else {
        data = json[Constant.data];
      }
    }
  }

  S parseData<S>(String data) {
    return json.decode(data);
  }
}
