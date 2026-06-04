import 'dart:convert';

import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:reown_walletkit/reown_walletkit.dart';
import '../bip39/bip39_base.dart' as bip39;
import '../bip32/bip32_base.dart' as bip32;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chain_data.dart';
import '../utils/constants.dart';
import '../utils/dart_defines.dart';
import 'chain_key.dart';
import 'i_key_service.dart';

class KeyService extends IKeyService {
  List<ChainKey> _keys = [];
  String? _cardId;

  @override
  String? getCardId() {
    return _cardId;
  }

  @override
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (var key in keys) {
      if (key.startsWith('rwkt_')) {
        await prefs.remove(key);
      }
    }
  }

  @override
  Future<List<ChainKey>> loadKeysFromScan(List<String> blockchains) async {

    var chainKeysInfo = await BlockchainPlatform.instance.createChainKeys(blockchains);
    _cardId = chainKeysInfo.cardId;

    _keys.addAll(chainKeysInfo.chainKeys);
    return _keys;
  }

  @override
  Future<List<ChainKey>> loadKeys() async {
    if(Constants.isCard){
      return _keys;
    }
    // ⚠️ WARNING: SharedPreferences is not the best way to store your keys! This is just for example purposes!
    final prefs = await SharedPreferences.getInstance();
    try {
      final savedKeys = prefs.getStringList('rwkt_chain_keys')!;
      final chainKeys = savedKeys.map((e) => ChainKey.fromJson(jsonDecode(e)));
      _keys = List<ChainKey>.from(chainKeys.toList());
      //
      // final extraKeys = await _extraChainKeys();
      // _keys.addAll(extraKeys);
    } catch (_) {}

    debugPrint('[$runtimeType] _keys $_keys');
    return _keys;
  }

  @override
  List<ChainKey> loadCardKeys() {
    return _keys;
  }

  @override
  void updateCardKeys(String cardId,List<ChainKey> chainKeys) async {
    _cardId = cardId;
    _keys.clear();
    _keys.addAll(chainKeys);
  }

  @override
  List<String> getChains() {
    final List<String> chainIds = [];
    for (final ChainKey key in _keys) {
      chainIds.addAll(key.chains);
    }
    return chainIds;
  }

  @override
  List<ChainKey> getKeysForChain(String value) {
    String namespace = value;
    if (value.contains(':')) {
      namespace = NamespaceUtils.getNamespaceFromChain(value);
    }
    return _keys.where((e) => e.namespace == namespace).toList();
  }

  @override
  List<String> getAllAccounts() {
    final List<String> accounts = [];
    for (final ChainKey key in _keys) {
      for (final String chain in key.chains) {
        accounts.add('$chain:${key.address}');
      }
    }
    return accounts;
  }

  @override
  Future<String> getMnemonic() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('rwkt_mnemonic') ?? '';
  }

  // ** bip39/bip32 - EIP155 **

  @override
  Future<void> loadDefaultWallet() async {
    const mnemonic = DartDefines.ethereumSecretKey;
    await restoreWalletFromSeed(mnemonic: mnemonic);
  }

  @override
  Future<void> createAddressFromSeed() async {
    final prefs = await SharedPreferences.getInstance();
    final mnemonic = prefs.getString('rwkt_mnemonic')!;

    final chainKeys = getKeysForChain('eip155');
    final index = chainKeys.length;

    final keyPair = _keyPairFromMnemonic(mnemonic, index: index);
    final chainKey = _eip155ChainKey(keyPair);

    _keys.add(chainKey);

    await _saveKeys();
  }

  @override
  Future<void> restoreWalletFromSeed({required String mnemonic}) async {
    // ⚠️ WARNING: SharedPreferences is not the best way to store your keys! This is just for example purposes!
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('rwkt_chain_keys');
    await prefs.setString('rwkt_mnemonic', mnemonic);

    final keyPair = _keyPairFromMnemonic(mnemonic);
    final chainKey = _eip155ChainKey(keyPair);

    _keys = List<ChainKey>.from([chainKey]);

    await _saveKeys();
  }

  Future<void> _saveKeys() async {
    final prefs = await SharedPreferences.getInstance();
    // Store only eip155 keys
    final chainKeys = _keys
        .where((k) => k.namespace == 'eip155')
        .map((e) => jsonEncode(e.toJson()))
        .toList();
    await prefs.setStringList('rwkt_chain_keys', chainKeys);
  }

  CryptoKeyPair _keyPairFromMnemonic(String mnemonic, {int index = 0}) {
    final isValidMnemonic = bip39.validateMnemonic(mnemonic);
    if (!isValidMnemonic) {
      throw 'Invalid mnemonic';
    }

    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);

    final child = root.derivePath("m/44'/60'/0'/0/$index");
    ///F53CCA96DFA380AF2B040431D3D1753FB781E320C3C3F869E6AE74B7EE8909A3
    ///04B32C74886D761A712869D4590F04850ABCC77B4D5755762DBEE9EE5368E9A46AAC4A2AB29A7218ABF70ABB2B47875E22798DE034B0BB6FBC7D6EFE7947E5E5DA
    ///
    /// 5754463bdfbd6e081ca1d6df965927feb1066a0df86d010ac4125eb4bc4c0082
    /// 034e286c7d22db9c9762895008914a27a67dd392fb28ce9de977a373833ae6be8f
    final private = hex.encode(child.privateKey as List<int>);
    // final private = 'F53CCA96DFA380AF2B040431D3D1753FB781E320C3C3F869E6AE74B7EE8909A3'.toLowerCase();
    final public = hex.encode(child.publicKey);
    return CryptoKeyPair(private, public);
  }

  ChainKey _eip155ChainKey(CryptoKeyPair keyPair) {
    final private = EthPrivateKey.fromHex(keyPair.privateKey);
    final publicKey = hex.encode(private.encodedPublicKey);
    final address = private.address.hex;
    final evmChainKey = ChainKey(
      blockchainId: 'ETH',
      chains: ChainsDataList.eip155Chains.map((e) => e.chainId).toList(),
      privateKey: keyPair.privateKey,
      publicKey: publicKey ,
      address: address,
    );
    debugPrint('[SampleWallet] evmChainKey ${evmChainKey.toString()}');
    return evmChainKey;
  }

  // ** extra derivations **
}
