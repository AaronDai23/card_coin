import 'dart:io';
import 'dart:async';

// import 'package:app_links/app_links.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:card_coin/card_base/pages/coin_message_detail_page/page.dart';
import 'package:card_coin/card_base/pages/coin_message_list_page/page.dart';
import 'package:card_coin/card_base/pages/device_activate_page/all_activate_page/page.dart';
import 'package:card_coin/card_base/pages/device_activate_page/email_activate_page/page.dart';
import 'package:card_coin/card_base/pages/device_activate_page/package_activate_page/page.dart';
import 'package:card_coin/card_base/pages/device_activate_page/phone_activate_page/page.dart';
import 'package:card_coin/card_base/pages/device_activate_page/selected_activate_page/page.dart';
import 'package:card_coin/card_base/pages/device_activate_page/single_activate_page/page.dart';
import 'package:card_coin/card_base/pages/error_tip_page/page.dart';
import 'package:card_coin/card_base/pages/flow_history_page/page.dart';
import 'package:card_coin/card_base/pages/investment_page/investment_active_page/page.dart';
import 'package:card_coin/card_base/pages/investment_page/investment_balance_page/investment_withdrawal_page/page.dart';
import 'package:card_coin/card_base/pages/investment_page/investment_balance_page/page.dart';
import 'package:card_coin/card_base/pages/investment_page/investment_handle_page/investment_coin_page/page.dart';
import 'package:card_coin/card_base/pages/investment_page/investment_handle_page/page.dart';
import 'package:card_coin/card_base/pages/investment_page/investment_history_page/page.dart';
import 'package:card_coin/card_base/pages/investment_page/investment_process_page/page.dart';
import 'package:card_coin/card_base/pages/investment_page/investment_single_detail_page/page.dart';
import 'package:card_coin/card_base/pages/investment_page/page.dart';
import 'package:card_coin/card_base/pages/member_points_page/page.dart';
import 'package:card_coin/card_base/pages/my_asset_page/cash_out_page/page.dart';
import 'package:card_coin/card_base/pages/my_asset_page/cash_out_history_page/page.dart';
import 'package:card_coin/card_base/pages/my_asset_page/cash_out_detail_page/page.dart';
import 'package:card_coin/card_base/pages/my_asset_page/convert_history_page/page.dart';
import 'package:card_coin/card_base/pages/my_asset_page/convert_detail_page/page.dart';
import 'package:card_coin/card_base/pages/my_asset_page/exchange_page/page.dart';
import 'package:card_coin/card_base/pages/my_asset_page/withdraw_bank_page/page.dart';
import 'package:card_coin/card_base/pages/my_asset_page/page.dart';
import 'package:card_coin/card_base/pages/scan_wallet_page/page.dart';
import 'package:card_coin/card_base/pages/settings_page/change_language_page/page.dart';
import 'package:card_coin/card_base/pages/settings_page/task_rewards_page/page.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/http/result_data.dart';
import 'package:card_coin/managers/default_stablecoin_manager.dart';
import 'package:card_coin/pages/add_bless_page/page.dart';
import 'package:card_coin/pages/app_version_page/page.dart';
import 'package:card_coin/pages/login_page/page.dart';
import 'package:card_coin/pages/main_page/address_book_page/edit_address_book_page/page.dart';
import 'package:card_coin/pages/main_page/cancel_pin_code_page/page.dart';
import 'package:card_coin/pages/main_page/create_new_wallet_page/page.dart';
import 'package:card_coin/pages/main_page/hd_wallet_list_page/hd_recharge_main_page/page.dart';
import 'package:card_coin/pages/main_page/hd_wallet_list_page/page.dart';
import 'package:card_coin/pages/main_page/hd_wallet_page/hd_recharge_page/page.dart';
import 'package:card_coin/pages/main_page/hd_wallet_page/hd_send_page/page.dart';

