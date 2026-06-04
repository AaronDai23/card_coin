import '../widgets/diagnostic_widget.dart';

enum DiagnosticStep { selfCheck, networkDiagnostic }

enum DiagnosticResult { allWell, networkWeak, intranetError, internetError, error }

enum NetworkSignal {
  strong,
  moderate,
  weak,
  veryWeak,
}


class PingResponseInfo {
  ///网络是否可用
  bool enable;

  ///信号强弱
  NetworkSignal get signal {
    if (time == null) {
      return NetworkSignal.veryWeak;
    } else {
      int responseTime = time!;
      if (responseTime < 80) {
        return NetworkSignal.strong;
      } else if (responseTime < 120) {
        return NetworkSignal.moderate;
      } else if (responseTime < 300) {
        return NetworkSignal.weak;
      } else {
        return NetworkSignal.veryWeak;
      }
    }
  }

  ///是否丢包
  bool? packetLoss;

  ///平均响应时间
  int? time;

  PingResponseInfo(this.enable, { this.packetLoss, this.time});
}

class DiagnosticLog {
  List<Map<String, dynamic>>? appPings;
  bool? webServerConnected;
  bool? mqttServerConnected;
  Map<String, dynamic>? bleInfo;
  Map<String, dynamic>? deviceDiagnostic;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (appPings != null) {
      data['appPings'] = appPings;
    }
    if (webServerConnected != null) {
      data['webServerConnected'] = webServerConnected;
    }
    if (mqttServerConnected != null) {
      data['mqttServerConnected'] = mqttServerConnected;
    }
    if (bleInfo != null) {
      data['bleInfo'] = bleInfo;
    }
    if (deviceDiagnostic != null) {
      data['deviceDiagnostic'] = deviceDiagnostic;
    }

    return data;
  }
}

class DiagnosticItemResult {
  String name;
  ResultState state;
  NetworkSignal signal;

  DiagnosticItemResult(this.name, {this.signal = NetworkSignal.strong,this.state = ResultState.processing});
}
