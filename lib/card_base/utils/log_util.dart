import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:logger/logger.dart';

class LogUtils {
  static String uid = "";
  static late final Logger logger;

  static void d(String tag, String msg) {
    print('DEBUG: $tag: $msg');
    logger.d('DEBUG: $tag: $msg');
  }

  static void e(String tag, String msg) {
    print('ERROR: $tag: $msg');
    logger.e('ERROR: $tag: $msg');
  }

  static void i(String tag, String msg) {
    print('INFO: $tag: $msg');
    logger.i('INFO: $tag: $msg');
  }

  static void init() {
    // 初始化本地日志
    logger = Logger(
      filter: ProductionFilter(), // 只打印 info 级别及以上的日志
      printer: PrettyPrinter(
        methodCount: 1,
        errorMethodCount: 3,
        lineLength: 100,
        colors: true,
        printEmojis: true,
      ),
      output: CLSOutput(), // 自定义输出
    );
  }
}

/// 自定义 Output，把日志转发到腾讯 CLS
class CLSOutput extends LogOutput {
  @override
  Future<void> output(OutputEvent event) async {
    for (var line in event.lines) {
      // 控制台输出
      print(line);

      Map<String, dynamic> params = {
        "uid": LogUtils.uid,
        "message": line,
      };

      // var resultData = await HttpManager.getInstance()
      //     .post(NetworkAddress.dummyLog, null, data: params);
      // if (resultData.isSuccess) {}
    }
  }
}