// import 'package:card_coin/pages/main_page/hd_wallet_page/page.dart';
import 'package:card_coin/pages/main_page/hd_wallet_page/select_fiat_page/page.dart';
import 'package:card_coin/pages/main_page/lightning_net_detail_page/light_net_Invoice_page/invoice_edit_page/page.dart';
import 'package:card_coin/pages/main_page/lightning_net_detail_page/light_net_Invoice_page/page.dart';
import 'package:card_coin/pages/main_page/lightning_net_detail_page/page.dart';
import 'package:card_coin/pages/main_page/lightning_net_detail_page/send_lightning_invoice_page/page.dart';
import 'package:card_coin/pages/main_page/pin_code_info_page/page.dart';
import 'package:card_coin/pages/main_page/select_currency_page/page.dart';
import 'package:card_coin/pages/main_page/set_pin_code_page/page.dart';
import 'package:card_coin/pages/main_page/settings_page/biometrics_page/page.dart';
import 'package:card_coin/pages/main_page/settings_page/check_card_page/page.dart';
import 'package:card_coin/pages/main_page/settings_page/device_settings_page/page.dart';
import 'package:card_coin/pages/main_page/settings_page/page.dart';
import 'package:card_coin/pages/main_page/unlock_pin_code_page/page.dart';
import 'package:card_coin/pages/main_page/write_ntag_page/page.dart';
import 'package:card_coin/pages/scan_qrcode_page/page.dart';
import 'package:card_coin/pages/splash_page/page.dart';
import 'package:card_coin/pages/webview_page/page.dart';
import 'package:card_coin/observability/otel_route_observer.dart';
import 'package:card_coin/reown_wallet/bottom_sheet/bottom_sheet_service.dart';
import 'package:card_coin/reown_wallet/bottom_sheet/i_bottom_sheet_service.dart';
import 'package:card_coin/reown_wallet/chain_services/evm_service.dart';
import 'package:card_coin/reown_wallet/key_service/i_key_service.dart';
import 'package:card_coin/reown_wallet/key_service/key_service.dart';
import 'package:card_coin/reown_wallet/walletkit_service.dart';
import 'package:card_coin/utils/card_coin_util.dart';
import 'package:card_coin/utils/login_util.dart';
import 'package:card_coin/utils/startup_time.dart';
import 'package:card_coin/widget/app_config.dart';
import 'package:common_utils/common_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action, Page;
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';

// import 'package:network_capture/view/network_capture_app.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:sharetrace_flutter_plugin/sharetrace_flutter_plugin.dart';
import 'cache/local_storage.dart';
import 'card_base/pages/activate_detail_page/page.dart';
import 'card_base/pages/bind_email_page/page.dart';
import 'card_base/pages/bind_phone_page/page.dart';
import 'card_base/pages/card_wallet_list_page/page.dart';
import 'card_base/pages/clean_cache_page/page.dart';
import 'card_base/pages/common_info_page/page.dart';
import 'card_base/pages/crop_image_page/page.dart';
import 'card_base/pages/device_activate_page/page.dart';
import 'card_base/pages/forgot_password/page.dart';
import 'card_base/pages/html_text_page/page.dart';
import 'card_base/pages/invite_list_page/page.dart';
import 'card_base/pages/main_page/tab_pages/tab_share_page/page.dart';
import 'card_base/pages/main_page/tab_pages/tab_wallet_page/group_card_page/group_card_detail_page/page.dart';
import 'card_base/pages/main_page/tab_pages/tab_wallet_page/group_card_page/page.dart';
import 'card_base/pages/main_page/tab_pages/tab_wallet_page/my_card_page/page.dart';
import 'card_base/pages/main_page/tab_pages/tab_wallet_page/page.dart';
import 'card_base/pages/main_page/tab_pages/tab_webview_page/page.dart';
import 'card_base/pages/member_page/page.dart';
import 'card_base/pages/message_manager_page/notice_detail_page/page.dart';
import 'card_base/pages/message_manager_page/page.dart';
import 'card_base/pages/multiple_login_page/email_otp_page/page.dart';
import 'card_base/pages/multiple_login_page/email_password_page/page.dart';
import 'card_base/pages/multiple_login_page/page.dart';
import 'card_base/pages/multiple_login_page/phone_otp_page/page.dart';
import 'card_base/pages/multiple_login_page/phone_password_page/page.dart';
import 'card_base/pages/register_page/email_register_page/page.dart';
import 'card_base/pages/register_page/page.dart';
import 'card_base/pages/register_page/phone_register_page/page.dart';
import 'card_base/pages/scan_login_page/page.dart';
import 'card_base/pages/set_password_page/page.dart';
import 'card_base/pages/settings_page/card_manager_page/page.dart';
import 'card_base/pages/settings_page/network_check_page/page.dart';
import 'card_base/pages/update_password_page/page.dart';
import 'card_base/widgets/pop_window.dart';
import 'global_store/action.dart';
import 'global_store/state.dart';
import 'global_store/store.dart';
import 'pages/main_page/address_book_page/page.dart';
import 'pages/main_page/backup_data_page/create_backup_page/page.dart';
import 'pages/main_page/backup_data_page/page.dart';

