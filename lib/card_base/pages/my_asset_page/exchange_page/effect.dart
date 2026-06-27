import 'dart:async';

import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

// 汇率自动刷新间隔
const int _kPriceRefreshSeconds = 30;

Timer? _priceTimer;
Timer? _previewTimer;

void _cancelPreviewTimer() {
  _previewTimer?.cancel();
  _previewTimer = null;
}

void _cancelPriceTimer() {
  _priceTimer?.cancel();
  _priceTimer = null;
}

void _schedulePriceTimer(Context<ExchangeState> ctx) {
  _cancelPriceTimer();
  _priceTimer = Timer.periodic(
    const Duration(seconds: _kPriceRefreshSeconds),
    (_) {
      if (ctx.state.selectedFrom != null && ctx.state.selectedTo != null) {
        ctx.dispatch(ExchangeActionCreator.onRefreshPrice());
      }
    },
  );
}

Effect<ExchangeState>? buildEffect() {
  return combineEffects(<Object, Effect<ExchangeState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    ExchangeAction.loadInit: _onLoadInit,
    ExchangeAction.selectFrom: _onSelectFrom,
    ExchangeAction.selectTo: _onSelectTo,
    ExchangeAction.refreshPrice: _onRefreshPrice,
    ExchangeAction.stepFrom: _onStepFrom,
    ExchangeAction.stepTo: _onStepTo,
    ExchangeAction.setAllFrom: _onSetAllFrom,
    ExchangeAction.setAllTo: _onSetAllTo,
    ExchangeAction.requestPreview: _onRequestPreview,
    ExchangeAction.submit: _onSubmit,
  });
}

void _onInit(Action action, Context<ExchangeState> ctx) {
  ctx.dispatch(ExchangeActionCreator.onLoadInit());
}

void _onDispose(Action action, Context<ExchangeState> ctx) {
  _cancelPriceTimer();
  _cancelPreviewTimer();
}

Future<void> _onLoadInit(Action action, Context<ExchangeState> ctx) async {
  ctx.dispatch(ExchangeActionCreator.onUpdateLoadingFrom(true));

  final result = await HttpManager.getInstance().get(
    NetworkAddress.assetExchangeInit,
    queryParameters: {'uid': ctx.state.uid},
  );

  if (result.isSuccess && result.data is List) {
    final list = (result.data as List)
        .map((e) => ExchangeFromItem.fromJson(e as Map<String, dynamic>))
        .toList();
    ctx.dispatch(ExchangeActionCreator.onLoadInitSuccess(list));
    // 默认选中第一个 From，自动加载 Target 列表
    if (list.isNotEmpty) {
      await _fetchTarget(ctx, list[0]);
    }
  } else {
    ctx.dispatch(ExchangeActionCreator.onLoadInitFailure());
    showToast(result.message);
  }
}

Future<void> _onSelectFrom(Action action, Context<ExchangeState> ctx) async {
  final index = action.payload as int;
  if (index < 0 || index >= ctx.state.fromList.length) return;
  ctx.dispatch(ExchangeActionCreator.onApplyFromSelection(index));
  final from = ctx.state.fromList[index];
  await _fetchTarget(ctx, from);
}

Future<void> _fetchTarget(
    Context<ExchangeState> ctx, ExchangeFromItem selectedFrom) async {
  ctx.dispatch(ExchangeActionCreator.onUpdateLoadingTo(true));
  _cancelPriceTimer();

  final result = await HttpManager.getInstance().get(
    NetworkAddress.assetExchangeTarget,
    queryParameters: {'uid': ctx.state.uid, 'fromCode': selectedFrom.code},
  );

  if (result.isSuccess && result.data is List) {
    final list = (result.data as List)
        .map((e) => ExchangeToItem.fromJson(e as Map<String, dynamic>))
        .toList();
    ctx.dispatch(ExchangeActionCreator.onLoadTargetSuccess(list));
    // 获取到 To 列表后立即刷新汇率，并启动定时器
    if (list.isNotEmpty) {
      await _doRefreshPrice(ctx, overrideFrom: selectedFrom);
      _schedulePriceTimer(ctx);
    }
  } else {
    ctx.dispatch(ExchangeActionCreator.onLoadTargetFailure());
    showToast(result.message);
  }
}

Future<void> _onSelectTo(Action action, Context<ExchangeState> ctx) async {
  // 切换 To 后立即刷新汇率并重启定时器
  _cancelPriceTimer();
  await _doRefreshPrice(ctx);
  _schedulePriceTimer(ctx);
}

