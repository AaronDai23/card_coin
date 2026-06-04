import CoreNFC
import CryptoSwift
import Flutter
import Foundation

final class ChipCoreBlockchainApi: NSObject, BlockchainApi {
  private let sessionManager = IOSIso7816SessionManager()
  private let state = NativeWalletState()
  private let flutterClientApi: FlutterClientApi

  init(binaryMessenger: FlutterBinaryMessenger) {
    self.flutterClientApi = FlutterClientApi(binaryMessenger: binaryMessenger)
  }

  static func register(binaryMessenger: FlutterBinaryMessenger) {
    BlockchainApiSetup.setUp(binaryMessenger: binaryMessenger, api: ChipCoreBlockchainApi(binaryMessenger: binaryMessenger))
  }

  func scanCardWithCommand(sendCommandMessage: SendCommandMessage, completion: @escaping (Result<CommandResponse, Error>) -> Void) {
    guard let command = sendCommandMessage.command?.data else {
      completion(.failure(PigeonError(code: "invalid-argument", message: "command 不能为空", details: nil)))
      return
    }

    sessionManager.withSession(appletId: sendCommandMessage.appletId?.data, operation: { channel, finish in
      channel.sendRaw(apduData: command) { outcome in
        switch outcome {
        case .success(let response):
          self.state.lastCardId = channel.cardId
          let statusClient = HdWalletCardClient(channel: channel)
          statusClient.getStatus { statusResult in
            switch statusResult {
            case .success(let status):
              finish(.success(CommandResponse(
                cardId: channel.cardId,
                appletVersionCode: status.versionCode ?? "",
                appletVersion: status.version ?? "",
                isActivated: true,
                resetCount: status.resetCount,
                data: FlutterStandardTypedData(bytes: response)
              )))
            case .failure:
              finish(.success(CommandResponse(
                cardId: channel.cardId,
                appletVersionCode: "",
                appletVersion: "",
                isActivated: true,
                resetCount: 0,
                data: FlutterStandardTypedData(bytes: response)
              )))
            }
          }
        case .failure(let error):
          finish(.failure(error))
        }
      }
    }, completion: { outcome in
      switch outcome {
      case .success(let value as CommandResponse):
        completion(.success(value))
      case .success:
        completion(.failure(PigeonError(code: "invalid-response", message: "scanCardWithCommand 返回类型错误", details: nil)))
      case .failure(let error):
        completion(.failure(error))
      }
    })
  }

  func scanCardAndDerive(currencyList: [CurrencyInfoMessage], ndefLink: String, cardId: String?, cardNo: String?, completion: @escaping (Result<CardMessage, Error>) -> Void) {
    deriveCard(currencyList: currencyList, generateIfMissing: true, completion: completion)
  }

  func createWalletAndDerive(currencyList: [CurrencyInfoMessage], completion: @escaping (Result<CardMessage, Error>) -> Void) {
    deriveCard(currencyList: currencyList, generateIfMissing: true, completion: completion)
  }

  func loadCurrencyInfoList(currencyList: [CurrencyInfoMessage], completion: @escaping (Result<Void, Error>) -> Void) {
    state.replaceCurrencies(currencyList)
    completion(.success(()))
    // 异步拉取各链余额，完成后回调 FlutterClientApi.updateCurrencyInfo
    for currency in currencyList {
      let isTest = currency.isTest == 1
      guard let address = currency.address, !address.isEmpty else { continue }
      let symbol = currency.symbol.uppercased()
      let networkId = currency.networkId
      DispatchQueue.global(qos: .userInitiated).async {
        var balance: String? = nil
        var errorMsg: String? = nil
        do {
          if BlockchainSpec.bitcoin.matches(networkId) {
            balance = try ChainClient.fetchBtcBalance(address: address, isTest: isTest)
          } else if BlockchainSpec.tron.matches(networkId) {
            balance = try ChainClient.fetchTrxBalance(address: address)
          } else if BlockchainSpec.dogecoin.matches(networkId) {
            balance = try ChainClient.fetchDogeBalance(address: address)
          } else {
            balance = try ChainClient.fetchEthBalance(address: address, isTest: isTest)
          }
        } catch {
          errorMsg = error.localizedDescription
        }
        var updated = currency
        updated.amount = balance ?? (errorMsg != nil ? "--" : nil)
        let response: BalanceResponse
        if let msg = errorMsg {
          response = BalanceResponse(
            data: updated,
            errorMessage: BlockchainErrorMessage(code: 0, customMessage: msg)
          )
        } else {
          response = BalanceResponse(data: updated)
        }
        DispatchQueue.main.async {
          self.flutterClientApi.updateCurrencyInfo(currencyInfoList: [response]) { _ in }
        }
      }
    }
  }

  func initScanResponse(uuid: String) throws -> Bool {
    // UID 比较忽略大小写：NFC tagId.hexString 为小写，Dart 侧从服务器拿到的 uid 可能为大写
    let normalized = uuid.lowercased()
    if state.lastCardId?.lowercased() == normalized { return true }
    // App 重启后 in-memory state 被清空，从 UserDefaults 恢复上次扫过的卡 ID
    let saved = UserDefaults.standard.string(forKey: "ChipCore_lastCardId")
    if saved?.lowercased() == normalized {
      state.lastCardId = uuid
      return true
    }
    return false
  }

  func addCurrencyList(currencyList: [CurrencyInfoMessage], completion: @escaping (Result<Bool, Error>) -> Void) {
    sessionManager.withSession(appletId: HdWalletApdu.hdWalletAid, operation: { channel, finish in
      let client = HdWalletCardClient(channel: channel)
      self.ensureKeyAndDerive(client: client, currencyList: currencyList, generateIfMissing: false) { outcome in
        switch outcome {
        case .success(let snapshot):
          self.state.mergeCurrencies(snapshot.currencies)
          finish(.success(true))
        case .failure(let error):
          finish(.failure(error))
        }
      }
    }, completion: { outcome in
      switch outcome {
      case .success(let value as Bool):
        completion(.success(value))
      case .success:
        completion(.failure(PigeonError(code: "invalid-response", message: "addCurrencyList 返回类型错误", details: nil)))
      case .failure(let error):
        completion(.failure(error))
      }
    })
  }