// import 'pages/main_page/hd_wallet_page/select_blockchain_page/page.dart';
import 'pages/main_page/hd_wallet_page/transaction_detail_page/page.dart';
import 'pages/main_page/lightning_net_detail_page/withdraw_lightning_page/page.dart';
import 'pages/main_page/page.dart';
import 'pages/main_page/reset_factory_settings_page/page.dart';
import 'pages/main_page/reset_info_page/page.dart';
import 'pages/main_page/settings_page/asset_settings_page/page.dart';
import 'pages/main_page/settings_page/encrypt_check_page/page.dart';
import 'pages/main_page/write_card_page/page.dart';

// import 'package:flutter_bugly/flutter_bugly.dart';
import 'card_base/pages/main_page/page.dart' as card_base_main;
import 'card_base/pages/settings_page/page.dart' as card_base_settings;
import 'pigeons/blockchain_platform_interface.dart';
import 'reown_wallet/deep_link_handler.dart';
import 'reown_wallet/i_walletkit_service.dart';
import 'reown_wallet/key_service/chain_key.dart';
import 'reown_wallet/models/chain_data.dart';
import 'utils/deep_link_manager.dart';

// Color mainColor = Color(0xFF2337f9);
RouteObserver<PopRoute> routeObserver = RouteObserver<PopRoute>();
final OtelRouteObserver otelRouteObserver = OtelRouteObserver();

class AppRoute {
  static AbstractRoutes? _global;

  // 手动维护所有路由名称列表（和 pages 中的key保持一致）
  static final List<String> _allRoutes = [
    'mainPage',
    'cardBaseMainPage',
    'splashPage',
    'loginPage',
    'registerPage',
    'settingsPage',
    'scanQrcodePage',
    'hdRechargePage',
    'hdSendPage',
    'transactionDetailPage',
    'pinCodeInfoPage',
    'setPinCodePage',
    'cancelPinCodePage',
    'unlockPinCodePage',
    'writeCardPage',
    'writeNtagPage',
    'webviewPage',
    'appVersionPage',
    'createNewWalletPage',
    'resetInfoPage',
    'resetFactorySettingsPage',
    'cleanCachePage',
    'backupDataPage',
    'deviceSettingsPage',
    'createBackupPage',
    'addressBookPage',
    'editAddressBookPage',
    'hdWalletListPage',
    'cardWalletListPage',
    'selectCurrencyPage',
    'selectFiatPage',
    'hdRechargeMainPage',
    'scanWalletPage',
    'scanLoginPage',
    'tabWalletPage',
    'multipleLoginPage',
    'emailPasswordPage',
    'phonePasswordPage',
    'emailOtpPage',
    'phoneOtpPage',
    'emailRegisterPage',
    'phoneRegisterPage',
    'myCardPage',
    'groupCardPage',
    'tabWebviewPage',
    'cardBaseSettingsPage',
    'cardManagerPage',
    'bindEmailPage',
    'updatePasswordPage',
    'messageManagerPage',
    'noticeDetailPage',
    'groupCardDetailPage',
    'memberPage',
    'inviteListPage',
    'tabSharePage',
    'forgotPasswordPage',
    'commonInfoPage',
    'bindPhonePage',
    'setPasswordPage',
    'cropImagePage',
    'htmlTextPage',
    'memberPointsPage',
    'checkCardPage',
    'lightningNetDetailPage',
    'encryptCheckPage',
    'deviceActivatePage',
    'emailActivatePage',
    'phoneActivatePage',
    'changeLanguagePage',
    'activateDetailPage',
    'lightNetInvoicePage',
    'invoiceEditPage',
    'sendLightningInvoicePage',
    'allActivatePage',
    'singleActivatePage',
    'packageActivatePage',
    'selectedActivatePage',
    'assetSettingsPage',
    'networkCheckPage',
    'lightningRewardsPage',
    'investmentPage',
    'investmentHandlePage',
    'investmentHistoryPage',
    'investmentCoinPage',
    'investmentBalancePage',
    'investmentWithdrawalPage',
    'investmentActivePage',
    'investmentProcessPage',
    'investmentSingleDetailPage',
    'withdrawLightningPage',
    'myAssetPage',
    'exchangePage',
    'convertHistoryPage',
    'convertDetailPage',
    'cashOutPage',
    'cashOutHistoryPage',
    'cashOutDetailPage',
    'withdrawBankPage',
    'flowHistoryPage',
    'biometricsPage',
    'coinMessageDetailPage',
    'coinMessageListPage',
    'addBlessPage',
    'errorTipPage', // 新增的错误页面
  ];

