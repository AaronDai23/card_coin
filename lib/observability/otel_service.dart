import 'dart:developer' as developer;

import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/sdk.dart';

import 'otel_config.dart';

class OtelService {
  OtelService._();

  static final OtelService instance = OtelService._();

  bool _initialized = false;
  Tracer? _tracer;

  Tracer get tracer {
    return _tracer ?? globalTracerProvider.getTracer('card_coin.default');
  }

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    developer.log(
      '[OTel] init traces endpoint=${_buildTracesUri()}',
      name: 'otel.init',
    );

    final provider = TracerProviderBase(
      resource: Resource([
        Attribute.fromString(
            ResourceAttributes.serviceName, OtelConfig.serviceName),
        Attribute.fromString(
            ResourceAttributes.serviceVersion, OtelConfig.serviceVersion),
      ]),
      processors: [
        BatchSpanProcessor(
          CollectorExporter(
            _buildTracesUri(),
            timeoutMilliseconds: 10000,
          ),
          scheduledDelayMillis: 2000,
        ),
      ],
    );

    try {
      registerGlobalTracerProvider(provider);
    } on StateError {
      // Global provider already initialized.
    }

    try {
      registerGlobalTextMapPropagator(W3CTraceContextPropagator());
    } on StateError {
      // Global propagator already initialized.
    }

    _tracer = globalTracerProvider.getTracer('card_coin.app');
    _initialized = true;
  }

  Span startSpan(
    String name, {
    SpanKind kind = SpanKind.internal,
    List<Attribute> attributes = const [],
  }) {
    return tracer.startSpan(
      name,
      context: Context.current,
      kind: kind,
      attributes: attributes,
    );
  }

  void recordGlobalException(
    String source,
    Object error,
    StackTrace stackTrace,
  ) {
    final span = startSpan(
      'app.exception.$source',
      kind: SpanKind.internal,
      attributes: [
        Attribute.fromString('exception.source', source),
      ],
    );

    span
      ..setStatus(StatusCode.error, error.toString())
      ..recordException(error, stackTrace: stackTrace)
      ..end();
  }

  Uri _buildTracesUri() {
    const endpoint = OtelConfig.signozOtlpEndpoint;
    if (endpoint.endsWith('/v1/traces')) {
      return Uri.parse(endpoint);
    }

    if (endpoint.endsWith('/')) {
      return Uri.parse('${endpoint}v1/traces');
    }

    return Uri.parse('$endpoint/v1/traces');
  }
}
