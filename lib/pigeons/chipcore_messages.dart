/// chipcore_sdk Pigeon 桥接层
///
/// 从 chipcore_sdk 重新导出 BlockchainApi，channel 名为：
///   dev.flutter.pigeon.chipcore_sdk.BlockchainApi.xxx
///
/// 使用方式：
///   import 'package:card_coin/pigeons/chipcore_messages.dart';
///   final api = ChipCoreBlockchainApi();
///   await api.scanCardAndDerive(...);
///
/// 原有代码通过 'package:card_coin/pigeons/messages.dart' 使用的 BlockchainApi
/// 对应的是旧的 TangemSDK channel（card_coin.BlockchainApi.xxx），
/// native 端已切换到 chipcore_sdk，建议逐步迁移到本文件的 ChipCoreBlockchainApi。
library;

export 'package:chipcore_sdk/src/pigeon/messages.dart'
    show
        BlockchainApi,
        FeeMessage,
        SendMessage,
        ValidateAddressMessage,
        FeeResponse,
        SendTransactionResponse,
        BlockchainErrorMessage,
        BalanceResponse,
        CurrencyInfoMessage,
        CardMessage,
        FeeType,
        CurrencyType,
        TransactionHistoryRequest,
        TransactionsHistory,
        ChainKeyInfo,
        ChainKeyMessage,
        SendCommandMessage,
        CommandResponse;
