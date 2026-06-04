class OtelConfig {
  // 可通过 --dart-define=SIGNOZ_OTLP_ENDPOINT=... 覆盖
  static const String signozOtlpEndpoint = String.fromEnvironment(
    'SIGNOZ_OTLP_ENDPOINT',
    defaultValue: 'https://signoz.dropromo.com:14318',
  );
  static const String serviceName = "chipbase-app";
  static const String serviceVersion = "0.121.1";
}
