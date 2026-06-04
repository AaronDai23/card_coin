import 'package:get_it/get_it.dart';
import 'package:reown_walletkit/reown_walletkit.dart';

abstract class IWalletKitService extends Disposable{
  Future<void> create();
  Future<void> init();

  ReownWalletKit get walletKit;
}