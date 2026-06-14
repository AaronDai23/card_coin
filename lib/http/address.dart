class NetworkAddress {
  static const String blockChairUrl = 'https://api.blockchair.com';
  static const String iconBaseUrl = 'https://cryptologos.cc';
  static const String buyCoinUrl =
      'https://openc.pro/widget-page/?widgetId=UFUzQmY2UHY';

  static const String systemPublicKeyUrl = '/service-rest/m/system/publicKey';

  static const String appUpgradeUrl = '/service-rest/m/app/upgrade';
  static const String localeMessageMd5Url =
      '/service-rest/m/localeMessageClient/md5?module=CLIENT';
  static const String localeMessageListUrl =
      '/service-rest/m/localeMessageClient/list?module=CLIENT';
  static const String languageListUrl =
      '/service-rest/m/localeMessageClient/country';

  static const String smartCardDetailUrl = '/service-rest/m/smartCard/detail';
  static const String countryCurrencyUrl = '/service-rest/m/country/currency';
  static const String apduLogUrl = '/service-rest/m/smartCard/apdu/log';
  static const String uploadPublicKeyUrl =
      '/service-rest/m/smartCard/updatePublicKey';
  static const String syncWallet =
      '/service-rest/m/smartCard/wallet/sync'; // 同步钱包

  static const String geTokenPrices =
      '/service-rest/m/crypto/prices'; // 货币价格--批量
  static const String cryptoListUrl =
      '/service-rest/m/smartCard/crypto/page'; // 加密货币列表,分页
  static const String geCurrencys = '/service-rest/m/country/currency'; // 法币列表
  static const String syncalias = '/service-rest/m/smartCard/alias'; // 同步别名
  static const String walletList =
      '/service-rest/m/smartCard/wallet/list'; // 获取钱包列表
  static const String allcryptoListUrl =
      '/service-rest/m/crypto/list'; // 加密货币列表
  static const String allcryptoMd5 = '/service-rest/m/crypto/md5'; // 加密货币列表md5
  static const String ndefDomain =
      '/service-rest/m/smartCard/ndef/domain'; // nDEF域名

  ///名片Api
  static const String imageBaseUrl = 'https://img.pangu.network';
  static const String loginUrl = '/service-rest/m/login/login';
  static const String registerVerifyUrl =
      '/service-rest/m/login/sendVerityCode';
  static const String getInviteCodeUrl =
      '/service-rest/m/login/inviteCodeByLink';
  static const String emailVerifyUrl =
      '/service-rest/m/customer/sendEmailVerityCode';
  static const String sendLoginVerityCodeUrl =
      '/service-rest/m/login/sendLoginVerityCode';
  static const String registerUrl = '/service-rest/m/login/register';
  static const String loginMultipleUrl = '/service-rest/m/login/loginMultiple';
  static const String loginMethodUrl = '/service-rest/m/system/loginMethod';
  static const String registerBindUrl = '/service-rest/m/login/registerBind';
  static const String bindEmailUrl = '/service-rest/m/customer/bindEmail';
  static const String forgotVerifyUrl =
      '/service-rest/m/login/sendForgetVerityCode';
  static const String resetPwdUrl = '/service-rest/m/login/resetMyPassword';
  static const String updatePwdUrl =
      '/service-rest/m/customer/changeMyPassword';

  static const String advertisementUrl = '/service-rest/m/advertisement';
  static const String homeBannerUrl = '$advertisementUrl/banner/HOME';
  static const String cardsBannerUrl = '$advertisementUrl/banner/CARDS';
  static const String pageCategoryUrl = '$advertisementUrl/pageCategory/TAB';
  static const String mainTabsUrl = '$advertisementUrl/pageCategory/HOME';
  static const String pageCategorySideUrl =
      '$advertisementUrl/pageCategory/SIDE';
  static const String bannerMoreUrl = '$advertisementUrl/banner/MORE';

  static const String socialLinksUrl = '/service-rest/m/postCard/type';
  static const String createSocialUrl =
      '/service-rest/m/postCard/createButtons';
  static const String detailSocialsUrl = '/service-rest/m/postCard/detail';
  static const String domainUrl = '/service-rest/m/postCard/domain';
  static const String updateSocicalLinkUrl =
      '/service-rest/m/postCard/updateButtons';
  static const String deleteSocicalLinkUrl = '/service-rest/m/postCard/delete';
  static const String sortLinkUrl = '/service-rest/m/postCard/sort';
  static const String linkProfileUrl = '/service-rest/m/postCard/profile';
  static const String singleLinkUrl = '/service-rest/m/postCard/single';
  static const String updateProfileUrl =
      '/service-rest/m/postCard/updateProfile';
  static const String createCardUrl = '/service-rest/m/postCard/createCard';
  static const String detectPostCardUrl =
      '/service-rest/m/postCard/detectPostCard';

  static const String avatarLinkUrl = '/service-rest/m/customer/avatar';
  static const String verifyMethodUrl = '/service-rest/m/customer/verifyMethod';
  static const String setPasswordVerifyUrl =
      '/service-rest/m/customer/sendSetPasswordVerifyCode';
  static const String setPasswordUrl = '/service-rest/m/customer/setPassword';

  static const String h5BackListUrl = '/service-rest/m/h5BlackList';
  static const String uploadWebviewUrl = '/service-rest/m/webView/request';
  static const String memberLevelUrl = '/service-rest/m/system/customer/level';
  static const String memberRankUrl = '/service-rest/m/level/rank';
  static const String privilegeUrl = '/service-rest/m/level/privilege';
  static const String activityButtonsUrl =
      '/service-rest/m/app/activityButtons';

  static const String cardListUrl = '/service-rest/m/authDevice/page';
  static const String bindNfcUrl = '/service-rest/m/authDevice/bindNFC';
  static const String deleteCardUrl = '/service-rest/m/authDevice/delete';
  static const String setMainCardUrl = '/service-rest/m/authDevice/setMajor';
  static const String setCardNameUrl = '/service-rest/m/authDevice/setName';
  static const String setCardAmountUrl =
      '/service-rest/m/authDevice/updateProfile';
  static const String bindCardVerify = '/service-rest/m/authDevice/verify';

  static const String teamsMembersUrl =
      '/service-rest/m/postCard/teams/member/page';
  static const String createMemberUrl =
      '/service-rest/m/postCard/teams/member/create';
  static const String updateMemberRemarkUrl =
      '/service-rest/m/postCard/teams/member/updateNickName';
  static const String groupCardDetailUrl =
      '/service-rest/m/postCard/teams/member/postCardDetail';

  static const String inviteListUrl = '/service-rest/m/customer/invite/page';

  static const String customerLevelDocUrl =
      '/service-rest/m/doc/customer_level_rank';

  static const String messageListUrl = '/service-rest/m/customer/message/page';
  static const String messageDetailUrl =
      '/service-rest/m/customer/message/detail';
  static const String messageReadUrl = '/service-rest/m/customer/message/read';
  static const String messageDeleteUrl =
      '/service-rest/m/customer/message/delete';
  static const String messageUnreadCountUrl =
      '/service-rest/m/customer/message/unReadCount';

  static const String awardHistoryUrl = '/service-rest/m/task/awardHistory';

  static const String userAgreementUrl = '/service-rest/m/doc/user_agreement';
  static const String termsPrivacyUrl = '/service-rest/m/doc/terms_and_privacy';
  static const String registerCountryUrl = '/service-rest/m/country';
  static const String createVirtualDeviceUrl =
      '/service-rest/m/authDevice/virtualDevice';

  static const String createCardTypeUrl =
      '/service-rest/m/system/postcardSource';
  static const String qrInfoTypeUrl = '/service-rest/m/postCard/qrInfoType';
  static const String updateQrInfoTypeUrl = '/service-rest/m/postCard/qrInfo';

  static const String cancellationAccountUrl =
      '/service-rest/m/customer/cancellation';

  ///名片钱包合并新增api
  static const String addCardHoldUrl =
      '/service-rest/m/customer/smartCard/hold';
  static const String cardGroupsUrl =
      '/service-rest/m/customer/smartCard/group/page';
  static const String smartCardListUrl =
      '/service-rest/m/customer/smartCard/page';
  static const String deleteSmartCardUrl =
      '/service-rest/m/customer/smartCard/delete';
  static const String countryUrl = '/service-rest/m/country/register';
  static const String cardDetailUrl =
      '/service-rest/m/customer/smartCard/detail';
  static const String bindPhoneUrl = '/service-rest/m/customer/bindPhone';
  static const String systemConfigUrl = '/service-rest/m/system/config';
  static const String sendPhoneVerifyCodeUrl =
      '/service-rest/m/customer/sendPhoneVerifyCode';
  static const String updateNicknameUrl =
      '/service-rest/m/customer/updateProfile';
  static const String memberPointsBalanceUrl =
      '/service-rest/m/customer/memberPoints/balance';
  static const String memberPointsRecordsUrl =
      '/service-rest/m/customer/memberPoints/page';

  //
  static const String getCardNumber = '/service-rest/m/smartCard/cardNumber';
  static const String checkUid = '/service-rest/m/smartCard/check/uid';
  static const String healthCheck =
      '/service-rest/m/smartCard/healthCheck/report'; // 上传报告
  static const String lightSparkBalance =
      '/service-rest/m/crypto/lightning/balance'; // 闪电余额

  static const String lightSparkTransactions =
      '/service-rest/m/crypto/lightning/transactions'; // 闪电交易记录

  static const String lightSparkWithdrawal =
      '/service-rest/m/crypto/lightning/withdrawal'; // 闪电提现

  static const String invoiceUrl = '/service-rest/m/crypto/lightning/invoice';

  static const String lightningSignMessageUrl =
      '/service-rest/m/crypto/lightning/signMessage';

  static const String lightningPaymentUrl =
      '/service-rest/m/crypto/lightning/payment';

  static const String lightningWithdrawUrl =
      '/service-rest/m/crypto/lightning/withdrawal';

  static const String validateInvoiceUrl =
      '/service-rest/m/crypto/lightning/invoice/detect';

  static const String registerMethodUrl =
      '/service-rest/m/system/registerMethod';

  static const String validateMethodUrl =
      '/service-rest/m/customer/smartCardActivation/validateMethod';

  static const String cardholderVerityUrl =
      '/service-rest/m/customer/smartCardActivation/identifier';

  static const String activateVerityUrl =
      '/service-rest/m/customer/smartCardActivation/sendVerifyCode';

  static const String activateCardUrl =
      '/service-rest/m/customer/smartCardActivation';
  static const String activateCardVerifyUrl =
      '/service-rest/m/customer/smartCardActivation/verify';

  static const String compatibilitySmartCard =
      '/service-rest/m/app/compatibility/smartCard';
  static const String getUnitsInfo = '/service-rest/m/crypto/unit/unit';

  static const String getCardActivationTitle =
      '/service-rest/m/advertisement/page/CARD_ACTIVATION';
  static const String getLightningBalance =
      '/service-rest/m/customer/lightning/balance';
  static const String getLightningPage =
      '/service-rest/m/customer/lightning/page';
  static const String getLightningReceive =
      '/service-rest/m/customer/lightning/receive';

  static const String activateSummaryUrl =
      '/service-rest/m/customer/smartCardActivation/active/summary';

  static const String activateCardV2Url =
      '/service-rest/m/customer/smartCardActivation/active';

  static const String activatePackageSummaryUrl =
      '/service-rest/m/customer/smartCardActivation/active/package';

  static const String activatePackagePageUrl =
      '/service-rest/m/customer/smartCardActivation/active/package/page';

  static const String cryptoSettingPageUrl =
      '/service-rest/m/smartCard/cryptoSetting/page';

  static const String updateCryptoSettingPageUrl =
      '/service-rest/m/smartCard/cryptoSetting/update';

  static const String investmentPage =
      '/service-rest/m/crypto/investment/page'; // 获取已有定投列表
  static const String createInvestment =
      '/service-rest/m/crypto/investment/create'; // 创建定投
  static const String terminatedInvestment =
      '/service-rest/m/crypto/investment/terminated'; // 终止定投
  static const String investmentDetail =
      '/service-rest/m/crypto/investment/detail'; // 获取定投详情
  static const String investmentTransactions =
      '/service-rest/m/crypto/investment/transactions'; // 获取定投已执行历史列表
  static const String investmentParameter =
      '/service-rest/m/crypto/investment/parameter'; // 获取必要参数
  static const String investmentSmartCardCrypto =
      '/service-rest/m/crypto/investment/smartCardCrypto'; // 获取加密货币地址列表
  static const String investmentBalance =
      '/service-rest/m/crypto/investment/balance'; // 获取定投余额
  static const String pauseInvestment =
      '/service-rest/m/crypto/investment/pause'; // 暂停定投
  static const String resumeInvestment =
      '/service-rest/m/crypto/investment/resume'; // 重启定投
  static const String updateInvestment =
      '/service-rest/m/crypto/investment/update'; // 更新定投
  static const String investmentRorecast =
      '/service-rest/m/crypto/investment/forecast'; // 定投去年同期预估

  static const String investmentWithdrawal =
      '/service-rest/m/crypto/investment/withdrawal'; // 资产提现
  static const String investmentSignMessage =
      '/service-rest/m/smartCard/sign/message'; // 获取签名消息
  static const String investmentPreWithdrawal =
      '/service-rest/m/crypto/investment/preWithdrawal'; // 获取签名消息
  static const String investmentActivation =
      '/service-rest/m/crypto/investment/activation'; // 激活卡片定投

  static const String preApprovalDCA =
      '/service-rest/m/crypto/investment/preApprovalDCA'; // 获取签名信息

  static const String approvalDCA =
      '/service-rest/m/crypto/investment/approvalDCA'; // 获取签名信息
  static const String preTransferDCA =
      '/service-rest/m/crypto/investment/preTransferDCA'; // 获取签名信息
  static const String flowProgress =
      '/service-rest/m/crypto/investment/flowProgress'; // 合约进度查询
  static const String cardDetailSingleUrl =
      '/service-rest/m/crypto/investment/detail/simple'; // 获取定投详情简版
  static const String signDCA =
      '/service-rest/m/crypto/investment/signDCA'; // 获取定投详情简版
  static const String dapplist =
      '/service-rest/m/third/product/list'; // 获取dapp列表

  static const String assetSummary =
      '/service-rest/m/smartCard/asset/summary'; // 获取资产总览
  static const String flowHistory =
      '/service-rest/m/crypto/investment/flowHistory'; // 获取定投流水

  static const String dummyLog = '/service-rest/m/dummy/log'; // 上传dummy log

  static const String challenge =
      '/service-rest/m/customer/biometrics/challenge'; // 在用户已经登录的情况下点击启用生物识别，随即发起随机码挑战

  static const String bindBiometrics =
      '/service-rest/m/customer/biometrics/bind'; // 发起绑定生物识别

  static const String unbindBiometrics =
      '/service-rest/m/customer/biometrics/unBind'; // 用户关闭生物识别的时候

  static const String biometricsDetail =
      '/service-rest/m/customer/biometrics/detail'; // 获取生物识别绑定详情

  static const String loginChallenge =
      '/service-rest/m/login/biometrics/challenge'; // 在用户已经登录的情况下点击启用生物识别，随即发起随机码挑战

  static const String biometricDetail =
      '/service-rest/m/customer/biometrics/detail'; // 用于获取用户是否绑定了的生物识别信息列表

  static const String smartCardConfig = '/service-rest/m/smartCard/config';

  static const String smartCardAppInstall = '/service-rest/m/app/install';

  static const String advertisementPageCategorySide =
      '/service-rest/m/advertisement/pageCategory/WALLET/SIDE';

  static const String chainStampPage =
      '/service-rest/m/chainStamp/page'; // 获取链印列表
  static const String chainStampCreate =
      '/service-rest/m/chainStamp/latest'; // 获取最新链印
  static const String chainStampDetail =
      '/service-rest/m/chainStamp/detail'; // 获取链印详情
  static const String chainStampDelete =
      '/service-rest/m/chainStamp/delete'; // 删除链印

  static const String chainStampPersonalCreate =
      '/service-rest/m/chainStamp/personal/create'; // 创建个人链印

  static const String smartCardCardNumberPage =
      '/service-rest/m/smartCard/cardNumber/page'; // 获取智能卡号列表
  static const String taskItemCompleted =
      '/service-rest/m/task/itemCompleted'; // 任务完成

  static const String getKLines = '/service-rest/m/crypto/kline'; // k线获取
  static const String currencyAddressDetail =
      '/service-rest/m/smartCard/address/detail'; // 获取货币地址详情

  static const String defaultStablecoin =
      '/service-rest/m/crypto/defaultStablecoin'; // 获取默认稳定币
}