  static AbstractRoutes get global {
    _global ??= PageRoutes(
      pages: <String, Page<Object, dynamic>>{
        'errorTipPage': ErrorTipPage(),
        'mainPage': MainPage(),
        'cardBaseMainPage': card_base_main.MainPage(),
        'splashPage': SplashPage(),
        // 'hdWalletPage': HdWalletPage(),
        'loginPage': LoginPage(),
        'registerPage': RegisterPage(),
        'settingsPage': SettingsPage(),
        // 'selectBlockchainPage': SelectBlockchainPage(),
        'scanQrcodePage': ScanQrcodePage(),
        'hdRechargePage': HdRechargePage(),
        'hdSendPage': HdSendPage(),
        'transactionDetailPage': TransactionDetailPage(),
        'pinCodeInfoPage': PinCodeInfoPage(),
        'setPinCodePage': SetPinCodePage(),
        'cancelPinCodePage': CancelPinCodePage(),
        'unlockPinCodePage': UnlockPinCodePage(),
        'writeCardPage': WriteCardPage(),
        'writeNtagPage': WriteNtagPage(),
        'webviewPage': WebviewPage(),
        'appVersionPage': AppVersionPage(),
        'createNewWalletPage': CreateNewWalletPage(),
        'resetInfoPage': ResetInfoPage(),
        'resetFactorySettingsPage': ResetFactorySettingsPage(),
        'cleanCachePage': CleanCachePage(),
        'backupDataPage': BackupDataPage(),
        'deviceSettingsPage': DeviceSettingsPage(),
        'createBackupPage': CreateBackupPage(),
        'addressBookPage': AddressBookPage(),
        'editAddressBookPage': EditAddressBookPage(),
        'hdWalletListPage': HDWalletListPage(),
        'cardWalletListPage': CardWalletListPage(),
        'selectCurrencyPage': SelectCurrencyPage(),
        'selectFiatPage': SelectFiatPage(),
        'hdRechargeMainPage': HdRechargeMainPage(),
        'scanWalletPage': ScanWalletPage(),
        'scanLoginPage': ScanLoginPage(),
        'tabWalletPage': TabWalletPage(),
        'multipleLoginPage': MultipleLoginPage(),
        'emailPasswordPage': EmailPasswordPage(),
        'phonePasswordPage': PhonePasswordPage(),
        'emailOtpPage': EmailOtpPage(),
        'phoneOtpPage': PhoneOtpPage(),
        'emailRegisterPage': EmailRegisterPage(),
        'phoneRegisterPage': PhoneRegisterPage(),
        'myCardPage': MyCardPage(),
        'groupCardPage': GroupCardPage(),
        'tabWebviewPage': TabWebviewPage(),
        'cardBaseSettingsPage': card_base_settings.SettingsPage(),
        'cardManagerPage': CardManagerPage(),
        'bindEmailPage': BindEmailPage(),
        'updatePasswordPage': UpdatePasswordPage(),
        'messageManagerPage': MessageManagerPage(),
        'noticeDetailPage': NoticeDetailPage(),
        'groupCardDetailPage': GroupCardDetailPage(),
        'memberPage': MemberPage(),
        'inviteListPage': InviteListPage(),
        'tabSharePage': TabSharePage(),
        'forgotPasswordPage': ForgotPasswordPage(),
        'commonInfoPage': CommonInfoPage(),
        'bindPhonePage': BindPhonePage(),
        'setPasswordPage': SetPasswordPage(),
        'cropImagePage': CropImagePage(),
        'htmlTextPage': HtmlTextPage(),
        'memberPointsPage': MemberPointsPage(),
        'checkCardPage': CheckCardPage(),
        'lightningNetDetailPage': LightningNetDetailPage(),
        'encryptCheckPage': EncryptCheckPage(),
        'deviceActivatePage': DeviceActivatePage(),
        'emailActivatePage': EmailActivatePage(),
        'phoneActivatePage': PhoneActivatePage(),
        'changeLanguagePage': ChangeLanguagePage(),
        'activateDetailPage': ActivateDetailPage(),
        "lightNetInvoicePage": LightNetInvoicePage(),
        "invoiceEditPage": InvoiceEditPage(),
        'sendLightningInvoicePage': SendLightningInvoicePage(),
        'allActivatePage': AllActivatePage(),
        'singleActivatePage': SingleActivatePage(),
        'packageActivatePage': PackageActivatePage(),
        'selectedActivatePage': SelectedActivatePage(),
        'assetSettingsPage': AssetSettingsPage(),
        'networkCheckPage': NetworkCheckPage(),
        'lightningRewardsPage': LightningRewardsPage(),
        'investmentPage': InvestmentPage(),
        'investmentHandlePage': InvestmentHandlePage(),
        'investmentHistoryPage': InvestmentHistoryPage(),
        'investmentCoinPage': InvestmentCoinPage(),
        'investmentBalancePage': InvestmentBalancePage(),
        'investmentWithdrawalPage': InvestmentWithdrawalPage(),
        'investmentActivePage': InvestmentActivePage(),
        'investmentProcessPage': InvestmentProcessPage(),
        'investmentSingleDetailPage': InvestmentSingleDetailPage(),
        'withdrawLightningPage': WithdrawLightningPage(),
        'myAssetPage': MyAssetPage(),
        'exchangePage': ExchangePage(),
        'convertHistoryPage': ConvertHistoryPage(),
        'convertDetailPage': ConvertDetailPage(),
        'cashOutPage': CashOutPage(),
        'cashOutHistoryPage': CashOutHistoryPage(),
        'cashOutDetailPage': CashOutDetailPage(),
        'withdrawBankPage': WithdrawBankPage(),
        'flowHistoryPage': FlowHistoryPage(),
        'biometricsPage': BiometricsPage(),
        'coinMessageDetailPage': CoinMessageDetailPage(),
        'coinMessageListPage': CoinMessageListPage(),
        'addBlessPage': AddBlessPage(),
      },
      visitor: (String path, Page<Object, dynamic> page) {
        /// 只有特定的范围的 Page 才需要建立和 AppStore 的连接关系
        /// 满足 Page<T> ，T 是 GlobalBaseState 的子类
        if (page.isTypeof<GlobalBaseState>()) {
          /// 建立 AppStore 驱动 PageStore 的单向数据连接
          /// 1. 参数1 AppStore
          /// 2. 参数2 当 AppStore.state 变化时, PageStore.state 该如何变化
          page.connectExtraStore<GlobalState>(GlobalStore.store,
              (Object pagestate, GlobalState appState) {
            final GlobalBaseState p = pagestate as dynamic;
            if (p.languageResource != appState.languageResource) {
              if (pagestate is Cloneable) {
                final dynamic copy = pagestate.clone();
                final GlobalBaseState newState = copy;
                newState.languageLocale = appState.languageLocale;
                newState.languageResource = appState.languageResource;
                return newState;
              }
            }
            return pagestate;
          });
        }
      },
    );

    return _global!;
  }

