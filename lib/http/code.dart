///错误编码
class Code {
  ///网络错误
  static const NETWORK_ERROR = -1;

  ///连接超时
  static const NETWORK_CONNECT_TIMEOUT = -2;

  ///请求超时
  static const NETWORK_REQUEST_TIMEOUT = -3;

  ///响应超时
  static const NETWORK_RESPONSE_TIMEOUT = -4;

  static const NETWORK_CANCEL = -5;

  ///未知异常
  static const UNKNOWN_EXCEPTION = -6;

  static const SUCCESS = 200;

  //请求成功
  static const REQUEST_CODE_SUCCESS = -1;

  //错误码
  //请求错误
  static const ERROR_CODE_BAD_REQUEST = 400;

  //用户未授权或者过期
  static const ERROR_CODE_BAD_UNAUTHORIZED = 401;

  //用户不存在
  static const ERROR_CODE_BAD_USER = 10031;

  //用户已经存在
  static const ERROR_CODE_USER_EXIST = 10032;

  //登陆密码错误
  static const ERROR_CODE_BAD_PASSWORD = 10033;

  //国别码不存在
  static const ERROR_CODE_NOT_NATION = 10034;

  //app版本太低
  static const ERROR_CODE_UPDATE_APP = 30001;

  //MIN错误
  static const ERROR_CODE_MID_ILLEGAL = 30002;

  //没有找到最新版本
  static const ERROR_CODE_NOT_UPDATE = 30003;

  //Record not exist
  static const ERROR_CODE_RECORD_NOT_EXIST = 30004;

  //User not match
  static const ERROR_CODE_USER_NOT_MATCH = 30005;

  //设备离线
  static const ERROR_CODE_DEVICE_OFFLINE = 40001;

  //设备无响应
  static const ERROR_CODE_DEVICE_NOTRESPONES = 40002;

  //没有MacAddress地址
  static const ERROR_CODE_NO_MAC_ADDRESS = 40003;

  //服务器异常
  static const ERROR_CODE_SERVER_EXCEPTION = 40004;

  //没有权限
  static const ERROR_CODE_NOT_PERMISSION = 40005;

  //id exist
  static const ERROR_CODE_ID_EXIST = 40006;

  //id not exist
  static const ERROR_CODE_ID_NOT_EXIST = 40007;

  //保存图片错误
  static const ERROR_CODE_SAVE_FILE_ERROR = 40008;

  //没有找到场景
  static const ERROR_CODE_SCENE_NOT_FOUND = 40009;

  //账号信息错误
  static const ERROR_CODE_ACCOUNT_ERROR = 40010;

  //密码相同
  static const ERROR_CODE_SAME_PASSWORD = 40011;

  //校验码错误
  static const ERROR_CODE_CHECK_CODE_ERROR = 40012;

  //图片不存在
  static const ERROR_CODE_NOT_PICTURE = 40013;

  //参数不能为空
  static const ERROR_CODE_NULL_PARAMS = 40014;

  //数据不存在
  static const ERROR_CODE_NOT_DATA = 40015;

  //数据不合法
  static const ERROR_CODE_DATA_ILLEGAL = 40016;

  //中国不支持Google服务
  static const ERROR_CODE_GOOGLE_NOT_SUPPORT = 40019;

  //中国不支持Google服务
  static const ERROR_CODE_CANCLE_RQUEST = 40000000;

  static errorHandleFunction(code, message, noTip) {
    if (noTip) {
      return message;
    }
//    eventBus.fire(new HttpErrorEvent(code, message));
    return message;
  }
}
