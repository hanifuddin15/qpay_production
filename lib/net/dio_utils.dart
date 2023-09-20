import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:qpay/common/appconstants.dart';
import 'contract/base_entity.dart';
import 'contract/token_vm.dart';
import 'error_handler.dart';
import 'http_api.dart';

int _connectTimeout = 40000;
int _receiveTimeout = 40000;
int _sendTimeout = 10000;
String _baseUrl;
String _baseAuthUrl;
List<Interceptor> _interceptors = [];

// final baseAuthUrl = "https://api.qpaybd.com.bd/api/v1/";
// final baseUrl = "https://api.qpaybd.com.bd/api/v1/";
int unAuthStatus;

void setInitDio({
  int connectTimeout,
  int receiveTimeout,
  int sendTimeout,
  List<Interceptor> interceptors,
}) {
  _connectTimeout = connectTimeout ?? _connectTimeout;
  _receiveTimeout = receiveTimeout ?? _receiveTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _baseUrl = '';
  _baseAuthUrl = '';
  _interceptors = interceptors ?? _interceptors;
}

typedef NetSuccessCallback<T> = Function(T data);
typedef NetSuccessListCallback<T> = Function(List<T> data);
typedef NetErrorCallback = Function(int code, String msg);

class DioUtils {
  static final DioUtils _singleton = DioUtils._();

  static DioUtils get instance => DioUtils();

  factory DioUtils() => _singleton;

  static Dio _dio;

  Dio get dio => _dio;

  DioUtils._() {
    BaseOptions _options = BaseOptions(
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,
      responseType: ResponseType.plain,
      validateStatus: (status) {
        return true;
      },
      baseUrl: "",
//      contentType: Headers.formUrlEncodedContentType
    );
    _dio = Dio(_options);

    _interceptors.forEach((interceptor) {
      _dio.interceptors.add(interceptor);
    });
  }

  Future<BaseEntity<T>> _request<T>(
    String method,
    String url, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
  }) async {
    try {
      final Response response = await _dio.request(
        _baseUrl+url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options),
        cancelToken: cancelToken,
      );
      // unAuthStatus = response.statusCode;
      Map<String, dynamic> _map =
          await compute(parseData, response.data.toString());
      return BaseEntity.fromJson(_map);
    } on DioError catch (e) {
      // if (unAuthStatus == 401) {
      //   return await _refreshSessionAndRetry<T>(e);
      // }
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.requestOptions);
      } else {
        print(e.requestOptions);
        print(e.message);
      }
    } catch (e) {
      print(e);
      return BaseEntity(
          ExceptionHandler.parse_error, 'Failed to parse response', null);
    }
  }

  Future<BaseEntity<T>> _requestEncoded<T>(
      String method,
      String url, {
        dynamic data,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options,
      }) async {
    try {
      final Response response = await _dio.request(
        _baseAuthUrl+url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options, Headers.formUrlEncodedContentType),
        cancelToken: cancelToken,
      );

      Map<String, dynamic> _map =
      await compute(parseData, response.data.toString());
      return BaseEntity.fromJson(_map);
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.requestOptions);
      } else {
        print(e.requestOptions);
        print(e.message);
      }
    } catch (e) {
      print(e);
      return BaseEntity(
          ExceptionHandler.parse_error, 'Failed to parse response', null);
    }
  }



  Options _checkOptions(String method, Options options, [String contentType]) {
    options ??= Options();
    options.method = method;
    options.receiveDataWhenStatusError = true;

    if(contentType!=null && contentType.isNotEmpty){
      options.contentType = contentType;
    }

    return options;
  }

  Future requestNetwork<T>(
    Method method,
    String url, {
    NetSuccessCallback<T> onSuccess,
    NetSuccessListCallback<T> onSuccessList,
    NetErrorCallback onError,
    dynamic params,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
    bool isList: false,
  }) {
    String m = _getRequestMethod(method);
    return _request<T>(
      m,
      url,
      data: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    ).then((BaseEntity<T> result) {
      if (result!=null && result?.code == 0) {
        if (isList) {
          if (onSuccessList != null) {
            onSuccessList(result.listData);
          }
        } else {
          if (onSuccess != null) {
            onSuccess(result.data);
          }
        }
      } else {
        _onError(result?.code, result?.message, onError);
      }
    }, onError: (dynamic e) {
      _cancelLogPrint(e, url);
      final NetError error = ExceptionHandler.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  Future requestEncryptedNetwork<T>(
      Method method,
      String url, {
        NetSuccessCallback<T> onSuccess,
        NetSuccessListCallback<T> onSuccessList,
        NetErrorCallback onError,
        dynamic params,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options,
        bool isList: false,
      }) {
    String m = _getRequestMethod(method);
    return _requestEncoded<T>(
      m,
      url,
      data: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    ).then((BaseEntity<T> result) {
      if (result?.code == 0) {
        if (isList) {
          if (onSuccessList != null) {
            onSuccessList(result.listData);
          }
        } else {
          if (onSuccess != null) {
            onSuccess(result.data);
          }
        }
      } else {
        _onError(result?.code, result?.message, onError);
      }
    }, onError: (dynamic e) {
      _cancelLogPrint(e, url);
      final NetError error = ExceptionHandler.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  void asyncRequestNetwork<T>(
    Method method,
    String url, {
    NetSuccessCallback<T> onSuccess,
    NetSuccessListCallback<T> onSuccessList,
    NetErrorCallback onError,
    dynamic params,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
    bool isList: false,
  }) {
    String m = _getRequestMethod(method);
    Stream.fromFuture(_request<T>(
      m,
      url,
      data: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    )).asBroadcastStream().listen((result) {
      if (result!=null && result?.code == 0) {
        if (isList) {
          if (onSuccessList != null) {
            onSuccessList(result.listData);
          }
        } else {
          if (onSuccess != null) {
            onSuccess(result.data);
          }
        }
      } else {
        _onError(result?.code, result?.message, onError);
      }
    }, onError: (dynamic e) {
      _cancelLogPrint(e, url);
      final NetError error = ExceptionHandler.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  void _cancelLogPrint(dynamic e, String url) {
    if (e is DioError && CancelToken.isCancel(e)) {}
  }

  void _onError(int code, String msg, NetErrorCallback onError) {
    if (code == null) {
      code = ExceptionHandler.unknown_error;
      msg = msg == null ? 'Something went wrong.' : msg;
    }
    if (onError != null) {
      onError(code, msg);
    }
  }

  String _getRequestMethod(Method method) {
    String m;
    switch (method) {
      case Method.get:
        m = 'GET';
        break;
      case Method.post:
        m = 'POST';
        break;
      case Method.put:
        m = 'PUT';
        break;
      case Method.patch:
        m = 'PATCH';
        break;
      case Method.delete:
        m = 'DELETE';
        break;
      case Method.head:
        m = 'HEAD';
        break;
    }
    return m;
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data);
}

enum Method { get, post, put, patch, delete, head }