  /// 检查路由是否存在（基于手动维护的列表）
  static bool isRouteExist(String routeName) {
    return _allRoutes.contains(routeName);
  }

  // // ===== 新增：带登录校验的安全跳转 =====
  // /// 带登录校验的页面跳转（支持清除历史栈）
  // static Future<void> pushNamedWithAuthCheck({
  //   required BuildContext context,
  //   required String routeName,
  //   RoutePredicate? predicate,
  //   Object? arguments,
  //   String? errorMessage,
  // }) async {
  //   // 1. 先检查路由是否存在
  //   if (!isRouteExist(routeName)) {
  //     Navigator.pushNamed(
  //       context,
  //       'errorTipPage',
  //       arguments: {
  //         'errorMessage': errorMessage ?? 'Page: "$routeName" no find',
  //         'returnRoute': 'splashPage',
  //       },
  //     );
  //     return;
  //   }

  //   // 2. 检查该路由是否需要登录
  //   if (LoginAuthUtil.isRouteNeedLogin(routeName)) {
  //     bool isLogin = await LoginAuthUtil.isLogin();

  //     if (!isLogin) {
  //       // 未登录：记录目标页面，跳转到登录页
  //       await LoginAuthUtil.saveTargetRoute(routeName, arguments: arguments);

  //       // 跳转到登录页，并等待登录结果
  //       bool? loginSuccess =
  //           await Navigator.pushNamed(context, 'multipleLoginPage') as bool?;

  //       if (loginSuccess != true) {
  //         // 登录取消/失败，不跳转
  //         return;
  //       }
  //     }
  //   }

  //   // 3. 路由存在且登录状态满足，执行跳转
  //   if (predicate != null) {
  //     // 清除历史栈的跳转（如你的cardBaseMainPage场景）
  //     Navigator.pushNamedAndRemoveUntil(
  //       context,
  //       routeName,
  //       predicate,
  //       arguments: arguments,
  //     );
  //   } else {
  //     // 普通跳转
  //     Navigator.pushNamed(
  //       context,
  //       routeName,
  //       arguments: arguments,
  //     );
  //   }
  // }
}

