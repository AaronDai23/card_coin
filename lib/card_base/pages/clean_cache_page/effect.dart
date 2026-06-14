import 'dart:convert';

import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'action.dart';
import 'state.dart';

Effect<CleanCacheState>? buildEffect() {
  return combineEffects(<Object, Effect<CleanCacheState>>{
    CleanCacheAction.action: _onAction,
    CleanCacheAction.clearCache: _onClearCache,
  });
}

void _onAction(Action action, Context<CleanCacheState> ctx) {}

Future<void> _onClearCache(Action action, Context<CleanCacheState> ctx) async {
  if (ctx.state.isClearing) return;

  final confirm = await showDialog<bool>(
    context: ctx.context,
    builder: (context) {
      return const ZenggeTextAlertDialog(
        'This will clear all local caches except login status. Continue?',
        enableCancel: true,
        confirmText: 'Clear Now',
        cancelText: 'Cancel',
      );
    },
  );

  if (confirm != true) return;

  ctx.dispatch(CleanCacheActionCreator.onUpdateClearing(true));
  try {
    final cleanedCardCount = await _clearAllCacheExceptLogin(ctx.state.cardId);
    print(
        '[CleanCache] Completed. Cleared wallet cache for $cleanedCardCount card(s).');

    await showDialog<void>(
      context: ctx.context,
      barrierDismissible: false,
      builder: (context) {
        return const ZenggeTextAlertDialog(
          'Cache cleared successfully.',
          enableCancel: false,
          confirmText: 'OK',
        );
      },
    );
  } catch (e) {
    showToast('Clear cache failed: $e');
  } finally {
    ctx.dispatch(CleanCacheActionCreator.onUpdateClearing(false));
  }
}

Future<int> _clearAllCacheExceptLogin(String currentCardId) async {
  final prefs = await SharedPreferences.getInstance();
  final keepUserInfo = prefs.getString(LocalStorage.userInfoKey);
  final keys = prefs.getKeys().toList(growable: false);

  final cardIds = <String>{
    ..._collectCardIdsFromCardInfoKeys(keys),
    ...await _collectCardIdsFromCardInfoLists(prefs, keys),
  };
  if (currentCardId.isNotEmpty) {
    cardIds.add(currentCardId);
  }

  for (final cardId in cardIds) {
    try {
      BlockchainPlatform.instance.clearLocalCurrency(cardId, []);
    } catch (e) {
      print('[CleanCache] clearLocalCurrency failed for $cardId: $e');
    }
  }

  for (final key in keys) {
    if (key == LocalStorage.userInfoKey) continue;
    await prefs.remove(key);
  }

  if (keepUserInfo != null) {
    await prefs.setString(LocalStorage.userInfoKey, keepUserInfo);
  }

  final sortedCardIds = cardIds.toList()..sort();
  print(': $sortedCardIds');
  return cardIds.length;
}

Set<String> _collectCardIdsFromCardInfoKeys(Iterable<String> keys) {
  final cardIds = <String>{};
  for (final key in keys) {
    if (key.startsWith(LocalStorage.cardInfo) &&
        !key.startsWith(LocalStorage.cardInfoList)) {
      final cardId = key.substring(LocalStorage.cardInfo.length);
      if (cardId.isNotEmpty) {
        cardIds.add(cardId);
      }
    }
  }
  return cardIds;
}

Future<Set<String>> _collectCardIdsFromCardInfoLists(
  SharedPreferences prefs,
  Iterable<String> keys,
) async {
  final cardIds = <String>{};

  for (final key in keys) {
    if (!key.startsWith(LocalStorage.cardInfoList)) continue;
    final list = prefs.getStringList(key) ?? const <String>[];
    for (final item in list) {
      final parsedId = _tryParseCardId(item);
      if (parsedId.isNotEmpty) {
        cardIds.add(parsedId);
      }
    }
  }

  return cardIds;
}

String _tryParseCardId(String raw) {
  try {
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      final cardId = decoded['cardId']?.toString() ?? '';
      if (cardId.isNotEmpty) return cardId;
    }
    if (decoded is Map) {
      final cardId = decoded['cardId']?.toString() ?? '';
      if (cardId.isNotEmpty) return cardId;
    }
  } catch (_) {
    final match = RegExp(r'"cardId"\s*:\s*"([^"]+)"').firstMatch(raw);
    if (match != null) {
      return match.group(1) ?? '';
    }
  }
  return '';
}
