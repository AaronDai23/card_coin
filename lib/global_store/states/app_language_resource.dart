class AppLanguageResource {
  late final Map<String, dynamic> _messages;

  AppLanguageResource(Map<String, dynamic> messages) : _messages = messages;

  String notNullString(String? text, [String replaceText = 'undefined']) {
    if (text == null) return replaceText;
    return text;
  }

  String textWithArgument(String? text, List<String> args) {
    String content = notNullString(text);
    for (int i = 0; i < args.length; i++) {
      String replaceText = '{$i}';
      content = content.replaceFirst(replaceText, args[i]);
    }
    return content;
  }

  String get appVersion =>
      notNullString(_messages['client.appVersion'], 'Version Information');

  String get currentVersion =>
      notNullString(_messages['client.currentVersion'], 'Current version');

  String get language =>
      notNullString(_messages['client.language'], 'language');

  String get loading => notNullString(_messages['client.loading'], 'Loading…');

  String get loadFailure =>
      notNullString(_messages['client.loadFailure'], 'Load failure');

  String get rescan => notNullString(_messages['client.rescan'], 'Rescan');

  String get addBlockchain =>
      notNullString(_messages['client.addBlockchain'], 'Add Blockchain');

  String get deleteCurrencyTip => notNullString(
      _messages['client.deleteCurrencyTip'],
      'Make sure you want to delete this currency?');

  String get cancel => notNullString(_messages['client.cancel'], 'Cancel');

  String get confirm => notNullString(_messages['client.confirm'], 'Confirm');

  String get disableNfc => notNullString(_messages['client.disableNfc'],
      'The NFC function of the mobile phone is disabled.');

  String get recharge =>
      notNullString(_messages['client.recharge'], 'Recharge');

  String get withdraw =>
      notNullString(_messages['client.withdraw'], 'Withdraw');

  String get bugCoin => notNullString(_messages['client.bugCoin'], 'Buy Coin');

  String get transactionRecord => notNullString(
      _messages['client.transactionRecord'], 'Transaction record');

  String get rechargeAddress =>
      notNullString(_messages['client.rechargeAddress'], 'Recharge Address');

  String get copySuccess =>
      notNullString(_messages['client.copySuccess'], 'Copied successful!');

  String get saveQR =>
      notNullString(_messages['client.saveQR'], 'Save QR code to album');

  String get sendAddress =>
      notNullString(_messages['client.sendAddress'], 'Send Address');

  String get sendQuantity =>
      notNullString(_messages['client.sendQuantity'], 'Send Quantity');

  String get inputAddressTip => notNullString(
      _messages['client.inputAddressTip'],
      'Input or hold press to paste address');

  String get invalidAddress =>
      notNullString(_messages['client.invalidAddress'], 'Invalid address');

  String get availableAmount => notNullString(
      _messages['client.availableAmount'], 'Current Available Amount:');

  String get inputQuantityTip => notNullString(
      _messages['client.inputQuantityTip'], 'Enter withdrawal quantity');

  String get all => notNullString(_messages['client.all'], 'ALL');

  String get send => notNullString(_messages['client.send'], 'Send');

  String get sendOut => notNullString(_messages['client.sendOut'], 'Send Out');

  String get receive => notNullString(_messages['client.receive'], 'Receive');

  String get transactionFee =>
      notNullString(_messages['client.transactionFee'], 'Transaction Fee');

  String get confirmed =>
      notNullString(_messages['client.confirmed'], 'Confirmed');

  String get unconfirmed =>
      notNullString(_messages['client.unconfirmed'], 'Unconfirmed');

  String get sendTransactionFailed => notNullString(
      _messages['client.sendTransactionFailed'], 'Send transaction failed');

  String get sentSuccessfully =>
      notNullString(_messages['client.sentSuccessfully'], 'Sent successfully');

  String get inputPinCode => notNullString(
      _messages['client.inputPinCode'], 'Please enter the PIN Code');

  String get inputAmountTip =>
      notNullString(_messages['client.inputAmountTip'], 'Please input amount');

  String get lackBalance =>
      notNullString(_messages['client.lackBalance'], 'Lack of balance');

  String get scanCard =>
      notNullString(_messages['client.scanCard'], 'Scan Card');

  String get homeWelcomeTips =>
      notNullString(_messages['client.homeWelcomeTips'], 'Welcome to AirChip3');

  String get homeSubTips => notNullString(_messages['client.homeSubTips'],
      'The safest way to buy,use and store cryptocurrency');

  String get biometricVerification => notNullString(
      _messages['client.biometricVerification'], 'Biometric verification');

  String get vaultUnlocking =>
      notNullString(_messages['client.vaultUnlocking'], 'Vault unlocking');

  String get verifyIdentity =>
      notNullString(_messages['client.verifyIdentity'], 'Verify identity');

  String get unlockVerify => notNullString(
      _messages['client.unlockVerify'], 'Unlock with fingerprint');

  String get myWallet =>
      notNullString(_messages['client.myWallet'], 'My wallet');

  String get addNewWallet =>
      notNullString(_messages['client.addNewWallet'], 'Add new wallet');

  String get setPinCode =>
      notNullString(_messages['client.setPinCode'], 'Set PIN code');

  String get unlockPinCode =>
      notNullString(_messages['client.unlockPinCode'], 'Unlock PIN code');

  String get deviceSetting =>
      notNullString(_messages['client.deviceSetting'], 'Device setting');

  String get backUp => notNullString(_messages['client.backUp'], 'Back up');

  String get addressBook =>
      notNullString(_messages['client.addressBook'], 'Address Book');

  String get addAddressBook =>
      notNullString(_messages['client.addAddressBook'], 'Add Address Book');

  String get editAddressBook =>
      notNullString(_messages['client.editAddressBook'], 'Edit Address Book');

  String get deviceWrite =>
      notNullString(_messages['client.deviceWrite'], 'Device write');

  String get readyToScan =>
      notNullString(_messages['client.readyToScan'], 'Ready to scan');

  String get scanTips => notNullString(_messages['client.scanTips'],
      'Hold your card to the upper back of your phone to activate it.Hold the card there until a success popup appears!');

  String get pinCode => notNullString(_messages['client.pinCode'], 'PIN code');

  String get notSet => notNullString(_messages['client.notSet'], 'Not set');

  String get createPin =>
      notNullString(_messages['client.createPin'], 'Create PIN');

  String get getReady =>
      notNullString(_messages['client.getReady'], 'Get your device ready!');

  String get getReadyTips => notNullString(_messages['client.getReadyTips'],
      "Scan the card to change its settings.The changes will impact only the card you've scanned and will not affect other cards tied to your wallet.");

  String get cardId => notNullString(_messages['client.cardId'], 'Card ID');

  String get version => notNullString(_messages['client.version'], 'Version');

  String get resetFactory =>
      notNullString(_messages['client.resetFactory'], 'Reset Factory Settings');

  String get resetFactoryTips => notNullString(
      _messages['client.resetFactoryTips'],
      'Factory Reset will completely delete the wallet from the selected card and remove it from the app.You will not be able to restore the current wallet.');

  String get attention =>
      notNullString(_messages['client.attention'], 'Attention');

  String get agreeTips => notNullString(_messages['client.agreeTips'],
      'I understand that after performing this action,I will no longer have access to the current wallet');

  String get resetDevice =>
      notNullString(_messages['client.resetDevice'], 'Reset the device');

  String get longTap => notNullString(_messages['client.longTap'], 'Long tap');

  String get longTapTips => notNullString(_messages['client.longTapTips'],
      'To ensure security please hold the card until the operation complete.');

  String get resetSuccess =>
      notNullString(_messages['client.resetSuccess'], 'Reset successful');

  String get activationDevice =>
      notNullString(_messages['client.activationDevice'], 'Activating device');

  String get createWallet =>
      notNullString(_messages['client.createWallet'], 'Create a wallet');

  String get createWalletTips => notNullString(
      _messages['client.createWalletTips'],
      "let's generate all the keys on your device and create a secure wallet");

  String get nullList =>
      notNullString(_messages['client.nullList'], 'Null list');

  String get add => notNullString(_messages['client.add'], 'Add');

  String get added => notNullString(_messages['client.added'], 'Added');

  String get titleName => notNullString(_messages['client.titleName'], 'Name:');

  String get titleWalletAddress =>
      notNullString(_messages['client.titleWalletAddress'], 'Wallet address:');

  String get titleRemarks =>
      notNullString(_messages['client.titleRemarks'], 'Remarks:');

  String get createBackup =>
      notNullString(_messages['client.createBackup'], 'Creating a backup');

  String get prepareDevice =>
      notNullString(_messages['client.prepareDevice'], 'Prepare your device');

  String get preparePrimaryDevice => notNullString(
      _messages['client.preparePrimaryDevice'], 'Prepare your primary device');

  String get scanPrimaryCard =>
      notNullString(_messages['client.scanPrimaryCard'], 'Scan primary card');

  String get setPinTips => notNullString(
      _messages['client.setPinTips'], 'Have no set pin for the card!');

  String get setSuccessful =>
      notNullString(_messages['client.setSuccessful'], 'Set successful!');

  String getPukCodeTips(String pukCode) => textWithArgument(
      _messages['client.getPukCodeTips'] ?? 'PUK Code:{0}', [pukCode]);

  String get getPukCodeTips2 => notNullString(
      _messages['client.getPukCodeTips2'],
      'When the password is entered incorrectly 5 times, the device will be locked, and the PUK code is required to unlock it; after the PUK is entered incorrectly 3 times, the device will be unusable, please remember!');

  String getPinCodeTips(int count) => textWithArgument(
      _messages['client.getPinCodeTips'] ??
          '({0} input opportunities left) Already set',
      [count.toString()]);

  String get cancelPin =>
      notNullString(_messages['client.cancelPin'], 'Cancel PIN');

  String get updatePin =>
      notNullString(_messages['client.updatePin'], 'Update PIN');

  String get titleNewPinCode =>
      notNullString(_messages['client.titleNewPinCode'], 'New PIN code:');

  String get titlePinCode =>
      notNullString(_messages['client.titlePinCode'], 'PIN code:');

  String get inputNewPinCode =>
      notNullString(_messages['client.inputNewPinCode'], 'Input new PIN code');

  String get initWallet =>
      notNullString(_messages['client.initWallet'], 'Initializing wallet...');

  String get copyPuk => notNullString(_messages['client.copyPuk'], 'Copy PUK');

  String get inputPukCode => notNullString(
      _messages['client.inputPukCode'], 'input 8 length puk code');

  String get titlePukCode =>
      notNullString(_messages['client.titlePukCode'], 'PUK Code:');

  String get inputErrorPukCode => notNullString(
      _messages['client.inputErrorPukCode'],
      'The Puk code format is incorrect and contains 8 characters');

  String get incorrectPukCode => notNullString(
      _messages['client.incorrectPukCode'], 'The PUK Code is incorrect');

  String get unlockSuccess =>
      notNullString(_messages['client.unlockSuccess'], 'Unlocking succeeded');

  String get inputPinAndPuk => notNullString(
      _messages['client.inputPinAndPuk'], 'Please input PIN code and PUK code');

  String get settings =>
      notNullString(_messages['client.settings'], 'Settings');

  String get sameDeviceTips => notNullString(_messages['client.sameDeviceTips'],
      'You have used a card from another wallet.Tap the card associated with this wallet.');

  String get notSetPinCode => notNullString(
      _messages['client.notSetPinCode'], 'Have no set pin for the card!');

  String get backUpSuccess =>
      notNullString(_messages['client.backUpSuccess'], 'Back up success!');

  String get noBackUpDevice =>
      notNullString(_messages['client.noBackUpDevice'], 'No backup cards');

  String get backUpTip => notNullString(_messages['client.backUpTip'],
      'To start the backup process add up to two backup cards.');

  String get addBackUpDevice =>
      notNullString(_messages['client.addBackUpDevice'], 'Add a backup card');

  String getDeleteAddressTips(String name) => textWithArgument(
      _messages['client.getDeleteAddressTips'] ?? '是否删除 [{0}]?', [name]);

  String get save => notNullString(_messages['client.save'], 'Save');

  String get pleaseInput =>
      notNullString(_messages['client.pleaseInput'], 'Please input...');

  String get walletNickNameTitle =>
      notNullString(_messages['client.walletNickNameTitle'], '钱包别名:');

  String get walletNickName =>
      notNullString(_messages['client.walletNickName'], '钱包别名');

  String get nickName => notNullString(_messages['client.nickName'], '别名:');

  String get changeWalletNickNameTip => notNullString(
      _messages['client.changeWalletNickNameTip'], '可以给钱包起个别名，方便记忆');

  String get pleaseInputWalletNickName =>
      notNullString(_messages['client.pleaseInputWalletNickName'], '请输入别名');

  String get nickNameEmptyTip =>
      notNullString(_messages['client.nickNameEmptyTip'], '别名不能为空');

  String get removeWalletTitle =>
      notNullString(_messages['client.removeWalletTitle'], '确定移除此钱包?');

  String get removeWalletScuccess =>
      notNullString(_messages['client.removeWalletScuccess'], '移除钱包成功');

  String get isSaveChangeBlocksTip => notNullString(
      _messages['client.isSaveChangeBlocksTip'], '币种已发生变化，是否保存改动?');

  String get changeFialt =>
      notNullString(_messages['client.changeFialt'], 'App Currency');

  String get upgradeNow =>
      notNullString(_messages['client.upgradeNow'], 'Upgrade now');

  String get versionAvailable => notNullString(
      _messages['client.versionAvailable'], 'New version available');

  String get scanCardFailed =>
      notNullString(_messages['client.scanCardFailed'], 'Scan card failed');

  String get unlockFailureError => notNullString(
      _messages['client.unlockFailureError'], 'Unlock failure error');

  String get notSetNetworkLink => notNullString(
      _messages['client.notSetNetworkLink'], 'error!not set network link!');

  String get userCancel =>
      notNullString(_messages['client.userCancel'], 'User cancel');

  String get nfcWritingCard =>
      notNullString(_messages['client.nfcWritingCard'], ' NFC writing card');

  String get createUri =>
      notNullString(_messages['client.createUri'], 'Create Uri');

  String get write => notNullString(_messages['client.write'], 'Write');

  String get read => notNullString(_messages['client.read'], 'Read');

  String get addressNameEmpty =>
      notNullString(_messages['client.addressNameEmpty'], '未填写名称');

  String get addressEmpty =>
      notNullString(_messages['client.addressEmpty'], '未填写钱包地址');

  String get totalBalance =>
      notNullString(_messages['client.totalBalance'], 'Total Balance');

  String get totalFiatBalance =>
      notNullString(_messages['client.totalFiatBalance'], 'Total Fiat Balance');

  String get verifyCardFail =>
      notNullString(_messages['client.verifyCardFail'], '验证设备失败，可能是伪造的设备');

  String get transactionDetail => notNullString(
      _messages['client.transactionDetail'], 'transaction detail');

  String get savechanges =>
      notNullString(_messages['client.savechanges'], 'Save changes');

  String get notrechargeSend => notNullString(
      _messages['client.notrechargeSend'],
      'Network issue, this currency currently does not support coin recharge and withdrawal operations');

  String get scanCarInitialization => notNullString(
      _messages['client.scanCarInitialization'],
      'There is currency in the wallet, please scan the card for initialization');

  String get activationCard =>
      notNullString(_messages['client.activationCard'], 'Activating card');

  String get selectSendNet => notNullString(
      _messages['client.selectSendNet'], 'please select send network');

  String get sendNetAbnoraml => notNullString(
      _messages['client.sendNetAbnoraml'],
      'This network currently does not support coin withdrawals');

  String get slecetCoinInPro => notNullString(
      _messages['client.slecetCoinInPro'],
      'This feature requires downloading the Pro version to experience');

  String get receivedQuantity =>
      notNullString(_messages['client.receivedQuantity'], 'Received quantity');

  String get sendNetwork =>
      notNullString(_messages['client.sendNetwork'], 'Send Netwrok');

  String get sendFee => notNullString(_messages['client.sendFee'], 'Send fee');

  String get sendConfirm =>
      notNullString(_messages['client.sendConfirm'], 'Send Confirm');

  String get sendQuantityEmpty => notNullString(
      _messages['client.sendQuantityEmpty'], 'send quantity can\'t be empty');

  String get qrCodeError =>
      notNullString(_messages['client.qrCodeError'], 'Incorrect QR code');

  String get ablumn => notNullString(_messages['client.ablumn'], 'Photo album');

  String get accountVerify =>
      notNullString(_messages['client.accountVerify'], 'Account verification');

  String get addCard =>
      notNullString(_messages['client.addCard'], 'Add a card');

  String get addMemberCard =>
      notNullString(_messages['client.addMemberCard'], 'Add member card');

  String get addNewLink =>
      notNullString(_messages['client.addNewLink'], 'Add new link');

  String get addSuccess =>
      notNullString(_messages['client.addSuccess'], 'Added successfully');

  String get agreeAndRegister => notNullString(
      _messages['client.agreeAndRegister'],
      'Agree to the agreement and register');

  String get agreed =>
      notNullString(_messages['client.agreed'], 'I have read and agree');

  String get alreadyBind => notNullString(
      _messages['client.alreadyBind'], 'User device already bind');

  String get and => notNullString(_messages['client.and'], 'and');

  String get bgImage =>
      notNullString(_messages['client.bgImage'], 'Background image');

  String get bind => notNullString(_messages['client.bind'], 'Bind');

  String get bindEmail =>
      notNullString(_messages['client.bindEmail'], 'Bind email');

  String get bindPhone =>
      notNullString(_messages['client.bindPhone'], 'Bind phone');

  String get bindSuccess =>
      notNullString(_messages['client.bindSuccess'], 'Binding success');

  String get bonusRank =>
      notNullString(_messages['client.bonusRank'], 'Bonus Rank');

  String get cancelAccountTip => notNullString(
      _messages['client.cancelAccountTip'],
      'After the account is cancelled, the data related to the account cannot be retrieved. Are you sure you want to perform this operation?');

  String get cancelEmailSend => notNullString(
      _messages['client.cancelEmailSend'], 'Mail has been canceled');

  String get cancelPinCode =>
      notNullString(_messages['client.cancelPinCode'], 'Cancel PIN code');

  String get cancellationAccount => notNullString(
      _messages['client.cancellationAccount'], 'Account cancellation');

  String get cardAddTips =>
      notNullString(_messages['client.cardAddTips'], '该卡片不存在密匙, 请先添加');

  String get cardBrand => notNullString(_messages['client.cardBrand'], 'Brand');

  String get cardDomain =>
      notNullString(_messages['client.cardDomain'], 'domain:');

  String get cardHolder =>
      notNullString(_messages['client.cardHolder'], 'Card Holder');

  String get cardInfo =>
      notNullString(_messages['client.cardInfo'], 'Card Info');

  String get cardManager =>
      notNullString(_messages['client.cardManager'], 'Smart Card Management');

  String get cardName =>
      notNullString(_messages['client.cardName'], 'Card name');

  String get cardNo => notNullString(_messages['client.cardNo'], 'Card number');

  String get cardNoUnset =>
      notNullString(_messages['client.cardNoUnset'], '未设置卡号');

  String get cardPinCodeTips =>
      notNullString(_messages['client.cardPinCodeTips'], '该卡片未设置PIN, 请先设置');

  String get cardResetTips =>
      notNullString(_messages['client.cardResetTips'], '该卡片未重置或存在密匙, 请先重置');

  String get changeLanguage =>
      notNullString(_messages['client.changeLanguage'], 'Change Language');

  String get changeRegister =>
      notNullString(_messages['client.changeRegister'], 'Switch Sign Up');

  String get changeVerify => notNullString(
      _messages['client.changeVerify'], 'Change verification method');

  String get clickLogin =>
      notNullString(_messages['client.clickLogin'], 'Click to Login');

  String get clickUpload =>
      notNullString(_messages['client.clickUpload'], 'Click to upload');

  String get companyName =>
      notNullString(_messages['client.companyName'], 'Company Name');

  String get confirmDelete =>
      notNullString(_messages['client.confirmDelete'], 'Confirm to delete?');

  String get conySuccess =>
      notNullString(_messages['client.conySuccess'], 'Copy success');

  String get copy => notNullString(_messages['client.copy'], 'Copy');

  String get createExternal =>
      notNullString(_messages['client.createExternal'], 'Create External');

  String get currentAmount =>
      notNullString(_messages['client.currentAmount'], 'Current balance');

  String get currentEmail =>
      notNullString(_messages['client.currentEmail'], 'Current email:');

  String get currentLevel =>
      notNullString(_messages['client.currentLevel'], 'Current level');

  String get cutPhoneFailure => notNullString(
      _messages['client.cutPhoneFailure'], 'Failed to crop avatar');

  String get dataSource =>
      notNullString(_messages['client.dataSource'], 'Data source:');

  String get delete => notNullString(_messages['client.delete'], 'Delete');

  String get deleteCard =>
      notNullString(_messages['client.deleteCard'], 'Delete card');

  String get deleteMsgTip => notNullString(_messages['client.deleteMsgTip'],
      'Are you sure you want to delete the selected messages?');

  String get deleteSuccess =>
      notNullString(_messages['client.deleteSuccess'], 'Delete success');

  String get department =>
      notNullString(_messages['client.department'], 'Department');

  String get disableEmailApp => notNullString(
      _messages['client.disableEmailApp'], 'No email app available on phone');

  String get done => notNullString(_messages['client.done'], 'Done');

  String get edit => notNullString(_messages['client.edit'], 'Edit');

  String get editCard =>
      notNullString(_messages['client.editCard'], 'Edit card');

  String get editCardInfo =>
      notNullString(_messages['client.editCardInfo'], 'Edit card information');

  String get editProfile =>
      notNullString(_messages['client.editProfile'], 'Edit Profile');

  String get editQr => notNullString(_messages['client.editQr'], 'Edit QR');

  String get editRemark =>
      notNullString(_messages['client.editRemark'], 'Edit Remark');

  String get emailCodeLogin => notNullString(
      _messages['client.emailCodeLogin'], 'Email and verification code');

  String get emailError => notNullString(
      _messages['client.emailError'], 'Email format is incorrect');

  String get emailLogin =>
      notNullString(_messages['client.emailLogin'], 'Email password login');

  String get emailPwdLogin =>
      notNullString(_messages['client.emailPwdLogin'], 'Email and password');

  String get emailRegister =>
      notNullString(_messages['client.emailRegister'], '邮箱注册');

  String get enterAccountInfo => notNullString(
      _messages['client.enterAccountInfo'], 'Input account information');

  String get enterAddress =>
      notNullString(_messages['client.enterAddress'], 'Enter your Address');

  String get enterCardName =>
      notNullString(_messages['client.enterCardName'], 'Enter card name');

  String get enterCompanyName => notNullString(
      _messages['client.enterCompanyName'], 'Enter your company name');

  String get enterDepartment => notNullString(
      _messages['client.enterDepartment'], 'Enter your department');

  String get enterEmail =>
      notNullString(_messages['client.enterEmail'], 'Input the email address');

  String get enterEmailCod => notNullString(
      _messages['client.enterEmailCod'], 'Enter email verification code');

  String get enterEmailContent => notNullString(
      _messages['client.enterEmailContent'], 'Enter email content');

  String get enterEmailTitle =>
      notNullString(_messages['client.enterEmailTitle'], 'Enter email title');

  String get enterFormatError => notNullString(
      _messages['client.enterFormatError'],
      'Information is not in the correct format');

  String get enterHint =>
      notNullString(_messages['client.enterHint'], 'Please enter...');

  String get enterMemberPhone => notNullString(
      _messages['client.enterMemberPhone'], 'Enter member phone no.');

  String get enterName =>
      notNullString(_messages['client.enterName'], 'Enter your name');

  String get enterNewPwd =>
      notNullString(_messages['client.enterNewPwd'], 'Enter new password');

  String get enterNewPwdAgain => notNullString(
      _messages['client.enterNewPwdAgain'], 'Enter new password again');

  String get enterOriginPwd => notNullString(
      _messages['client.enterOriginPwd'], 'Enter origin password');

  String get enterPhoneCode => notNullString(
      _messages['client.enterPhoneCode'], 'Enter verification code');

  String get enterPhoneNo =>
      notNullString(_messages['client.enterPhoneNo'], 'Input phone no.');

  String get enterPwd => notNullString(
      _messages['client.enterPwd'], 'Enter password of at least 6 digits');

  String get enterRemark =>
      notNullString(_messages['client.enterRemark'], 'Enter remarks');

  String get enterTitle =>
      notNullString(_messages['client.enterTitle'], 'Enter your job title');

  String get enterinviteCode => notNullString(
      _messages['client.enterinviteCode'],
      'Enter an invitation code (optional)');

  String get errorInfo =>
      notNullString(_messages['client.errorInfo'], 'Error message');

  String getFetchCode(String seconds) {
    return textWithArgument(
        _messages['client.fetchCode'] ?? 'Retry after {0} S', [seconds]);
  }

  String get forgotPwd =>
      notNullString(_messages['client.forgotPwd'], 'Forgot password');

  String getBindFailure(String errorMsg) {
    return textWithArgument(
        _messages['client.getBindFailure'] ?? 'Binding failed: {0}',
        [errorMsg]);
  }

  String getCountDown(String seconds) {
    return textWithArgument(
        _messages['client.getCountDown'] ?? '{0}秒后重新获取', [seconds]);
  }

  String getNotEnterCardId(String cardId) {
    return textWithArgument(
        _messages['client.getBindFailure'] ?? 'Binding failed: {0}', [cardId]);
  }

  String getOperateErrorWithInfo(String error) {
    return textWithArgument(
        _messages['client.getOperateErrorWithInfo'] ?? '操作失败:{0}', [error]);
  }

  String getOrderSuccess(String errorMsg) {
    return textWithArgument(
        _messages['client.getOrderSuccess'] ?? 'Update sort failed: {0}',
        [errorMsg]);
  }

  String getSaveFailure(String errorMsg) {
    return textWithArgument(
        _messages['client.getSaveFailure'] ?? 'Failed to save: {0}',
        [errorMsg]);
  }

  String getSendEmailCode(String email) {
    return textWithArgument(
        _messages['client.getSendEmailCode'] ??
            'A verification code will be sent to the email address {0}',
        [email]);
  }

  String getSendPhoneCode(String phoneNo) {
    return textWithArgument(
        _messages['client.getSendPhoneCode'] ??
            'A verification code will be sent to the phone no. {0}',
        [phoneNo]);
  }

  String getUnsupportActivity(String pageName) {
    return textWithArgument(
        _messages['client.getUnsupportActivity'] ??
            '【{0}】Page jump is not supported',
        [pageName]);
  }

  String get gotoRegister => notNullString(
      _messages['client.gotoRegister'], 'No account? Go register one');

  String get inviteDetail =>
      notNullString(_messages['client.inviteDetail'], 'Invitation Details');

  String get levelActive =>
      notNullString(_messages['client.levelActive'], 'level active');

  String get levelLocked =>
      notNullString(_messages['client.levelLocked'], 'level locked');

  String get linkFormatError => notNullString(
      _messages['client.linkFormatError'], 'The redirected URL is incorrect');

  String get links => notNullString(_messages['client.links'], 'Links');

  String get logo => notNullString(_messages['client.logo'], 'Logo');

  String get mainCard =>
      notNullString(_messages['client.mainCard'], '(Main Card)');

  String get manager => notNullString(_messages['client.manager'], 'Manager');

  String get messageCenter =>
      notNullString(_messages['client.messageCenter'], 'Message center');

  String get messageDetail =>
      notNullString(_messages['client.messageDetail'], 'Message detail');

  String get modify => notNullString(_messages['client.modify'], 'Modify');

  String get modifyEmail =>
      notNullString(_messages['client.modifyEmail'], 'Modify email');

  String get modifyPwd =>
      notNullString(_messages['client.modifyPwd'], 'Modify password');

  String get modifyPwdSuccess => notNullString(
      _messages['client.modifyPwdSuccess'], 'Modify password success');

  String get modifySuccess =>
      notNullString(_messages['client.modifySuccess'], 'Successfully modified');

  String get myCard => notNullString(_messages['client.myCard'], 'My Card');

  String get name => notNullString(_messages['client.name'], 'Name');

  String get nfcNotAvailable =>
      notNullString(_messages['client.nfcNotAvailable'], 'NFC 功能不可用');

  String get nfcOffTip => notNullString(
      _messages['client.nfcOffTip'], 'Turn NFC on in Settings,then try again.');

  String get nfcOffTitle =>
      notNullString(_messages['client.nfcOffTitle'], 'NFC is Turned Off');

  String get nfcRegister =>
      notNullString(_messages['client.nfcRegister'], 'NFC卡注册');

  String get noRecord =>
      notNullString(_messages['client.noRecord'], 'No records');

  String get noSameCard => notNullString(_messages['client.noSameCard'],
      'The current smart card numbers are inconsistent!');

  String get notData => notNullString(_messages['client.notData'], '数据为空');

  String get notEnteredDevice =>
      notNullString(_messages['client.notEnteredDevice'], '数据库未录入该设备信息');

  String get operateError =>
      notNullString(_messages['client.operateError'], '操作失败');

  String get operateTutorial =>
      notNullString(_messages['client.operateTutorial'], 'How to use');

  String get password =>
      notNullString(_messages['client.password'], 'Password');

  String get phoneCodeLogin => notNullString(
      _messages['client.phoneCodeLogin'], 'Mobile No. and verification code');

  String get phoneFormatError =>
      notNullString(_messages['client.phoneFormatError'], '手机号格式错误');

  String get phoneLogin => notNullString(
      _messages['client.phoneLogin'], 'Login with mobile no. and password');

  String get phoneNoLogin =>
      notNullString(_messages['client.phoneNoLogin'], 'Mobile no. login');

  String get phoneNoTitle =>
      notNullString(_messages['client.phoneNoTitle'], 'Phone no:');

  String get phonePwdLogin => notNullString(
      _messages['client.phonePwdLogin'], 'Mobile No. and password');

  String get phoneRegister =>
      notNullString(_messages['client.phoneRegister'], '手机号注册');

  String get preview => notNullString(_messages['client.preview'], 'Preview');

  String get privacyPolicy =>
      notNullString(_messages['client.privacyPolicy'], 'Privacy Policy');

  String get processing => notNullString(_messages['client.processing'], '处理中');

  String get readCardError => notNullString(_messages['client.readCardError'],
      'Read card error,please try it again!');

  String get readCardIdError => notNullString(
      _messages['client.readCardIdError'], 'can not read card identifier');

  String get refresh => notNullString(_messages['client.refresh'], '刷新');

  String get registerAccount =>
      notNullString(_messages['client.registerAccount'], 'Register an account');

  String get registerSuccess =>
      notNullString(_messages['client.registerSuccess'], 'Register Success');

  String get remark => notNullString(_messages['client.remark'], 'Remark');

  String get rememberPwd =>
      notNullString(_messages['client.rememberPwd'], 'Remember password');

  String get resetPwd =>
      notNullString(_messages['client.resetPwd'], 'Reset password');

  String get resetPwdSuccess => notNullString(
      _messages['client.resetPwdSuccess'], 'Reset password success');

  String get rewardsRecord =>
      notNullString(_messages['client.rewardsRecord'], 'Rewards record');

  String get saveEmailDraft =>
      notNullString(_messages['client.saveEmailDraft'], 'Saved to draft email');

  String get saveRqSuccess => notNullString(
      _messages['client.saveRqSuccess'], 'QR code saved successfully');

  String get scanQrCode => notNullString(_messages['client.scanQrCode'], '扫码');

  String get selectCoin =>
      notNullString(_messages['client.selectCoin'], '请选择充币网络');

  String get selectCountry =>
      notNullString(_messages['client.selectCountry'], '选择国家或地区');

  String get selectMessage =>
      notNullString(_messages['client.selectMessage'], '请选择要操作的消息');

  String get selectOperateMsg => notNullString(
      _messages['client.selectOperateMsg'],
      'Please select a message to act on');

  String get sendCodeSuccess => notNullString(
      _messages['client.sendCodeSuccess'], 'Verification code sent');

  String get sendEmail =>
      notNullString(_messages['client.sendEmail'], 'Send email');

  String get sendEmailSuccess => notNullString(
      _messages['client.sendEmailSuccess'], 'Mail sent successfully');

  String get setMainCard =>
      notNullString(_messages['client.setMainCard'], 'Set as main card');

  String get setMainPostCard =>
      notNullString(_messages['client.setMainPostCard'], 'Set as main card');

  String get setPwd =>
      notNullString(_messages['client.setPwd'], 'Set Password');

  String get setPwdSuccess => notNullString(
      _messages['client.setPwdSuccess'], 'Set password successfully');

  String get share => notNullString(_messages['client.share'], 'Share');

  String get shareProfile => notNullString(
      _messages['client.shareProfile'], 'Sharing Personal Profile');

  String get switchLogin =>
      notNullString(_messages['client.switchLogin'], 'Switch login');

  String get tabHand =>
      notNullString(_messages['client.tabHand'], 'Card in hand');

  String get tabHolder =>
      notNullString(_messages['client.tabHolder'], 'Card in holder');

  String get tagRecords =>
      notNullString(_messages['client.tagRecords'], 'Tag Records:');

  String get takePhoto =>
      notNullString(_messages['client.takePhoto'], 'Take Photo');

  String get tapDownload =>
      notNullString(_messages['client.tapDownload'], 'Tap to download');

  String get tapSave => notNullString(
      _messages['client.tapSave'], 'Tap to download QR code to photos');

  String get task => notNullString(_messages['client.task'], 'Task');

  String get tip => notNullString(_messages['client.tip'], 'Tip');

  String get title => notNullString(_messages['client.title'], 'Job title');

  String get transferredIn =>
      notNullString(_messages['client.transferredIn'], '已转入');

  String get transferredOut =>
      notNullString(_messages['client.transferredOut'], '已转出');

  String get tryRefresh =>
      notNullString(_messages['client.tryRefresh'], '刷新试试～～');

  String get twicePwd => notNullString(_messages['client.twicePwd'],
      'The passwords entered repeatedly are inconsistent');

  String get unSupportRecharge =>
      notNullString(_messages['client.unSupportRecharge'], '此网络暂时不支持充币');

  String get unbindEmail =>
      notNullString(_messages['client.unbindEmail'], '未绑定邮箱');

  String get unbindPhone =>
      notNullString(_messages['client.unbindPhone'], '未绑定手机号');

  String get unsupporetCard => notNullString(_messages['client.unsupporetCard'],
      'The current card type is not yet supported, so stay tuned!');

  String get unsupportedAmount => notNullString(
      _messages['client.unsupportedAmount'],
      'The current card type does not support reading the balance.');

  String get updateName =>
      notNullString(_messages['client.updateName'], 'Modify name');

  String get updateNickname =>
      notNullString(_messages['client.updateNickname'], '修改昵称');

  String get updateQRSource => notNullString(
      _messages['client.updateQRSource'], 'Modify source of QR code');

  String get userAgreement =>
      notNullString(_messages['client.userAgreement'], 'User Agreement');

  String get userLevel =>
      notNullString(_messages['client.userLevel'], 'User Level');

  String get yourAddress =>
      notNullString(_messages['client.yourAddress'], 'Your address');

  String get yourBalane =>
      notNullString(_messages['client.yourBalane'], 'Your Balance');

  String get yourCompanyName =>
      notNullString(_messages['client.yourCompanyName'], 'Your company name');

  String get yourDepartment =>
      notNullString(_messages['client.yourDepartment'], 'Your department');

  String get yourName =>
      notNullString(_messages['client.yourName'], 'Your name');

  String get yourRemark =>
      notNullString(_messages['client.yourRemark'], 'Your remarks');

  String get yourTitle =>
      notNullString(_messages['client.yourTitle'], 'Your title');

  String get reload => notNullString(_messages['client.reload'], 'Reload');

  String get agreementTip => notNullString(
      _messages['client.agreementTip'], 'Please accept registration agreement');

  String get enterEmailCode => notNullString(
      _messages['client.enterEmailCode'], 'Enter email verification code');

  String get expiredTip => notNullString(_messages['client.expiredTip'],
      'Your login has expired, please log in again!');

  String get failed => notNullString(_messages['client.failed'], 'Failed');

  String get login => notNullString(_messages['client.login'], 'Login');

  String get networkResponseTimeout => notNullString(
      _messages['client.networkResponseTimeout'], 'Response timeout');

  String get logoutAccount => notNullString(
      _messages['client.logoutAccount'], 'Logout current account');

  String get alreadyScan =>
      notNullString(_messages['client.alreadyScan'], 'Logout current account');

  String get walletMainTitle =>
      notNullString(_messages['client.walletMainTitle'], 'Wallet');

  String get welcomeToBestWish => notNullString(
      _messages['client.welcomeToBestWish'], 'Welcome to ChipBase Wallet');

  String get pointsBalance =>
      notNullString(_messages['client.pointsBalance'], 'Airdrop voucher');

  String get totalPoints =>
      notNullString(_messages['client.totalPoints'], 'Income Kumulatif');

  String get yesterdayPoints =>
      notNullString(_messages['client.yesterdayPoints'], 'Income Kemarin');

  String get pukCode => notNullString(_messages['client.pukCode'], 'PUK Code');

  String get enterPukCode =>
      notNullString(_messages['client.enterPukCode'], 'Enter puk code');

  String get pukCodeFormatTips => notNullString(
      _messages['client.pukCodeFormatTips'],
      'The PUK code is an 8-digit code returned after the PIN code is successfully created.');

  String get pinCodeDigitsTips => notNullString(
      _messages['client.pinCodeDigitsTips'],
      'The pin value can only be 6 digits');

  String get pinCodeNumTips => notNullString(
      _messages['client.pinCodeNumTips'], 'The pin value can only be a number');

  String get pukCodeDigitsTips => notNullString(
      _messages['client.pukCodeDigitsTips'],
      'The puk value can only be 8 digits');

  String get pukCodeError =>
      notNullString(_messages['client.pukCodeError'], 'Puk code wrong');

  String get cardLocked =>
      notNullString(_messages['client.cardLocked'], 'Card is locked');

  String get homePageTips => notNullString(_messages['client.homePageTips'],
      'The safest way to buy,use and store cryptocurrency');

  String getWelcomeTips(String name) {
    return textWithArgument(
        _messages['client.getWelcomeTips'] ?? 'Welcome to {0}', [name]);
  }

  String get notConfigured => notNullString(
      _messages['client.notConfigured'], 'Currency not configured');

  String get notSaveTips => notNullString(_messages['client.notSaveTips'],
      'The changed currency has not been saved yet. Are you sure you don\'t want to save it?');

  String get uidNotSame =>
      notNullString(_messages['client.uidNotSame'], 'Uid not same');

  String get healthCheck =>
      notNullString(_messages['client.healthCheck'], 'Health Check');

  String get notNeedUnlock => notNullString(
      _messages['client.notNeedUnlock'], 'Card not locked,not need unlock');

  String get checkCardTips => notNullString(_messages['client.checkCardTips'],
      'This page will help you to make card health check,please keep card tap in NFC area till this operation completed.');

  String get tryScan =>
      notNullString(_messages['client.tryScan'], 'Try scan now');

  String getCheckTotalFailTip(String number) {
    return textWithArgument(
        _messages['client.getCheckFailTotal'] ??
            'Total 21 items in Health check, failed {0}',
        [number]);
  }

  String get getCheckTotalTip => notNullString(
      _messages['client.getCheckTotalTip'], 'Total 21 items in Health check!');

  String get checking =>
      notNullString(_messages['client.checking'], 'Checking...');

  String get startCheck =>
      notNullString(_messages['client.startCheck'], 'Start Check');

  String get uploadSuccess =>
      notNullString(_messages['client.uploadSuccess'], 'Upload success');

  String get uploadFailed =>
      notNullString(_messages['client.uploadFailed'], 'Upload fail,try again!');

  String get yes => notNullString(_messages['client.yes'], 'Yes');

  String get no => notNullString(_messages['client.no'], 'No');

  String get cardVendorCheck =>
      notNullString(_messages['client.cardVendorCheck'], 'Card Vendor Check');

  String get cardNumber =>
      notNullString(_messages['client.cardNumber'], 'Card Number');

  String get cardVersion =>
      notNullString(_messages['client.cardVersion'], 'Card Version');

  String get cardLock =>
      notNullString(_messages['client.cardLock'], 'Card Lock');

  String get cardDisable =>
      notNullString(_messages['client.cardDisable'], 'Card Disable');

  String get keyPairGenerated =>
      notNullString(_messages['client.keyPairGenerated'], 'Key Pair Generated');

  String get getDeriveInfo =>
      notNullString(_messages['client.getDeriveInfo'], 'Get Derive Info');

  String get signature =>
      notNullString(_messages['client.signature'], 'Signature');

  String get pinset => notNullString(_messages['client.pinset'], 'Pin Set');

  String get pinRemaining =>
      notNullString(_messages['client.pinRemaining'], 'PIN Remaining');

  String get pukRemaining =>
      notNullString(_messages['client.pukRemaining'], 'PUK Remaining');

  String get ndefPrefixSet =>
      notNullString(_messages['client.ndefPrefixSet'], 'NDEF Prefix Set');

  String get signTimes =>
      notNullString(_messages['client.signTimes'], 'Sign Times');

  String get shareVersion =>
      notNullString(_messages['client.shareVersion'], 'Shared Version');

  String get ndefVersion =>
      notNullString(_messages['client.ndefVersion'], 'NDEF Version');

  String get cardVersionCode =>
      notNullString(_messages['client.cardVersionCode'], 'Version Code');

  String get balance => notNullString(_messages['client.balance'], 'Balance');

  String get contentIsEmpty =>
      notNullString(_messages['client.contentIsEmpty'], 'Empty');

  String getCheckTotal(String num) {
    return textWithArgument(
        _messages['client.getCheckFailTotal'] ??
            'Total 13 items in Health check, failed {0}',
        [num]);
  }

  String get empty => notNullString(_messages['client.empty'], 'Empty');

  String get scanCardTip =>
      notNullString(_messages['client.scanCardTip'], 'Click to scan card');

  String get changeLan =>
      notNullString(_messages['client.changeLan'], 'Language');

  String get pinFormat => notNullString(
      _messages['client.pinFormat'], 'The PIN code format is 6 digits');

  String get switchActivate =>
      notNullString(_messages['client.switchActivate'], 'Switch Activate');
  String get allActivate =>
      notNullString(_messages['client.allActivate'], 'Activate All');
  String get singleActivate => notNullString(
      _messages['client.singleActivate'], 'Single card activation');
  String get packageActivate =>
      notNullString(_messages['client.packageActivate'], 'Package Activation');
  String get titleTotalNum =>
      notNullString(_messages['client.titleTotalNum'], 'Total:');
  String get activateAllTips => notNullString(
      _messages['client.activateAllTips'],
      'Are you sure you want to activate all cards?');
  String get activatePackageTips => notNullString(
      _messages['client.activatePackageTips'],
      'Are you sure you want to activate all Packages in the current list?');
  String get verifyEmailAddress => notNullString(
      _messages['client.verifyEmailAddress'], 'Verify Email Address');
  String get verify => notNullString(_messages['client.verify'], 'Verify');
  String get titleCardNum =>
      notNullString(_messages['client.titleCardNum'], 'Card number:');
  String get titleBatchNum =>
      notNullString(_messages['client.titleBatchNum'], 'Batch number:');
  String get titleBatchCardNum => notNullString(
      _messages['client.titleBatchCardNum'], 'Number of cards in this batch:');
  String get titleActivatedCardNum => notNullString(
      _messages['client.titleActivatedCardNum'], 'Activated quantity:');
  String get titleInActivateCardNum => notNullString(
      _messages['client.titleInActivateCardNum'], 'Inactive quantity:');
  String get titlePackageNum => notNullString(
      _messages['client.titlePackageNum'], 'Total number of packages:');
  String get titleActivatedPackageNum => notNullString(
      _messages['client.titleActivatedPackageNum'], 'Activated Packages:');
  String get titleInActivatedPackageNum => notNullString(
      _messages['client.titleInActivatedPackageNum'], 'Inactivated Packages:');
  String getUnitPieces(String num) {
    return textWithArgument(
        _messages['client.getUnitPieces'] ?? '{0} pieces', [num]);
  }

  String getUnitPackage(String num) {
    return textWithArgument(_messages['client.getUnitPackage'] ?? '{0}', [num]);
  }

  String sendCode2Email(String address) {
    return textWithArgument(
        _messages['client.sendCode2Email'] ??
            'Send email verification code to {0}',
        [address]);
  }

  String get gotoActivate =>
      notNullString(_messages['client.gotoActivate'], 'Deactivation');
  String get selectAll =>
      notNullString(_messages['client.selectAll'], 'Select All');
  String get activateCard =>
      notNullString(_messages['client.activateCard'], 'Activation');
  String get scanActivate =>
      notNullString(_messages['client.scanActivate'], 'Tap card to activate');
  String get inActivateTips => notNullString(
      _messages['client.inActivateTip'], 'The device not activated!');
  String get activateNow =>
      notNullString(_messages['client.activateNow'], 'Activate Now');
  String get assetSettings =>
      notNullString(_messages['client.assetSettings'], 'Asset Settings');
  String get activateDetail => notNullString(_messages['client.activateDetail'],
      'Activation process:\n1. Tap the card to obtain card information\n2. Verify order contact information\n3. Obtain verification code\n4. Activate all cards in the current batch');
  String get activateDetailTips => notNullString(
      _messages['client.activateDetailTips'],
      'Please note that for unactivated cards, your merchant information cannot be displayed and the card amount cannot be operated.');
  String get networkCheck =>
      notNullString(_messages['client.networkCheck'], 'Network Check');
  String get normalSignalTips => notNullString(
      _messages['client.normalSignalTips'], 'Mobile network signal is normal');
  String get moderateSignalTips => notNullString(
      _messages['client.moderateSignalTips'], 'Moderate mobile network signal');
  String get poorSignalTips => notNullString(
      _messages['client.poorSignalTips'], 'Poor mobile network signal');
  String get veryPoorSignalTips => notNullString(
      _messages['client.veryPoorSignalTips'],
      'Very poor mobile network signal');
  String get lossPacketTips => notNullString(
      _messages['client.lossPacketTips'], 'Packet loss may occur');
  String get networkAbnormalityTips => notNullString(
      _messages['client.networkAbnormalityTips'], 'Mobile network abnormality');
  String get checkingNetwork => notNullString(
      _messages['client.checkingNetwork'], 'Checking server connection...');
  String get serverNormal => notNullString(
      _messages['client.serverNormal'], 'Server connection is normal');
  String get serverSlightlySlow => notNullString(
      _messages['client.serverSlightlySlow'],
      'The server response speed is slightly slow');
  String get serverSlow =>
      notNullString(_messages['client.serverSlow'], 'Slow server response');
  String get serverVerySlow => notNullString(
      _messages['client.serverVerySlow'], 'The server response is very slow');
  String get serverAbnormality => notNullString(
      _messages['client.serverAbnormality'], 'Server connection abnormality');
  String get checkPhoneNetwork => notNullString(
      _messages['client.checkPhoneNetwork'],
      'Please check whether your phone can access the Internet normally');
  String get serverContactUs => notNullString(
      _messages['client.serverContactUs'],
      'The server connection is abnormal, please contact us to solve the problem');
  String get checkingPhoneNetwork => notNullString(
      _messages['client.checkingPhoneNetwork'], 'Checking mobile network...');
  String get noPhoneNetwork => notNullString(_messages['client.noPhoneNetwork'],
      'Currently in airplane mode or without network connection.');

  String get exportTimes =>
      notNullString(_messages['client.exportTimes'], 'Export Times');

  String get restoreTimes =>
      notNullString(_messages['client.restoreTimes'], 'Restore Times');

  String get syncUid => notNullString(_messages['client.syncUid'], 'Sync UID');

  String get hdTapTimes =>
      notNullString(_messages['client.hdTapTimes'], 'HD Tap Times');

  String get ndefTapTimes =>
      notNullString(_messages['client.ndefTapTimes'], 'NDEF Tap Times');

  String get stop => notNullString(_messages['client.stop'], 'Stop');
}
