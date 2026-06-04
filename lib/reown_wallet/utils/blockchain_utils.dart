import '../models/chain_data.dart';
import '../models/chain_metadata.dart';

class BlockchainUtils{
  static ChainMetadata getChainMetadata(String chainId) {
    return ChainsDataList.eip155Chains.firstWhere((element) {
      return element.chainId == chainId;
    });
  }
}