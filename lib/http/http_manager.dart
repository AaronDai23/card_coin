import 'dart:io';
import 'package:card_coin/http/result_data.dart';
import 'package:card_coin/observability/otel_dio_interceptor.dart';
import 'package:card_coin/http/smart_card_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

import 'code.dart';

class HttpManager {
  static final HttpManager _instance = HttpManager._internal();
  late Dio _dio;
  late String baseUrl;
  HttpManager._internal() {
    baseUrl = "https://api.dropromo.com";
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
        baseUrl: baseUrl,
      ),
    );
    _dio.interceptors.add(OtelDioInterceptor());
    _dio.interceptors.add(SmartCardInterceptors());
  }

  static HttpManager getInstance({String? baseUrl}) {
    if (null == baseUrl) {
      return _instance._normal();
    } else {
      return _instance._baseUrl(baseUrl);
    }
  }

  HttpManager _baseUrl(String? baseUrl) {
    if (baseUrl != null) {
      _dio.options.baseUrl = baseUrl;
    }
    return this;
  }

  HttpManager _normal() {
    if (_dio.options.baseUrl != baseUrl) {
      _dio.options.baseUrl = baseUrl;
    }
    return this;
  }

  ///通用的GET请求
  Future<ResultData> get(api,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      noTip = false,
      bool autoRetry = true}) async {
    Response response;
    try {
      if (headers != null) {
        _dio.options.headers.addAll(headers);
      }
      response = await _dio.get(api, queryParameters: queryParameters);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        print('loadUser cancelled');
        return resultError(e);
      }
      if (autoRetry) {
        print('[HttpManager] GET $api failed, retrying once...');
        return get(api,
            queryParameters: queryParameters,
            headers: headers,
            noTip: noTip,
            autoRetry: false);
      }
      return resultError(e);
    }

    final ResultData result = response.data;
    // 请求成功但业务失败（解密未就绪等），静默重试一次
    if (!result.isSuccess && autoRetry) {
      print(
          '[HttpManager] GET $api business failure (${result.message}), retrying once...');
      return get(api,
          queryParameters: queryParameters,
          headers: headers,
          noTip: noTip,
          autoRetry: false);
    }
    return result;
  }

  ///通用的POST请求
  Future<ResultData> post(api, params,
      {data, noTip = false, cancelToken, bool autoRetry = true}) async {
    Response response;
    try {
      response = await _dio.post(api,
          data: data,
          queryParameters: params,
          cancelToken: cancelToken,
          options: Options(extra: {'noTip': noTip}));
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        print('loadUser cancelled');
        return resultError(e);
      }
      if (autoRetry) {
        print('[HttpManager] POST $api failed, retrying once...');
        return post(api, params,
            data: data,
            noTip: noTip,
            cancelToken: cancelToken,
            autoRetry: false);
      }
      return resultError(e);
    }
    return response.data;
  }
}

Future<void> ensurePhonePermission() async {
  final status = await Permission.phone.status;
  if (!status.isGranted) {
    await Permission.phone.request();
  }
}

ResultData resultError(DioException e) {
  ResultData resultData;
  // 1. 连接/请求/响应超时，或真正的网络不可达，才提示网络异常（VPN/双卡等建议）
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    resultData = ResultData(false, Code.NETWORK_CONNECT_TIMEOUT,
        'Current network is unstable. \nSuggested step-by-step inspection: \n1.If using dual SIM card+VPN, you can try turning off one card or turning off VPN \n2. If not, check the network or whether the Do Not Disturb mode is enabled.');
  } else if (e.error is SocketException) {
    // 只有真正 SocketException 才提示网络异常
    resultData = ResultData(false, Code.NETWORK_ERROR,
        'Current network is unstable. \nSuggested step-by-step inspection: \n1.If using dual SIM card+VPN, you can try turning off one card or turning off VPN \n2. If not, check the network or whether the Do Not Disturb mode is enabled.');
  } else if (e.type == DioExceptionType.badResponse) {
    int statusCode = e.response?.statusCode ?? -1;
    print('error=========:${e.toString()}');
    // 业务错误码，全部按业务错误处理，不弹网络异常
    if (statusCode == 400) {
      resultData = ResultData(false, statusCode,
          'The remote server or network is abnormal, please try again later.');
    } else if (statusCode == 401) {
      resultData = ResultData(false, statusCode,
          'The login status has expired, please login again.');
    } else if (statusCode == 404) {
      resultData = ResultData(false, statusCode,
          'The remote server or network is abnormal, please try again later.');
    } else if (statusCode == 502) {
      resultData = ResultData(false, statusCode,
          'The server is being updated, please try again later.');
    } else if (statusCode == 503) {
      resultData = ResultData(
          false, statusCode, 'The server is busy, please try again later.');
    } else if (statusCode == 830016) {
      resultData = ResultData(false, statusCode, '钱包地址未同步，请先初始化并同步钱包！');
    } else if (statusCode == 10003333) {
      // 只有服务端主动返回 10003333 才弹 VPN 异常
      resultData = ResultData(false, statusCode,
          'The current device is detected to be using dual SIM cards with VPN enabled, which causes network request failures. It is recommended to disable one SIM card or the VPN before retrying');
    } else {
      if (statusCode > 0) {
        resultData = ResultData(
            false,
            statusCode,
            e.response?.statusMessage ??
                'Network error with status code $statusCode');
      } else {
        // 其它未知业务错误
        resultData = ResultData(
            false, statusCode, 'Unknown error, please try again later.');
      }
    }
  } else if (e.type == DioExceptionType.cancel) {
    resultData = ResultData(false, Code.NETWORK_CANCEL, 'Cancel the request');
  } else {
    // 其它未知异常，不弹 VPN 异常，给出通用提示
    resultData = ResultData(false, Code.UNKNOWN_EXCEPTION,
        'Unknown error, please try again later.');
  }

  return resultData;
}