Future<void> mainCommon() async {
  StartupTime.markAppStartIfNeeded();
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  LogUtil.init(isDebug: true);
  DartPingIOS.register();

  //锁定竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (Platform.isAndroid) {
    // 设置状态栏背景及颜色
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Color(0x00F58A1F));
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    // SystemChrome.setEnabledSystemUIOverlays([]); //隐藏状态栏

    // AndroidWebView（TextureView）通过 Flutter 帧管线合成，不存在 SurfaceView
    // Z-order 黑屏问题。SurfaceAndroidWebView 虽可减少帧丢失，但在 fish_redux
    // dispatch 触发 overlay 重建时会导致 WebView 区域永久黑屏，已确认为
    // flutter/flutter#74765 已知问题，故回退使用 AndroidWebView。
    WebView.platform = AndroidWebView();
  }

  var locale = await LocalStorage.getLocale();
  if (locale != null) {
    GlobalStore.store.dispatch(GlobalActionCreator.onChangeLanguage(locale));
  } else {
    const defaultLocale = Locale('en', 'US');
    LocalStorage.saveLocale(defaultLocale);
    GlobalStore.store
        .dispatch(GlobalActionCreator.onChangeLanguage(defaultLocale));
  }

  // Startup async task: refresh default stablecoin every launch, but do not block app flow.
  unawaited(DefaultStablecoinManager.refreshFromServer());

  DeepLinkHandler.initListener();
  StartupTime.printElapsed('main_common_ready');
}

/// 创建应用的根 Widget
/// 1. 创建一个简单的路由，并注册页面
/// 2. 对所需的页面进行和 AppStore 的连接
/// 3. 对所需的页面进行 AOP 的增强

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

