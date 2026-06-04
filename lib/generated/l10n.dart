// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Connection timeout`
  String get network_connect_timeout {
    return Intl.message(
      'Connection timeout',
      name: 'network_connect_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Request timeout`
  String get network_request_timeout {
    return Intl.message(
      'Request timeout',
      name: 'network_request_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Response timeout`
  String get network_response_timeout {
    return Intl.message(
      'Response timeout',
      name: 'network_response_timeout',
      desc: '',
      args: [],
    );
  }

  /// `The remote server or network is abnormal, please try again later.`
  String get remote_server_or_network_is_abnormal {
    return Intl.message(
      'The remote server or network is abnormal, please try again later.',
      name: 'remote_server_or_network_is_abnormal',
      desc: '',
      args: [],
    );
  }

  /// `The login status has expired, please login again.`
  String get login_status_expired {
    return Intl.message(
      'The login status has expired, please login again.',
      name: 'login_status_expired',
      desc: '',
      args: [],
    );
  }

  /// `The server is being updated, please try again later.`
  String get server_upgrade {
    return Intl.message(
      'The server is being updated, please try again later.',
      name: 'server_upgrade',
      desc: '',
      args: [],
    );
  }

  /// `The server is busy, please try again later.`
  String get server_is_busy {
    return Intl.message(
      'The server is busy, please try again later.',
      name: 'server_is_busy',
      desc: '',
      args: [],
    );
  }

  /// `Cancel the request`
  String get cancel_request {
    return Intl.message(
      'Cancel the request',
      name: 'cancel_request',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get unknown_mistake {
    return Intl.message(
      'Unknown error',
      name: 'unknown_mistake',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get unknown_error {
    return Intl.message(
      'Unknown error',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `Remote server or network failed, Please try again later.`
  String get error_code_bad_request {
    return Intl.message(
      'Remote server or network failed, Please try again later.',
      name: 'error_code_bad_request',
      desc: '',
      args: [],
    );
  }

  /// `List is empty`
  String get nulllist {
    return Intl.message('List is empty', name: 'nulllist', desc: '', args: []);
  }

  /// `Reload`
  String get reload {
    return Intl.message('Reload', name: 'reload', desc: '', args: []);
  }

  /// `Unable to connect to the network, please try again`
  String get network_error {
    return Intl.message(
      'Unable to connect to the network, please try again',
      name: 'network_error',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get comfirm {
    return Intl.message('Confirm', name: 'comfirm', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Tips`
  String get tips {
    return Intl.message('Tips', name: 'tips', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `No records`
  String get noRecords {
    return Intl.message('No records', name: 'noRecords', desc: '', args: []);
  }

  /// `Product with Risk`
  String get riskProduct {
    return Intl.message(
      'Product with Risk',
      name: 'riskProduct',
      desc: '',
      args: [],
    );
  }

  /// `Currently Stable`
  String get currentStable {
    return Intl.message(
      'Currently Stable',
      name: 'currentStable',
      desc: '',
      args: [],
    );
  }

  /// `How much {coin} do you want to  buy?`
  String wantBuy(Object coin) {
    return Intl.message(
      'How much $coin do you want to  buy?',
      name: 'wantBuy',
      desc: '',
      args: [coin],
    );
  }

  /// `SELL`
  String get sellCapital {
    return Intl.message('SELL', name: 'sellCapital', desc: '', args: []);
  }

  /// `BUY`
  String get buyCapital {
    return Intl.message('BUY', name: 'buyCapital', desc: '', args: []);
  }

  /// `Spot`
  String get spot {
    return Intl.message('Spot', name: 'spot', desc: '', args: []);
  }

  /// `Wallet`
  String get wallet {
    return Intl.message('Wallet', name: 'wallet', desc: '', args: []);
  }

  /// `Demo`
  String get demo {
    return Intl.message('Demo', name: 'demo', desc: '', args: []);
  }

  /// `Riil`
  String get riil {
    return Intl.message('Riil', name: 'riil', desc: '', args: []);
  }

  /// `Akun`
  String get akun {
    return Intl.message('Akun', name: 'akun', desc: '', args: []);
  }

  /// `Saving and Earning Coin, Guarantee Profit`
  String get earnCoin {
    return Intl.message(
      'Saving and Earning Coin, Guarantee Profit',
      name: 'earnCoin',
      desc: '',
      args: [],
    );
  }

  /// `Invest`
  String get invest {
    return Intl.message('Invest', name: 'invest', desc: '', args: []);
  }

  /// `Not logged in/Click to login`
  String get notLogged {
    return Intl.message(
      'Not logged in/Click to login',
      name: 'notLogged',
      desc: '',
      args: [],
    );
  }

  /// `USDT Address`
  String get usdtAddress {
    return Intl.message(
      'USDT Address',
      name: 'usdtAddress',
      desc: '',
      args: [],
    );
  }

  /// `Input USDT address`
  String get inputUsdtAddress {
    return Intl.message(
      'Input USDT address',
      name: 'inputUsdtAddress',
      desc: '',
      args: [],
    );
  }

  /// `Edit USDT Address`
  String get editUsdtAddress {
    return Intl.message(
      'Edit USDT Address',
      name: 'editUsdtAddress',
      desc: '',
      args: [],
    );
  }

  /// `Add USDT Address`
  String get addUsdtAddress {
    return Intl.message(
      'Add USDT Address',
      name: 'addUsdtAddress',
      desc: '',
      args: [],
    );
  }

  /// `Bind Bank`
  String get bindBank {
    return Intl.message('Bind Bank', name: 'bindBank', desc: '', args: []);
  }

  /// `No Account Added`
  String get noAccount {
    return Intl.message(
      'No Account Added',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `ADD`
  String get addCapital {
    return Intl.message('ADD', name: 'addCapital', desc: '', args: []);
  }

  /// `Bank Type`
  String get bankType {
    return Intl.message('Bank Type', name: 'bankType', desc: '', args: []);
  }

  /// `Choose Bank Type`
  String get chooseBankType {
    return Intl.message(
      'Choose Bank Type',
      name: 'chooseBankType',
      desc: '',
      args: [],
    );
  }

  /// `Account Number`
  String get accountNo {
    return Intl.message(
      'Account Number',
      name: 'accountNo',
      desc: '',
      args: [],
    );
  }

  /// `Input Account Number`
  String get inputAccount {
    return Intl.message(
      'Input Account Number',
      name: 'inputAccount',
      desc: '',
      args: [],
    );
  }

  /// `Choose bank`
  String get chooseBank {
    return Intl.message('Choose bank', name: 'chooseBank', desc: '', args: []);
  }

  /// `OCR verify`
  String get ocrVerify {
    return Intl.message('OCR verify', name: 'ocrVerify', desc: '', args: []);
  }

  /// `Withdraw records`
  String get withdrawRecords {
    return Intl.message(
      'Withdraw records',
      name: 'withdrawRecords',
      desc: '',
      args: [],
    );
  }

  /// `Invite friends`
  String get inviteFriends {
    return Intl.message(
      'Invite friends',
      name: 'inviteFriends',
      desc: '',
      args: [],
    );
  }

  /// `Invitation code:`
  String get invitationCode {
    return Intl.message(
      'Invitation code:',
      name: 'invitationCode',
      desc: '',
      args: [],
    );
  }

  /// `Copied success`
  String get copiedSuccess {
    return Intl.message(
      'Copied success',
      name: 'copiedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Invite friends now`
  String get inviteNow {
    return Intl.message(
      'Invite friends now',
      name: 'inviteNow',
      desc: '',
      args: [],
    );
  }

  /// `Link coppied success，spread and invite friends to join now！`
  String get coppiedLink {
    return Intl.message(
      'Link coppied success，spread and invite friends to join now！',
      name: 'coppiedLink',
      desc: '',
      args: [],
    );
  }

  /// `Invitation Bonus`
  String get invitationBonus {
    return Intl.message(
      'Invitation Bonus',
      name: 'invitationBonus',
      desc: '',
      args: [],
    );
  }

  /// `Number of Invitations`
  String get invitationNo {
    return Intl.message(
      'Number of Invitations',
      name: 'invitationNo',
      desc: '',
      args: [],
    );
  }

  /// `Bonus Details`
  String get bonusDetails {
    return Intl.message(
      'Bonus Details',
      name: 'bonusDetails',
      desc: '',
      args: [],
    );
  }

  /// `Total Bonus`
  String get totalBonus {
    return Intl.message('Total Bonus', name: 'totalBonus', desc: '', args: []);
  }

  /// `Can be withdraw`
  String get canWithdraw {
    return Intl.message(
      'Can be withdraw',
      name: 'canWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get withdraw {
    return Intl.message('Withdraw', name: 'withdraw', desc: '', args: []);
  }

  /// `Unsettlement`
  String get unsettlement {
    return Intl.message(
      'Unsettlement',
      name: 'unsettlement',
      desc: '',
      args: [],
    );
  }

  /// `Investment amount currently invited:`
  String get currentlyInvited {
    return Intl.message(
      'Investment amount currently invited:',
      name: 'currentlyInvited',
      desc: '',
      args: [],
    );
  }

  /// `Average daily investment amount`
  String get dailyInvestment {
    return Intl.message(
      'Average daily investment amount',
      name: 'dailyInvestment',
      desc: '',
      args: [],
    );
  }

  /// `List of invited users`
  String get userInvitedList {
    return Intl.message(
      'List of invited users',
      name: 'userInvitedList',
      desc: '',
      args: [],
    );
  }

  /// `Investment amount`
  String get investmentAmount {
    return Intl.message(
      'Investment amount',
      name: 'investmentAmount',
      desc: '',
      args: [],
    );
  }

  /// `Direct level`
  String get directLevel {
    return Intl.message(
      'Direct level',
      name: 'directLevel',
      desc: '',
      args: [],
    );
  }

  /// `Order bonus`
  String get orderBonus {
    return Intl.message('Order bonus', name: 'orderBonus', desc: '', args: []);
  }

  /// `My Invitation code`
  String get myInvitationCode {
    return Intl.message(
      'My Invitation code',
      name: 'myInvitationCode',
      desc: '',
      args: [],
    );
  }

  /// `My node`
  String get myNode {
    return Intl.message('My node', name: 'myNode', desc: '', args: []);
  }

  /// `Invited order`
  String get invitedOrder {
    return Intl.message(
      'Invited order',
      name: 'invitedOrder',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get level {
    return Intl.message('Level', name: 'level', desc: '', args: []);
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message('About Us', name: 'aboutUs', desc: '', args: []);
  }

  /// `Help`
  String get help {
    return Intl.message('Help', name: 'help', desc: '', args: []);
  }

  /// `Current user:`
  String get currentUser {
    return Intl.message(
      'Current user:',
      name: 'currentUser',
      desc: '',
      args: [],
    );
  }

  /// `Current version:`
  String get currentVersion {
    return Intl.message(
      'Current version:',
      name: 'currentVersion',
      desc: '',
      args: [],
    );
  }

  /// `language:`
  String get language {
    return Intl.message('language:', name: 'language', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Chinese`
  String get chinese {
    return Intl.message('Chinese', name: 'chinese', desc: '', args: []);
  }

  /// `Indonesia`
  String get indonesia {
    return Intl.message('Indonesia', name: 'indonesia', desc: '', args: []);
  }

  /// `Logout current account`
  String get logoutAccount {
    return Intl.message(
      'Logout current account',
      name: 'logoutAccount',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message('Setting', name: 'setting', desc: '', args: []);
  }

  /// `Invest Now`
  String get investNow {
    return Intl.message('Invest Now', name: 'investNow', desc: '', args: []);
  }

  /// `Annual Percentage Rate`
  String get annualRate {
    return Intl.message(
      'Annual Percentage Rate',
      name: 'annualRate',
      desc: '',
      args: [],
    );
  }

  /// `Investment introduction`
  String get investIntro {
    return Intl.message(
      'Investment introduction',
      name: 'investIntro',
      desc: '',
      args: [],
    );
  }

  /// `Return forecast`
  String get returnForecast {
    return Intl.message(
      'Return forecast',
      name: 'returnForecast',
      desc: '',
      args: [],
    );
  }

  /// `Daily Rate =`
  String get dailyRate {
    return Intl.message('Daily Rate =', name: 'dailyRate', desc: '', args: []);
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Refurn Forecast`
  String get refurnForecast {
    return Intl.message(
      'Refurn Forecast',
      name: 'refurnForecast',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message('Day', name: 'day', desc: '', args: []);
  }

  /// `Forecast Return for 30 day:`
  String get monthForecast {
    return Intl.message(
      'Forecast Return for 30 day:',
      name: 'monthForecast',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient Balance`
  String get insufficientBalance {
    return Intl.message(
      'Insufficient Balance',
      name: 'insufficientBalance',
      desc: '',
      args: [],
    );
  }

  /// `Investment amount must be integral times of 100`
  String get investTips {
    return Intl.message(
      'Investment amount must be integral times of 100',
      name: 'investTips',
      desc: '',
      args: [],
    );
  }

  /// `Loading…`
  String get loading {
    return Intl.message('Loading…', name: 'loading', desc: '', args: []);
  }

  /// `I want to `
  String get iWantTo {
    return Intl.message('I want to ', name: 'iWantTo', desc: '', args: []);
  }

  /// `Buy`
  String get buy {
    return Intl.message('Buy', name: 'buy', desc: '', args: []);
  }

  /// `Sell`
  String get sell {
    return Intl.message('Sell', name: 'sell', desc: '', args: []);
  }

  /// `Other Amount`
  String get otherAmount {
    return Intl.message(
      'Other Amount',
      name: 'otherAmount',
      desc: '',
      args: [],
    );
  }

  /// `Input Amount`
  String get inputAmount {
    return Intl.message(
      'Input Amount',
      name: 'inputAmount',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message('Balance', name: 'balance', desc: '', args: []);
  }

  /// `Into`
  String get into {
    return Intl.message('Into', name: 'into', desc: '', args: []);
  }

  /// `CONTINUE`
  String get continueStr {
    return Intl.message('CONTINUE', name: 'continueStr', desc: '', args: []);
  }

  /// `Total Net Assets Valuation`
  String get totalNetAssets {
    return Intl.message(
      'Total Net Assets Valuation',
      name: 'totalNetAssets',
      desc: '',
      args: [],
    );
  }

  /// `Cumulative Profit`
  String get cumulativeProfit {
    return Intl.message(
      'Cumulative Profit',
      name: 'cumulativeProfit',
      desc: '',
      args: [],
    );
  }

  /// `Rate of Return`
  String get rateOfReturn {
    return Intl.message(
      'Rate of Return',
      name: 'rateOfReturn',
      desc: '',
      args: [],
    );
  }

  /// `Fund Account`
  String get fundAccount {
    return Intl.message(
      'Fund Account',
      name: 'fundAccount',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Account`
  String get transactionAccount {
    return Intl.message(
      'Transaction Account',
      name: 'transactionAccount',
      desc: '',
      args: [],
    );
  }

  /// `Commission Account`
  String get commissionAccount {
    return Intl.message(
      'Commission Account',
      name: 'commissionAccount',
      desc: '',
      args: [],
    );
  }

  /// `Buy Product`
  String get buyProduct {
    return Intl.message('Buy Product', name: 'buyProduct', desc: '', args: []);
  }

  /// `Deposit`
  String get deposit {
    return Intl.message('Deposit', name: 'deposit', desc: '', args: []);
  }

  /// `Deposit Amount`
  String get depositAmount {
    return Intl.message(
      'Deposit Amount',
      name: 'depositAmount',
      desc: '',
      args: [],
    );
  }

  /// `Deposit Method`
  String get depositMethod {
    return Intl.message(
      'Deposit Method',
      name: 'depositMethod',
      desc: '',
      args: [],
    );
  }

  /// `Deposit Success`
  String get depositSuccess {
    return Intl.message(
      'Deposit Success',
      name: 'depositSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Deposit order information`
  String get depositOrderInfo {
    return Intl.message(
      'Deposit order information',
      name: 'depositOrderInfo',
      desc: '',
      args: [],
    );
  }

  /// `Warning:Only the repayment code generated inside this App is official and valid,please be aware of any Fraud!!!`
  String get depositTips {
    return Intl.message(
      'Warning:Only the repayment code generated inside this App is official and valid,please be aware of any Fraud!!!',
      name: 'depositTips',
      desc: '',
      args: [],
    );
  }

  /// `Repay Code`
  String get repayCode {
    return Intl.message('Repay Code', name: 'repayCode', desc: '', args: []);
  }

  /// `Total Payment`
  String get totalPayment {
    return Intl.message(
      'Total Payment',
      name: 'totalPayment',
      desc: '',
      args: [],
    );
  }

  /// `Deposit Reminder`
  String get depositReminder {
    return Intl.message(
      'Deposit Reminder',
      name: 'depositReminder',
      desc: '',
      args: [],
    );
  }

  /// `Balance Total Assets`
  String get balanceTotalAssets {
    return Intl.message(
      'Balance Total Assets',
      name: 'balanceTotalAssets',
      desc: '',
      args: [],
    );
  }

  /// `Balance History`
  String get balanceHistory {
    return Intl.message(
      'Balance History',
      name: 'balanceHistory',
      desc: '',
      args: [],
    );
  }

  /// `Identity authentication is required to withdraw cash. Do you want to authenticate now?`
  String get withdrawVerify {
    return Intl.message(
      'Identity authentication is required to withdraw cash. Do you want to authenticate now?',
      name: 'withdrawVerify',
      desc: '',
      args: [],
    );
  }

  /// `My Asset`
  String get myAsset {
    return Intl.message('My Asset', name: 'myAsset', desc: '', args: []);
  }

  /// `Today's Profit`
  String get todayProfit {
    return Intl.message(
      'Today\'s Profit',
      name: 'todayProfit',
      desc: '',
      args: [],
    );
  }

  /// `Profit / Loss Today`
  String get profitLossToday {
    return Intl.message(
      'Profit / Loss Today',
      name: 'profitLossToday',
      desc: '',
      args: [],
    );
  }

  /// `Profit`
  String get profit {
    return Intl.message('Profit', name: 'profit', desc: '', args: []);
  }

  /// `Increase`
  String get increase {
    return Intl.message('Increase', name: 'increase', desc: '', args: []);
  }

  /// `My Orders`
  String get myOrders {
    return Intl.message('My Orders', name: 'myOrders', desc: '', args: []);
  }

  /// `My Portfolio`
  String get myPortfolio {
    return Intl.message(
      'My Portfolio',
      name: 'myPortfolio',
      desc: '',
      args: [],
    );
  }

  /// `Press Again To Exit`
  String get againExit {
    return Intl.message(
      'Press Again To Exit',
      name: 'againExit',
      desc: '',
      args: [],
    );
  }

  /// `New Version Available, Update Now ?`
  String get upgradeTips {
    return Intl.message(
      'New Version Available, Update Now ?',
      name: 'upgradeTips',
      desc: '',
      args: [],
    );
  }

  /// `Update Now`
  String get upgradeNow {
    return Intl.message('Update Now', name: 'upgradeNow', desc: '', args: []);
  }

  /// `Upgrading...`
  String get upgrading {
    return Intl.message('Upgrading...', name: 'upgrading', desc: '', args: []);
  }

  /// `You Haven't Logged in, Please Login`
  String get noLogTips {
    return Intl.message(
      'You Haven\'t Logged in, Please Login',
      name: 'noLogTips',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Robust Fixed Income Asset`
  String get steadyAsset {
    return Intl.message(
      'Robust Fixed Income Asset',
      name: 'steadyAsset',
      desc: '',
      args: [],
    );
  }

  /// `ADIB bonus`
  String get adibBonus {
    return Intl.message('ADIB bonus', name: 'adibBonus', desc: '', args: []);
  }

  /// `You Have Completed OCR Verification`
  String get alreadyOCR {
    return Intl.message(
      'You Have Completed OCR Verification',
      name: 'alreadyOCR',
      desc: '',
      args: [],
    );
  }

  /// `OCR Verification Completed`
  String get successOCR {
    return Intl.message(
      'OCR Verification Completed',
      name: 'successOCR',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Loading failure`
  String get loadingFailure {
    return Intl.message(
      'Loading failure',
      name: 'loadingFailure',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Estimated Rate of Return`
  String get expectReturn {
    return Intl.message(
      'Estimated Rate of Return',
      name: 'expectReturn',
      desc: '',
      args: [],
    );
  }

  /// `Current Products`
  String get currentProduct {
    return Intl.message(
      'Current Products',
      name: 'currentProduct',
      desc: '',
      args: [],
    );
  }

  /// `Term`
  String get dueTime {
    return Intl.message('Term', name: 'dueTime', desc: '', args: []);
  }

  /// `Please input mobile number`
  String get inputMobile {
    return Intl.message(
      'Please input mobile number',
      name: 'inputMobile',
      desc: '',
      args: [],
    );
  }

  /// `Please input password`
  String get inputPassword {
    return Intl.message(
      'Please input password',
      name: 'inputPassword',
      desc: '',
      args: [],
    );
  }

  /// `Keep password`
  String get keepPassword {
    return Intl.message(
      'Keep password',
      name: 'keepPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgotPassword {
    return Intl.message(
      'Forgot password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Register now`
  String get registerNow {
    return Intl.message(
      'Register now',
      name: 'registerNow',
      desc: '',
      args: [],
    );
  }

  /// `Discount of the Month`
  String get monthlyCommission {
    return Intl.message(
      'Discount of the Month',
      name: 'monthlyCommission',
      desc: '',
      args: [],
    );
  }

  /// `Discount Ratio`
  String get bonusRatio {
    return Intl.message(
      'Discount Ratio',
      name: 'bonusRatio',
      desc: '',
      args: [],
    );
  }

  /// `return of yesterday`
  String get returnYesterday {
    return Intl.message(
      'return of yesterday',
      name: 'returnYesterday',
      desc: '',
      args: [],
    );
  }

  /// `Investment amount must be bigger than {minInvest}`
  String minInvestTip(Object minInvest) {
    return Intl.message(
      'Investment amount must be bigger than $minInvest',
      name: 'minInvestTip',
      desc: '',
      args: [minInvest],
    );
  }

  /// `Investment amount must be bigger than 0`
  String get noInvestTip {
    return Intl.message(
      'Investment amount must be bigger than 0',
      name: 'noInvestTip',
      desc: '',
      args: [],
    );
  }

  /// `Investment amount must be integral times of 100`
  String get timerInvestTip {
    return Intl.message(
      'Investment amount must be integral times of 100',
      name: 'timerInvestTip',
      desc: '',
      args: [],
    );
  }

  /// `Invest success`
  String get investSuccess {
    return Intl.message(
      'Invest success',
      name: 'investSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Investment order history`
  String get investHistory {
    return Intl.message(
      'Investment order history',
      name: 'investHistory',
      desc: '',
      args: [],
    );
  }

  /// `Pull up load`
  String get loadMoreTip {
    return Intl.message(
      'Pull up load',
      name: 'loadMoreTip',
      desc: '',
      args: [],
    );
  }

  /// `Load Failed!Click retry!`
  String get reloadTip {
    return Intl.message(
      'Load Failed!Click retry!',
      name: 'reloadTip',
      desc: '',
      args: [],
    );
  }

  /// `Release to load more`
  String get releaseLoadMoreTip {
    return Intl.message(
      'Release to load more',
      name: 'releaseLoadMoreTip',
      desc: '',
      args: [],
    );
  }

  /// `No more Data`
  String get noMoreData {
    return Intl.message('No more Data', name: 'noMoreData', desc: '', args: []);
  }

  /// `Status:`
  String get statusItem {
    return Intl.message('Status:', name: 'statusItem', desc: '', args: []);
  }

  /// `Investment product:`
  String get investmentItem {
    return Intl.message(
      'Investment product:',
      name: 'investmentItem',
      desc: '',
      args: [],
    );
  }

  /// `Annual percentage rate:`
  String get percentRateItem {
    return Intl.message(
      'Annual percentage rate:',
      name: 'percentRateItem',
      desc: '',
      args: [],
    );
  }

  /// `Submit time:`
  String get submitTimeItem {
    return Intl.message(
      'Submit time:',
      name: 'submitTimeItem',
      desc: '',
      args: [],
    );
  }

  /// `Reinvested time:`
  String get reinvestTimeItem {
    return Intl.message(
      'Reinvested time:',
      name: 'reinvestTimeItem',
      desc: '',
      args: [],
    );
  }

  /// `Approval time:`
  String get approvalTimeItem {
    return Intl.message(
      'Approval time:',
      name: 'approvalTimeItem',
      desc: '',
      args: [],
    );
  }

  /// `Redeem`
  String get redeem {
    return Intl.message('Redeem', name: 'redeem', desc: '', args: []);
  }

  /// `Not mature`
  String get notMature {
    return Intl.message('Not mature', name: 'notMature', desc: '', args: []);
  }

  /// `Withdrawal waiting approve`
  String get withdrawApprove {
    return Intl.message(
      'Withdrawal waiting approve',
      name: 'withdrawApprove',
      desc: '',
      args: [],
    );
  }

  /// `Current Invest`
  String get currentInvest {
    return Intl.message(
      'Current Invest',
      name: 'currentInvest',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Return`
  String get estimatedReturn {
    return Intl.message(
      'Estimated Return',
      name: 'estimatedReturn',
      desc: '',
      args: [],
    );
  }

  /// `Already Return`
  String get alreadyReturn {
    return Intl.message(
      'Already Return',
      name: 'alreadyReturn',
      desc: '',
      args: [],
    );
  }

  /// `Total Expected Return`
  String get totalExpectReturn {
    return Intl.message(
      'Total Expected Return',
      name: 'totalExpectReturn',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw Type`
  String get withdrawType {
    return Intl.message(
      'Withdraw Type',
      name: 'withdrawType',
      desc: '',
      args: [],
    );
  }

  /// `Auto Withdrawing`
  String get autoWithdraw {
    return Intl.message(
      'Auto Withdrawing',
      name: 'autoWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw By Hand`
  String get handWithdraw {
    return Intl.message(
      'Withdraw By Hand',
      name: 'handWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `First Approval`
  String get firstApproval {
    return Intl.message(
      'First Approval',
      name: 'firstApproval',
      desc: '',
      args: [],
    );
  }

  /// `Mature Date`
  String get matureDate {
    return Intl.message('Mature Date', name: 'matureDate', desc: '', args: []);
  }

  /// `flexible`
  String get filexible {
    return Intl.message('flexible', name: 'filexible', desc: '', args: []);
  }

  /// `Already Reinvest`
  String get alreadyReinvest {
    return Intl.message(
      'Already Reinvest',
      name: 'alreadyReinvest',
      desc: '',
      args: [],
    );
  }

  /// `YES`
  String get yesText {
    return Intl.message('YES', name: 'yesText', desc: '', args: []);
  }

  /// `NO`
  String get noText {
    return Intl.message('NO', name: 'noText', desc: '', args: []);
  }

  /// `Reinvest Time`
  String get reinvestTime {
    return Intl.message(
      'Reinvest Time',
      name: 'reinvestTime',
      desc: '',
      args: [],
    );
  }

  /// `Reinvest`
  String get reinvest {
    return Intl.message('Reinvest', name: 'reinvest', desc: '', args: []);
  }

  /// `Please input verification code`
  String get inputVerificationCode {
    return Intl.message(
      'Please input verification code',
      name: 'inputVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Verification code`
  String get verificationCode {
    return Intl.message(
      'Verification code',
      name: 'verificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Please input phone number!`
  String get inputPhone {
    return Intl.message(
      'Please input phone number!',
      name: 'inputPhone',
      desc: '',
      args: [],
    );
  }

  /// `I Want To Invest`
  String get iWantInvest {
    return Intl.message(
      'I Want To Invest',
      name: 'iWantInvest',
      desc: '',
      args: [],
    );
  }

  /// `Please select bank`
  String get selectBankTip {
    return Intl.message(
      'Please select bank',
      name: 'selectBankTip',
      desc: '',
      args: [],
    );
  }

  /// `Please input bank card number`
  String get bankCardTip {
    return Intl.message(
      'Please input bank card number',
      name: 'bankCardTip',
      desc: '',
      args: [],
    );
  }

  /// `Bank Card Verification Failed, Please Re-Check Bank Account`
  String get bankVertifyError {
    return Intl.message(
      'Bank Card Verification Failed, Please Re-Check Bank Account',
      name: 'bankVertifyError',
      desc: '',
      args: [],
    );
  }

  /// `Maximum amount for a single transaction is {amount}{moneyUnit}`
  String singleMax(Object amount, Object moneyUnit) {
    return Intl.message(
      'Maximum amount for a single transaction is $amount$moneyUnit',
      name: 'singleMax',
      desc: '',
      args: [amount, moneyUnit],
    );
  }

  /// `The amount entered exceeds your {coinType}`
  String maxCoinTip(Object coinType) {
    return Intl.message(
      'The amount entered exceeds your $coinType',
      name: 'maxCoinTip',
      desc: '',
      args: [coinType],
    );
  }

  /// `Purchase Success !`
  String get buySuccess {
    return Intl.message(
      'Purchase Success !',
      name: 'buySuccess',
      desc: '',
      args: [],
    );
  }

  /// `Sold Success !`
  String get sellSuccess {
    return Intl.message(
      'Sold Success !',
      name: 'sellSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Bank Card Information Confirmation`
  String get bankInfoConfirm {
    return Intl.message(
      'Bank Card Information Confirmation',
      name: 'bankInfoConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Bank Name:`
  String get bankNameItem {
    return Intl.message('Bank Name:', name: 'bankNameItem', desc: '', args: []);
  }

  /// `Bank Card Number:`
  String get bankNoItem {
    return Intl.message(
      'Bank Card Number:',
      name: 'bankNoItem',
      desc: '',
      args: [],
    );
  }

  /// `Cardholder:`
  String get holderItem {
    return Intl.message('Cardholder:', name: 'holderItem', desc: '', args: []);
  }

  /// `Bind Card`
  String get bindCard {
    return Intl.message('Bind Card', name: 'bindCard', desc: '', args: []);
  }

  /// `Basic info`
  String get basicInfo {
    return Intl.message('Basic info', name: 'basicInfo', desc: '', args: []);
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Birthday`
  String get birthday {
    return Intl.message('Birthday', name: 'birthday', desc: '', args: []);
  }

  /// `ID No.`
  String get idNo {
    return Intl.message('ID No.', name: 'idNo', desc: '', args: []);
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Post Code`
  String get postCode {
    return Intl.message('Post Code', name: 'postCode', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Withdraw Bank Card`
  String get withdrawToCard {
    return Intl.message(
      'Withdraw Bank Card',
      name: 'withdrawToCard',
      desc: '',
      args: [],
    );
  }

  /// `Balance Assets`
  String get balanceAsset {
    return Intl.message(
      'Balance Assets',
      name: 'balanceAsset',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal Range ({coinUnit}{minAmount} ~ {maxAmount})`
  String withdrawRange(Object coinUnit, Object minAmount, Object maxAmount) {
    return Intl.message(
      'Withdrawal Range ($coinUnit$minAmount ~ $maxAmount)',
      name: 'withdrawRange',
      desc: '',
      args: [coinUnit, minAmount, maxAmount],
    );
  }

  /// `Calculating...`
  String get calculating {
    return Intl.message(
      'Calculating...',
      name: 'calculating',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the withdrawal amount`
  String get inputWithdrawAmount {
    return Intl.message(
      'Please enter the withdrawal amount',
      name: 'inputWithdrawAmount',
      desc: '',
      args: [],
    );
  }

  /// `The withdrawal application is submitted successfully!`
  String get withdrawSuccessTip {
    return Intl.message(
      'The withdrawal application is submitted successfully!',
      name: 'withdrawSuccessTip',
      desc: '',
      args: [],
    );
  }

  /// `(Withdrawable Amount {amount})`
  String canWithdrawAmount(Object amount) {
    return Intl.message(
      '(Withdrawable Amount $amount)',
      name: 'canWithdrawAmount',
      desc: '',
      args: [amount],
    );
  }

  /// `Withdrawal Amount`
  String get withdrawAmount {
    return Intl.message(
      'Withdrawal Amount',
      name: 'withdrawAmount',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient Withdrawal Amount`
  String get amountNotEnough {
    return Intl.message(
      'Insufficient Withdrawal Amount',
      name: 'amountNotEnough',
      desc: '',
      args: [],
    );
  }

  /// `Total Return`
  String get totalReturn {
    return Intl.message(
      'Total Return',
      name: 'totalReturn',
      desc: '',
      args: [],
    );
  }

  /// `Daily return`
  String get dailyReturn {
    return Intl.message(
      'Daily return',
      name: 'dailyReturn',
      desc: '',
      args: [],
    );
  }

  /// `Mature in {showDay} days`
  String matureDay(Object showDay) {
    return Intl.message(
      'Mature in $showDay days',
      name: 'matureDay',
      desc: '',
      args: [showDay],
    );
  }

  /// `Withdrawal waiting approve`
  String get withdrawWaiting {
    return Intl.message(
      'Withdrawal waiting approve',
      name: 'withdrawWaiting',
      desc: '',
      args: [],
    );
  }

  /// `My network`
  String get myNetwork {
    return Intl.message('My network', name: 'myNetwork', desc: '', args: []);
  }

  /// `Order from invitation`
  String get orderInvitation {
    return Intl.message(
      'Order from invitation',
      name: 'orderInvitation',
      desc: '',
      args: [],
    );
  }

  /// `Annual percentage ratetion`
  String get percentRatetion {
    return Intl.message(
      'Annual percentage ratetion',
      name: 'percentRatetion',
      desc: '',
      args: [],
    );
  }

  /// `Investment introduction`
  String get investmentIntro {
    return Intl.message(
      'Investment introduction',
      name: 'investmentIntro',
      desc: '',
      args: [],
    );
  }

  /// `{number}days`
  String numberDays(Object number) {
    return Intl.message(
      '${number}days',
      name: 'numberDays',
      desc: '',
      args: [number],
    );
  }

  /// `Choose investment product`
  String get chooseProduct {
    return Intl.message(
      'Choose investment product',
      name: 'chooseProduct',
      desc: '',
      args: [],
    );
  }

  /// `ConvenienceStore`
  String get convenienceStore {
    return Intl.message(
      'ConvenienceStore',
      name: 'convenienceStore',
      desc: '',
      args: [],
    );
  }

  /// `Please select the payment method`
  String get choosePayMethod {
    return Intl.message(
      'Please select the payment method',
      name: 'choosePayMethod',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the deposit amount`
  String get rechargeTip {
    return Intl.message(
      'Please enter the deposit amount',
      name: 'rechargeTip',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Username`
  String get nickname {
    return Intl.message('Username', name: 'nickname', desc: '', args: []);
  }

  /// `Password at least 6 digits`
  String get passwordTip {
    return Intl.message(
      'Password at least 6 digits',
      name: 'passwordTip',
      desc: '',
      args: [],
    );
  }

  /// `Invitation code (optional)`
  String get invitationCodeTip {
    return Intl.message(
      'Invitation code (optional)',
      name: 'invitationCodeTip',
      desc: '',
      args: [],
    );
  }

  /// `I agree`
  String get iAgree {
    return Intl.message('I agree', name: 'iAgree', desc: '', args: []);
  }

  /// `user registration agreement`
  String get registerAgreement {
    return Intl.message(
      'user registration agreement',
      name: 'registerAgreement',
      desc: '',
      args: [],
    );
  }

  /// `Please input Username`
  String get nickNameTip {
    return Intl.message(
      'Please input Username',
      name: 'nickNameTip',
      desc: '',
      args: [],
    );
  }

  /// `6-16 digit(letter, number, symbol),can not use 1 type only,case sensitive`
  String get pwdTypeTip {
    return Intl.message(
      '6-16 digit(letter, number, symbol),can not use 1 type only,case sensitive',
      name: 'pwdTypeTip',
      desc: '',
      args: [],
    );
  }

  /// `Please accept registration agreement`
  String get agreementTip {
    return Intl.message(
      'Please accept registration agreement',
      name: 'agreementTip',
      desc: '',
      args: [],
    );
  }

  /// `Bonus withdraw`
  String get bonusWithdraw {
    return Intl.message(
      'Bonus withdraw',
      name: 'bonusWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `Order bonus withdraw`
  String get orderBonusWithdraw {
    return Intl.message(
      'Order bonus withdraw',
      name: 'orderBonusWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `ADIB bonus withdraw`
  String get adibBonusWithdraw {
    return Intl.message(
      'ADIB bonus withdraw',
      name: 'adibBonusWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `Amount available:`
  String get amountAvailableTip {
    return Intl.message(
      'Amount available:',
      name: 'amountAvailableTip',
      desc: '',
      args: [],
    );
  }

  /// `amount to withdraw`
  String get amountToWithdraw {
    return Intl.message(
      'amount to withdraw',
      name: 'amountToWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `please input amount to withdraw`
  String get amountWithdrawTIp {
    return Intl.message(
      'please input amount to withdraw',
      name: 'amountWithdrawTIp',
      desc: '',
      args: [],
    );
  }

  /// `maximum amount:`
  String get maxAmount {
    return Intl.message(
      'maximum amount:',
      name: 'maxAmount',
      desc: '',
      args: [],
    );
  }

  /// `Apply withdraw`
  String get applyWithdraw {
    return Intl.message(
      'Apply withdraw',
      name: 'applyWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `User input amount in app to withdraw`
  String get applyWithdrawTip {
    return Intl.message(
      'User input amount in app to withdraw',
      name: 'applyWithdrawTip',
      desc: '',
      args: [],
    );
  }

  /// `Customer service approval`
  String get customerApproval {
    return Intl.message(
      'Customer service approval',
      name: 'customerApproval',
      desc: '',
      args: [],
    );
  }

  /// `Customer service review withdraw application，check amount and user info`
  String get customerApprovalTip {
    return Intl.message(
      'Customer service review withdraw application，check amount and user info',
      name: 'customerApprovalTip',
      desc: '',
      args: [],
    );
  }

  /// `Bank transfer`
  String get bankTransfer {
    return Intl.message(
      'Bank transfer',
      name: 'bankTransfer',
      desc: '',
      args: [],
    );
  }

  /// `after approval，finance department will transfer amount to user bank account with 1 work day `
  String get bankTransferTip {
    return Intl.message(
      'after approval，finance department will transfer amount to user bank account with 1 work day ',
      name: 'bankTransferTip',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw procedure`
  String get procedure {
    return Intl.message(
      'Withdraw procedure',
      name: 'procedure',
      desc: '',
      args: [],
    );
  }

  /// `fixed term product can not withdraw before mature，flexible product can withdraw at any time`
  String get procedureTip {
    return Intl.message(
      'fixed term product can not withdraw before mature，flexible product can withdraw at any time',
      name: 'procedureTip',
      desc: '',
      args: [],
    );
  }

  /// `Pay time: `
  String get payTimeItem {
    return Intl.message('Pay time: ', name: 'payTimeItem', desc: '', args: []);
  }

  /// `fixed term ({lockDays}day)`
  String fixedTerm(Object lockDays) {
    return Intl.message(
      'fixed term (${lockDays}day)',
      name: 'fixedTerm',
      desc: '',
      args: [lockDays],
    );
  }

  /// `Not logged in`
  String get notLogin {
    return Intl.message('Not logged in', name: 'notLogin', desc: '', args: []);
  }

  /// `Service charge`
  String get feeCharged {
    return Intl.message(
      'Service charge',
      name: 'feeCharged',
      desc: '',
      args: [],
    );
  }

  /// `Actual amount received`
  String get realReceived {
    return Intl.message(
      'Actual amount received',
      name: 'realReceived',
      desc: '',
      args: [],
    );
  }

  /// `Transfer successful!！`
  String get transferSuccess {
    return Intl.message(
      'Transfer successful!！',
      name: 'transferSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Select crypto`
  String get selectCrypto {
    return Intl.message(
      'Select crypto',
      name: 'selectCrypto',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get transfer {
    return Intl.message('Transfer', name: 'transfer', desc: '', args: []);
  }

  /// `Token`
  String get token {
    return Intl.message('Token', name: 'token', desc: '', args: []);
  }

  /// `From`
  String get from {
    return Intl.message('From', name: 'from', desc: '', args: []);
  }

  /// `To`
  String get to {
    return Intl.message('To', name: 'to', desc: '', args: []);
  }

  /// `Funding`
  String get funding {
    return Intl.message('Funding', name: 'funding', desc: '', args: []);
  }

  /// `Trading accounts`
  String get tradingAccounts {
    return Intl.message(
      'Trading accounts',
      name: 'tradingAccounts',
      desc: '',
      args: [],
    );
  }

  /// `Transfer all`
  String get transferAll {
    return Intl.message(
      'Transfer all',
      name: 'transferAll',
      desc: '',
      args: [],
    );
  }

  /// `Max. transfer`
  String get maxTransfer {
    return Intl.message(
      'Max. transfer',
      name: 'maxTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `Equity`
  String get equity {
    return Intl.message('Equity', name: 'equity', desc: '', args: []);
  }

  /// `Frozen`
  String get frozen {
    return Intl.message('Frozen', name: 'frozen', desc: '', args: []);
  }

  /// `Available`
  String get available {
    return Intl.message('Available', name: 'available', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Tag is not ndef writable`
  String get disableWrite {
    return Intl.message(
      'Tag is not ndef writable',
      name: 'disableWrite',
      desc: '',
      args: [],
    );
  }

  /// `Success to "Ndef Write"`
  String get ndefWrite {
    return Intl.message(
      'Success to "Ndef Write"',
      name: 'ndefWrite',
      desc: '',
      args: [],
    );
  }

  /// `Write success`
  String get writeSuccess {
    return Intl.message(
      'Write success',
      name: 'writeSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Ready to scan`
  String get areadyScan {
    return Intl.message(
      'Ready to scan',
      name: 'areadyScan',
      desc: '',
      args: [],
    );
  }

  /// `Nfc is not Available`
  String get disableNfc {
    return Intl.message(
      'Nfc is not Available',
      name: 'disableNfc',
      desc: '',
      args: [],
    );
  }

  /// `Hold your card to the upper back of your phone to activate it.Hold the card there until a success popup appears!`
  String get scanTip {
    return Intl.message(
      'Hold your card to the upper back of your phone to activate it.Hold the card there until a success popup appears!',
      name: 'scanTip',
      desc: '',
      args: [],
    );
  }

  /// `Tag is not ndef`
  String get disableNdef {
    return Intl.message(
      'Tag is not ndef',
      name: 'disableNdef',
      desc: '',
      args: [],
    );
  }

  /// `NFC writing card`
  String get nfcWrite {
    return Intl.message(
      'NFC writing card',
      name: 'nfcWrite',
      desc: '',
      args: [],
    );
  }

  /// `Create Text:`
  String get createText {
    return Intl.message('Create Text:', name: 'createText', desc: '', args: []);
  }

  /// `Create Uri:`
  String get createUri {
    return Intl.message('Create Uri:', name: 'createUri', desc: '', args: []);
  }

  /// `Create Mime`
  String get createMime {
    return Intl.message('Create Mime', name: 'createMime', desc: '', args: []);
  }

  /// `type:`
  String get cardType {
    return Intl.message('type:', name: 'cardType', desc: '', args: []);
  }

  /// `data:`
  String get cardData {
    return Intl.message('data:', name: 'cardData', desc: '', args: []);
  }

  /// `Write`
  String get writeCard {
    return Intl.message('Write', name: 'writeCard', desc: '', args: []);
  }

  /// `Read`
  String get readCard {
    return Intl.message('Read', name: 'readCard', desc: '', args: []);
  }

  /// `Your login has expired, please log in again!`
  String get expiredTip {
    return Intl.message(
      'Your login has expired, please log in again!',
      name: 'expiredTip',
      desc: '',
      args: [],
    );
  }

  /// `Version Information`
  String get appVersion {
    return Intl.message(
      'Version Information',
      name: 'appVersion',
      desc: '',
      args: [],
    );
  }

  /// `New version available {versionName}`
  String foundNewVersion(Object versionName) {
    return Intl.message(
      'New version available $versionName',
      name: 'foundNewVersion',
      desc: '',
      args: [versionName],
    );
  }

  /// `Updating…`
  String get updating {
    return Intl.message('Updating…', name: 'updating', desc: '', args: []);
  }

  /// `Download successful`
  String get downloadSuccess {
    return Intl.message(
      'Download successful',
      name: 'downloadSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Download failed`
  String get downloadFail {
    return Intl.message(
      'Download failed',
      name: 'downloadFail',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade unsuccessful`
  String get upgradeFail {
    return Intl.message(
      'Upgrade unsuccessful',
      name: 'upgradeFail',
      desc: '',
      args: [],
    );
  }

  /// `{percent}% downloaded`
  String downloadPercent(Object percent) {
    return Intl.message(
      '$percent% downloaded',
      name: 'downloadPercent',
      desc: '',
      args: [percent],
    );
  }

  /// `Mobile no. login`
  String get phoneNoLogin {
    return Intl.message(
      'Mobile no. login',
      name: 'phoneNoLogin',
      desc: '',
      args: [],
    );
  }

  /// `Input phone no.`
  String get enterPhoneNo {
    return Intl.message(
      'Input phone no.',
      name: 'enterPhoneNo',
      desc: '',
      args: [],
    );
  }

  /// `Enter verification code`
  String get enterPhoneCode {
    return Intl.message(
      'Enter verification code',
      name: 'enterPhoneCode',
      desc: '',
      args: [],
    );
  }

  /// `Verification code sent`
  String get sendCodeSuccess {
    return Intl.message(
      'Verification code sent',
      name: 'sendCodeSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Enter password of at least 6 digits`
  String get enterPwd {
    return Intl.message(
      'Enter password of at least 6 digits',
      name: 'enterPwd',
      desc: '',
      args: [],
    );
  }

  /// `Enter an invitation code (optional)`
  String get enterinviteCode {
    return Intl.message(
      'Enter an invitation code (optional)',
      name: 'enterinviteCode',
      desc: '',
      args: [],
    );
  }

  /// `Remember password`
  String get rememberPwd {
    return Intl.message(
      'Remember password',
      name: 'rememberPwd',
      desc: '',
      args: [],
    );
  }

  /// `Agree to the agreement and register`
  String get agreeAndRegister {
    return Intl.message(
      'Agree to the agreement and register',
      name: 'agreeAndRegister',
      desc: '',
      args: [],
    );
  }

  /// `I have read and agree`
  String get agreed {
    return Intl.message(
      'I have read and agree',
      name: 'agreed',
      desc: '',
      args: [],
    );
  }

  /// `User Agreement`
  String get userAgreement {
    return Intl.message(
      'User Agreement',
      name: 'userAgreement',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get and {
    return Intl.message('and', name: 'and', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `【{pageName}】Page jump is not supported`
  String unsupportActivity(Object pageName) {
    return Intl.message(
      '【$pageName】Page jump is not supported',
      name: 'unsupportActivity',
      desc: '',
      args: [pageName],
    );
  }

  /// `The redirected URL is incorrect`
  String get linkFormatError {
    return Intl.message(
      'The redirected URL is incorrect',
      name: 'linkFormatError',
      desc: '',
      args: [],
    );
  }

  /// `Register an account`
  String get registerAccount {
    return Intl.message(
      'Register an account',
      name: 'registerAccount',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get settings {
    return Intl.message('Setting', name: 'settings', desc: '', args: []);
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Create External`
  String get createExternal {
    return Intl.message(
      'Create External',
      name: 'createExternal',
      desc: '',
      args: [],
    );
  }

  /// `domain:`
  String get cardDomain {
    return Intl.message('domain:', name: 'cardDomain', desc: '', args: []);
  }

  /// `Card Info`
  String get cardInfo {
    return Intl.message('Card Info', name: 'cardInfo', desc: '', args: []);
  }

  /// `Data source:`
  String get dataSource {
    return Intl.message('Data source:', name: 'dataSource', desc: '', args: []);
  }

  /// `Copy`
  String get copy {
    return Intl.message('Copy', name: 'copy', desc: '', args: []);
  }

  /// `Tag Records:`
  String get tagRecords {
    return Intl.message('Tag Records:', name: 'tagRecords', desc: '', args: []);
  }

  /// `Bind`
  String get bind {
    return Intl.message('Bind', name: 'bind', desc: '', args: []);
  }

  /// `Binding success`
  String get bindSuccess {
    return Intl.message(
      'Binding success',
      name: 'bindSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Binding failed: {errorMsg}`
  String bindFailure(Object errorMsg) {
    return Intl.message(
      'Binding failed: $errorMsg',
      name: 'bindFailure',
      desc: '',
      args: [errorMsg],
    );
  }

  /// `Incorrect QR code`
  String get qrCodeError {
    return Intl.message(
      'Incorrect QR code',
      name: 'qrCodeError',
      desc: '',
      args: [],
    );
  }

  /// `Bind email`
  String get bindEmail {
    return Intl.message('Bind email', name: 'bindEmail', desc: '', args: []);
  }

  /// `Input the email address`
  String get enterEmail {
    return Intl.message(
      'Input the email address',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter email verification code`
  String get enterEmailCode {
    return Intl.message(
      'Enter email verification code',
      name: 'enterEmailCode',
      desc: '',
      args: [],
    );
  }

  /// `Click to Login`
  String get clickLogin {
    return Intl.message(
      'Click to Login',
      name: 'clickLogin',
      desc: '',
      args: [],
    );
  }

  /// `Read card error,please try it again!`
  String get readCardError {
    return Intl.message(
      'Read card error,please try it again!',
      name: 'readCardError',
      desc: '',
      args: [],
    );
  }

  /// `The current card type is not yet supported, so stay tuned!`
  String get unsupporetCard {
    return Intl.message(
      'The current card type is not yet supported, so stay tuned!',
      name: 'unsupporetCard',
      desc: '',
      args: [],
    );
  }

  /// `can not read card identifier`
  String get readCardIdError {
    return Intl.message(
      'can not read card identifier',
      name: 'readCardIdError',
      desc: '',
      args: [],
    );
  }

  /// `Edit card`
  String get editCard {
    return Intl.message('Edit card', name: 'editCard', desc: '', args: []);
  }

  /// `Please enter...`
  String get enterHint {
    return Intl.message(
      'Please enter...',
      name: 'enterHint',
      desc: '',
      args: [],
    );
  }

  /// `How to use`
  String get operateTutorial {
    return Intl.message(
      'How to use',
      name: 'operateTutorial',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Modify`
  String get modify {
    return Intl.message('Modify', name: 'modify', desc: '', args: []);
  }

  /// `Delete success`
  String get deleteSuccess {
    return Intl.message(
      'Delete success',
      name: 'deleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Input account information`
  String get enterAccountInfo {
    return Intl.message(
      'Input account information',
      name: 'enterAccountInfo',
      desc: '',
      args: [],
    );
  }

  /// `Information is not in the correct format`
  String get enterFormatError {
    return Intl.message(
      'Information is not in the correct format',
      name: 'enterFormatError',
      desc: '',
      args: [],
    );
  }

  /// `Successfully modified`
  String get modifySuccess {
    return Intl.message(
      'Successfully modified',
      name: 'modifySuccess',
      desc: '',
      args: [],
    );
  }

  /// `Added successfully`
  String get addSuccess {
    return Intl.message(
      'Added successfully',
      name: 'addSuccess',
      desc: '',
      args: [],
    );
  }

  /// `My Card`
  String get myCard {
    return Intl.message('My Card', name: 'myCard', desc: '', args: []);
  }

  /// `Card Holder`
  String get cardHolder {
    return Intl.message('Card Holder', name: 'cardHolder', desc: '', args: []);
  }

  /// `Links`
  String get links {
    return Intl.message('Links', name: 'links', desc: '', args: []);
  }

  /// `Your name`
  String get yourName {
    return Intl.message('Your name', name: 'yourName', desc: '', args: []);
  }

  /// `Your company name`
  String get yourCompanyName {
    return Intl.message(
      'Your company name',
      name: 'yourCompanyName',
      desc: '',
      args: [],
    );
  }

  /// `Your department`
  String get yourDepartment {
    return Intl.message(
      'Your department',
      name: 'yourDepartment',
      desc: '',
      args: [],
    );
  }

  /// `Your title`
  String get yourTitle {
    return Intl.message('Your title', name: 'yourTitle', desc: '', args: []);
  }

  /// `Your address`
  String get yourAddress {
    return Intl.message(
      'Your address',
      name: 'yourAddress',
      desc: '',
      args: [],
    );
  }

  /// `Deparment: `
  String get deparment {
    return Intl.message('Deparment: ', name: 'deparment', desc: '', args: []);
  }

  /// `Preview`
  String get preview {
    return Intl.message('Preview', name: 'preview', desc: '', args: []);
  }

  /// `Add new link`
  String get addNewLink {
    return Intl.message('Add new link', name: 'addNewLink', desc: '', args: []);
  }

  /// `Update sort failed: {errorMsg}`
  String orderSuccess(Object errorMsg) {
    return Intl.message(
      'Update sort failed: $errorMsg',
      name: 'orderSuccess',
      desc: '',
      args: [errorMsg],
    );
  }

  /// `Confirm to delete?`
  String get confirmDelete {
    return Intl.message(
      'Confirm to delete?',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Sharing Personal Profile`
  String get shareProfile {
    return Intl.message(
      'Sharing Personal Profile',
      name: 'shareProfile',
      desc: '',
      args: [],
    );
  }

  /// `Tap to download QR code to photos`
  String get tapSave {
    return Intl.message(
      'Tap to download QR code to photos',
      name: 'tapSave',
      desc: '',
      args: [],
    );
  }

  /// `Tap to download`
  String get tapDownload {
    return Intl.message(
      'Tap to download',
      name: 'tapDownload',
      desc: '',
      args: [],
    );
  }

  /// `Edit QR`
  String get editQr {
    return Intl.message('Edit QR', name: 'editQr', desc: '', args: []);
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Copy success`
  String get conySuccess {
    return Intl.message(
      'Copy success',
      name: 'conySuccess',
      desc: '',
      args: [],
    );
  }

  /// `QR code saved successfully`
  String get saveRqSuccess {
    return Intl.message(
      'QR code saved successfully',
      name: 'saveRqSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save: {errorMsg}`
  String saveFailure(Object errorMsg) {
    return Intl.message(
      'Failed to save: $errorMsg',
      name: 'saveFailure',
      desc: '',
      args: [errorMsg],
    );
  }

  /// `Login with mobile no. and password`
  String get phoneLogin {
    return Intl.message(
      'Login with mobile no. and password',
      name: 'phoneLogin',
      desc: '',
      args: [],
    );
  }

  /// `Email password login`
  String get emailLogin {
    return Intl.message(
      'Email password login',
      name: 'emailLogin',
      desc: '',
      args: [],
    );
  }

  /// `No account? Go register one`
  String get gotoRegister {
    return Intl.message(
      'No account? Go register one',
      name: 'gotoRegister',
      desc: '',
      args: [],
    );
  }

  /// `Set Password`
  String get setPwd {
    return Intl.message('Set Password', name: 'setPwd', desc: '', args: []);
  }

  /// `A verification code will be sent to the phone no. {phoneNo}`
  String sendPhoneCode(Object phoneNo) {
    return Intl.message(
      'A verification code will be sent to the phone no. $phoneNo',
      name: 'sendPhoneCode',
      desc: '',
      args: [phoneNo],
    );
  }

  /// `A verification code will be sent to the email address {email}`
  String sendEmailCode(Object email) {
    return Intl.message(
      'A verification code will be sent to the email address $email',
      name: 'sendEmailCode',
      desc: '',
      args: [email],
    );
  }

  /// `Change verification method`
  String get changeVerify {
    return Intl.message(
      'Change verification method',
      name: 'changeVerify',
      desc: '',
      args: [],
    );
  }

  /// `Set password successfully`
  String get setPwdSuccess {
    return Intl.message(
      'Set password successfully',
      name: 'setPwdSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to crop avatar`
  String get cutPhoneFailure {
    return Intl.message(
      'Failed to crop avatar',
      name: 'cutPhoneFailure',
      desc: '',
      args: [],
    );
  }

  /// `User Level`
  String get userLevel {
    return Intl.message('User Level', name: 'userLevel', desc: '', args: []);
  }

  /// `Current level`
  String get currentLevel {
    return Intl.message(
      'Current level',
      name: 'currentLevel',
      desc: '',
      args: [],
    );
  }

  /// `level locked`
  String get levelLocked {
    return Intl.message(
      'level locked',
      name: 'levelLocked',
      desc: '',
      args: [],
    );
  }

  /// `level active`
  String get levelActive {
    return Intl.message(
      'level active',
      name: 'levelActive',
      desc: '',
      args: [],
    );
  }

  /// `Bonus Rank`
  String get bonusRank {
    return Intl.message('Bonus Rank', name: 'bonusRank', desc: '', args: []);
  }

  /// `Account verification`
  String get accountVerify {
    return Intl.message(
      'Account verification',
      name: 'accountVerify',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Background image`
  String get bgImage {
    return Intl.message(
      'Background image',
      name: 'bgImage',
      desc: '',
      args: [],
    );
  }

  /// `Click to upload`
  String get clickUpload {
    return Intl.message(
      'Click to upload',
      name: 'clickUpload',
      desc: '',
      args: [],
    );
  }

  /// `Logo`
  String get logo {
    return Intl.message('Logo', name: 'logo', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Enter your name`
  String get enterName {
    return Intl.message(
      'Enter your name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Company Name`
  String get companyName {
    return Intl.message(
      'Company Name',
      name: 'companyName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your company name`
  String get enterCompanyName {
    return Intl.message(
      'Enter your company name',
      name: 'enterCompanyName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Address`
  String get enterAddress {
    return Intl.message(
      'Enter your Address',
      name: 'enterAddress',
      desc: '',
      args: [],
    );
  }

  /// `Department`
  String get department {
    return Intl.message('Department', name: 'department', desc: '', args: []);
  }

  /// `Enter your department`
  String get enterDepartment {
    return Intl.message(
      'Enter your department',
      name: 'enterDepartment',
      desc: '',
      args: [],
    );
  }

  /// `Job title`
  String get title {
    return Intl.message('Job title', name: 'title', desc: '', args: []);
  }

  /// `Enter your job title`
  String get enterTitle {
    return Intl.message(
      'Enter your job title',
      name: 'enterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Photo album`
  String get ablumn {
    return Intl.message('Photo album', name: 'ablumn', desc: '', args: []);
  }

  /// `Take Photo`
  String get takePhoto {
    return Intl.message('Take Photo', name: 'takePhoto', desc: '', args: []);
  }

  /// `Smart Card Management`
  String get cardManager {
    return Intl.message(
      'Smart Card Management',
      name: 'cardManager',
      desc: '',
      args: [],
    );
  }

  /// `Add to`
  String get add {
    return Intl.message('Add to', name: 'add', desc: '', args: []);
  }

  /// `Edit card information`
  String get editCardInfo {
    return Intl.message(
      'Edit card information',
      name: 'editCardInfo',
      desc: '',
      args: [],
    );
  }

  /// `Card name`
  String get cardName {
    return Intl.message('Card name', name: 'cardName', desc: '', args: []);
  }

  /// `Enter card name`
  String get enterCardName {
    return Intl.message(
      'Enter card name',
      name: 'enterCardName',
      desc: '',
      args: [],
    );
  }

  /// `Set as main card`
  String get setMainCard {
    return Intl.message(
      'Set as main card',
      name: 'setMainCard',
      desc: '',
      args: [],
    );
  }

  /// `Add a card`
  String get addCard {
    return Intl.message('Add a card', name: 'addCard', desc: '', args: []);
  }

  /// `Card number`
  String get cardNo {
    return Intl.message('Card number', name: 'cardNo', desc: '', args: []);
  }

  /// `Brand`
  String get cardBrand {
    return Intl.message('Brand', name: 'cardBrand', desc: '', args: []);
  }

  /// `Current balance`
  String get currentAmount {
    return Intl.message(
      'Current balance',
      name: 'currentAmount',
      desc: '',
      args: [],
    );
  }

  /// `User device already bind`
  String get alreadyBind {
    return Intl.message(
      'User device already bind',
      name: 'alreadyBind',
      desc: '',
      args: [],
    );
  }

  /// `Send email`
  String get sendEmail {
    return Intl.message('Send email', name: 'sendEmail', desc: '', args: []);
  }

  /// `Enter email title`
  String get enterEmailTitle {
    return Intl.message(
      'Enter email title',
      name: 'enterEmailTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter email content`
  String get enterEmailContent {
    return Intl.message(
      'Enter email content',
      name: 'enterEmailContent',
      desc: '',
      args: [],
    );
  }

  /// `No email app available on phone`
  String get disableEmailApp {
    return Intl.message(
      'No email app available on phone',
      name: 'disableEmailApp',
      desc: '',
      args: [],
    );
  }

  /// `Saved to draft email`
  String get saveEmailDraft {
    return Intl.message(
      'Saved to draft email',
      name: 'saveEmailDraft',
      desc: '',
      args: [],
    );
  }

  /// `Mail has been canceled`
  String get cancelEmailSend {
    return Intl.message(
      'Mail has been canceled',
      name: 'cancelEmailSend',
      desc: '',
      args: [],
    );
  }

  /// `Mail sent successfully`
  String get sendEmailSuccess {
    return Intl.message(
      'Mail sent successfully',
      name: 'sendEmailSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error message`
  String get errorInfo {
    return Intl.message('Error message', name: 'errorInfo', desc: '', args: []);
  }

  /// `Your Balance`
  String get yourBalane {
    return Intl.message('Your Balance', name: 'yourBalane', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Add member card`
  String get addMemberCard {
    return Intl.message(
      'Add member card',
      name: 'addMemberCard',
      desc: '',
      args: [],
    );
  }

  /// `Enter member phone no.`
  String get enterMemberPhone {
    return Intl.message(
      'Enter member phone no.',
      name: 'enterMemberPhone',
      desc: '',
      args: [],
    );
  }

  /// `Remark`
  String get remark {
    return Intl.message('Remark', name: 'remark', desc: '', args: []);
  }

  /// `Enter remarks`
  String get enterRemark {
    return Intl.message(
      'Enter remarks',
      name: 'enterRemark',
      desc: '',
      args: [],
    );
  }

  /// `Invitation Details`
  String get inviteDetail {
    return Intl.message(
      'Invitation Details',
      name: 'inviteDetail',
      desc: '',
      args: [],
    );
  }

  /// `Phone no:`
  String get phoneNoTitle {
    return Intl.message('Phone no:', name: 'phoneNoTitle', desc: '', args: []);
  }

  /// `Your remarks`
  String get yourRemark {
    return Intl.message('Your remarks', name: 'yourRemark', desc: '', args: []);
  }

  /// `(Main Card)`
  String get mainCard {
    return Intl.message('(Main Card)', name: 'mainCard', desc: '', args: []);
  }

  /// `Forgot password`
  String get forgotPwd {
    return Intl.message(
      'Forgot password',
      name: 'forgotPwd',
      desc: '',
      args: [],
    );
  }

  /// `Register Success`
  String get registerSuccess {
    return Intl.message(
      'Register Success',
      name: 'registerSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Edit Remark`
  String get editRemark {
    return Intl.message('Edit Remark', name: 'editRemark', desc: '', args: []);
  }

  /// `Enter new password again`
  String get enterNewPwdAgain {
    return Intl.message(
      'Enter new password again',
      name: 'enterNewPwdAgain',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetPwd {
    return Intl.message('Reset password', name: 'resetPwd', desc: '', args: []);
  }

  /// `Enter new password`
  String get enterNewPwd {
    return Intl.message(
      'Enter new password',
      name: 'enterNewPwd',
      desc: '',
      args: [],
    );
  }

  /// `The passwords entered repeatedly are inconsistent`
  String get twicePwd {
    return Intl.message(
      'The passwords entered repeatedly are inconsistent',
      name: 'twicePwd',
      desc: '',
      args: [],
    );
  }

  /// `Reset password success`
  String get resetPwdSuccess {
    return Intl.message(
      'Reset password success',
      name: 'resetPwdSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Modify password`
  String get modifyPwd {
    return Intl.message(
      'Modify password',
      name: 'modifyPwd',
      desc: '',
      args: [],
    );
  }

  /// `Modify password success`
  String get modifyPwdSuccess {
    return Intl.message(
      'Modify password success',
      name: 'modifyPwdSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Enter origin password`
  String get enterOriginPwd {
    return Intl.message(
      'Enter origin password',
      name: 'enterOriginPwd',
      desc: '',
      args: [],
    );
  }

  /// `Message center`
  String get messageCenter {
    return Intl.message(
      'Message center',
      name: 'messageCenter',
      desc: '',
      args: [],
    );
  }

  /// `Manager`
  String get manager {
    return Intl.message('Manager', name: 'manager', desc: '', args: []);
  }

  /// `Message detail`
  String get messageDetail {
    return Intl.message(
      'Message detail',
      name: 'messageDetail',
      desc: '',
      args: [],
    );
  }

  /// `Task`
  String get task {
    return Intl.message('Task', name: 'task', desc: '', args: []);
  }

  /// `The current smart card numbers are inconsistent!`
  String get noSameCard {
    return Intl.message(
      'The current smart card numbers are inconsistent!',
      name: 'noSameCard',
      desc: '',
      args: [],
    );
  }

  /// `The current card type does not support reading the balance.`
  String get unsupportedAmount {
    return Intl.message(
      'The current card type does not support reading the balance.',
      name: 'unsupportedAmount',
      desc: '',
      args: [],
    );
  }

  /// `Retry after {seconds} S`
  String fetchCode(Object seconds) {
    return Intl.message(
      'Retry after $seconds S',
      name: 'fetchCode',
      desc: '',
      args: [seconds],
    );
  }

  /// `Rewards record`
  String get rewardsRecord {
    return Intl.message(
      'Rewards record',
      name: 'rewardsRecord',
      desc: '',
      args: [],
    );
  }

  /// `No record!`
  String get noRecord {
    return Intl.message('No record!', name: 'noRecord', desc: '', args: []);
  }

  /// `NFC is Turned Off`
  String get nfcOffTitle {
    return Intl.message(
      'NFC is Turned Off',
      name: 'nfcOffTitle',
      desc: '',
      args: [],
    );
  }

  /// `Turn NFC on in Settings,then try again.`
  String get nfcOffTip {
    return Intl.message(
      'Turn NFC on in Settings,then try again.',
      name: 'nfcOffTip',
      desc: '',
      args: [],
    );
  }

  /// `Modify email`
  String get modifyEmail {
    return Intl.message(
      'Modify email',
      name: 'modifyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Switch login`
  String get switchLogin {
    return Intl.message(
      'Switch login',
      name: 'switchLogin',
      desc: '',
      args: [],
    );
  }

  /// `Mobile No. and password`
  String get phonePwdLogin {
    return Intl.message(
      'Mobile No. and password',
      name: 'phonePwdLogin',
      desc: '',
      args: [],
    );
  }

  /// `Email and password`
  String get emailPwdLogin {
    return Intl.message(
      'Email and password',
      name: 'emailPwdLogin',
      desc: '',
      args: [],
    );
  }

  /// `Mobile No. and verification code`
  String get phoneCodeLogin {
    return Intl.message(
      'Mobile No. and verification code',
      name: 'phoneCodeLogin',
      desc: '',
      args: [],
    );
  }

  /// `Email and verification code`
  String get emailCodeLogin {
    return Intl.message(
      'Email and verification code',
      name: 'emailCodeLogin',
      desc: '',
      args: [],
    );
  }

  /// `Current email:`
  String get currentEmail {
    return Intl.message(
      'Current email:',
      name: 'currentEmail',
      desc: '',
      args: [],
    );
  }

  /// `Modify source of QR code`
  String get updateQRSource {
    return Intl.message(
      'Modify source of QR code',
      name: 'updateQRSource',
      desc: '',
      args: [],
    );
  }

  /// `Set as main card`
  String get setMainPostCard {
    return Intl.message(
      'Set as main card',
      name: 'setMainPostCard',
      desc: '',
      args: [],
    );
  }

  /// `Delete card`
  String get deleteCard {
    return Intl.message('Delete card', name: 'deleteCard', desc: '', args: []);
  }

  /// `Modify name`
  String get updateName {
    return Intl.message('Modify name', name: 'updateName', desc: '', args: []);
  }

  /// `Switch Sign Up`
  String get changeRegister {
    return Intl.message(
      'Switch Sign Up',
      name: 'changeRegister',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Email format is incorrect`
  String get emailError {
    return Intl.message(
      'Email format is incorrect',
      name: 'emailError',
      desc: '',
      args: [],
    );
  }

  /// `Please select a message to act on`
  String get selectOperateMsg {
    return Intl.message(
      'Please select a message to act on',
      name: 'selectOperateMsg',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the selected messages?`
  String get deleteMsgTip {
    return Intl.message(
      'Are you sure you want to delete the selected messages?',
      name: 'deleteMsgTip',
      desc: '',
      args: [],
    );
  }

  /// `Account cancellation`
  String get cancellationAccount {
    return Intl.message(
      'Account cancellation',
      name: 'cancellationAccount',
      desc: '',
      args: [],
    );
  }

  /// `Tip`
  String get tip {
    return Intl.message('Tip', name: 'tip', desc: '', args: []);
  }

  /// `After the account is cancelled, the data related to the account cannot be retrieved. Are you sure you want to perform this operation?`
  String get cancelAccountTip {
    return Intl.message(
      'After the account is cancelled, the data related to the account cannot be retrieved. Are you sure you want to perform this operation?',
      name: 'cancelAccountTip',
      desc: '',
      args: [],
    );
  }

  /// `Card in hand`
  String get tabHand {
    return Intl.message('Card in hand', name: 'tabHand', desc: '', args: []);
  }

  /// `Card in holder`
  String get tabHolder {
    return Intl.message(
      'Card in holder',
      name: 'tabHolder',
      desc: '',
      args: [],
    );
  }

  /// `邮箱注册`
  String get emailRegister {
    return Intl.message('邮箱注册', name: 'emailRegister', desc: '', args: []);
  }

  /// `手机号注册`
  String get phoneRegister {
    return Intl.message('手机号注册', name: 'phoneRegister', desc: '', args: []);
  }

  /// `NFC卡注册`
  String get nfcRegister {
    return Intl.message('NFC卡注册', name: 'nfcRegister', desc: '', args: []);
  }

  /// `手机号格式错误`
  String get phoneFormatError {
    return Intl.message(
      '手机号格式错误',
      name: 'phoneFormatError',
      desc: '',
      args: [],
    );
  }

  /// `绑定手机号`
  String get bindPhone {
    return Intl.message('绑定手机号', name: 'bindPhone', desc: '', args: []);
  }

  /// `操作失败`
  String get operateError {
    return Intl.message('操作失败', name: 'operateError', desc: '', args: []);
  }

  /// `操作失败:{error}`
  String operateErrorWithInfo(Object error) {
    return Intl.message(
      '操作失败:$error',
      name: 'operateErrorWithInfo',
      desc: '',
      args: [error],
    );
  }

  /// `未设置卡号`
  String get cardNoUnset {
    return Intl.message('未设置卡号', name: 'cardNoUnset', desc: '', args: []);
  }

  /// `请选择要操作的消息`
  String get selectMessage {
    return Intl.message('请选择要操作的消息', name: 'selectMessage', desc: '', args: []);
  }

  /// `修改昵称`
  String get updateNickname {
    return Intl.message('修改昵称', name: 'updateNickname', desc: '', args: []);
  }

  /// `未绑定手机号`
  String get unbindPhone {
    return Intl.message('未绑定手机号', name: 'unbindPhone', desc: '', args: []);
  }

  /// `未绑定邮箱`
  String get unbindEmail {
    return Intl.message('未绑定邮箱', name: 'unbindEmail', desc: '', args: []);
  }

  /// `选择国家或地区`
  String get selectCountry {
    return Intl.message('选择国家或地区', name: 'selectCountry', desc: '', args: []);
  }

  /// `{seconds}秒后重新获取`
  String countDown(Object seconds) {
    return Intl.message(
      '$seconds秒后重新获取',
      name: 'countDown',
      desc: '',
      args: [seconds],
    );
  }

  /// `该卡片未重置或存在密匙, 请先重置`
  String get cardResetTips {
    return Intl.message(
      '该卡片未重置或存在密匙, 请先重置',
      name: 'cardResetTips',
      desc: '',
      args: [],
    );
  }

  /// `该卡片未设置PIN, 请先设置`
  String get cardPinCodeTips {
    return Intl.message(
      '该卡片未设置PIN, 请先设置',
      name: 'cardPinCodeTips',
      desc: '',
      args: [],
    );
  }

  /// `该卡片不存在密匙, 请先添加`
  String get cardAddTips {
    return Intl.message(
      '该卡片不存在密匙, 请先添加',
      name: 'cardAddTips',
      desc: '',
      args: [],
    );
  }

  /// `取消PIN Code`
  String get cancelPinCode {
    return Intl.message(
      '取消PIN Code',
      name: 'cancelPinCode',
      desc: '',
      args: [],
    );
  }

  /// `数据库未录入{cardId}设备信息`
  String notEnterCardId(Object cardId) {
    return Intl.message(
      '数据库未录入$cardId设备信息',
      name: 'notEnterCardId',
      desc: '',
      args: [cardId],
    );
  }

  /// `请选择充币网络`
  String get selectCoin {
    return Intl.message('请选择充币网络', name: 'selectCoin', desc: '', args: []);
  }

  /// `此网络暂时不支持充币`
  String get unSupportRecharge {
    return Intl.message(
      '此网络暂时不支持充币',
      name: 'unSupportRecharge',
      desc: '',
      args: [],
    );
  }

  /// `已转出`
  String get transferredOut {
    return Intl.message('已转出', name: 'transferredOut', desc: '', args: []);
  }

  /// `已转入`
  String get transferredIn {
    return Intl.message('已转入', name: 'transferredIn', desc: '', args: []);
  }

  /// `处理中`
  String get processing {
    return Intl.message('处理中', name: 'processing', desc: '', args: []);
  }

  /// `扫码`
  String get scanQrCode {
    return Intl.message('扫码', name: 'scanQrCode', desc: '', args: []);
  }

  /// `NFC 功能不可用`
  String get nfcNotAvailable {
    return Intl.message(
      'NFC 功能不可用',
      name: 'nfcNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `加载失败`
  String get loadFailure {
    return Intl.message('加载失败', name: 'loadFailure', desc: '', args: []);
  }

  /// `刷新试试～～`
  String get tryRefresh {
    return Intl.message('刷新试试～～', name: 'tryRefresh', desc: '', args: []);
  }

  /// `刷新`
  String get refresh {
    return Intl.message('刷新', name: 'refresh', desc: '', args: []);
  }

  /// `数据为空`
  String get notData {
    return Intl.message('数据为空', name: 'notData', desc: '', args: []);
  }

  /// `失败`
  String get failed {
    return Intl.message('失败', name: 'failed', desc: '', args: []);
  }

  /// `数据库未录入该设备信息`
  String get notEnteredDevice {
    return Intl.message(
      '数据库未录入该设备信息',
      name: 'notEnteredDevice',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