Future<void> _onRefreshPrice(Action action, Context<ExchangeState> ctx) async {
  await _doRefreshPrice(ctx);
}

Future<void> _doRefreshPrice(Context<ExchangeState> ctx,
    {ExchangeFromItem? overrideFrom}) async {
  final from = overrideFrom ?? ctx.state.selectedFrom;
  final to = ctx.state.selectedTo;
  if (from == null || to == null) return;

  ctx.dispatch(ExchangeActionCreator.onUpdateLoadingRate(true));

  final result = await HttpManager.getInstance().post(
    NetworkAddress.assetExchangePrice,
    null,
    data: {
      'uid': ctx.state.uid,
      'fromCode': from.code,
      'toCode': to.code,
      'fromAmount': ctx.state.inputAmount.isEmpty ? '0' : ctx.state.inputAmount,
      'smartCardCryptoId': from.id,
    },
  );

  if (result.isSuccess && result.data is Map) {
    ctx.dispatch(ExchangeActionCreator.onLoadPriceSuccess(
        Map<String, dynamic>.from(result.data as Map)));
  } else {
    ctx.dispatch(ExchangeActionCreator.onUpdateLoadingRate(false));
  }
}

Future<void> _doFetchPreview(Context<ExchangeState> ctx) async {
  final from = ctx.state.selectedFrom;
  final to = ctx.state.selectedTo;
  final amount = ctx.state.inputAmount;
  if (from == null || to == null || amount.isEmpty || amount == '0') {
    ctx.dispatch(ExchangeActionCreator.onLoadPreviewFailure());
    return;
  }

  ctx.dispatch(ExchangeActionCreator.onUpdateLoadingPreview(true));

  final result = await HttpManager.getInstance().post(
    NetworkAddress.assetExchangePreview,
    null,
    data: {
      'uid': ctx.state.uid,
      'fromCode': from.code,
      'toCode': to.code,
      'fromAmount': amount,
      'smartCardCryptoId': from.id,
    },
  );

  if (result.isSuccess && result.data is Map) {
    ctx.dispatch(ExchangeActionCreator.onLoadPreviewSuccess(
        Map<String, dynamic>.from(result.data as Map)));
  } else {
    ctx.dispatch(ExchangeActionCreator.onLoadPreviewFailure());
  }
}

Future<void> _onSubmit(Action action, Context<ExchangeState> ctx) async {
  final from = ctx.state.selectedFrom;
  final to = ctx.state.selectedTo;
  final amount = ctx.state.inputAmount;

  if (from == null || to == null || amount.isEmpty || amount == '0') {
    showToast('Please enter an amount');
    return;
  }

  ctx.dispatch(ExchangeActionCreator.onUpdateSubmitting(true));

  // Step 1: preSign — 创建订单并获取待签名载荷
  final preSignResult = await HttpManager.getInstance().post(
    NetworkAddress.assetExchangePreSign,
    null,
    data: {
      'uid': ctx.state.uid,
      'fromCode': from.code,
      'toCode': to.code,
      'fromAmount': amount,
      'smartCardCryptoId': from.id,
    },
  );

  if (!preSignResult.isSuccess || preSignResult.data == null) {
    ctx.dispatch(ExchangeActionCreator.onUpdateSubmitting(false));
    showToast(preSignResult.message);
    return;
  }

  final preSignData = Map<String, dynamic>.from(preSignResult.data as Map);
  final exchangeOrderId = preSignData['exchangeOrderId'] as String? ?? '';
  final signMessageObj = preSignData['signMessage'] as Map?;
  final signId = signMessageObj?['signId'] as String? ?? '';
  final signMessage = signMessageObj?['signMessage'] as String? ?? '';

  if (signMessage.isEmpty) {
    ctx.dispatch(ExchangeActionCreator.onUpdateSubmitting(false));
    showToast('signMessage is empty');
    return;
  }

  // Step 2: NFC 拍卡签名
  String signResult = '';
  try {
    signResult =
        await BlockchainPlatform.instance.signLightning(signMessage, false);
  } catch (error) {
    ctx.dispatch(ExchangeActionCreator.onUpdateSubmitting(false));
    if (error is PlatformException && error.message == 'WrongCardNumber') {
      showToast('WrongCardNumber');
      return;
    }
    if (error is PlatformException &&
        (error.message?.contains('channel-error') ?? false)) {
      showToast(
          'Current network is unstable. Please check your network and try again later.');
      return;
    }
    if (error.toString().contains('UserCancelled')) {
      showToast('User Cancelled the scan');
      return;
    }
    showToast(error.toString());
    return;
  }

  // Step 3: submitSign — 回传签名并广播
  final submitResult = await HttpManager.getInstance().post(
    NetworkAddress.assetExchangeSubmitSign,
    null,
    data: {
      'uid': ctx.state.uid,
      'exchangeOrderId': exchangeOrderId,
      'signId': signId,
      'signature': signResult,
    },
  );

  ctx.dispatch(ExchangeActionCreator.onUpdateSubmitting(false));

  if (submitResult.isSuccess) {
    await _showSubmitSuccessDialog(ctx, exchangeOrderId);
  } else {
    showToast(submitResult.message);
  }
}