bool isInitBTC = false;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  bool showNetworkException = false;

  // final AppLinks _appLinks = AppLinks(); // 初始化 app_links 实例
  // String? _initialLink; // App启动时的初始深度链接
  // String? _latestLink; // App运行时接收到的最新深度链接

  String installInfo = '';
  String wakeupInfo = '';

  @override
  void initState() {
    super.initState();
    StartupTime.mark('myapp_initstate_begin');
    _checkConnectivity();
    _subscribeToConnectivityChanges();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 延后非关键路径初始化，避免首屏阶段产生额外卡顿
      unawaited(Future<void>.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        _sharetraceHandle();
      }));
      // DeepLink 初始化：在第一帧渲染完成后立即启动，
      // 不依赖 fish_redux 的 SplashPage.Lifecycle.initState，
      // 避免初始路由时序问题导致 DeepLinkManager 未被调用。
      DeepLinkManager().init();
    });
    StartupTime.mark('myapp_before_initialize');
    initialize();
    StartupTime.mark('myapp_after_initialize');
  }

  /// 获取App启动时的深度链接（冷启动/后台唤起）
  // Future<void> _getInitialLink() async {
  //   try {
  //     final uri = await _appLinks.getInitialAppLink();
  //     if (uri != null) {
  //       setState(() => _initialLink = uri.toString());
  //       // 处理启动链接，跳转到对应页面
  //       _handleDeepLink(uri);
  //     }
  //   } catch (e) {
  //     print('获取初始链接失败：$e');
  //   }
  // }

  /// 监听App运行时的深度链接
  // void _listenToLinks() {
  //   _appLinks.uriLinkStream.listen(
  //     (Uri uri) {
  //       if (uri != null) {
  //         setState(() => _latestLink = uri.toString());
  //         // 处理实时接收到的链接
  //         _handleDeepLink(uri);
  //       }
  //     },
  //     onError: (e) {
  //       print('监听链接出错：$e');
  //     },
  //   );
  // }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _subscribeToConnectivityChanges() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    setState(() {
      // 任何一个网络状态为 none 都显示无网络
      var result = ConnectivityResult.other;
      for (var r in results) {
        if (r == ConnectivityResult.none) {
          result = r;
          break;
        }
      }
      showNetworkException = result == ConnectivityResult.none;
    });
  }

  void _sharetraceHandle() {
    StartupTime.mark('sharetrace_handle_begin');
    final sharetrace = SharetraceFlutterPlugin.getInstance();
    sharetrace.init();
    print("_sharetraceHandle_init");
    StartupTime.mark('sharetrace_init_done');
    sharetrace.getInstallTrace((data) async {
      // 1️⃣ 启动阶段稍微延迟（可选）
      await Future.delayed(const Duration(milliseconds: 1000));

      final rawParams = data['paramsData'];
      if (rawParams == null) return;

      final params = Uri.parse(
        'https://dummy.com/?$rawParams',
      ).queryParameters;

      String? instantStatus =
          await LocalStorage.getString("inatall_trace_uid") ?? "";
      // 2️⃣ 发网络请求（重点）
      if (instantStatus.isEmpty) {
        await _sharetracInstallHandle(params);
      }

      // 3️⃣ UI 更新（同步）
      if (!mounted) return;
      // setState(() {
      //   installInfo = data.toString();
      //  // showToast("getInstallTrace:$params");
      // });

      print("getInstallTrace:$params");
    });

    // sharetrace.registerWakeupHandler((data) async {
    //   await Future.delayed(const Duration(milliseconds: 1000));
    //   setState(() {
    //     showToast("getWakeupTrace:$data");
    //   });
    // });
  }

  Future<void> _sharetracInstallHandle(Map<String, String> params) async {
    bool saveSuccess1 = await LocalStorage.saveString(
        "inatall_trace_taskItemId", params['taskItemId'] ?? '');
    saveSuccess1;
    bool saveSuccess2 = await LocalStorage.saveString(
        "inatall_trace_channelUid", params['uid'] ?? '');
    saveSuccess2;
    ResultData allcryptoResult = await HttpManager.getInstance()
        .post(NetworkAddress.smartCardAppInstall, null, data: {
      'uid': params['uid'] ?? '',
      'taskItemId': params['taskItemId'] ?? '',
      'channelId': params['c'] ?? '',
      'channelSubId': params['s'] ?? '',
      'deviceId': await CardCoinUtil.getDeviceId()
    });
    if (allcryptoResult.isSuccess) {
      print("smartCardAppInstall success");
      bool saveSuccess =
          await LocalStorage.saveString("inatall_trace_uid", "1");
      print("save install trace uid success: $saveSuccess");
    } else {
      print("smartCardAppInstall failed :${allcryptoResult.message}");
    }
  }

  Future<void> initialize() async {
    GetIt.I.registerSingleton<IBottomSheetService>(BottomSheetService());
    final keyService = KeyService();
    GetIt.I.registerSingleton<IKeyService>(keyService);
    final walletKitService = WalletKitService();
    GetIt.I.registerSingleton<IWalletKitService>(walletKitService);
    var cardId = await LocalStorage.getString('dapp_cardId');
    if (cardId != null) {
      final blockchains =
          ChainsDataList.eip155Chains.map((e) => e.blockchainId).toList();
      List<ChainKey> chainKeys =
          await BlockchainPlatform.instance.getChainKeys(cardId, blockchains);
      if (chainKeys.isNotEmpty) {
        keyService.updateCardKeys(cardId, chainKeys);
        await walletKitService.create();
        for (final chainData in ChainsDataList.eip155Chains) {
          GetIt.I.registerSingleton<EVMService>(
            EVMService(chainSupported: chainData),
            instanceName: chainData.chainId,
          );
        }

        await walletKitService.init();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    StartupTime.mark('myapp_build_begin');
    var globalState = GlobalStore.store.getState();
    var appConfig = AppConfig.of(context);
    // FnPanel.setConfig(FnConfig(
    //     level: Level.release,
    //     globalButtonConfig: FnGlobalButtonConfig(bottom: 100)));
    final languageResource = globalState.languageResource;

    return OKToast(
      position: ToastPosition.center,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: appConfig.appDisplayName,
        debugShowCheckedModeBanner: true,
        navigatorObservers: [routeObserver, otelRouteObserver],
        theme: ThemeData(useMaterial3: false).copyWith(
            extensions: <ThemeExtension<dynamic>>[
              GradientTheme(primaryGradient: AppThemeConfig.gradient),
            ],
            brightness: Brightness.light, //控件颜色模式Light
            primaryColor: Colors.black, //设置主题色为黑色即可
            appBarTheme: ThemeData(useMaterial3: false).appBarTheme.copyWith(
                backgroundColor: AppThemeConfig.appBarBackground,
                foregroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.white),
                titleTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 20))),
        builder: EasyLoading.init(
            builder: (context, child) => Scaffold(
                  appBar: showNetworkException
                      ? PreferredSize(
                          preferredSize: const Size(double.infinity, 40),
                          child: SafeArea(
                            child: Container(
                              padding: const EdgeInsets.only(left: 14),
                              height: 100,
                              alignment: Alignment.centerLeft,
                              decoration:
                                  BoxDecoration(color: Colors.red.shade200),
                              child: Row(
                                children: [
                                  LoadAssetImage(
                                    'warning',
                                    width: 20,
                                    height: 20,
                                    color: Colors.red.shade800,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Expanded(
                                    child: Text(
                                      languageResource?.noPhoneNetwork ?? '',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.black,
                                        size: 20,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        )
                      : null,
                  body: GestureDetector(
                    onTap: () {
                      FocusScopeNode focusScopeNode = FocusScope.of(context);
                      if (!focusScopeNode.hasPrimaryFocus &&
                          focusScopeNode.focusedChild != null) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                    },
                    child: child,
                  ),
                )),
        locale: globalState.languageLocale ?? const Locale('en', 'US'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback:
            (Locale? locale, Iterable<Locale> supportedLocales) {
          var languageLocale = GlobalStore.store.getState().languageLocale;
          // 用户未选择语言时默认英文，不跟随系统语言。
          languageLocale ??= const Locale('en', 'US');
          GlobalStore.store
              .dispatch(GlobalActionCreator.onChangeLanguage(languageLocale));
          return languageLocale;
        },
        onGenerateRoute: (RouteSettings settings) {
          // 全局路由检查
          String routeName = settings.name ?? '';

          // Deep Link 路由检测：
          // 冷启动 → Flutter 推入完整 URL：https://asset.dropromo.com/?target=...
          // 热启动 → Flutter 引擎只取路径部分：/?target=...（不含 host）
          // 两种形式都需要处理。
          Uri? _deepLinkUri;
          if (routeName.startsWith('http://') ||
              routeName.startsWith('https://')) {
            _deepLinkUri = Uri.tryParse(routeName);
          } else if (routeName.startsWith('/') &&
              routeName.contains('target=')) {
            // 热启动路径形式，补全为可解析的 URI
            _deepLinkUri = Uri.tryParse('https://placeholder.com$routeName');
          }

          if (_deepLinkUri != null) {
            final target = _deepLinkUri.queryParameters['target'] ?? '';

            if (target.isNotEmpty && AppRoute.isRouteExist(target)) {
              // 无论冷启动还是热启动，统一立即弹出，交给 DeepLinkManager 处理：
              // • 冷启动：SplashPage 正常运行完成（跳到 cardBaseMainPage）后，
              //   DeepLinkManager 等待主页就绪，推入 目标页（栈：[cardBaseMainPage, target]）
              // • 热启动：uriLinkStream 触发，DeepLinkManager 等 80ms 后推入目标页
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (context) => const _AutoPopPage(),
              );
            } else {
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (context) => const _AutoPopPage(),
              );
            }
          }

          // 全局路由不存在检查
          if (!AppRoute.isRouteExist(settings.name ?? '')) {
            print('Route not found: ${settings.name}');
            settings = RouteSettings(
              name: 'errorTipPage',
              arguments: {
                'errorMessage': 'Page: "${settings.name}" not found',
                'returnRoute': 'splashPage',
              },
            );
          }
          // 2. 路由需要登录但未登录：跳转到登录页
          else if (LoginAuthUtil.isRouteNeedLogin(routeName)) {
            // 注意：这里需要用异步判断，所以需要特殊处理
            return MaterialPageRoute(
              builder: (context) => FutureBuilder<bool>(
                future: LoginAuthUtil.isLogin(),
                builder: (context, snapshot) {
                  if (snapshot.data == false) {
                    // 未登录：记录目标页面并跳转到登录页
                    LoginAuthUtil.saveTargetRoute(routeName,
                        arguments: settings.arguments);
                    return AppRoute.global.buildPage('multipleLoginPage', null);
                  }
                  // 已登录：正常显示目标页面
                  return AppRoute.global
                      .buildPage(routeName, settings.arguments);
                },
              ),
              settings: settings,
            );
          }

          return MaterialPageRoute<Object>(
              builder: (BuildContext context) {
                return AppRoute.global
                    .buildPage(settings.name!, settings.arguments);
              },
              settings: settings);
        },
        home: AppRoute.global.buildPage('splashPage', null),
      ),
    );
  }
}

/// Deep Link 占位页：被推入后立即弹出，让导航栈回到正常状态。
/// DeepLinkManager 负责在主页就绪后推入真正的目标页面。
class _AutoPopPage extends StatefulWidget {
  const _AutoPopPage();

  @override
  State<_AutoPopPage> createState() => _AutoPopPageState();
}

class _AutoPopPageState extends State<_AutoPopPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (Navigator.canPop(context)) {
        // 热启动：_AutoPopPage 在栈顶（现有路由之上），pop 回之前的页面
        Navigator.pop(context);
      }
      // 冷启动：_AutoPopPage 在栈底，splashPage 在栈顶（用户看到的是 splashPage）
      // canPop = false，不 pop，等 SplashPage 的 pushNamedAndRemoveUntil 把它一起清掉
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
