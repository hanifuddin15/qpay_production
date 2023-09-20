import 'dart:io';

import 'package:dio/dio.dart';

class ExceptionHandler {
  static const int success = 200;
  static const int success_not_content = 204;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int not_found = 404;
  static const int server_failure = 500;
  static const int device_changed = 426;

  static const int net_error = 1000;
  static const int parse_error = 1001;
  static const int socket_error = 1002;
  static const int http_error = 1003;
  static const int timeout_error = 1004;
  static const int cancel_error = 1005;
  static const int unknown_error = 9999;

  static NetError handleException(dynamic error) {
    print(error);
    if (error is DioError) {
      if (error.type == DioErrorType.other ||
          error.type == DioErrorType.response) {
        dynamic e = error.error;
        if (e is SocketException) {
          return NetError(socket_error, 'Please check your network!');
        }
        if (e is HttpException) {
          return NetError(http_error, 'Server exception！');
        }
        return NetError(net_error, 'Please check your network!');
      } else if (error.type == DioErrorType.connectTimeout ||
          error.type == DioErrorType.sendTimeout ||
          error.type == DioErrorType.receiveTimeout) {
        return NetError(timeout_error, 'Timeout！');
      } else if (error.type == DioErrorType.cancel) {
        return NetError(cancel_error, 'Canceled');
      } else {
        return NetError(unknown_error, 'Unexpected error occurred');
      }
    } else {
      return NetError(unknown_error, 'Unexpected error occurred');
    }
  }
}

class NetError {
  int code;
  String msg;

  NetError(this.code, this.msg);
}