Future<void> _showSubmitSuccessDialog(
    Context<ExchangeState> ctx, String exchangeOrderId) async {
  final context = ctx.context;
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Submission completed'),
        content: const Text(
          'Your convert request has been submitted successfully. You can track the progress in detail.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pushNamed(
                'convertDetailPage',
                arguments: {
                  'uid': ctx.state.uid,
                  'exchangeOrderId': exchangeOrderId,
                },
              );
            },
            child: const Text('View Progress'),
          ),
        ],
      );
    },
  );
}

Future<void> _onStepFrom(Action action, Context<ExchangeState> ctx) async {
  final direction = action.payload as int;
  final from = ctx.state.selectedFrom;
  if (from == null) return;

  final step = double.tryParse(from.step) ?? 1.0;
  final current = double.tryParse(ctx.state.inputAmount) ?? 0.0;
  final balance = double.tryParse(from.balance) ?? double.maxFinite;
  final newAmount = (current + direction * step).clamp(0.0, balance);

  ctx.dispatch(
      ExchangeActionCreator.onAmountChanged(_amountToString(newAmount)));
  _schedulePreview(ctx);
}

Future<void> _onStepTo(Action action, Context<ExchangeState> ctx) async {
  final direction = action.payload as int;
  final to = ctx.state.selectedTo;
  final from = ctx.state.selectedFrom;
  if (to == null || from == null) return;

  final step = double.tryParse(to.step) ?? 1.0;
  final currentTo = double.tryParse(ctx.state.estimatedToAmount) ?? 0.0;
  final rate = double.tryParse(ctx.state.rate);
  if (rate == null || rate <= 0) return;

  final newTo = (currentTo + direction * step).clamp(0.0, double.maxFinite);
  final newFrom = newTo / rate;
  final balance = double.tryParse(from.balance) ?? double.maxFinite;
  final clampedFrom = newFrom.clamp(0.0, balance);

  ctx.dispatch(
      ExchangeActionCreator.onAmountChanged(_amountToString(clampedFrom)));
  _schedulePreview(ctx);
}

Future<void> _onSetAllFrom(Action action, Context<ExchangeState> ctx) async {
  final from = ctx.state.selectedFrom;
  if (from == null || from.balance.isEmpty) return;
  ctx.dispatch(ExchangeActionCreator.onAmountChanged(from.balance));
  _schedulePreview(ctx);
}

Future<void> _onSetAllTo(Action action, Context<ExchangeState> ctx) async {
  final to = ctx.state.selectedTo;
  final from = ctx.state.selectedFrom;
  if (to == null || from == null) return;

  final maxConvertible = double.tryParse(to.maxConvertible);
  final rate = double.tryParse(ctx.state.rate);
  if (maxConvertible == null || rate == null || rate <= 0) return;

  final newFrom = maxConvertible / rate;
  final balance = double.tryParse(from.balance) ?? double.maxFinite;
  final clampedFrom = newFrom.clamp(0.0, balance);

  ctx.dispatch(
      ExchangeActionCreator.onAmountChanged(_amountToString(clampedFrom)));
  _schedulePreview(ctx);
}

void _onRequestPreview(Action action, Context<ExchangeState> ctx) {
  _schedulePreview(ctx);
}

void _schedulePreview(Context<ExchangeState> ctx) {
  _cancelPreviewTimer();
  _previewTimer = Timer(
    const Duration(milliseconds: 600),
    () => _doFetchPreview(ctx),
  );
}

/// 将 double 转为干净的字符串（去除多余尾零）
String _amountToString(double v) {
  if (v == 0) return '0';
  final s = v.toStringAsFixed(8);
  final trimmed =
      s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  return trimmed.isEmpty ? '0' : trimmed;
}
