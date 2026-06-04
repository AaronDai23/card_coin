import 'dart:convert';
import 'package:card_coin/config/blockchair_config.dart';
import 'package:card_coin/http/result_data.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';

import 'address.dart';

class RequestInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if(options.baseUrl == NetworkAddress.blockChairUrl){
      options.queryParameters['key'] = BlockChairConfig.blockChairApiKey;
      // options.queryParameters['transaction_details'] = false;
    }
    LogUtil.d('uri:${options.uri}');
    LogUtil.d('body:${options.data}');
    super.onRequest(options, handler);
  }
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    RequestOptions option = response.requestOptions;
    LogUtil.d('response:$response');

    if(response.statusCode == 200){
      Map<String,dynamic> data;
      if(response.data is String){
        data = json.decode(response.data);
      }else{
        data = response.data;
      }
      handler.resolve(Response(
          data: ResultData(true,0,'',data: data),
          requestOptions: option));
    }else{
      handler.reject(DioException(requestOptions: option,response: response));
    }

  }

}
