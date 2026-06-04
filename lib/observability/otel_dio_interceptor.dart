import 'dart:developer' as developer;

import 'package:card_coin/observability/otel_service.dart';
import 'package:dio/dio.dart';
import 'package:opentelemetry/api.dart';

class OtelDioInterceptor extends Interceptor {
  static const String _spanKey = 'otel.span';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final span = OtelService.instance.startSpan(
      'http ${options.method.toUpperCase()} ${options.path}',
      kind: SpanKind.client,
      attributes: [
        Attribute.fromString('http.method', options.method.toUpperCase()),
        Attribute.fromString('http.url', options.uri.toString()),
        Attribute.fromString('http.path', options.path),
      ],
    );

    options.extra[_spanKey] = span;

    final context = contextWithSpan(Context.current, span);
    globalTextMapPropagator.inject(context, options.headers, _MapTextSetter());

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final span = response.requestOptions.extra[_spanKey] as Span?;
    if (span != null) {
      final statusCode = response.statusCode ?? 0;
      span.setAttribute(Attribute.fromInt('http.status_code', statusCode));
      if (statusCode >= 400) {
        span.setStatus(StatusCode.error, 'HTTP $statusCode');
        _logFailedRequest(
          options: response.requestOptions,
          statusCode: statusCode,
          span: span,
          reason: 'http_status_error',
        );
      }
      span.end();
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final span = err.requestOptions.extra[_spanKey] as Span?;
    if (span != null) {
      final statusCode = err.response?.statusCode;
      if (statusCode != null) {
        span.setAttribute(Attribute.fromInt('http.status_code', statusCode));
      }

      _logFailedRequest(
        options: err.requestOptions,
        statusCode: statusCode,
        span: span,
        reason: err.message ?? err.type.name,
      );

      span
        ..setStatus(StatusCode.error, err.message ?? err.type.name)
        ..recordException(err, stackTrace: err.stackTrace)
        ..end();
    }

    handler.next(err);
  }

  void _logFailedRequest({
    required RequestOptions options,
    required Span span,
    required String reason,
    int? statusCode,
  }) {
    final traceId = span.spanContext.traceId.toString();
    final spanId = span.spanContext.spanId.toString();
    final traceparent = options.headers['traceparent']?.toString() ?? '';
    final status = statusCode?.toString() ?? 'unknown';
    final method = options.method.toUpperCase();
    final url = options.uri.toString();

    developer.log(
      '[OTel][HTTP_FAIL] method=$method status=$status url=$url reason=$reason trace_id=$traceId span_id=$spanId traceparent=$traceparent sigNozSearch=trace_id="$traceId"',
      name: 'otel.http',
      error: reason,
    );
  }
}

class _MapTextSetter extends TextMapSetter<Map<String, dynamic>> {
  @override
  void set(Map<String, dynamic> carrier, String key, String value) {
    carrier[key] = value;
  }
}
