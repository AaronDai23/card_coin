import 'dart:convert';
import 'dart:typed_data';

import 'package:card_coin/bean/public_key_bean.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/observability/otel_dio_interceptor.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart' show RSAPublicKey;
import 'package:pointycastle/asymmetric/rsa.dart' show RSAEngine;
import 'package:pointycastle/api.dart' show PublicKeyParameter;

/// 负责：
/// 1. 从后台获取公钥信息
/// 2. 用 AES 解密出真实 RSA 公钥
/// 3. 为 POST/PUT 正文加密（RSA 分块 + Base64）
/// 4. 为 GET/DELETE 参数加密（RSA 分块 + Base64）

class EncryptionManager {
  EncryptionManager._();
  static final EncryptionManager instance = EncryptionManager._();

  bool _initialized = false;
  bool _enable = false;
  RSAPublicKey? _rsaPublicKey;
  Future<void>? _initializingFuture;
  // 初始化失败重试计数，最多重试 _maxRetries 次
  int _retryCount = 0;
  static const int _maxRetries = 3;

  /// 是否开启加密
  bool get isEnabled => _enable && _rsaPublicKey != null;

  /// 是否已完成初始化
  bool get isInitialized => _initialized;

  /// 在拦截器中懒加载调用，获取并处理公钥
  /// [headers] 由拦截器传入，公钥请求将携带相同的业务请求头
  Future<void> initialize(String baseUrl,
      {Map<String, dynamic>? headers}) async {
    // 已成功初始化，直接返回
    if (_initialized && isEnabled) return;
    // 超过重试次数，不再尝试
    if (_initialized && !isEnabled && _retryCount >= _maxRetries) {
      print('[EncryptionManager] max retries ($_maxRetries) reached, skip');
      return;
    }
    // 正在初始化中，等待结束后返回
    final inFlight = _initializingFuture;
    if (inFlight != null) {
      await inFlight;
      return;
    }
    // 上次初始化失败/未能启用，重置状态再试
    if (_initialized && !isEnabled) {
      _retryCount++;
      _initialized = false;
      _enable = false;
      _rsaPublicKey = null;
      print('[EncryptionManager] retrying init, attempt=$_retryCount');
    }

    final future = _doInitialize(baseUrl, headers: headers);
    _initializingFuture = future;
    await future;
  }

