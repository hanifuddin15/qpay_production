import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:qpay/Events/token_expire_event.dart';
import 'package:qpay/Events/token_refresh_event.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/static_data/app_event_bus.dart';
import 'package:qpay/utils/log_utils.dart';
import 'package:sprintf/sprintf.dart';
import 'error_handler.dart';
import 'http_api.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler requestInterceptorHandler) async {
    /*We don't want execute this code if the path contains any request for token*/
    if( options.path != ApiEndpoint.token) {
      final String accessToken = SpUtil.getString(Constant.accessToken);
      try {
        var accessTokenExpiryObj = SpUtil.getString(Constant.accessTokenExpiry);
        DateTime accessTokenExpiry = accessTokenExpiryObj == "" ? DateTime
            .now().add(new Duration(days: 30)) : DateTime.parse(
            accessTokenExpiryObj);
        DateTime expirationLimit = DateTime.now().add(new Duration(minutes: 2));
        var currentTime = DateTime.now();

        if (accessTokenExpiry != null && accessTokenExpiry.isBefore(expirationLimit) && !currentTime.isAfter(accessTokenExpiry)) {
          AppEventManager().eventBus.fire(
              TokenRefreshEvent("token refresh"));

        }
      } catch (e) {
        e.toString();
      }

      if (accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    // return super.onRequest(options,requestInterceptorHandler);
    requestInterceptorHandler.next(options);
  }
}

class TokenInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler responseInterceptorHandler) async {
    if (response != null &&
        response.statusCode == ExceptionHandler.unauthorized) {
      AppEventManager().eventBus.fire(
          TokenExpireEvent("token Expired"));
    }
    responseInterceptorHandler.next(response);
  }
}

class LoggingInterceptor extends Interceptor {
  DateTime _startTime;
  DateTime _endTime;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler interceptorHandler) {
    _startTime = DateTime.now();
    Log.d('----------Start----------');
    if (options.queryParameters.isEmpty) {
      Log.d('RequestUrl: ' + options.baseUrl + options.path);
    } else {
      Log.d('RequestUrl: ' +
          options.baseUrl +
          options.path +
          '?' +
          Transformer.urlEncodeMap(options.queryParameters));
    }
    Log.d('RequestMethod: ' + options.method);
    Log.d('RequestHeaders:' + options.headers.toString());
    Log.d('RequestContentType: ${options.contentType}');
    Log.d('RequestData: ${options.data.toString()}');
    // return super.onRequest(options,interceptorHandler);
    interceptorHandler.next(options);
  }

  @override
  void onResponse(Response response,ResponseInterceptorHandler responseInterceptorHandler) {
    _endTime = DateTime.now();
    int duration = _endTime.difference(_startTime).inMilliseconds;
    if (response.statusCode == ExceptionHandler.success) {
      Log.d('ResponseCode: ${response.statusCode}');
    } else {
      Log.e('ResponseCode: ${response.statusCode}');
    }
    Log.json(response.data.toString());
    Log.d('----------End: $duration ----------');
    // return super.onResponse(response,responseInterceptorHandler);
    responseInterceptorHandler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler errorInterceptorHandler) {
    Log.d(err.message);
    // return super.onError(err,errorInterceptorHandler);
    errorInterceptorHandler.next(err);
  }
}

class AdapterInterceptor extends Interceptor {
  static const String _kMsg = 'msg';
  static const String _kErrorMsg = 'errorMessage';
  static const String _kErrorMsgList = 'errors';
  static const String _kSlash = '\'';
  static const String _kMessage = 'message';
  static const String _kMessageUpper = 'Message';

  static const String _kDefaultText = '\"No Data\"';
  static const String _kNotFound = 'Not found';

  static const String _kFailureFormat = '{\"code\":%d,\"message\":\"%s\"}';
  static const String _kSuccessFormat =
      '{\"code\":0,\"data\":%s,\"message\":\"\"}';

  @override
  void onResponse(Response response,ResponseInterceptorHandler responseInterceptorHandler) {
    Response r = adapterData(response);
    // return super.onResponse(r,responseInterceptorHandler);
    responseInterceptorHandler.next(r);
  }

  @override
  void onError(DioError err,ErrorInterceptorHandler errorInterceptorHandler) {
    if (err.response != null) {
      adapterData(err.response);
    }
    // return super.onError(err,errorInterceptorHandler);
    errorInterceptorHandler.next(err);
  }

  Response adapterData(Response response) {
    String result;
    String content = response.data == null ? '' : response.data.toString();
    if (response.statusCode == ExceptionHandler.success ||
        response.statusCode == ExceptionHandler.success_not_content) {
      if (content == null || content.isEmpty) {
        content = _kDefaultText;
      }
      result = sprintf(_kSuccessFormat, [content]);
      response.statusCode = response.statusCode;
    } else {
      if (response.statusCode == ExceptionHandler.not_found) {
        result = sprintf(_kFailureFormat, [response.statusCode, _kNotFound]);
        response.statusCode = ExceptionHandler.success;
      } else {
        if (content == null || content.isEmpty) {
          result = content;
        } else {
          String msg;
          try {
            content = content.replaceAll("\\", '');
            if (_kSlash == content.substring(0, 1)) {
              content = content.substring(1, content.length - 1);
            }
            msg = extractMessage(content, msg, response.statusCode);
            result = sprintf(_kFailureFormat, [response.statusCode, msg]);
            if (response.statusCode == ExceptionHandler.unauthorized) {
              response.statusCode = ExceptionHandler.unauthorized;
            } else {
              response.statusCode = ExceptionHandler.success;
            }
          } catch (e) {
            Log.d('Error：$e');
            result = sprintf(_kFailureFormat, [
              response.statusCode,
              'Unexpected error(${response.statusCode})'
            ]);
          }
        }
      }
    }
    response.data = result;
    return response;
  }

  String extractMessage(String content, String msg, int statusCode) {
    Map<String, dynamic> map = json.decode(content);
    if (statusCode == ExceptionHandler.server_failure) {
      msg = "Unexpected error";
    } else if (map.containsKey(_kMessage)) {
      msg = map[_kMessage];
    } else if (map.containsKey(_kMsg)) {
      msg = map[_kMsg];
    } else if (map.containsKey(_kErrorMsg)) {
      msg = map[_kErrorMsg];
    } else if (map.containsKey(_kMessageUpper)) {
      msg = map[_kMessageUpper];
    } else if (map.containsKey(_kErrorMsgList)) {
      LinkedHashMap internalMap = map[_kErrorMsgList];
      msg = internalMap.values.first[0];
    } else {
      msg = 'Oops!!';
    }
    return msg;
  }
}
