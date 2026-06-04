
import 'chain_key.dart';

abstract class IKeyService {
  String? getCardId();

  Future<void> clearAll();

  /// Returns a list of keys from scan card.
  Future<List<ChainKey>> loadKeysFromScan(List<String> blockchains);

  /// Returns a list of all the keys.
  Future<List<ChainKey>> loadKeys();

  void updateCardKeys(String cardId,List<ChainKey> chainKeys);

  List<ChainKey> loadCardKeys();

  /// Returns a list of all the chain ids.
  List<String> getChains();

  /// Returns a list of all the keys for a given chain id.
  /// If the chain is not found, returns an empty list.
  ///  - [chain]: The chain to get the keys for.
  List<ChainKey> getKeysForChain(String value);

  /// Returns a list of all the accounts in namespace:chainId:address format.
  List<String> getAllAccounts();

  Future<void> createAddressFromSeed();

  Future<void> loadDefaultWallet();

  Future<String> getMnemonic();

  Future<void> restoreWalletFromSeed({required String mnemonic});
}