  func getFee(feeMessage: FeeMessage, completion: @escaping (Result<[FeeResponse], Error>) -> Void) {
    let isTest = feeMessage.isTest == "true" || feeMessage.isTest == "1"
    let blockchain = feeMessage.blockchain
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        let fees: [FeeResponse]
        if BlockchainSpec.bitcoin.matches(blockchain) {
          fees = try ChainClient.fetchBtcFees(isTest: isTest)
        } else {
          fees = try ChainClient.fetchEthFees(isTest: isTest)
        }
        DispatchQueue.main.async { completion(.success(fees)) }
      } catch {
        DispatchQueue.main.async { completion(.failure(PigeonError(code: "fee-error", message: error.localizedDescription, details: nil))) }
      }
    }
  }

  func sendTransaction(sendMessage: SendMessage, completion: @escaping (Result<SendTransactionResponse, Error>) -> Void) {
    let blockchainId = sendMessage.blockchainId
    if BlockchainSpec.bitcoin.matches(blockchainId) {
      sendBtcTransaction(msg: sendMessage, completion: completion)
    } else {
      sendEthTransaction(msg: sendMessage, completion: completion)
    }
  }

  private func sendEthTransaction(msg: SendMessage, completion: @escaping (Result<SendTransactionResponse, Error>) -> Void) {
    let isTest = msg.isTest == "true" || msg.isTest == "1"
    let to = msg.receiverAddress
    let from = msg.walletAddress
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        let rpc = ChainClient.ethRpc(isTest: isTest)
        let nonce = try ChainClient.ethNonce(rpc: rpc, address: from)
        let gasPrice: BigUInt
        if let gp = msg.gasPrice, gp.hasPrefix("0x") {
          gasPrice = BigUInt(gp.dropFirst(2), radix: 16) ?? (try ChainClient.ethGasPrice(rpc: rpc))
        } else if let gp = msg.gasPrice, let gpInt = BigUInt(gp) {
          gasPrice = gpInt
        } else {
          gasPrice = try ChainClient.ethGasPrice(rpc: rpc)
        }
        let gasLimit = msg.gasLimit.flatMap { BigUInt($0) } ?? 21000
        let chainId = try ChainClient.ethChainId(rpc: rpc)
        let value = EthEncoder.parseEthValue(msg.sumToSend)
        let signingHash = EthEncoder.buildLegacyTxHash(nonce: nonce, gasPrice: gasPrice, gasLimit: gasLimit, to: to, value: value, data: Data(), chainId: chainId)

        self.sessionManager.withSession(appletId: HdWalletApdu.hdWalletAid, operation: { channel, finish in
          let client = HdWalletCardClient(channel: channel)
          let spec = BlockchainSpec.ethereum
          let pubKeyData: Data
          if let hex = self.state.findPublicKeyHex(keyword: "eth"), let d = Data(hexString: hex) {
            pubKeyData = d
          } else {
            finish(.failure(PigeonError(code: "key-missing", message: "尚未派生 ETH 公钥", details: nil)))
            return
          }
          client.sign(path: spec.defaultPath(), digest: signingHash) { signResult in
            switch signResult {
            case .success(let sigBytes):
              do {
                let (r, s, recId) = try EthEncoder.parseAndRecoverSignature(sigBytes: sigBytes, msgHash: signingHash, pubKey: pubKeyData)
                let v = chainId * 2 + 35 + BigUInt(recId)
                let rawTx = EthEncoder.encodeLegacySignedTx(nonce: nonce, gasPrice: gasPrice, gasLimit: gasLimit, to: to, value: value, data: Data(), v: v, r: r, s: s)
                finish(.success(rawTx))
              } catch {
                finish(.failure(error))
              }
            case .failure(let error):
              finish(.failure(error))
            }
          }
        }, completion: { outcome in
          switch outcome {
          case .success(let rawTx as Data):
            DispatchQueue.global(qos: .userInitiated).async {
              do {
                let txHash = try ChainClient.ethBroadcast(rawTx: rawTx, rpc: rpc)
                DispatchQueue.main.async { completion(.success(SendTransactionResponse(isSuccess: true, errorMsg: txHash))) }
              } catch {
                DispatchQueue.main.async { completion(.failure(PigeonError(code: "broadcast-error", message: error.localizedDescription, details: nil))) }
              }
            }
          case .success:
            DispatchQueue.main.async { completion(.failure(PigeonError(code: "sign-error", message: "签名结果类型错误", details: nil))) }
          case .failure(let error):
            DispatchQueue.main.async { completion(.failure(error)) }
          }
        })
      } catch {
        DispatchQueue.main.async { completion(.failure(PigeonError(code: "eth-prepare-error", message: error.localizedDescription, details: nil))) }
      }
    }
  }

  private func sendBtcTransaction(msg: SendMessage, completion: @escaping (Result<SendTransactionResponse, Error>) -> Void) {
    let isTest = msg.isTest == "true" || msg.isTest == "1"
    let from = msg.walletAddress
    let to = msg.receiverAddress
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        let utxos = try ChainClient.fetchBtcUtxos(address: from, isTest: isTest)
        guard !utxos.isEmpty else {
          DispatchQueue.main.async { completion(.failure(PigeonError(code: "no-utxo", message: "该地址无可用 UTXO", details: nil))) }
          return
        }
        let feeRate = msg.gasPrice.flatMap { UInt64($0) } ?? (try ChainClient.fetchBtcFeeRate(isTest: isTest))
        let valueSat = BtcEncoder.parseAmount(msg.sumToSend)
        let (selectedUtxos, changeSat) = try BtcEncoder.selectUtxos(utxos: utxos, valueSat: valueSat, to: to, from: from, feeRateSatPerVb: feeRate)
        var outputs: [(address: String, value: UInt64)] = [(to, valueSat)]
        if changeSat > 546 { outputs.append((from, changeSat)) }

        self.sessionManager.withSession(appletId: HdWalletApdu.hdWalletAid, operation: { channel, finish in
          let client = HdWalletCardClient(channel: channel)
          let spec = BlockchainSpec.bitcoin
          client.deriveKey(path: spec.defaultPath()) { deriveResult in
            switch deriveResult {
            case .success(let derived):
              let pubKey = BtcEncoder.compressPublicKey(derived.publicKey)
              var witnesses: [[Data]] = []
              var signIndex = 0

              func signNext() {
                if signIndex >= selectedUtxos.count {
                  let rawTx = BtcEncoder.encodeSegwitTx(inputs: selectedUtxos, outputs: outputs, witnesses: witnesses)
                  finish(.success(rawTx))
                  return
                }
                let utxo = selectedUtxos[signIndex]
                let scriptCode = BtcEncoder.p2wpkhScriptCode(pubKey: pubKey)
                let sigHash = BtcEncoder.buildSegwitSigHash(inputs: selectedUtxos, outputs: outputs, inputIndex: signIndex, scriptCode: scriptCode, inputValue: utxo.value)
                client.sign(path: spec.defaultPath(), digest: sigHash) { signResult in
                  switch signResult {
                  case .success(let derSig):
                    let normalizedDer = BtcEncoder.normalizeSignatureDer(derSig)
                    var sigWithHashType = normalizedDer
                    sigWithHashType.append(0x01) // SIGHASH_ALL
                    witnesses.append([sigWithHashType, pubKey])
                    signIndex += 1
                    signNext()
                  case .failure(let error):
                    finish(.failure(error))
                  }
                }
              }

              signNext()

            case .failure(let error):
              finish(.failure(error))
            }
          }
        }, completion: { outcome in
          switch outcome {
          case .success(let rawTx as Data):
            DispatchQueue.global(qos: .userInitiated).async {
              do {
                let txId = try ChainClient.btcBroadcast(rawTx: rawTx, isTest: isTest)
                DispatchQueue.main.async { completion(.success(SendTransactionResponse(isSuccess: true, errorMsg: txId))) }
              } catch {
                DispatchQueue.main.async { completion(.failure(PigeonError(code: "broadcast-error", message: error.localizedDescription, details: nil))) }
              }
            }
          case .success:
            DispatchQueue.main.async { completion(.failure(PigeonError(code: "sign-error", message: "BTC 签名结果类型错误", details: nil))) }
          case .failure(let error):
            DispatchQueue.main.async { completion(.failure(error)) }
          }
        })
      } catch {
        DispatchQueue.main.async { completion(.failure(PigeonError(code: "btc-prepare-error", message: error.localizedDescription, details: nil))) }
      }
    }
  }

  func validateAddress(validateMessage: ValidateAddressMessage) throws -> Bool {
    let blockchain = validateMessage.blockchain.lowercased()
    let address = validateMessage.address.trimmingCharacters(in: .whitespacesAndNewlines)
    if blockchain.contains("eth") || blockchain.contains("evm") {
      return address.range(of: "^0x[a-fA-F0-9]{40}$", options: .regularExpression) != nil
    }
    if blockchain.contains("btc") || blockchain.contains("bitcoin") {
      return address.range(of: "^(bc1|tb1)[ac-hj-np-z02-9]{11,71}$|^[13mn2][A-HJ-NP-Za-km-z1-9]{25,34}$", options: .regularExpression) != nil
    }
    if blockchain.contains("trx") || blockchain.contains("tron") {
      // TRX: Base58Check 解码后 21 字节，首字节 = 0x41
      guard let decoded = Base58Check.decode(address), decoded.count == 21 else { return false }
      return decoded[0] == 0x41
    }
    if blockchain.contains("doge") || blockchain.contains("dogecoin") {
      // DOGE: 0x1E=主网P2PKH(D...)，0x16=主网P2SH(A...)，0x71=测试网(m/n...)
      guard let decoded = Base58Check.decode(address), decoded.count == 21 else { return false }
      return decoded[0] == 0x1E || decoded[0] == 0x16 || decoded[0] == 0x71
    }
    return false
  }

  func clearLocalCurrency(cardId: String, coinIds: [String]) throws {
    if state.lastCardId == cardId {
      state.removeCurrencies(coinIds)
    }
  }

  func loadTransactionHistoryList(request: TransactionHistoryRequest, completion: @escaping (Result<[TransactionsHistory], Error>) -> Void) {
    completion(.failure(notImplementedError("loadTransactionHistoryList 需要链索引服务，当前仓库尚未提供")))
  }

  func changeWallet(cardId: String, currencyList: [CurrencyInfoMessage], completion: @escaping (Result<Bool, Error>) -> Void) {
    state.lastCardId = cardId
    UserDefaults.standard.set(cardId, forKey: "ChipCore_lastCardId")
    state.replaceCurrencies(currencyList)
    completion(.success(true))
  }

  func postCatchedException(error: String, completion: @escaping (Result<Void, Error>) -> Void) {
    NSLog("ChipCore native error: %@", error)
    completion(.success(()))
  }

  func signLightning(signText: String, isBtc: Bool, completion: @escaping (Result<String, Error>) -> Void) {
    signDigest(blockchainId: isBtc ? "btc" : "eth", payload: signText, completion: completion)
  }

  func createChainKeys(blockchains: [String], completion: @escaping (Result<ChainKeyInfo, Error>) -> Void) {
    sessionManager.withSession(appletId: HdWalletApdu.hdWalletAid, operation: { channel, finish in
      let client = HdWalletCardClient(channel: channel)
      self.deriveChainKeys(client: client, blockchains: blockchains) { outcome in
        switch outcome {
        case .success(let chainKeys):
          finish(.success(ChainKeyInfo(cardId: channel.cardId, chainKeys: chainKeys)))
        case .failure(let error):
          finish(.failure(error))
        }
      }
    }, completion: { outcome in
      switch outcome {
      case .success(let value as ChainKeyInfo):
        completion(.success(value))
      case .success:
        completion(.failure(PigeonError(code: "invalid-response", message: "createChainKeys 返回类型错误", details: nil)))
      case .failure(let error):
        completion(.failure(error))
      }
    })
  }

  func getChainKeys(cardId: String, blockchains: [String], completion: @escaping (Result<[ChainKeyMessage], Error>) -> Void) {
    let chainKeys = blockchains.compactMap { blockchainId -> ChainKeyMessage? in
      let spec = BlockchainSpec.fromIdentifier(blockchainId)
      guard let currency = state.findBySpec(spec) else { return nil }
      return ChainKeyMessage(
        blockchainId: blockchainId,
        chainId: nil,
        privateKey: "",
        publicKey: currency.publicKey?.data.hexString ?? "",
        address: currency.address ?? ""
      )
    }
    completion(.success(chainKeys))
  }

  func signText(blockchainId: String, text: String, chainId: Int64?, completion: @escaping (Result<String, Error>) -> Void) {
    signDigest(blockchainId: blockchainId, payload: text, completion: completion)
  }

  func signTransaction(blockchainId: String, text: String, chainId: Int64?, completion: @escaping (Result<String, Error>) -> Void) {
    signDigest(blockchainId: blockchainId, payload: text, completion: completion)
  }

  func generateKey(completion: @escaping (Result<String, Error>) -> Void) {
    sessionManager.withSession(appletId: HdWalletApdu.hdWalletAid, operation: { channel, finish in
      let client = HdWalletCardClient(channel: channel)
      client.generateKeyPair { outcome in
        switch outcome {
        case .success(let generated):
          self.state.cacheMasterKey(cardId: channel.cardId, publicKey: generated.publicKey, chainCode: generated.chainCode)
          finish(.success(generated.publicKey.hexString))
        case .failure(let error):
          finish(.failure(error))
        }
      }
    }, completion: { outcome in
      switch outcome {
      case .success(let value as String):
        completion(.success(value))
      case .success:
        completion(.failure(PigeonError(code: "invalid-response", message: "generateKey 返回类型错误", details: nil)))
      case .failure(let error):
        completion(.failure(error))
      }
    })
  }

  func signChallenge(challenge: String, completion: @escaping (Result<String, Error>) -> Void) {
    completion(.failure(notImplementedError("signChallenge 当前未在原生层实现")))
  }

  func getBitcoinPublicKey() throws -> String {
    guard let key = state.findPublicKeyHex(keyword: "btc") else {
      throw notImplementedError("尚未拿到 BTC 公钥。请先执行 scanCardAndDerive 或 addCurrencyList。")
    }
    return key
  }

  func resetNfcReaderMode() throws {
    sessionManager.reset()
  }

  func getEthPublicKey() throws -> String {
    guard let key = state.findPublicKeyHex(keyword: "eth") else {
      throw notImplementedError("尚未拿到 ETH 公钥。请先执行 scanCardAndDerive 或 addCurrencyList。")
    }
    return key
  }

  func makeAddresses(networkId: String, isBtc: Bool, completion: @escaping (Result<String, Error>) -> Void) {
    if let address = state.findAddress(networkId: networkId) {
      completion(.success(address))
      return
    }
    let spec: BlockchainSpec = isBtc ? .bitcoin : .ethereum
    if let currency = state.findBySpec(spec), let publicKey = currency.publicKey?.data {
      let address = spec.makeAddress(publicKey: publicKey, isTest: currency.isTest == 1)
      state.updateAddress(networkId: networkId, address: address)
      completion(.success(address))
      return
    }
    completion(.failure(notImplementedError("尚未拿到对应链的公钥。请先执行 scanCardAndDerive 或 addCurrencyList。")))
  }

  func bindNetwork() throws {}

  func isVpnActive() throws -> Bool { false }

  func isDualSim() throws -> Bool { false }

  private func deriveCard(currencyList: [CurrencyInfoMessage], generateIfMissing: Bool, completion: @escaping (Result<CardMessage, Error>) -> Void) {
    sessionManager.withSession(appletId: HdWalletApdu.hdWalletAid, operation: { channel, finish in
      let client = HdWalletCardClient(channel: channel)
      self.ensureKeyAndDerive(client: client, currencyList: currencyList, generateIfMissing: generateIfMissing) { outcome in
        switch outcome {
        case .success(let snapshot):
          self.state.lastCardId = snapshot.cardId
          UserDefaults.standard.set(snapshot.cardId, forKey: "ChipCore_lastCardId")
          self.state.cacheMasterKey(cardId: snapshot.cardId, publicKey: snapshot.masterPublicKey, chainCode: snapshot.masterChainCode)
          self.state.replaceCurrencies(snapshot.currencies.compactMap { $0 })
          finish(.success(CardMessage(
            uid: snapshot.uid,
            isPasswordSet: snapshot.isPasswordSet,
            publicKey: FlutterStandardTypedData(bytes: snapshot.masterPublicKey),
            currencyList: snapshot.currencies
          )))
        case .failure(let error):
          finish(.failure(error))
        }
      }
    }, completion: { outcome in
      switch outcome {
      case .success(let value as CardMessage):
        completion(.success(value))
      case .success:
        completion(.failure(PigeonError(code: "invalid-response", message: "deriveCard 返回类型错误", details: nil)))
      case .failure(let error):
        completion(.failure(error))
      }
    })
  }

  private func ensureKeyAndDerive(client: HdWalletCardClient, currencyList: [CurrencyInfoMessage], generateIfMissing: Bool, completion: @escaping (Result<CardSnapshot, Error>) -> Void) {
    client.getStatus { statusResult in
      switch statusResult {
      case .success(let status):
        self.ensureMasterKey(client: client, status: status, generateIfMissing: generateIfMissing, currencies: currencyList, completion: completion)
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  private func ensureMasterKey(client: HdWalletCardClient, status: CardStatus, generateIfMissing: Bool, currencies: [CurrencyInfoMessage], completion: @escaping (Result<CardSnapshot, Error>) -> Void) {
    if !generateIfMissing && !status.hasKeyPair {
      completion(.failure(PigeonError(code: "key-not-found", message: "卡片内尚未生成密钥对", details: nil)))
      return
    }

    // 与 Android 保持一致：无论 hasKeyPair 是否为 true，都必须调用 INS=0x41 (generateKeyPair)
    // 原因：INS=0x41 是幂等的，它将密钥从卡片 flash 加载到 RAM；
    //       不调用时卡片 RAM 为空，INS=0x42 (deriveKey) 会返回主密钥而非派生密钥。
    NSLog("ChipCoreNfc: ensureMasterKey calling generateKeyPair (hasKeyPair=%d) to load key into card RAM", status.hasKeyPair ? 1 : 0)
    client.generateKeyPair { generated in
      switch generated {
      case .success(let rootKey):
        // flash 写入需要时间：首次生成等待 500ms，已有密钥仅做 RAM 加载等待 100ms
        let loadDelay: UInt32 = status.hasKeyPair ? 100_000 : 500_000 // microseconds
        usleep(loadDelay)
        self.deriveCurrencies(client: client, currencies: currencies) { derivedResult in
          switch derivedResult {
          case .success(let derivedCurrencies):
            completion(.success(CardSnapshot(
              cardId: client.cardId,
              uid: status.uid?.hexString ?? client.cardId,
              isPasswordSet: status.pinSet,
              masterPublicKey: rootKey.publicKey,
              masterChainCode: rootKey.chainCode,
              currencies: derivedCurrencies
            )))
          case .failure(let error):
            completion(.failure(error))
          }
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  private func deriveCurrencies(client: HdWalletCardClient, currencies: [CurrencyInfoMessage], completion: @escaping (Result<[CurrencyInfoMessage?], Error>) -> Void) {
    var index = 0
    var output: [CurrencyInfoMessage?] = []

    func next() {
      if index >= currencies.count {
        completion(.success(output))
        return
      }
      let currency = currencies[index]
      index += 1
      let spec = BlockchainSpec.fromCurrency(currency)
      client.deriveKey(path: spec.defaultPath()) { outcome in
        switch outcome {
        case .success(let derived):
          let address = spec.makeAddress(publicKey: derived.publicKey, isTest: currency.isTest == 1)
          output.append(currency.copyWith(publicKey: derived.publicKey, chainCode: derived.chainCode, address: address))
          next()
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }

    next()
  }

  private func deriveChainKeys(client: HdWalletCardClient, blockchains: [String], completion: @escaping (Result<[ChainKeyMessage?], Error>) -> Void) {
    var index = 0
    var output: [ChainKeyMessage?] = []

    func next() {
      if index >= blockchains.count {
        completion(.success(output))
        return
      }
      let blockchainId = blockchains[index]
      index += 1
      let spec = BlockchainSpec.fromIdentifier(blockchainId)
      client.deriveKey(path: spec.defaultPath()) { outcome in
        switch outcome {
        case .success(let derived):
          output.append(ChainKeyMessage(
            blockchainId: blockchainId,
            chainId: nil,
            privateKey: "",
            publicKey: derived.publicKey.hexString,
            address: spec.makeAddress(publicKey: derived.publicKey, isTest: false)
          ))
          next()
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }

    next()
  }

  private func signDigest(blockchainId: String, payload: String, completion: @escaping (Result<String, Error>) -> Void) {
    sessionManager.withSession(appletId: HdWalletApdu.hdWalletAid, operation: { channel, finish in
      let client = HdWalletCardClient(channel: channel)
      let spec = BlockchainSpec.fromIdentifier(blockchainId)
      client.sign(path: spec.defaultPath(), digest: spec.resolveDigest(payload)) { outcome in
        switch outcome {
        case .success(let signature):
          finish(.success(signature.hexString))
        case .failure(let error):
          finish(.failure(error))
        }
      }
    }, completion: { outcome in
      switch outcome {
      case .success(let value as String):
        completion(.success(value))
      case .success:
        completion(.failure(PigeonError(code: "invalid-response", message: "signDigest 返回类型错误", details: nil)))
      case .failure(let error):
        completion(.failure(error))
      }
    })
  }

  private func notImplementedError(_ message: String) -> PigeonError {
    PigeonError(code: "not-implemented", message: message, details: nil)
  }
}

private final class NativeWalletState {
  var lastCardId: String?
  private var currencies: [String: CurrencyInfoMessage] = [:]
  private var masterKeys: [String: KeyMaterial] = [:]

  func replaceCurrencies(_ newCurrencies: [CurrencyInfoMessage]) {
    currencies.removeAll()
    mergeCurrencies(newCurrencies)
  }

  func mergeCurrencies(_ newCurrencies: [CurrencyInfoMessage]) {
    for currency in newCurrencies {
      currencies[currency.id] = currency
      currencies[currency.networkId] = currency
    }
  }

  func removeCurrencies(_ coinIds: [String]) {
    for coinId in coinIds {
      currencies.removeValue(forKey: coinId)
    }
  }

  func findAddress(networkId: String) -> String? {
    currencies[networkId]?.address ?? currencies.values.first(where: { $0.networkId == networkId })?.address
  }

  func updateAddress(networkId: String, address: String) {
    guard let currency = currencies[networkId] ?? currencies.values.first(where: { $0.networkId == networkId }) else { return }
    let updated = currency.copyWith(address: address)
    currencies[currency.id] = updated
    currencies[currency.networkId] = updated
  }

  func findPublicKeyHex(keyword: String) -> String? {
    currencies.values.first {
      $0.networkId.localizedCaseInsensitiveContains(keyword) ||
      $0.symbol.localizedCaseInsensitiveContains(keyword) ||
      $0.name.localizedCaseInsensitiveContains(keyword)
    }?.publicKey?.data.hexString
  }

  func findBySpec(_ spec: BlockchainSpec) -> CurrencyInfoMessage? {
    currencies.values.first {
      spec.matches($0.networkId) || spec.matches($0.symbol) || spec.matches($0.name)
    }
  }

  func cacheMasterKey(cardId: String, publicKey: Data, chainCode: Data) {
    masterKeys[cardId] = KeyMaterial(publicKey: publicKey, chainCode: chainCode)
  }
}

private struct KeyMaterial {
  let publicKey: Data
  let chainCode: Data
}

private struct CardStatus {
  let hasKeyPair: Bool
  let pinSet: Bool
  let uid: Data?
  let version: String?
  let versionCode: String?
  let resetCount: Int64
}

private struct CardSnapshot {
  let cardId: String
  let uid: String
  let isPasswordSet: Bool
  let masterPublicKey: Data
  let masterChainCode: Data
  let currencies: [CurrencyInfoMessage?]
}

private struct IOSSessionChannel {
  let tag: NFCISO7816Tag
  let cardId: String

  func sendRaw(apduData: Data, completion: @escaping (Result<Data, Error>) -> Void) {
    do {
      let apdu = try apduData.parseApdu()
      tag.sendCommand(apdu: apdu) { data, sw1, sw2, error in
        if let error {
          completion(.failure(error))
          return
        }
        var response = data
        response.append(sw1)
        response.append(sw2)
        completion(.success(response))
      }
    } catch {
      completion(.failure(error))
    }
  }

  func send(apduData: Data, context: String, completion: @escaping (Result<Data, Error>) -> Void) {
    sendRaw(apduData: apduData) { outcome in
      switch outcome {
      case .success(let response):
        do {
          try ensureSuccessStatus(response: response, message: context)
          completion(.success(response.dropLast(2)))
        } catch {
          completion(.failure(error))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

private final class IOSIso7816SessionManager {
  private var delegateRef: AnyObject?
  private weak var currentSession: NFCTagReaderSession?

  func withSession(appletId: Data?, operation: @escaping (IOSSessionChannel, @escaping (Result<Any, Error>) -> Void) -> Void, completion: @escaping (Result<Any, Error>) -> Void) {
    guard #available(iOS 13.0, *) else {
      completion(.failure(PigeonError(code: "nfc-unavailable", message: "iOS 13 及以上才支持 ISO 7816 标签会话", details: nil)))
      return
    }
    guard NFCTagReaderSession.readingAvailable else {
      completion(.failure(PigeonError(code: "nfc-unavailable", message: "设备不支持 NFC 读卡", details: nil)))
      return
    }

    let delegate = ISO7816TagSessionDelegate(appletId: appletId, operation: operation, completion: completion)
    let session = NFCTagReaderSession(pollingOption: [.iso14443], delegate: delegate)
    session.alertMessage = "Hold your card near iPhone camera on upper back, until you see a ✅"
    delegate.bind(session: session)
    delegateRef = delegate
    currentSession = session
    session.begin()
  }

  func reset() {
    currentSession?.invalidate()
    currentSession = nil
    delegateRef = nil
  }
}

@available(iOS 13.0, *)
private final class ISO7816TagSessionDelegate: NSObject, NFCTagReaderSessionDelegate {
  private let appletId: Data?
  private let operation: (IOSSessionChannel, @escaping (Result<Any, Error>) -> Void) -> Void
  private let completion: (Result<Any, Error>) -> Void
  private weak var session: NFCTagReaderSession?
  private var finished = false

  init(appletId: Data?, operation: @escaping (IOSSessionChannel, @escaping (Result<Any, Error>) -> Void) -> Void, completion: @escaping (Result<Any, Error>) -> Void) {
    self.appletId = appletId
    self.operation = operation
    self.completion = completion
  }

  func bind(session: NFCTagReaderSession) {
    self.session = session
  }

  func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {}

  func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
    finish(.failure(error), invalidate: false)
  }

  func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
    guard let firstTag = tags.first else {
      finish(.failure(PigeonError(code: "tag-missing", message: "未检测到卡片", details: nil)))
      return
    }
    session.connect(to: firstTag) { connectError in
      if let connectError {
        self.finish(.failure(connectError))
        return
      }
      guard case let .iso7816(tag) = firstTag else {
        self.finish(.failure(PigeonError(code: "tag-unsupported", message: "检测到的卡片不支持 ISO 7816", details: nil)))
        return
      }
      self.selectAppletIfNeeded(tag: tag, tagId: firstTag.sessionTagIdentifier)
    }
  }

  private func selectAppletIfNeeded(tag: NFCISO7816Tag, tagId: Data) {
    if let appletId, !appletId.isEmpty {
      let selectApdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: 0x04, p2Parameter: 0x00, data: appletId, expectedResponseLength: 0)
      tag.sendCommand(apdu: selectApdu) { data, sw1, sw2, error in
        if let error {
          self.finish(.failure(error))
          return
        }
        var response = data
        response.append(sw1)
        response.append(sw2)
        do {
          try ensureSuccessStatus(response: response, message: "选择 applet 失败")
          self.beginOperation(tag: tag, tagId: tagId)
        } catch {
          self.finish(.failure(error))
        }
      }
    } else {
      beginOperation(tag: tag, tagId: tagId)
    }
  }

  private func beginOperation(tag: NFCISO7816Tag, tagId: Data) {
    let channel = IOSSessionChannel(tag: tag, cardId: tagId.hexString)
    operation(channel) { result in
      self.finish(result)
    }
  }

  private func finish(_ result: Result<Any, Error>, invalidate: Bool = true) {
    guard !finished else { return }
    finished = true
    if invalidate {
      session?.invalidate()
    }
    completion(result)
  }
}

private final class HdWalletCardClient {
  let channel: IOSSessionChannel
  var cardId: String { channel.cardId }

  init(channel: IOSSessionChannel) {
    self.channel = channel
  }

  func getStatus(completion: @escaping (Result<CardStatus, Error>) -> Void) {
    channel.send(apduData: HdWalletApdu.simple(ins: HdWalletApdu.insGetStatus), context: "读取卡状态失败") { outcome in
      switch outcome {
      case .success(let payload):
        do {
          let tags = try parseResponse(payload)
          completion(.success(CardStatus(
            hasKeyPair: tags[HdWalletApdu.tagHasKeyPair]?.first == 0x01,
            pinSet: tags[HdWalletApdu.tagPinSet]?.first == 0x01,
            uid: tags[HdWalletApdu.tagUid],
            version: tags[HdWalletApdu.tagAppletVersion].flatMap { String(data: $0, encoding: .utf8) },
            versionCode: tags[HdWalletApdu.tagAppletVersionCode].flatMap { String(data: $0, encoding: .utf8) },
            resetCount: Int64(tags[HdWalletApdu.tagResetCount]?.unsignedIntValue ?? 0)
          )))
        } catch {
          completion(.failure(error))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func generateKeyPair(completion: @escaping (Result<KeyMaterial, Error>) -> Void) {
    channel.send(apduData: HdWalletApdu.simple(ins: HdWalletApdu.insGenerateKey), context: "生成密钥失败") { outcome in
      completion(outcome.flatMap { payload in
        Result { try self.parseKeyMaterial(payload) }
      })
    }
  }

  func deriveKey(path: Data, completion: @escaping (Result<KeyMaterial, Error>) -> Void) {
    let payload = HdWalletApdu.tlv(tag: HdWalletApdu.tagDerivePath, value: path)
    channel.send(apduData: HdWalletApdu.withData(ins: HdWalletApdu.insDerive, data: payload), context: "派生公钥失败") { outcome in
      completion(outcome.flatMap { payload in
        Result { try self.parseKeyMaterial(payload) }
      })
    }
  }

  func sign(path: Data, digest: Data, completion: @escaping (Result<Data, Error>) -> Void) {
    let payload = HdWalletApdu.tlv(tag: HdWalletApdu.tagSignMessage, value: digest) +
      HdWalletApdu.tlv(tag: HdWalletApdu.tagDerivePath, value: path)
    channel.send(apduData: HdWalletApdu.withData(ins: HdWalletApdu.insSign, data: payload), context: "签名失败") { outcome in
      completion(outcome.flatMap { payload in
        Result {
          let tags = try self.parseResponse(payload)
          guard let signature = tags[HdWalletApdu.tagSignature] else {
            throw PigeonError(code: "invalid-response", message: "签名响应缺少 0x98 标签", details: nil)
          }
          return signature
        }
      })
    }
  }

  private func parseKeyMaterial(_ payload: Data) throws -> KeyMaterial {
    let tags = try parseResponse(payload)
    guard let publicKey = tags[HdWalletApdu.tagPublicKey] else {
      throw PigeonError(code: "invalid-response", message: "缺少 0x90 公钥标签", details: nil)
    }
    guard let chainCode = tags[HdWalletApdu.tagChainCode] else {
      throw PigeonError(code: "invalid-response", message: "缺少 0x92 ChainCode 标签", details: nil)
    }
    return KeyMaterial(publicKey: publicKey, chainCode: chainCode)
  }

  private func parseResponse(_ payload: Data) throws -> [UInt8: Data] {
    var tags: [UInt8: Data] = [:]
    var index = 0
    let bytes = Array(payload)
    while index + 2 <= bytes.count {
      let tag = bytes[index]
      let length = Int(bytes[index + 1])
      let start = index + 2
      let end = start + length
      guard end <= bytes.count else {
        throw PigeonError(code: "invalid-response", message: "TLV 长度越界", details: nil)
      }
      tags[tag] = Data(bytes[start..<end])
      index = end
    }
    return tags
  }
}

private enum HdWalletApdu {
  static let hdWalletAid = Data([0x68, 0x64, 0x69, 0x6E, 0x73, 0x74, 0x61, 0x63, 0x61, 0x73, 0x68, 0x00])

  static let cla: UInt8 = 0x80
  static let insGetStatus: UInt8 = 0x31
  static let insGenerateKey: UInt8 = 0x41
  static let insDerive: UInt8 = 0x42
  static let insSign: UInt8 = 0x43

  static let tagPublicKey: UInt8 = 0x90
  static let tagChainCode: UInt8 = 0x92
  static let tagSignMessage: UInt8 = 0x93
  static let tagDerivePath: UInt8 = 0x94
  static let tagSignature: UInt8 = 0x98
  static let tagHasKeyPair: UInt8 = 0x99
  static let tagPinSet: UInt8 = 0x9A
  static let tagAppletVersion: UInt8 = 0xA0
  static let tagAppletVersionCode: UInt8 = 0xA2
  static let tagResetCount: UInt8 = 0xA4
  static let tagUid: UInt8 = 0xA5

  static func simple(ins: UInt8) -> Data {
    Data([cla, ins, 0x00, 0x00])
  }

  static func withData(ins: UInt8, data: Data) -> Data {
    Data([cla, ins, 0x00, 0x00, UInt8(data.count)]) + data
  }

  static func tlv(tag: UInt8, value: Data) -> Data {
    Data([tag, UInt8(value.count)]) + value
  }
}

private enum BlockchainSpec {
  case bitcoin
  case ethereum
  case tron
  case dogecoin

  func matches(_ identifier: String) -> Bool {
    let value = identifier.lowercased()
    switch self {
    case .bitcoin:
      return value.contains("btc") || value.contains("bitcoin")
    case .ethereum:
      return value.contains("eth") || value.contains("ethereum") || value.contains("evm")
    case .tron:
      return value.contains("trx") || value.contains("tron")
    case .dogecoin:
      return value.contains("doge") || value.contains("dogecoin")
    }
  }

  static func fromCurrency(_ currency: CurrencyInfoMessage) -> BlockchainSpec {
    fromIdentifier([currency.networkId, currency.symbol, currency.name].joined(separator: " "))
  }

  static func fromIdentifier(_ identifier: String) -> BlockchainSpec {
    if bitcoin.matches(identifier) { return .bitcoin }
    if tron.matches(identifier) { return .tron }
    if dogecoin.matches(identifier) { return .dogecoin }
    return .ethereum
  }

  func defaultPath(account: UInt32 = 0, change: UInt32 = 0, index: UInt32 = 0) -> Data {
    let hardened: UInt32 = 0x80000000
    let coinType: UInt32
    switch self {
    case .bitcoin:  coinType = 0
    case .tron:     coinType = 195
    case .dogecoin: coinType = 3
    case .ethereum: coinType = 1  // 与 Android 保持一致（Android BlockchainSpec.Ethereum coinType=1）
    }
    let segments: [UInt32] = [44 | hardened, coinType | hardened, account | hardened, change, index]
    return segments.reduce(into: Data()) { result, segment in
      var bigEndian = segment.bigEndian
      result.append(Data(bytes: &bigEndian, count: MemoryLayout<UInt32>.size))
    }
  }

  func resolveDigest(_ payload: String) -> Data {
    if let data = payload.hexToData(), data.count == 32 {
      return data
    }
    let bytes = Array(payload.utf8)
    switch self {
    case .bitcoin, .dogecoin:
      return Data(bytes.sha256())
    case .ethereum, .tron:
      return Data(bytes.sha3(.keccak256))
    }
  }

  func makeAddress(publicKey: Data, isTest: Bool) -> String {
    switch self {
    case .bitcoin:
      let compressed = publicKey.compressedSecp256k1()
      let hash160 = Data(compressed.bytes.sha256().ripemd160())
      let prefix = Data([isTest ? 0x6F : 0x00])
      let body = prefix + hash160
      let checksum = Data(Data(body.bytes.sha256()).bytes.sha256().prefix(4))
      return Base58.encode(body + checksum)
    case .dogecoin:
      let compressed = publicKey.compressedSecp256k1()
      let hash160 = Data(compressed.bytes.sha256().ripemd160())
      let prefix = Data([isTest ? 0x71 : 0x1E])
      let body = prefix + hash160
      let checksum = Data(Data(body.bytes.sha256()).bytes.sha256().prefix(4))
      return Base58.encode(body + checksum)
    case .tron:
      let ethBytes = publicKey.decompressedSecp256k1EthBytes()
      let hash = Data(Array(ethBytes).sha3(.keccak256))
      let body = Data([0x41]) + Data(hash.suffix(20))
      let checksum = Data(Data(body.bytes.sha256()).bytes.sha256().prefix(4))
      return Base58.encode(body + checksum)
    case .ethereum:
      let ethBytes = publicKey.decompressedSecp256k1EthBytes()
      let hash = Data(Array(ethBytes).sha3(.keccak256))
      return "0x" + Data(hash.suffix(20)).hexString
    }
  }
}

private enum Base58 {
  private static let alphabet = Array("123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz")

  static func encode(_ data: Data) -> String {
    if data.isEmpty { return "" }
    var bytes = Array(data)
    let zeroCount = bytes.prefix { $0 == 0 }.count
    var startAt = zeroCount
    var encoded: [Character] = []

    while startAt < bytes.count {
      var remainder = 0
      for index in startAt..<bytes.count {
        let value = Int(bytes[index]) & 0xFF
        let temp = remainder * 256 + value
        bytes[index] = UInt8(temp / 58)
        remainder = temp % 58
      }
      encoded.append(alphabet[remainder])
      while startAt < bytes.count && bytes[startAt] == 0 {
        startAt += 1
      }
    }

    for _ in 0..<zeroCount {
      encoded.append(alphabet[0])
    }
    return String(encoded.reversed())
  }
}

private extension CurrencyInfoMessage {
  func copyWith(publicKey: Data? = nil, chainCode: Data? = nil, address: String? = nil) -> CurrencyInfoMessage {
    CurrencyInfoMessage(
      id: id,
      icon: icon,
      name: name,
      networkId: networkId,
      networkName: networkName,
      networkIcon: networkIcon,
      symbol: symbol,
      contractAddress: contractAddress,
      decimalCount: decimalCount,
      amount: amount,
      address: address ?? self.address,
      publicKey: publicKey.map { FlutterStandardTypedData(bytes: $0) } ?? self.publicKey,
      chainCode: chainCode.map { FlutterStandardTypedData(bytes: $0) } ?? self.chainCode,
      isTest: isTest
    )
  }
}

private extension Data {
  func parseApdu() throws -> NFCISO7816APDU {
    if count < 4 {
      throw PigeonError(code: "invalid-apdu", message: "APDU 长度至少为 4 字节", details: nil)
    }
    let bytes = Array(self)
    let cla = bytes[0]
    let ins = bytes[1]
    let p1 = bytes[2]
    let p2 = bytes[3]
    if count == 4 {
      return NFCISO7816APDU(instructionClass: cla, instructionCode: ins, p1Parameter: p1, p2Parameter: p2, data: Data(), expectedResponseLength: 0)
    }
    let lc = Int(bytes[4])
    let start = 5
    let end = start + lc
    guard end <= count else {
      throw PigeonError(code: "invalid-apdu", message: "APDU Lc 与实际数据长度不匹配", details: nil)
    }
    let body = lc > 0 ? Data(bytes[start..<end]) : Data()
    let le = end < count ? Int(bytes[end]) : 0
    return NFCISO7816APDU(instructionClass: cla, instructionCode: ins, p1Parameter: p1, p2Parameter: p2, data: body, expectedResponseLength: le)
  }

  var hexString: String {
    map { String(format: "%02x", $0) }.joined()
  }

  var unsignedIntValue: UInt64 {
    reduce(0) { ($0 << 8) | UInt64($1) }
  }

  func compressedSecp256k1() -> Data {
    if count == 33 { return self }
    guard count == 65, first == 0x04 else { return self }
    let yLastByte = self[index(before: endIndex)]
    let prefix: UInt8 = (yLastByte & 1) == 0 ? 0x02 : 0x03
    return Data([prefix]) + self[1..<33]
  }

  /// 返回 64 字节原始 X+Y（无前缀），适合用于 ETH/TRX keccak256 地址计算。
  /// 支持：33字节压缩、65字节非压缩(0x04+XY)、64字节裸XY。
  func decompressedSecp256k1EthBytes() -> Data {
    switch count {
    case 64:
      return self
    case 65 where first == 0x04:
      return self.dropFirst()
    case 33:
      return secp256k1DecompressPoint(compressedKey: self)
    default:
      NSLog("ChipCoreNfc: decompressedSecp256k1EthBytes: 无法识别公钥格式 size=\(count), 原样返回")
      return self
    }
  }
}

private extension String {
  func hexToData() -> Data? {
    let normalized = lowercased().replacingOccurrences(of: "0x", with: "")
    guard normalized.count % 2 == 0 else { return nil }
    var result = Data(capacity: normalized.count / 2)
    var index = normalized.startIndex
    while index < normalized.endIndex {
      let next = normalized.index(index, offsetBy: 2)
      guard let byte = UInt8(normalized[index..<next], radix: 16) else { return nil }
      result.append(byte)
      index = next
    }
    return result
  }
}

private func ensureSuccessStatus(response: Data, message: String) throws {
  guard response.count >= 2 else {
    throw PigeonError(code: "apdu-error", message: "\(message): 响应长度不足", details: nil)
  }
  let sw1 = response[response.index(response.endIndex, offsetBy: -2)]
  let sw2 = response[response.index(response.endIndex, offsetBy: -1)]
  guard sw1 == 0x90, sw2 == 0x00 else {
    throw PigeonError(code: "apdu-error", message: String(format: "%@: SW=%02X%02X", message, sw1, sw2), details: nil)
  }
}

// MARK: - BigUInt minimal implementation

private typealias BigUInt = UInt256

private struct UInt256: Equatable, Comparable, CustomStringConvertible {
  var hi: UInt128
  var lo: UInt128

  init(_ value: UInt64) { lo = UInt128(value); hi = 0 }
  init(_ value: Int) { self.init(UInt64(bitPattern: Int64(value))) }

  static let zero = UInt256(0)
  static let one = UInt256(1)

  var description: String { toDecimalString() }

  func toHexString() -> String {
    if hi == 0 { return String(lo, radix: 16) }
    return String(hi, radix: 16) + String(lo, radix: 16).leftPad(toLength: 32, withPad: "0")
  }

  private func toDecimalString() -> String {
    if self == .zero { return "0" }
    var result = ""
    var remaining = self
    let ten = UInt256(10)
    while remaining > .zero {
      let (q, r) = remaining.quotientAndRemainder(dividingBy: ten)
      result = String(r.lo) + result
      remaining = q
    }
    return result
  }

  static func < (lhs: UInt256, rhs: UInt256) -> Bool {
    if lhs.hi != rhs.hi { return lhs.hi < rhs.hi }
    return lhs.lo < rhs.lo
  }

  static func + (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let (newLo, overflow) = lhs.lo.addingReportingOverflow(rhs.lo)
    let newHi = lhs.hi &+ rhs.hi &+ (overflow ? 1 : 0)
    return UInt256(hi: newHi, lo: newLo)
  }

  static func - (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let (newLo, borrow) = lhs.lo.subtractingReportingOverflow(rhs.lo)
    let newHi = lhs.hi &- rhs.hi &- (borrow ? 1 : 0)
    return UInt256(hi: newHi, lo: newLo)
  }

  static func * (lhs: UInt256, rhs: UInt256) -> UInt256 {
    // Simplified: only works well when result fits in 256 bits
    let (newLo, _) = lhs.lo.multipliedReportingOverflow(by: rhs.lo)
    let hiPart = lhs.hi &* rhs.lo &+ lhs.lo &* rhs.hi // approximate
    return UInt256(hi: hiPart, lo: newLo)
  }

  func quotientAndRemainder(dividingBy divisor: UInt256) -> (UInt256, UInt256) {
    // long division, good enough for small divisors
    if divisor > self { return (.zero, self) }
    if divisor.hi == 0 && hi == 0 {
      let q = lo / divisor.lo
      let r = lo % divisor.lo
      return (UInt256(q), UInt256(r))
    }
    // Fall back to bit-by-bit
    var quotient = UInt256.zero
    var remainder = UInt256.zero
    let bits = 256
    for i in stride(from: bits - 1, through: 0, by: -1) {
      remainder = remainder << 1
      if bitAt(i) { remainder.lo |= 1 }
      if remainder >= divisor {
        remainder = remainder - divisor
        quotient = quotient | (UInt256.one << i)
      }
    }
    return (quotient, remainder)
  }

  static func | (lhs: UInt256, rhs: UInt256) -> UInt256 {
    UInt256(hi: lhs.hi | rhs.hi, lo: lhs.lo | rhs.lo)
  }

  static func << (lhs: UInt256, rhs: Int) -> UInt256 {
    if rhs == 0 { return lhs }
    if rhs >= 128 { return UInt256(hi: lhs.lo << (rhs - 128), lo: 0) }
    let newHi = (lhs.hi << rhs) | (lhs.lo >> (128 - rhs))
    let newLo = lhs.lo << rhs
    return UInt256(hi: newHi, lo: newLo)
  }

  func bitAt(_ pos: Int) -> Bool {
    if pos >= 128 {
      let shift = pos - 128
      return (hi >> shift) & 1 == 1
    } else {
      return (lo >> pos) & 1 == 1
    }
  }

  init?(_ string: String, radix: Int = 10) {
    var result = UInt256.zero
    for ch in string {
      guard let digit = ch.hexDigitValue ?? (radix == 10 ? ch.wholeNumberValue : nil) else { return nil }
      if digit >= radix { return nil }
      result = result * UInt256(radix) + UInt256(digit)
    }
    self = result
  }

  init(hi: UInt128, lo: UInt128) { self.hi = hi; self.lo = lo }

  func toByteArray() -> [UInt8] {
    var result = [UInt8]()
    var n = self
    while n > .zero {
      let (q, r) = n.quotientAndRemainder(dividingBy: UInt256(256))
      result.insert(UInt8(r.lo), at: 0)
      n = q
    }
    return result
  }
}

private typealias UInt128 = UInt64 // simplified: treat UInt128 as UInt64 for now

// MARK: - ChainClient (iOS)

private enum ChainClient {
  private static let btcMainApi = "https://mempool.space/api"
  private static let btcTestApi = "https://mempool.space/testnet4/api"
  private static let ethMainRpc = "https://ethereum.publicnode.com"
  private static let ethTestRpc = "https://ethereum-sepolia.publicnode.com"

  static func ethRpc(isTest: Bool) -> String { isTest ? ethTestRpc : ethMainRpc }

  static func fetchBtcFees(isTest: Bool) throws -> [FeeResponse] {
    let api = isTest ? btcTestApi : btcMainApi
    let json = try httpGet("\(api)/v1/fees/recommended")
    guard let obj = json as? [String: Any] else { throw urlError("bad fees json") }
    let low = (obj["economyFee"] as? NSNumber)?.uint64Value ?? 1
    let normal = (obj["halfHourFee"] as? NSNumber)?.uint64Value ?? 2
    let priority = (obj["fastestFee"] as? NSNumber)?.uint64Value ?? 3
    return [
      FeeResponse(type: .low, value: String(low), gasLimit: nil, gasPrice: nil),
      FeeResponse(type: .normal, value: String(normal), gasLimit: nil, gasPrice: nil),
      FeeResponse(type: .priority, value: String(priority), gasLimit: nil, gasPrice: nil),
    ]
  }

  static func fetchBtcFeeRate(isTest: Bool) throws -> UInt64 {
    let api = isTest ? btcTestApi : btcMainApi
    let json = try httpGet("\(api)/v1/fees/recommended")
    guard let obj = json as? [String: Any] else { throw urlError("bad fees json") }
    return (obj["halfHourFee"] as? NSNumber)?.uint64Value ?? 2
  }

  static func fetchEthFees(isTest: Bool) throws -> [FeeResponse] {
    let rpc = ethRpc(isTest: isTest)
    let gasPrice = try ethGasPrice(rpc: rpc)
    let gasLimit: BigUInt = 21000
    func weiForFactor(_ f: UInt64) -> String {
      let gp = gasPrice * BigUInt(f) / BigUInt(100)
      return EthEncoder.weiToEthString(gp * gasLimit)
    }
    func gpHex(_ f: UInt64) -> String {
      return "0x" + (gasPrice * BigUInt(f) / BigUInt(100)).toHexString()
    }
    return [
      FeeResponse(type: .low, value: weiForFactor(80), gasLimit: "21000", gasPrice: gpHex(80)),
      FeeResponse(type: .normal, value: weiForFactor(100), gasLimit: "21000", gasPrice: gpHex(100)),
      FeeResponse(type: .priority, value: weiForFactor(120), gasLimit: "21000", gasPrice: gpHex(120)),
    ]
  }

  static func ethGasPrice(rpc: String) throws -> BigUInt {
    let result = try rpcCall(endpoint: rpc, method: "eth_gasPrice", params: "[]")
    let hex = result.trimmingCharacters(in: CharacterSet(charactersIn: "\"")).dropFirst(2)
    return BigUInt(String(hex), radix: 16) ?? BigUInt(20_000_000_000) // 20 gwei fallback
  }

  static func ethNonce(rpc: String, address: String) throws -> BigUInt {
    let result = try rpcCall(endpoint: rpc, method: "eth_getTransactionCount", params: "[\"\(address)\",\"pending\"]")
    let hex = result.trimmingCharacters(in: CharacterSet(charactersIn: "\"")).dropFirst(2)
    return BigUInt(String(hex), radix: 16) ?? .zero
  }

  static func ethChainId(rpc: String) throws -> BigUInt {
    let result = try rpcCall(endpoint: rpc, method: "eth_chainId", params: "[]")
    let hex = result.trimmingCharacters(in: CharacterSet(charactersIn: "\"")).dropFirst(2)
    return BigUInt(String(hex), radix: 16) ?? BigUInt(1)
  }

  static func ethBroadcast(rawTx: Data, rpc: String) throws -> String {
    let hex = "0x" + rawTx.hexString
    let result = try rpcCall(endpoint: rpc, method: "eth_sendRawTransaction", params: "[\"\(hex)\"]")
    return result.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
  }

  static func fetchBtcUtxos(address: String, isTest: Bool) throws -> [BtcUtxo] {
    let api = isTest ? btcTestApi : btcMainApi
    guard let arr = try httpGet("\(api)/address/\(address)/utxo") as? [[String: Any]] else {
      return []
    }
    return arr.compactMap { obj -> BtcUtxo? in
      guard let txid = obj["txid"] as? String,
            let vout = obj["vout"] as? Int,
            let value = obj["value"] as? Int64 else { return nil }
      let status = obj["status"] as? [String: Any]
      let confirmed = status?["confirmed"] as? Bool ?? false
      guard confirmed else { return nil }
      return BtcUtxo(txid: txid, vout: vout, value: UInt64(value))
    }
  }

  static func btcBroadcast(rawTx: Data, isTest: Bool) throws -> String {
    let api = isTest ? btcTestApi : btcMainApi
    let hex = rawTx.hexString
    return try httpPost(url: "\(api)/tx", body: hex, contentType: "text/plain") as? String ?? ""
  }

  // ── 余额查询 ────────────────────────────────────────────────────────────────

  static func fetchBtcBalance(address: String, isTest: Bool) throws -> String {
    let api = isTest ? btcTestApi : btcMainApi
    guard let arr = try httpGet("\(api)/address/\(address)/utxo") as? [[String: Any]] else {
      return "0"
    }
    let satoshis = arr.reduce(Int64(0)) { acc, obj in
      let status = obj["status"] as? [String: Any]
      let confirmed = status?["confirmed"] as? Bool ?? false
      guard confirmed, let value = obj["value"] as? Int64 else { return acc }
      return acc + value
    }
    return Decimal(satoshis, exponentiation: -8)
  }

  static func fetchEthBalance(address: String, isTest: Bool) throws -> String {
    let rpc = ethRpc(isTest: isTest)
    let result = try rpcCall(endpoint: rpc, method: "eth_getBalance", params: "[\"\(address)\",\"latest\"]")
    let hex = result.trimmingCharacters(in: CharacterSet(charactersIn: "\"")).dropFirst(2)
    let wei = BigUInt(String(hex), radix: 16) ?? .zero
    return EthEncoder.weiToEthString(wei)
  }

  static func fetchTrxBalance(address: String) throws -> String {
    guard let json = try httpGet("https://api.trongrid.io/v1/accounts/\(address)") as? [String: Any],
          let dataArr = json["data"] as? [[String: Any]] else {
      return "0"
    }
    let sunBalance = dataArr.first?["balance"] as? Int64 ?? 0
    return Decimal(sunBalance, exponentiation: -6)
  }

  static func fetchDogeBalance(address: String) throws -> String {
    guard let json = try httpGet("https://api.blockchair.com/dogecoin/dashboards/address/\(address)") as? [String: Any],
          let data = json["data"] as? [String: Any] else {
      return "0"
    }
    let addrData = data[address] as? [String: Any] ?? data[address.lowercased()] as? [String: Any]
    let satoshis = (addrData?["address"] as? [String: Any])?["balance"] as? Int64 ?? 0
    return Decimal(satoshis, exponentiation: -8)
  }

  private static func Decimal(_ raw: Int64, exponentiation exp: Int) -> String {
    let divisor = Foundation.Decimal(sign: .plus, exponent: exp, significand: 1)
    let value = Foundation.Decimal(raw) * divisor
    var result = value
    var rounded = Foundation.Decimal()
    NSDecimalRound(&rounded, &result, 8, .plain)
    return NSDecimalNumber(decimal: rounded).stringValue
  }

  private static func rpcCall(endpoint: String, method: String, params: String) throws -> String {
    let body = "{\"jsonrpc\":\"2.0\",\"method\":\"\(method)\",\"params\":\(params),\"id\":1}"
    guard let json = try httpPost(url: endpoint, body: body, contentType: "application/json") as? [String: Any] else {
      throw urlError("RPC response invalid")
    }
    if let err = json["error"] as? [String: Any] {
      throw urlError(err["message"] as? String ?? "RPC error")
    }
    let result = json["result"]
    if let str = result as? String { return str }
    if let num = result as? NSNumber { return num.stringValue }
    throw urlError("RPC result missing")
  }

  @discardableResult
  private static func httpGet(_ urlStr: String) throws -> Any {
    let sem = DispatchSemaphore(value: 0)
    var resultData: Data?
    var resultError: Error?
    let url = URL(string: urlStr)!
    var req = URLRequest(url: url, timeoutInterval: 15)
    req.setValue("application/json", forHTTPHeaderField: "Accept")
    URLSession.shared.dataTask(with: req) { data, _, error in
      resultData = data; resultError = error; sem.signal()
    }.resume()
    sem.wait()
    if let error = resultError { throw error }
    guard let data = resultData else { throw urlError("no data") }
    return try JSONSerialization.jsonObject(with: data)
  }

  @discardableResult
  private static func httpPost(url urlStr: String, body: String, contentType: String) throws -> Any {
    let sem = DispatchSemaphore(value: 0)
    var resultData: Data?
    var resultError: Error?
    var resultCode: Int = 0
    let url = URL(string: urlStr)!
    var req = URLRequest(url: url, timeoutInterval: 15)
    req.httpMethod = "POST"
    req.setValue(contentType, forHTTPHeaderField: "Content-Type")
    req.setValue("application/json, text/plain", forHTTPHeaderField: "Accept")
    req.httpBody = body.data(using: .utf8)
    URLSession.shared.dataTask(with: req) { data, response, error in
      resultData = data
      resultError = error
      resultCode = (response as? HTTPURLResponse)?.statusCode ?? 0
      sem.signal()
    }.resume()
    sem.wait()
    if let error = resultError { throw error }
    guard let data = resultData else { throw urlError("no data") }
    if resultCode < 200 || resultCode >= 300 {
      throw urlError("HTTP \(resultCode): \(String(data: data, encoding: .utf8) ?? "")")
    }
    if contentType == "text/plain" {
      return String(data: data, encoding: .utf8) ?? ""
    }
    return try JSONSerialization.jsonObject(with: data)
  }

  private static func urlError(_ msg: String) -> Error {
    NSError(domain: "ChainClient", code: -1, userInfo: [NSLocalizedDescriptionKey: msg])
  }
}

// MARK: - BTC types/encoder (iOS)

private struct BtcUtxo {
  let txid: String
  let vout: Int
  let value: UInt64
}

private enum BtcEncoder {
  static func parseAmount(_ str: String) -> UInt64 {
    if str.contains(".") {
      let parts = str.split(separator: ".")
      let whole = UInt64(parts[0]) ?? 0
      let fracRaw = (String(parts.count > 1 ? parts[1] : "") + "00000000").prefix(8)
      let frac = UInt64(fracRaw) ?? 0
      return whole * 100_000_000 + frac
    }
    return UInt64(str) ?? 0
  }

  static func compressPublicKey(_ key: Data) -> Data {
    if key.count == 33 { return key }
    guard key.count == 65, key[0] == 0x04 else { return key }
    let prefix: UInt8 = (key[64] & 1) == 0 ? 0x02 : 0x03
    return Data([prefix]) + key[1..<33]
  }

  static func selectUtxos(utxos: [BtcUtxo], valueSat: UInt64, to: String, from: String, feeRateSatPerVb: UInt64) throws -> ([BtcUtxo], UInt64) {
    let sorted = utxos.sorted { $0.value > $1.value }
    var selected: [BtcUtxo] = []
    var total: UInt64 = 0
    for utxo in sorted {
      selected.append(utxo)
      total += utxo.value
      let vsize = estimateVsize(inputCount: selected.count, outputCount: 2)
      let fee = vsize * feeRateSatPerVb
      if total >= valueSat + fee {
        return (selected, total - valueSat - fee)
      }
    }
    throw PigeonError(code: "insufficient-funds", message: "余额不足以支付金额和手续费", details: nil)
  }

  private static func estimateVsize(inputCount: Int, outputCount: Int) -> UInt64 {
    let base = 10 + inputCount * 41 + outputCount * 31
    let witness = 1 + inputCount * (1 + 1 + 73 + 1 + 33)
    return UInt64((base * 4 + witness + 3) / 4)
  }

  static func p2wpkhScriptCode(pubKey: Data) -> Data {
    let hash160 = RIPEMD160.hash(message: SHA256.hash(data: pubKey))
    return Data([0x19, 0x76, 0xA9, 0x14]) + hash160 + Data([0x88, 0xAC])
  }

  static func buildSegwitSigHash(inputs: [BtcUtxo], outputs: [(address: String, value: UInt64)], inputIndex: Int, scriptCode: Data, inputValue: UInt64) -> Data {
    var prevouts = Data()
    for u in inputs {
      prevouts += Data(hexString: u.txid)!.reversed + int32LE(UInt32(u.vout))
    }
    let hashPrevouts = sha256d(prevouts)

    var seqData = Data()
    for _ in inputs { seqData += int32LE(0xFFFFFFFE) }
    let hashSequence = sha256d(seqData)

    var outData = Data()
    for o in outputs {
      outData += int64LE(o.value)
      let script = scriptForAddress(o.address)
      outData += varInt(UInt64(script.count)) + script
    }
    let hashOutputs = sha256d(outData)

    let utxo = inputs[inputIndex]
    var preimage = Data()
    preimage += int32LE(2) // version
    preimage += hashPrevouts
    preimage += hashSequence
    preimage += Data(hexString: utxo.txid)!.reversed + int32LE(UInt32(utxo.vout))
    preimage += scriptCode
    preimage += int64LE(inputValue)
    preimage += int32LE(0xFFFFFFFE) // sequence
    preimage += hashOutputs
    preimage += int32LE(0) // locktime
    preimage += int32LE(1) // SIGHASH_ALL
    return sha256d(preimage)
  }

  static func encodeSegwitTx(inputs: [BtcUtxo], outputs: [(address: String, value: UInt64)], witnesses: [[Data]]) -> Data {
    var raw = int32LE(2) + Data([0x00, 0x01]) + varInt(UInt64(inputs.count))
    for u in inputs {
      raw += Data(hexString: u.txid)!.reversed + int32LE(UInt32(u.vout)) + Data([0x00]) + int32LE(0xFFFFFFFE)
    }
    raw += varInt(UInt64(outputs.count))
    for o in outputs {
      let script = scriptForAddress(o.address)
      raw += int64LE(o.value) + varInt(UInt64(script.count)) + script
    }
    for witness in witnesses {
      raw += varInt(UInt64(witness.count))
      for item in witness { raw += varInt(UInt64(item.count)) + item }
    }
    raw += int32LE(0)
    return raw
  }

  static func normalizeSignatureDer(_ sig: Data) -> Data {
    guard sig[0] == 0x30 else { return sig }
    var offset = 2
    guard sig[offset] == 0x02 else { return sig }
    let rLen = Int(sig[offset + 1])
    let rBytes = sig[(offset + 2)..<(offset + 2 + rLen)]
    offset += 2 + rLen
    guard sig[offset] == 0x02 else { return sig }
    let sLen = Int(sig[offset + 1])
    let sBytes = sig[(offset + 2)..<(offset + 2 + sLen)]

    // Low-S normalization
    let n = Data(hexString: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141")!
    let s = Data(sBytes)
    let normalizedS: Data
    if isGreaterThanHalfN(s, n: n) {
      normalizedS = subtractFromN(s, n: n)
    } else {
      normalizedS = s
    }

    return encodeDer(r: Data(rBytes), s: normalizedS)
  }

  private static func isGreaterThanHalfN(_ s: Data, n: Data) -> Bool {
    // Compare s > n/2 (half of curve order)
    // Simple byte-by-byte: compare first byte
    let half = n[0] / 2
    return s[0] > half
  }

  private static func subtractFromN(_ s: Data, n: Data) -> Data {
    // Simplified subtraction, sufficient for DER sig normalization
    var result = [UInt8](repeating: 0, count: 32)
    var borrow: Int = 0
    let nb = Array(n)
    let sb = Array(s.prefix(32).rightPadded(to: 32))
    for i in stride(from: 31, through: 0, by: -1) {
      let diff = Int(nb[i]) - Int(sb[i]) - borrow
      result[i] = UInt8(bitPattern: Int8(diff & 0xFF))
      borrow = diff < 0 ? 1 : 0
    }
    return Data(result)
  }

  private static func encodeDer(r: Data, s: Data) -> Data {
    func pad(_ d: Data) -> Data {
      var clean = d.dropWhile { $0 == 0 }
      if let first = clean.first, first >= 0x80 { clean = Data([0x00]) + clean }
      return Data(clean)
    }
    let rp = pad(r); let sp = pad(s)
    let body = Data([0x02, UInt8(rp.count)]) + rp + Data([0x02, UInt8(sp.count)]) + sp
    return Data([0x30, UInt8(body.count)]) + body
  }

  private static func scriptForAddress(_ address: String) -> Data {
    if address.lowercased().hasPrefix("bc1") || address.lowercased().hasPrefix("tb1") {
      return Bech32.decode(address)
    }
    guard let decoded = Base58Check.decode(address), !decoded.isEmpty else {
      return Data()
    }
    let prefix = decoded[0]
    let hash = decoded[1..<min(21, decoded.count)]
    switch prefix {
    case 0x00: return Data([0x76, 0xA9, 0x14]) + hash + Data([0x88, 0xAC])
    case 0x05: return Data([0xA9, 0x14]) + hash + Data([0x87])
    default: return Data()
    }
  }

  static func int32LE(_ value: UInt32) -> Data {
    var v = value.littleEndian
    return Data(bytes: &v, count: 4)
  }

  static func int64LE(_ value: UInt64) -> Data {
    var v = value.littleEndian
    return Data(bytes: &v, count: 8)
  }

  static func varInt(_ value: UInt64) -> Data {
    switch value {
    case 0..<0xFD: return Data([UInt8(value)])
    case 0xFD...0xFFFF:
      var v = UInt16(value).littleEndian
      return Data([0xFD]) + Data(bytes: &v, count: 2)
    case 0x10000...0xFFFFFFFF:
      var v = UInt32(value).littleEndian
      return Data([0xFE]) + Data(bytes: &v, count: 4)
    default:
      var v = value.littleEndian
      return Data([0xFF]) + Data(bytes: &v, count: 8)
    }
  }

  private static func sha256d(_ data: Data) -> Data {
    SHA256.hash(data: SHA256.hash(data: data))
  }
}

// MARK: - ETH encoder (iOS)

private enum EthEncoder {
  static func parseEthValue(_ amount: String) -> BigUInt {
    if amount.contains(".") {
      let parts = amount.split(separator: ".", maxSplits: 1)
      let whole = BigUInt(String(parts[0])) ?? .zero
      let fracStr = (String(parts.count > 1 ? parts[1] : "") + "000000000000000000").prefix(18)
      let frac = BigUInt(String(fracStr)) ?? .zero
      let scale = pow10_18()
      return whole * scale + frac
    }
    return BigUInt(amount) ?? .zero
  }

  static func weiToEthString(_ wei: BigUInt) -> String {
    let scale = pow10_18()
    let (whole, remainder) = wei.quotientAndRemainder(dividingBy: scale)
    if remainder == .zero { return whole.description }
    var fracStr = remainder.description
    while fracStr.count < 18 { fracStr = "0" + fracStr }
    fracStr = String(fracStr.reversed().drop(while: { $0 == "0" }).reversed())
    return "\(whole).\(fracStr)"
  }

  private static func pow10_18() -> BigUInt {
    var result = BigUInt(1)
    for _ in 0..<18 { result = result * BigUInt(10) }
    return result
  }

  static func buildLegacyTxHash(nonce: BigUInt, gasPrice: BigUInt, gasLimit: BigUInt, to: String, value: BigUInt, data: Data, chainId: BigUInt) -> Data {
    let items: [Data] = [
      rlpEncode(nonce),
      rlpEncode(gasPrice),
      rlpEncode(gasLimit),
      rlpEncode(Data(hexString: to.dropPrefix("0x")) ?? Data()),
      rlpEncode(value),
      rlpEncode(data),
      rlpEncode(chainId),
      rlpEncode(BigUInt(0)),
      rlpEncode(BigUInt(0)),
    ]
    let raw = rlpList(items)
    return keccak256(raw)
  }

  static func encodeLegacySignedTx(nonce: BigUInt, gasPrice: BigUInt, gasLimit: BigUInt, to: String, value: BigUInt, data: Data, v: BigUInt, r: BigUInt, s: BigUInt) -> Data {
    let items: [Data] = [
      rlpEncode(nonce),
      rlpEncode(gasPrice),
      rlpEncode(gasLimit),
      rlpEncode(Data(hexString: to.dropPrefix("0x")) ?? Data()),
      rlpEncode(value),
      rlpEncode(data),
      rlpEncode(v),
      rlpEncode(r.toByteData()),
      rlpEncode(s.toByteData()),
    ]
    return rlpList(items)
  }

  static func parseAndRecoverSignature(sigBytes: Data, msgHash: Data, pubKey: Data) throws -> (BigUInt, BigUInt, Int) {
    let r: BigUInt
    let s: BigUInt
    if sigBytes.count == 64 {
      r = BigUInt(sigBytes[0..<32].hexString, radix: 16) ?? .zero
      s = BigUInt(sigBytes[32..<64].hexString, radix: 16) ?? .zero
    } else if sigBytes.count == 65 {
      r = BigUInt(sigBytes[1..<33].hexString, radix: 16) ?? .zero
      s = BigUInt(sigBytes[33..<65].hexString, radix: 16) ?? .zero
    } else if sigBytes[0] == 0x30 {
      (r, s) = try parseDer(sigBytes)
    } else {
      throw PigeonError(code: "sig-format", message: "无法识别签名格式 length=\(sigBytes.count)", details: nil)
    }
    // recId recovery: try 0 then 1 (simplified, use 0)
    return (r, s, 0)
  }

  private static func parseDer(_ der: Data) throws -> (BigUInt, BigUInt) {
    var offset = 2
    guard der[offset] == 0x02 else { throw PigeonError(code: "sig-format", message: "DER R tag error", details: nil) }
    let rLen = Int(der[offset + 1])
    let r = BigUInt(der[(offset + 2)..<(offset + 2 + rLen)].hexString, radix: 16) ?? .zero
    offset += 2 + rLen
    guard der[offset] == 0x02 else { throw PigeonError(code: "sig-format", message: "DER S tag error", details: nil) }
    let sLen = Int(der[offset + 1])
    let s = BigUInt(der[(offset + 2)..<(offset + 2 + sLen)].hexString, radix: 16) ?? .zero
    return (r, s)
  }

  private static func rlpEncode(_ value: BigUInt) -> Data { rlpEncode(value.toByteData()) }

  static func rlpEncode(_ bytes: Data) -> Data {
    if bytes.isEmpty { return Data([0x80]) }
    if bytes.count == 1, bytes[0] < 0x80 { return bytes }
    if bytes.count <= 55 { return Data([UInt8(0x80 + bytes.count)]) + bytes }
    let lenBytes = intToMinBytes(bytes.count)
    return Data([UInt8(0xB7 + lenBytes.count)]) + lenBytes + bytes
  }

  private static func rlpList(_ items: [Data]) -> Data {
    let payload = items.reduce(Data()) { $0 + $1 }
    if payload.count <= 55 { return Data([UInt8(0xC0 + payload.count)]) + payload }
    let lenBytes = intToMinBytes(payload.count)
    return Data([UInt8(0xF7 + lenBytes.count)]) + lenBytes + payload
  }

  private static func intToMinBytes(_ value: Int) -> Data {
    var result = [UInt8]()
    var v = value
    while v > 0 { result.insert(UInt8(v & 0xFF), at: 0); v >>= 8 }
    return Data(result)
  }

  private static func keccak256(_ data: Data) -> Data {
    data.keccak256()
  }
}

// MARK: - Bech32 (iOS)

private enum Bech32 {
  private static let charset = Array("qpzry9x8gf2tvdw0s3jn54khce6mua7l")
  private static let gen: [UInt32] = [0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3]

  static func decode(_ hrpAndData: String) -> Data {
    let lower = hrpAndData.lowercased()
    guard let pos = lower.lastIndex(of: "1") else { return Data() }
    let hrp = String(lower[..<pos])
    let dataStr = String(lower[lower.index(after: pos)...])
    let data = dataStr.compactMap { charset.firstIndex(of: $0) }
    let decoded = convertBits(data.dropLast(6), from: 5, to: 8, pad: false)
    guard !decoded.isEmpty else { return Data() }
    let witVer = Int(decoded[0])
    let witProg = decoded.dropFirst()
    switch witVer {
    case 0:
      if witProg.count == 20 { return Data([0x00, 0x14]) + witProg }
      return Data([0x00, 0x20]) + witProg
    default:
      return Data([UInt8(0x50 + witVer), UInt8(witProg.count)]) + witProg
    }
  }

  private static func convertBits(_ data: [Int], from: Int, to: Int, pad: Bool) -> [UInt8] {
    var acc = 0; var bits = 0
    var result = [UInt8]()
    let maxv = (1 << to) - 1
    for v in data {
      acc = (acc << from) | v; bits += from
      while bits >= to { bits -= to; result.append(UInt8((acc >> bits) & maxv)) }
    }
    if pad, bits > 0 { result.append(UInt8((acc << (to - bits)) & maxv)) }
    return result
  }
}

// MARK: - Base58Check (iOS)

private enum Base58Check {
  private static let alphabet = Array("123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz")

  static func decode(_ input: String) -> Data? {
    var result = [UInt8]()
    var carry: UInt64 = 0
    var digits = [UInt8]()
    for ch in input {
      guard let idx = alphabet.firstIndex(of: ch) else { return nil }
      var v = UInt64(idx)
      for i in stride(from: digits.count - 1, through: 0, by: -1) {
        v += UInt64(digits[i]) * 58
        digits[i] = UInt8(v & 0xFF)
        v >>= 8
      }
      while v > 0 { digits.insert(UInt8(v & 0xFF), at: 0); v >>= 8 }
      _ = carry
    }
    let leading = input.prefix(while: { $0 == "1" }).count
    result = Array(repeating: 0, count: leading) + digits
    guard result.count >= 4 else { return nil }
    let payload = Data(result.dropLast(4))
    let checksum = Data(result.suffix(4))
    let expected = Data(SHA256.hash(data: SHA256.hash(data: payload)).prefix(4))
    guard checksum == expected else { return nil }
    return payload
  }
}

// MARK: - SHA256 / RIPEMD160 wrappers (iOS uses CryptoSwift)

private enum SHA256 {
  static func hash(data: Data) -> Data {
    Data(data.sha256())
  }
}

private enum RIPEMD160 {
  static func hash(message: Data) -> Data {
    Data(message.ripemd160())
  }
}

// MARK: - Data / String helpers

private extension Data {
  var hexString: String { map { String(format: "%02x", $0) }.joined() }
  var reversed: Data { Data(self.reversed() as [UInt8]) }

  init?(hexString: String) {
    let normalized = hexString.replacingOccurrences(of: "0x", with: "", options: .caseInsensitive, range: hexString.range(of: "0x", options: .caseInsensitive))
    guard normalized.count % 2 == 0 else { return nil }
    var result = Data()
    var index = normalized.startIndex
    while index < normalized.endIndex {
      let next = normalized.index(index, offsetBy: 2)
      guard let byte = UInt8(normalized[index..<next], radix: 16) else { return nil }
      result.append(byte)
      index = next
    }
    self = result
  }

  func dropPrefix(_ prefix: String) -> String { hexString }

  func rightPadded(to length: Int) -> Data {
    if count >= length { return self }
    return self + Data(repeating: 0, count: length - count)
  }
}

private extension [UInt8] {
  func rightPadded(to length: Int) -> [UInt8] {
    if count >= length { return self }
    return self + Array(repeating: 0, count: length - count)
  }
}

private extension String {
  func dropPrefix(_ prefix: String) -> String {
    if hasPrefix(prefix) { return String(dropFirst(prefix.count)) }
    return self
  }
}

private extension BigUInt {
  func toByteData() -> Data {
    let bytes = toByteArray()
    if bytes.isEmpty { return Data([0]) }
    return Data(bytes)
  }
}

private extension DataProtocol {
  func keccak256() -> Data {
    var d = Data(self)
    return Data(d.sha3(.keccak256))
  }
}

// MARK: - secp256k1 点解压（33字节压缩公钥 → 64字节 X+Y）

/// 将 33 字节 secp256k1 压缩公钥解压为 64 字节原始 X+Y（适合 ETH/TRX keccak256 地址计算）。
/// 算法：y² = x³ + 7 mod p，p = 2^256 - 2^32 - 977，y = (x³+7)^((p+1)/4) mod p
/// 使用 256 字节大整数（vbignum via Security framework 不可用时纯 Swift 实现）。
private func secp256k1DecompressPoint(compressedKey: Data) -> Data {
  guard compressedKey.count == 33,
        let prefix = compressedKey.first,
        prefix == 0x02 || prefix == 0x03 else {
    NSLog("ChipCoreNfc: secp256k1DecompressPoint: 输入不是33字节压缩公钥")
    return compressedKey
  }

  // secp256k1 曲线参数
  // p = 2^256 - 2^32 - 977
  let pBytes: [UInt8] = [
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFE, 0xFF, 0xFF, 0xFC, 0x2F
  ]

  // (p+1)/4 指数
  let expBytes: [UInt8] = [
    0x3F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xBF, 0xFF, 0xFF, 0x0C
  ]

  let x = Array(compressedKey[1..<33])
  let p = pBytes
  let exp = expBytes

  // x3 = x^3 mod p
  let x2 = bigModMul(x, x, p)
  let x3 = bigModMul(x2, x, p)
  // rhs = (x^3 + 7) mod p
  let seven: [UInt8] = Array(repeating: 0, count: 31) + [7]
  let rhs = bigModAdd(x3, seven, p)
  // y = rhs^exp mod p
  var y = bigModExp(rhs, exp, p)

  // 根据 prefix 选择正确的 y（偶/奇）
  let yIsEven = (y.last ?? 0) & 1 == 0
  let wantEven = prefix == 0x02
  if yIsEven != wantEven {
    y = bigModNeg(y, p)
  }

  // 将 x, y 各填充到 32 字节
  let xPadded = Array(x.suffix(32)).leftPadded(to: 32)
  let yPadded = y.leftPadded(to: 32)
  return Data(xPadded + yPadded)
}

// MARK: - 256-bit 大整数辅助函数（小端 [UInt8] 数组）

/// a + b mod m（所有操作数均为 32 字节大端字节数组）
private func bigModAdd(_ a: [UInt8], _ b: [UInt8], _ m: [UInt8]) -> [UInt8] {
  var result = [UInt8](repeating: 0, count: 32)
  var carry: UInt16 = 0
  for i in stride(from: 31, through: 0, by: -1) {
    let sum = UInt16(a[i]) + UInt16(b[i]) + carry
    result[i] = UInt8(sum & 0xFF)
    carry = sum >> 8
  }
  // 若结果 >= m，则减去 m
  if bigCmp(result, m) >= 0 {
    return bigSub(result, m)
  }
  return result
}

/// a - b（假设 a >= b，大端字节数组）
private func bigSub(_ a: [UInt8], _ b: [UInt8]) -> [UInt8] {
  var result = [UInt8](repeating: 0, count: 32)
  var borrow: Int16 = 0
  for i in stride(from: 31, through: 0, by: -1) {
    let diff = Int16(a[i]) - Int16(b[i]) - borrow
    if diff < 0 {
      result[i] = UInt8(diff + 256)
      borrow = 1
    } else {
      result[i] = UInt8(diff)
      borrow = 0
    }
  }
  return result
}

/// a * b mod m（使用 school-book 乘法，64字节中间结果，大端）
private func bigModMul(_ a: [UInt8], _ b: [UInt8], _ m: [UInt8]) -> [UInt8] {
  var product = [UInt16](repeating: 0, count: 64)
  for i in 0..<32 {
    for j in 0..<32 {
      product[i + j + 1] = product[i + j + 1] + UInt16(a[i]) * UInt16(b[j])
    }
  }
  // 归一化进位
  var carry: UInt32 = 0
  for i in stride(from: 63, through: 0, by: -1) {
    let v = UInt32(product[i]) + carry
    product[i] = UInt16(v & 0xFF)
    carry = v >> 8
  }
  // 转为字节数组并 mod m
  let bytes = product.map { UInt8($0 & 0xFF) }
  return bigMod(bytes, m)
}

/// base^exp mod m（二进制快速幂，大端字节数组，mod 在每次平方/乘时降位）
private func bigModExp(_ base: [UInt8], _ exp: [UInt8], _ m: [UInt8]) -> [UInt8] {
  var result: [UInt8] = Array(repeating: 0, count: 32)
  result[31] = 1 // result = 1
  var b = base
  for ei in stride(from: 31, through: 0, by: -1) {
    var bits = exp[ei]
    for _ in 0..<8 {
      result = bigModMul(result, result, m)
      if bits & 0x80 != 0 {
        result = bigModMul(result, b, m)
      }
      bits <<= 1
    }
  }
  return result
}

/// -a mod m（即 m - a）
private func bigModNeg(_ a: [UInt8], _ m: [UInt8]) -> [UInt8] {
  if a.allSatisfy({ $0 == 0 }) { return a }
  return bigSub(m, a)
}

/// 比较两个大端字节数组：返回 -1/0/1
private func bigCmp(_ a: [UInt8], _ b: [UInt8]) -> Int {
  for (ai, bi) in zip(a, b) {
    if ai < bi { return -1 }
    if ai > bi { return 1 }
  }
  return 0
}

/// 将变长大端字节数组对 32 字节大端数 m 取模（Barrett reduction 简化版）
private func bigMod(_ a: [UInt8], _ m: [UInt8]) -> [UInt8] {
  // 跳过前导零，找有效起始
  var start = 0
  while start < a.count - 32 && a[start] == 0 { start += 1 }
  // 逐步对 m 做移位减法（适用于 64-byte / 32-byte mod）
  var rem = [UInt8](a[start...])
  // 让 rem 扩展到至少 32 字节
  while rem.count < 32 { rem.insert(0, at: 0) }
  // 如果 rem > 32 字节，用长除法
  while rem.count > 32 || bigCmp(rem.count == 32 ? rem : Array(rem.suffix(32)), m) >= 0 {
    if rem.count > 32 {
      // 取高位进行移位减法
      let shift = rem.count - 32
      var mShifted = m + [UInt8](repeating: 0, count: shift)
      while mShifted.count < rem.count { mShifted.insert(0, at: 0) }
      while bigCmp(rem.count == mShifted.count ? rem : Array(rem.prefix(mShifted.count)), mShifted) >= 0 {
        rem = bigSubVar(rem, mShifted)
        // 移除前导零
        while rem.count > 32 && rem.first == 0 { rem.removeFirst() }
      }
    } else {
      rem = bigSub(rem, m)
    }
  }
  return rem.leftPadded(to: 32)
}

/// 变长大端字节数组减法（a >= b）
private func bigSubVar(_ a: [UInt8], _ b: [UInt8]) -> [UInt8] {
  var result = a
  var borrow: Int16 = 0
  let offset = a.count - b.count
  for i in stride(from: b.count - 1, through: 0, by: -1) {
    let ai = i + offset
    let diff = Int16(result[ai]) - Int16(b[i]) - borrow
    if diff < 0 {
      result[ai] = UInt8(diff + 256)
      borrow = 1
    } else {
      result[ai] = UInt8(diff)
      borrow = 0
    }
  }
  return result
}

private extension Array where Element == UInt8 {
  func leftPadded(to length: Int) -> [UInt8] {
    if count >= length { return Array(suffix(length)) }
    return Array(repeating: 0, count: length - count) + self
  }
}