  Future<void> _doInitialize(String baseUrl,
      {Map<String, dynamic>? headers}) async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ));
      dio.interceptors.add(OtelDioInterceptor());
      final response = await dio.get(
        NetworkAddress.systemPublicKeyUrl,
        options: Options(headers: headers),
      );
      final Map<String, dynamic> body = response.data is String
          ? jsonDecode(response.data as String)
          : response.data as Map<String, dynamic>;
      print('[EncryptionManager] Step1 - raw response: $body');

      // errcode 可能是 String 或 int，统一转字符串比较
      final errcode = body['errcode']?.toString();
      print('[EncryptionManager] Step2 - errcode=$errcode');

      if (errcode == '0') {
        final data = body['data'];
        print(
            '[EncryptionManager] Step3 - data field type=${data.runtimeType}');
        final bean = PublicKeyBean.fromJson(data as Map<String, dynamic>);
        print('[EncryptionManager] Step4 - enable=${bean.enable}, '
            'symbol.length=${bean.symbol.length}, '
            'publicKey.length=${bean.publicKey.length}');
        _enable = bean.enable;
        if (_enable) {
          final aesKey = _extractAesKey(bean.symbol);
          print(
              '[EncryptionManager] Step5 - extracted aesKey.length=${aesKey.length}');
          final realPublicKeyBase64 = _aesDecrypt(bean.publicKey, aesKey);
          print('[EncryptionManager] Step6 - AES decrypt OK, '
              'rsaKey.length=${realPublicKeyBase64.length}, '
              'prefix=${realPublicKeyBase64.substring(0, realPublicKeyBase64.length.clamp(0, 20))}');
          _rsaPublicKey = _parseRsaPublicKey(realPublicKeyBase64);
          print('[EncryptionManager] Step7 - RSA key parsed OK, '
              'modulus bits=${_rsaPublicKey!.modulus!.bitLength}');
        } else {
          print(
              '[EncryptionManager] Step4 - enable=false, encryption disabled');
        }
      } else {
        print('[EncryptionManager] Step2 - errcode!=0, skip encryption init');
      }
    } catch (e, st) {
      // 获取失败时降级为不加密，避免阻塞业务
      print('[EncryptionManager] initialize FAILED at some step: $e');
      print('[EncryptionManager] stack: $st');
    } finally {
      _initialized = true;
      _initializingFuture = null;
      print('[EncryptionManager] initialized. isEnabled=$isEnabled');
    }
  }

  /// 重置状态（如切换账号/环境时调用）
  void reset() {
    _initialized = false;
    _enable = false;
    _rsaPublicKey = null;
    _initializingFuture = null;
  }

  // ---------------------------------------------------------------------------
  // 公开加密接口
  // ---------------------------------------------------------------------------

  /// 将 [plaintext] 用 RSA 公钥加密，返回 Base64 字符串
  /// 超过单块限制时自动分块，所有密文字节合并后统一 Base64（与后台 RSAPlatformUtils 一致）
  String encryptToBase64(String plaintext) {
    if (_rsaPublicKey == null) {
      throw StateError('EncryptionManager not ready');
    }
    final RSAPublicKey key = _rsaPublicKey!;
    final int keyBytes = (key.modulus!.bitLength + 7) ~/ 8;
    final int maxChunk = keyBytes - 11; // PKCS1 v1.5 overhead

    final encrypter =
        Encrypter(RSA(publicKey: key, encoding: RSAEncoding.PKCS1));
    final List<int> bytes = utf8.encode(plaintext);
    final allCipherBytes = <int>[];

    for (int offset = 0; offset < bytes.length; offset += maxChunk) {
      final int end =
          (offset + maxChunk < bytes.length) ? offset + maxChunk : bytes.length;
      final chunk = Uint8List.fromList(bytes.sublist(offset, end));
      allCipherBytes.addAll(encrypter.encryptBytes(chunk).bytes);
    }
    return base64Encode(allCipherBytes);
  }

  // ---------------------------------------------------------------------------
  // 公开解密接口（解密服务端私钥加密的响应）
  // ---------------------------------------------------------------------------

  /// 用 RSA 公钥解密服务端私钥加密的响应数据
  /// 对应 Java RSAPlatformUtils.encryptByPrivateKey（服务端响应加密）
  /// 等价于：先做一次 c^e mod n，再去掉 PKCS1 type1 padding
  String? decryptResponseBase64(String encryptedBase64) {
    if (_rsaPublicKey == null) return null;
    try {
      final cipherBytes = base64Decode(encryptedBase64);
      final key = _rsaPublicKey!;
      final int keyLen = (key.modulus!.bitLength + 7) ~/ 8;

      final engine = RSAEngine();
      engine.init(true, PublicKeyParameter<RSAPublicKey>(key));

      final allBytes = <int>[];
      for (int off = 0; off < cipherBytes.length; off += keyLen) {
        final end = (off + keyLen < cipherBytes.length)
            ? off + keyLen
            : cipherBytes.length;
        final block = Uint8List.fromList(cipherBytes.sublist(off, end));
        final outBuf = Uint8List(keyLen);
        final outLen = engine.processBlock(block, 0, block.length, outBuf, 0);
        final stripped = _stripPkcs1Padding(outBuf.sublist(0, outLen));
        if (stripped != null) allBytes.addAll(stripped);
      }
      final plaintext = utf8.decode(Uint8List.fromList(allBytes));
      print('[EncryptionManager] decryptResponseBase64 OK: '
          '${plaintext.substring(0, plaintext.length.clamp(0, 60))}...');
      return plaintext;
    } catch (e) {
      print('[EncryptionManager] decryptResponseBase64 FAILED: $e');
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // 私有辅助
  // ---------------------------------------------------------------------------

  /// 去掉 RSA PKCS1 padding（type1: 0x00 0x01 0xFF...0xFF 0x00；type2: 0x00 0x02 <random> 0x00）
  Uint8List? _stripPkcs1Padding(Uint8List input) {
    if (input.length < 11) return null;
    int pos = 0;
    if (input[pos++] != 0x00) return null;
    final type = input[pos++];
    if (type == 0x01) {
      while (pos < input.length && input[pos] == 0xFF) {
        pos++;
      }
    } else if (type == 0x02) {
      while (pos < input.length && input[pos] != 0x00) {
        pos++;
      }
    } else {
      return null;
    }
    if (pos >= input.length || input[pos] != 0x00) return null;
    return input.sublist(pos + 1);
  }

  /// 从 symbol 中提取 AES 密钥：去掉第一位和最后两位
  String _extractAesKey(String symbol) {
    if (symbol.length < 3) throw ArgumentError('symbol too short: $symbol');
    return symbol.substring(1, symbol.length - 2);
  }

  /// AES/GCM/NoPadding 解密 Base64 密文，返回明文字符串
  /// 与后台 AESPlatformUtils 保持一致：
  ///   - Key  : MD5(password 的 UTF-8 字节) → 16 字节
  ///   - IV   : "@412ef#@FFwg" 的 UTF-8 字节（12 字节，GCM 标准长度）
  ///   - Mode : AES/GCM/NoPadding
  String _aesDecrypt(String encryptedBase64, String aesKeyStr) {
    // Key: MD5(password) → 16 字节
    final md5Digest = crypto.md5.convert(utf8.encode(aesKeyStr));
    final key = Key(Uint8List.fromList(md5Digest.bytes));

    // IV: 固定字符串 "@412ef#@FFwg"
    const ivString = '@412ef#@FFwg';
    final iv = IV(Uint8List.fromList(utf8.encode(ivString)));

    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    final encrypted = Encrypted.fromBase64(encryptedBase64);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  /// 将 Base64 DER 或 PEM 格式的公钥解析为 RSAPublicKey
  RSAPublicKey _parseRsaPublicKey(String keyStr) {
    String pem = keyStr.trim();
    if (!pem.startsWith('-----')) {
      // 补全 PEM 头尾（每 64 字符换行）
      final sb = StringBuffer('-----BEGIN PUBLIC KEY-----\n');
      for (int i = 0; i < pem.length; i += 64) {
        final end = (i + 64 < pem.length) ? i + 64 : pem.length;
        sb.writeln(pem.substring(i, end));
      }
      sb.write('-----END PUBLIC KEY-----');
      pem = sb.toString();
    }
    return RSAKeyParser().parse(pem) as RSAPublicKey;
  }
}
