// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  static String m0(errorMsg) => "Binding failed: ${errorMsg}";

  static String m1(amount) => "(Withdrawable Amount ${amount})";

  static String m2(seconds) => "${seconds}秒后重新获取";

  static String m3(percent) => "${percent}% downloaded";

  static String m4(seconds) => "Retry after ${seconds} S";

  static String m5(lockDays) => "fixed term (${lockDays}day)";

  static String m6(versionName) => "New version available ${versionName}";

  static String m7(showDay) => "Mature in ${showDay} days";

  static String m8(coinType) => "The amount entered exceeds your ${coinType}";

  static String m9(minInvest) =>
      "Investment amount must be bigger than ${minInvest}";

  static String m10(cardId) => "数据库未录入${cardId}设备信息";

  static String m11(number) => "${number}days";

  static String m12(error) => "操作失败:${error}";

  static String m13(errorMsg) => "Update sort failed: ${errorMsg}";

  static String m14(errorMsg) => "Failed to save: ${errorMsg}";

  static String m15(email) =>
      "A verification code will be sent to the email address ${email}";

  static String m16(phoneNo) =>
      "A verification code will be sent to the phone no. ${phoneNo}";

  static String m17(amount, moneyUnit) =>
      "Maximum amount for a single transaction is ${amount}${moneyUnit}";

  static String m18(pageName) => "【${pageName}】Page jump is not supported";

  static String m19(coin) => "How much ${coin} do you want to  buy?";

  static String m20(coinUnit, minAmount, maxAmount) =>
      "Withdrawal Range (${coinUnit}${minAmount} ~ ${maxAmount})";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "ablumn": MessageLookupByLibrary.simpleMessage("Photo album"),
    "aboutUs": MessageLookupByLibrary.simpleMessage("About Us"),
    "accountNo": MessageLookupByLibrary.simpleMessage("Account Number"),
    "accountVerify": MessageLookupByLibrary.simpleMessage(
      "Account verification",
    ),
    "add": MessageLookupByLibrary.simpleMessage("Add to"),
    "addCapital": MessageLookupByLibrary.simpleMessage("ADD"),
    "addCard": MessageLookupByLibrary.simpleMessage("Add a card"),
    "addMemberCard": MessageLookupByLibrary.simpleMessage("Add member card"),
    "addNewLink": MessageLookupByLibrary.simpleMessage("Add new link"),
    "addSuccess": MessageLookupByLibrary.simpleMessage("Added successfully"),
    "addUsdtAddress": MessageLookupByLibrary.simpleMessage("Add USDT Address"),
    "address": MessageLookupByLibrary.simpleMessage("Address"),
    "adibBonus": MessageLookupByLibrary.simpleMessage("ADIB bonus"),
    "adibBonusWithdraw": MessageLookupByLibrary.simpleMessage(
      "ADIB bonus withdraw",
    ),
    "againExit": MessageLookupByLibrary.simpleMessage("Press Again To Exit"),
    "agreeAndRegister": MessageLookupByLibrary.simpleMessage(
      "Agree to the agreement and register",
    ),
    "agreed": MessageLookupByLibrary.simpleMessage("I have read and agree"),
    "agreementTip": MessageLookupByLibrary.simpleMessage(
      "Please accept registration agreement",
    ),
    "akun": MessageLookupByLibrary.simpleMessage("Akun"),
    "alreadyBind": MessageLookupByLibrary.simpleMessage(
      "User device already bind",
    ),
    "alreadyOCR": MessageLookupByLibrary.simpleMessage(
      "You Have Completed OCR Verification",
    ),
    "alreadyReinvest": MessageLookupByLibrary.simpleMessage("Already Reinvest"),
    "alreadyReturn": MessageLookupByLibrary.simpleMessage("Already Return"),
    "amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "amountAvailableTip": MessageLookupByLibrary.simpleMessage(
      "Amount available:",
    ),
    "amountNotEnough": MessageLookupByLibrary.simpleMessage(
      "Insufficient Withdrawal Amount",
    ),
    "amountToWithdraw": MessageLookupByLibrary.simpleMessage(
      "amount to withdraw",
    ),
    "amountWithdrawTIp": MessageLookupByLibrary.simpleMessage(
      "please input amount to withdraw",
    ),
    "and": MessageLookupByLibrary.simpleMessage("and"),
    "annualRate": MessageLookupByLibrary.simpleMessage(
      "Annual Percentage Rate",
    ),
    "appVersion": MessageLookupByLibrary.simpleMessage("Version Information"),
    "applyWithdraw": MessageLookupByLibrary.simpleMessage("Apply withdraw"),
    "applyWithdrawTip": MessageLookupByLibrary.simpleMessage(
      "User input amount in app to withdraw",
    ),
    "approvalTimeItem": MessageLookupByLibrary.simpleMessage("Approval time:"),
    "areadyScan": MessageLookupByLibrary.simpleMessage("Ready to scan"),
    "autoWithdraw": MessageLookupByLibrary.simpleMessage("Auto Withdrawing"),
    "available": MessageLookupByLibrary.simpleMessage("Available"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "balance": MessageLookupByLibrary.simpleMessage("Balance"),
    "balanceAsset": MessageLookupByLibrary.simpleMessage("Balance Assets"),
    "balanceHistory": MessageLookupByLibrary.simpleMessage("Balance History"),
    "balanceTotalAssets": MessageLookupByLibrary.simpleMessage(
      "Balance Total Assets",
    ),
    "bankCardTip": MessageLookupByLibrary.simpleMessage(
      "Please input bank card number",
    ),
    "bankInfoConfirm": MessageLookupByLibrary.simpleMessage(
      "Bank Card Information Confirmation",
    ),
    "bankNameItem": MessageLookupByLibrary.simpleMessage("Bank Name:"),
    "bankNoItem": MessageLookupByLibrary.simpleMessage("Bank Card Number:"),
    "bankTransfer": MessageLookupByLibrary.simpleMessage("Bank transfer"),
    "bankTransferTip": MessageLookupByLibrary.simpleMessage(
      "after approval，finance department will transfer amount to user bank account with 1 work day ",
    ),
    "bankType": MessageLookupByLibrary.simpleMessage("Bank Type"),
    "bankVertifyError": MessageLookupByLibrary.simpleMessage(
      "Bank Card Verification Failed, Please Re-Check Bank Account",
    ),
    "basicInfo": MessageLookupByLibrary.simpleMessage("Basic info"),
    "bgImage": MessageLookupByLibrary.simpleMessage("Background image"),
    "bind": MessageLookupByLibrary.simpleMessage("Bind"),
    "bindBank": MessageLookupByLibrary.simpleMessage("Bind Bank"),
    "bindCard": MessageLookupByLibrary.simpleMessage("Bind Card"),
    "bindEmail": MessageLookupByLibrary.simpleMessage("Bind email"),
    "bindFailure": m0,
    "bindPhone": MessageLookupByLibrary.simpleMessage("绑定手机号"),
    "bindSuccess": MessageLookupByLibrary.simpleMessage("Binding success"),
    "birthday": MessageLookupByLibrary.simpleMessage("Birthday"),
    "bonusDetails": MessageLookupByLibrary.simpleMessage("Bonus Details"),
    "bonusRank": MessageLookupByLibrary.simpleMessage("Bonus Rank"),
    "bonusRatio": MessageLookupByLibrary.simpleMessage("Discount Ratio"),
    "bonusWithdraw": MessageLookupByLibrary.simpleMessage("Bonus withdraw"),
    "buy": MessageLookupByLibrary.simpleMessage("Buy"),
    "buyCapital": MessageLookupByLibrary.simpleMessage("BUY"),
    "buyProduct": MessageLookupByLibrary.simpleMessage("Buy Product"),
    "buySuccess": MessageLookupByLibrary.simpleMessage("Purchase Success !"),
    "calculating": MessageLookupByLibrary.simpleMessage("Calculating..."),
    "canWithdraw": MessageLookupByLibrary.simpleMessage("Can be withdraw"),
    "canWithdrawAmount": m1,
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelAccountTip": MessageLookupByLibrary.simpleMessage(
      "After the account is cancelled, the data related to the account cannot be retrieved. Are you sure you want to perform this operation?",
    ),
    "cancelEmailSend": MessageLookupByLibrary.simpleMessage(
      "Mail has been canceled",
    ),
    "cancelPinCode": MessageLookupByLibrary.simpleMessage("取消PIN Code"),
    "cancel_request": MessageLookupByLibrary.simpleMessage(
      "Cancel the request",
    ),
    "cancellationAccount": MessageLookupByLibrary.simpleMessage(
      "Account cancellation",
    ),
    "cardAddTips": MessageLookupByLibrary.simpleMessage("该卡片不存在密匙, 请先添加"),
    "cardBrand": MessageLookupByLibrary.simpleMessage("Brand"),
    "cardData": MessageLookupByLibrary.simpleMessage("data:"),
    "cardDomain": MessageLookupByLibrary.simpleMessage("domain:"),
    "cardHolder": MessageLookupByLibrary.simpleMessage("Card Holder"),
    "cardInfo": MessageLookupByLibrary.simpleMessage("Card Info"),
    "cardManager": MessageLookupByLibrary.simpleMessage(
      "Smart Card Management",
    ),
    "cardName": MessageLookupByLibrary.simpleMessage("Card name"),
    "cardNo": MessageLookupByLibrary.simpleMessage("Card number"),
    "cardNoUnset": MessageLookupByLibrary.simpleMessage("未设置卡号"),
    "cardPinCodeTips": MessageLookupByLibrary.simpleMessage("该卡片未设置PIN, 请先设置"),
    "cardResetTips": MessageLookupByLibrary.simpleMessage("该卡片未重置或存在密匙, 请先重置"),
    "cardType": MessageLookupByLibrary.simpleMessage("type:"),
    "changeLanguage": MessageLookupByLibrary.simpleMessage("Change Language"),
    "changeRegister": MessageLookupByLibrary.simpleMessage("Switch Sign Up"),
    "changeVerify": MessageLookupByLibrary.simpleMessage(
      "Change verification method",
    ),
    "chinese": MessageLookupByLibrary.simpleMessage("Chinese"),
    "chooseBank": MessageLookupByLibrary.simpleMessage("Choose bank"),
    "chooseBankType": MessageLookupByLibrary.simpleMessage("Choose Bank Type"),
    "choosePayMethod": MessageLookupByLibrary.simpleMessage(
      "Please select the payment method",
    ),
    "chooseProduct": MessageLookupByLibrary.simpleMessage(
      "Choose investment product",
    ),
    "clickLogin": MessageLookupByLibrary.simpleMessage("Click to Login"),
    "clickUpload": MessageLookupByLibrary.simpleMessage("Click to upload"),
    "comfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "commissionAccount": MessageLookupByLibrary.simpleMessage(
      "Commission Account",
    ),
    "companyName": MessageLookupByLibrary.simpleMessage("Company Name"),
    "confirmDelete": MessageLookupByLibrary.simpleMessage("Confirm to delete?"),
    "continueStr": MessageLookupByLibrary.simpleMessage("CONTINUE"),
    "convenienceStore": MessageLookupByLibrary.simpleMessage(
      "ConvenienceStore",
    ),
    "conySuccess": MessageLookupByLibrary.simpleMessage("Copy success"),
    "copiedSuccess": MessageLookupByLibrary.simpleMessage("Copied success"),
    "coppiedLink": MessageLookupByLibrary.simpleMessage(
      "Link coppied success，spread and invite friends to join now！",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Copy"),
    "countDown": m2,
    "createExternal": MessageLookupByLibrary.simpleMessage("Create External"),
    "createMime": MessageLookupByLibrary.simpleMessage("Create Mime"),
    "createText": MessageLookupByLibrary.simpleMessage("Create Text:"),
    "createUri": MessageLookupByLibrary.simpleMessage("Create Uri:"),
    "cumulativeProfit": MessageLookupByLibrary.simpleMessage(
      "Cumulative Profit",
    ),
    "currentAmount": MessageLookupByLibrary.simpleMessage("Current balance"),
    "currentEmail": MessageLookupByLibrary.simpleMessage("Current email:"),
    "currentInvest": MessageLookupByLibrary.simpleMessage("Current Invest"),
    "currentLevel": MessageLookupByLibrary.simpleMessage("Current level"),
    "currentProduct": MessageLookupByLibrary.simpleMessage("Current Products"),
    "currentStable": MessageLookupByLibrary.simpleMessage("Currently Stable"),
    "currentUser": MessageLookupByLibrary.simpleMessage("Current user:"),
    "currentVersion": MessageLookupByLibrary.simpleMessage("Current version:"),
    "currentlyInvited": MessageLookupByLibrary.simpleMessage(
      "Investment amount currently invited:",
    ),
    "customerApproval": MessageLookupByLibrary.simpleMessage(
      "Customer service approval",
    ),
    "customerApprovalTip": MessageLookupByLibrary.simpleMessage(
      "Customer service review withdraw application，check amount and user info",
    ),
    "cutPhoneFailure": MessageLookupByLibrary.simpleMessage(
      "Failed to crop avatar",
    ),
    "dailyInvestment": MessageLookupByLibrary.simpleMessage(
      "Average daily investment amount",
    ),
    "dailyRate": MessageLookupByLibrary.simpleMessage("Daily Rate ="),
    "dailyReturn": MessageLookupByLibrary.simpleMessage("Daily return"),
    "dataSource": MessageLookupByLibrary.simpleMessage("Data source:"),
    "day": MessageLookupByLibrary.simpleMessage("Day"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteCard": MessageLookupByLibrary.simpleMessage("Delete card"),
    "deleteMsgTip": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete the selected messages?",
    ),
    "deleteSuccess": MessageLookupByLibrary.simpleMessage("Delete success"),
    "demo": MessageLookupByLibrary.simpleMessage("Demo"),
    "deparment": MessageLookupByLibrary.simpleMessage("Deparment: "),
    "department": MessageLookupByLibrary.simpleMessage("Department"),
    "deposit": MessageLookupByLibrary.simpleMessage("Deposit"),
    "depositAmount": MessageLookupByLibrary.simpleMessage("Deposit Amount"),
    "depositMethod": MessageLookupByLibrary.simpleMessage("Deposit Method"),
    "depositOrderInfo": MessageLookupByLibrary.simpleMessage(
      "Deposit order information",
    ),
    "depositReminder": MessageLookupByLibrary.simpleMessage("Deposit Reminder"),
    "depositSuccess": MessageLookupByLibrary.simpleMessage("Deposit Success"),
    "depositTips": MessageLookupByLibrary.simpleMessage(
      "Warning:Only the repayment code generated inside this App is official and valid,please be aware of any Fraud!!!",
    ),
    "directLevel": MessageLookupByLibrary.simpleMessage("Direct level"),
    "disableEmailApp": MessageLookupByLibrary.simpleMessage(
      "No email app available on phone",
    ),
    "disableNdef": MessageLookupByLibrary.simpleMessage("Tag is not ndef"),
    "disableNfc": MessageLookupByLibrary.simpleMessage("Nfc is not Available"),
    "disableWrite": MessageLookupByLibrary.simpleMessage(
      "Tag is not ndef writable",
    ),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "downloadFail": MessageLookupByLibrary.simpleMessage("Download failed"),
    "downloadPercent": m3,
    "downloadSuccess": MessageLookupByLibrary.simpleMessage(
      "Download successful",
    ),
    "dueTime": MessageLookupByLibrary.simpleMessage("Term"),
    "earnCoin": MessageLookupByLibrary.simpleMessage(
      "Saving and Earning Coin, Guarantee Profit",
    ),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editCard": MessageLookupByLibrary.simpleMessage("Edit card"),
    "editCardInfo": MessageLookupByLibrary.simpleMessage(
      "Edit card information",
    ),
    "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
    "editQr": MessageLookupByLibrary.simpleMessage("Edit QR"),
    "editRemark": MessageLookupByLibrary.simpleMessage("Edit Remark"),
    "editUsdtAddress": MessageLookupByLibrary.simpleMessage(
      "Edit USDT Address",
    ),
    "emailCodeLogin": MessageLookupByLibrary.simpleMessage(
      "Email and verification code",
    ),
    "emailError": MessageLookupByLibrary.simpleMessage(
      "Email format is incorrect",
    ),
    "emailLogin": MessageLookupByLibrary.simpleMessage("Email password login"),
    "emailPwdLogin": MessageLookupByLibrary.simpleMessage("Email and password"),
    "emailRegister": MessageLookupByLibrary.simpleMessage("邮箱注册"),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enterAccountInfo": MessageLookupByLibrary.simpleMessage(
      "Input account information",
    ),
    "enterAddress": MessageLookupByLibrary.simpleMessage("Enter your Address"),
    "enterCardName": MessageLookupByLibrary.simpleMessage("Enter card name"),
    "enterCompanyName": MessageLookupByLibrary.simpleMessage(
      "Enter your company name",
    ),
    "enterDepartment": MessageLookupByLibrary.simpleMessage(
      "Enter your department",
    ),
    "enterEmail": MessageLookupByLibrary.simpleMessage(
      "Input the email address",
    ),
    "enterEmailCode": MessageLookupByLibrary.simpleMessage(
      "Enter email verification code",
    ),
    "enterEmailContent": MessageLookupByLibrary.simpleMessage(
      "Enter email content",
    ),
    "enterEmailTitle": MessageLookupByLibrary.simpleMessage(
      "Enter email title",
    ),
    "enterFormatError": MessageLookupByLibrary.simpleMessage(
      "Information is not in the correct format",
    ),
    "enterHint": MessageLookupByLibrary.simpleMessage("Please enter..."),
    "enterMemberPhone": MessageLookupByLibrary.simpleMessage(
      "Enter member phone no.",
    ),
    "enterName": MessageLookupByLibrary.simpleMessage("Enter your name"),
    "enterNewPwd": MessageLookupByLibrary.simpleMessage("Enter new password"),
    "enterNewPwdAgain": MessageLookupByLibrary.simpleMessage(
      "Enter new password again",
    ),
    "enterOriginPwd": MessageLookupByLibrary.simpleMessage(
      "Enter origin password",
    ),
    "enterPhoneCode": MessageLookupByLibrary.simpleMessage(
      "Enter verification code",
    ),
    "enterPhoneNo": MessageLookupByLibrary.simpleMessage("Input phone no."),
    "enterPwd": MessageLookupByLibrary.simpleMessage(
      "Enter password of at least 6 digits",
    ),
    "enterRemark": MessageLookupByLibrary.simpleMessage("Enter remarks"),
    "enterTitle": MessageLookupByLibrary.simpleMessage("Enter your job title"),
    "enterinviteCode": MessageLookupByLibrary.simpleMessage(
      "Enter an invitation code (optional)",
    ),
    "equity": MessageLookupByLibrary.simpleMessage("Equity"),
    "errorInfo": MessageLookupByLibrary.simpleMessage("Error message"),
    "error_code_bad_request": MessageLookupByLibrary.simpleMessage(
      "Remote server or network failed, Please try again later.",
    ),
    "estimatedReturn": MessageLookupByLibrary.simpleMessage("Estimated Return"),
    "expectReturn": MessageLookupByLibrary.simpleMessage(
      "Estimated Rate of Return",
    ),
    "expiredTip": MessageLookupByLibrary.simpleMessage(
      "Your login has expired, please log in again!",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("失败"),
    "feeCharged": MessageLookupByLibrary.simpleMessage("Service charge"),
    "female": MessageLookupByLibrary.simpleMessage("Female"),
    "fetchCode": m4,
    "filexible": MessageLookupByLibrary.simpleMessage("flexible"),
    "firstApproval": MessageLookupByLibrary.simpleMessage("First Approval"),
    "firstName": MessageLookupByLibrary.simpleMessage("First Name"),
    "fixedTerm": m5,
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot password"),
    "forgotPwd": MessageLookupByLibrary.simpleMessage("Forgot password"),
    "foundNewVersion": m6,
    "from": MessageLookupByLibrary.simpleMessage("From"),
    "frozen": MessageLookupByLibrary.simpleMessage("Frozen"),
    "fundAccount": MessageLookupByLibrary.simpleMessage("Fund Account"),
    "funding": MessageLookupByLibrary.simpleMessage("Funding"),
    "gender": MessageLookupByLibrary.simpleMessage("Gender"),
    "gotoRegister": MessageLookupByLibrary.simpleMessage(
      "No account? Go register one",
    ),
    "handWithdraw": MessageLookupByLibrary.simpleMessage("Withdraw By Hand"),
    "help": MessageLookupByLibrary.simpleMessage("Help"),
    "history": MessageLookupByLibrary.simpleMessage("History"),
    "holderItem": MessageLookupByLibrary.simpleMessage("Cardholder:"),
    "iAgree": MessageLookupByLibrary.simpleMessage("I agree"),
    "iWantInvest": MessageLookupByLibrary.simpleMessage("I Want To Invest"),
    "iWantTo": MessageLookupByLibrary.simpleMessage("I want to "),
    "idNo": MessageLookupByLibrary.simpleMessage("ID No."),
    "increase": MessageLookupByLibrary.simpleMessage("Increase"),
    "indonesia": MessageLookupByLibrary.simpleMessage("Indonesia"),
    "inputAccount": MessageLookupByLibrary.simpleMessage(
      "Input Account Number",
    ),
    "inputAmount": MessageLookupByLibrary.simpleMessage("Input Amount"),
    "inputMobile": MessageLookupByLibrary.simpleMessage(
      "Please input mobile number",
    ),
    "inputPassword": MessageLookupByLibrary.simpleMessage(
      "Please input password",
    ),
    "inputPhone": MessageLookupByLibrary.simpleMessage(
      "Please input phone number!",
    ),
    "inputUsdtAddress": MessageLookupByLibrary.simpleMessage(
      "Input USDT address",
    ),
    "inputVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Please input verification code",
    ),
    "inputWithdrawAmount": MessageLookupByLibrary.simpleMessage(
      "Please enter the withdrawal amount",
    ),
    "insufficientBalance": MessageLookupByLibrary.simpleMessage(
      "Insufficient Balance",
    ),
    "into": MessageLookupByLibrary.simpleMessage("Into"),
    "invest": MessageLookupByLibrary.simpleMessage("Invest"),
    "investHistory": MessageLookupByLibrary.simpleMessage(
      "Investment order history",
    ),
    "investIntro": MessageLookupByLibrary.simpleMessage(
      "Investment introduction",
    ),
    "investNow": MessageLookupByLibrary.simpleMessage("Invest Now"),
    "investSuccess": MessageLookupByLibrary.simpleMessage("Invest success"),
    "investTips": MessageLookupByLibrary.simpleMessage(
      "Investment amount must be integral times of 100",
    ),
    "investmentAmount": MessageLookupByLibrary.simpleMessage(
      "Investment amount",
    ),
    "investmentIntro": MessageLookupByLibrary.simpleMessage(
      "Investment introduction",
    ),
    "investmentItem": MessageLookupByLibrary.simpleMessage(
      "Investment product:",
    ),
    "invitationBonus": MessageLookupByLibrary.simpleMessage("Invitation Bonus"),
    "invitationCode": MessageLookupByLibrary.simpleMessage("Invitation code:"),
    "invitationCodeTip": MessageLookupByLibrary.simpleMessage(
      "Invitation code (optional)",
    ),
    "invitationNo": MessageLookupByLibrary.simpleMessage(
      "Number of Invitations",
    ),
    "inviteDetail": MessageLookupByLibrary.simpleMessage("Invitation Details"),
    "inviteFriends": MessageLookupByLibrary.simpleMessage("Invite friends"),
    "inviteNow": MessageLookupByLibrary.simpleMessage("Invite friends now"),
    "invitedOrder": MessageLookupByLibrary.simpleMessage("Invited order"),
    "keepPassword": MessageLookupByLibrary.simpleMessage("Keep password"),
    "language": MessageLookupByLibrary.simpleMessage("language:"),
    "lastName": MessageLookupByLibrary.simpleMessage("Last Name"),
    "level": MessageLookupByLibrary.simpleMessage("Level"),
    "levelActive": MessageLookupByLibrary.simpleMessage("level active"),
    "levelLocked": MessageLookupByLibrary.simpleMessage("level locked"),
    "linkFormatError": MessageLookupByLibrary.simpleMessage(
      "The redirected URL is incorrect",
    ),
    "links": MessageLookupByLibrary.simpleMessage("Links"),
    "loadFailure": MessageLookupByLibrary.simpleMessage("加载失败"),
    "loadMoreTip": MessageLookupByLibrary.simpleMessage("Pull up load"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading…"),
    "loadingFailure": MessageLookupByLibrary.simpleMessage("Loading failure"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "login_status_expired": MessageLookupByLibrary.simpleMessage(
      "The login status has expired, please login again.",
    ),
    "logo": MessageLookupByLibrary.simpleMessage("Logo"),
    "logoutAccount": MessageLookupByLibrary.simpleMessage(
      "Logout current account",
    ),
    "mainCard": MessageLookupByLibrary.simpleMessage("(Main Card)"),
    "male": MessageLookupByLibrary.simpleMessage("Male"),
    "manager": MessageLookupByLibrary.simpleMessage("Manager"),
    "matureDate": MessageLookupByLibrary.simpleMessage("Mature Date"),
    "matureDay": m7,
    "maxAmount": MessageLookupByLibrary.simpleMessage("maximum amount:"),
    "maxCoinTip": m8,
    "maxTransfer": MessageLookupByLibrary.simpleMessage("Max. transfer"),
    "messageCenter": MessageLookupByLibrary.simpleMessage("Message center"),
    "messageDetail": MessageLookupByLibrary.simpleMessage("Message detail"),
    "messages": MessageLookupByLibrary.simpleMessage("Messages"),
    "minInvestTip": m9,
    "modify": MessageLookupByLibrary.simpleMessage("Modify"),
    "modifyEmail": MessageLookupByLibrary.simpleMessage("Modify email"),
    "modifyPwd": MessageLookupByLibrary.simpleMessage("Modify password"),
    "modifyPwdSuccess": MessageLookupByLibrary.simpleMessage(
      "Modify password success",
    ),
    "modifySuccess": MessageLookupByLibrary.simpleMessage(
      "Successfully modified",
    ),
    "monthForecast": MessageLookupByLibrary.simpleMessage(
      "Forecast Return for 30 day:",
    ),
    "monthlyCommission": MessageLookupByLibrary.simpleMessage(
      "Discount of the Month",
    ),
    "myAsset": MessageLookupByLibrary.simpleMessage("My Asset"),
    "myCard": MessageLookupByLibrary.simpleMessage("My Card"),
    "myInvitationCode": MessageLookupByLibrary.simpleMessage(
      "My Invitation code",
    ),
    "myNetwork": MessageLookupByLibrary.simpleMessage("My network"),
    "myNode": MessageLookupByLibrary.simpleMessage("My node"),
    "myOrders": MessageLookupByLibrary.simpleMessage("My Orders"),
    "myPortfolio": MessageLookupByLibrary.simpleMessage("My Portfolio"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "ndefWrite": MessageLookupByLibrary.simpleMessage(
      "Success to \"Ndef Write\"",
    ),
    "network_connect_timeout": MessageLookupByLibrary.simpleMessage(
      "Connection timeout",
    ),
    "network_error": MessageLookupByLibrary.simpleMessage(
      "Unable to connect to the network, please try again",
    ),
    "network_request_timeout": MessageLookupByLibrary.simpleMessage(
      "Request timeout",
    ),
    "network_response_timeout": MessageLookupByLibrary.simpleMessage(
      "Response timeout",
    ),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "nfcNotAvailable": MessageLookupByLibrary.simpleMessage("NFC 功能不可用"),
    "nfcOffTip": MessageLookupByLibrary.simpleMessage(
      "Turn NFC on in Settings,then try again.",
    ),
    "nfcOffTitle": MessageLookupByLibrary.simpleMessage("NFC is Turned Off"),
    "nfcRegister": MessageLookupByLibrary.simpleMessage("NFC卡注册"),
    "nfcWrite": MessageLookupByLibrary.simpleMessage("NFC writing card"),
    "nickNameTip": MessageLookupByLibrary.simpleMessage(
      "Please input Username",
    ),
    "nickname": MessageLookupByLibrary.simpleMessage("Username"),
    "noAccount": MessageLookupByLibrary.simpleMessage("No Account Added"),
    "noInvestTip": MessageLookupByLibrary.simpleMessage(
      "Investment amount must be bigger than 0",
    ),
    "noLogTips": MessageLookupByLibrary.simpleMessage(
      "You Haven\'t Logged in, Please Login",
    ),
    "noMoreData": MessageLookupByLibrary.simpleMessage("No more Data"),
    "noRecord": MessageLookupByLibrary.simpleMessage("No record!"),
    "noRecords": MessageLookupByLibrary.simpleMessage("No records"),
    "noSameCard": MessageLookupByLibrary.simpleMessage(
      "The current smart card numbers are inconsistent!",
    ),
    "noText": MessageLookupByLibrary.simpleMessage("NO"),
    "notData": MessageLookupByLibrary.simpleMessage("数据为空"),
    "notEnterCardId": m10,
    "notEnteredDevice": MessageLookupByLibrary.simpleMessage("数据库未录入该设备信息"),
    "notLogged": MessageLookupByLibrary.simpleMessage(
      "Not logged in/Click to login",
    ),
    "notLogin": MessageLookupByLibrary.simpleMessage("Not logged in"),
    "notMature": MessageLookupByLibrary.simpleMessage("Not mature"),
    "nulllist": MessageLookupByLibrary.simpleMessage("List is empty"),
    "numberDays": m11,
    "ocrVerify": MessageLookupByLibrary.simpleMessage("OCR verify"),
    "operateError": MessageLookupByLibrary.simpleMessage("操作失败"),
    "operateErrorWithInfo": m12,
    "operateTutorial": MessageLookupByLibrary.simpleMessage("How to use"),
    "orderBonus": MessageLookupByLibrary.simpleMessage("Order bonus"),
    "orderBonusWithdraw": MessageLookupByLibrary.simpleMessage(
      "Order bonus withdraw",
    ),
    "orderInvitation": MessageLookupByLibrary.simpleMessage(
      "Order from invitation",
    ),
    "orderSuccess": m13,
    "other": MessageLookupByLibrary.simpleMessage("Other"),
    "otherAmount": MessageLookupByLibrary.simpleMessage("Other Amount"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordTip": MessageLookupByLibrary.simpleMessage(
      "Password at least 6 digits",
    ),
    "payTimeItem": MessageLookupByLibrary.simpleMessage("Pay time: "),
    "percentRateItem": MessageLookupByLibrary.simpleMessage(
      "Annual percentage rate:",
    ),
    "percentRatetion": MessageLookupByLibrary.simpleMessage(
      "Annual percentage ratetion",
    ),
    "phoneCodeLogin": MessageLookupByLibrary.simpleMessage(
      "Mobile No. and verification code",
    ),
    "phoneFormatError": MessageLookupByLibrary.simpleMessage("手机号格式错误"),
    "phoneLogin": MessageLookupByLibrary.simpleMessage(
      "Login with mobile no. and password",
    ),
    "phoneNoLogin": MessageLookupByLibrary.simpleMessage("Mobile no. login"),
    "phoneNoTitle": MessageLookupByLibrary.simpleMessage("Phone no:"),
    "phonePwdLogin": MessageLookupByLibrary.simpleMessage(
      "Mobile No. and password",
    ),
    "phoneRegister": MessageLookupByLibrary.simpleMessage("手机号注册"),
    "postCode": MessageLookupByLibrary.simpleMessage("Post Code"),
    "preview": MessageLookupByLibrary.simpleMessage("Preview"),
    "price": MessageLookupByLibrary.simpleMessage("Price"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "procedure": MessageLookupByLibrary.simpleMessage("Withdraw procedure"),
    "procedureTip": MessageLookupByLibrary.simpleMessage(
      "fixed term product can not withdraw before mature，flexible product can withdraw at any time",
    ),
    "processing": MessageLookupByLibrary.simpleMessage("处理中"),
    "profit": MessageLookupByLibrary.simpleMessage("Profit"),
    "profitLossToday": MessageLookupByLibrary.simpleMessage(
      "Profit / Loss Today",
    ),
    "pwdTypeTip": MessageLookupByLibrary.simpleMessage(
      "6-16 digit(letter, number, symbol),can not use 1 type only,case sensitive",
    ),
    "qrCodeError": MessageLookupByLibrary.simpleMessage("Incorrect QR code"),
    "rateOfReturn": MessageLookupByLibrary.simpleMessage("Rate of Return"),
    "readCard": MessageLookupByLibrary.simpleMessage("Read"),
    "readCardError": MessageLookupByLibrary.simpleMessage(
      "Read card error,please try it again!",
    ),
    "readCardIdError": MessageLookupByLibrary.simpleMessage(
      "can not read card identifier",
    ),
    "realReceived": MessageLookupByLibrary.simpleMessage(
      "Actual amount received",
    ),
    "rechargeTip": MessageLookupByLibrary.simpleMessage(
      "Please enter the deposit amount",
    ),
    "redeem": MessageLookupByLibrary.simpleMessage("Redeem"),
    "refresh": MessageLookupByLibrary.simpleMessage("刷新"),
    "refurnForecast": MessageLookupByLibrary.simpleMessage("Refurn Forecast"),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "registerAccount": MessageLookupByLibrary.simpleMessage(
      "Register an account",
    ),
    "registerAgreement": MessageLookupByLibrary.simpleMessage(
      "user registration agreement",
    ),
    "registerNow": MessageLookupByLibrary.simpleMessage("Register now"),
    "registerSuccess": MessageLookupByLibrary.simpleMessage("Register Success"),
    "reinvest": MessageLookupByLibrary.simpleMessage("Reinvest"),
    "reinvestTime": MessageLookupByLibrary.simpleMessage("Reinvest Time"),
    "reinvestTimeItem": MessageLookupByLibrary.simpleMessage(
      "Reinvested time:",
    ),
    "releaseLoadMoreTip": MessageLookupByLibrary.simpleMessage(
      "Release to load more",
    ),
    "reload": MessageLookupByLibrary.simpleMessage("Reload"),
    "reloadTip": MessageLookupByLibrary.simpleMessage(
      "Load Failed!Click retry!",
    ),
    "remark": MessageLookupByLibrary.simpleMessage("Remark"),
    "rememberPwd": MessageLookupByLibrary.simpleMessage("Remember password"),
    "remote_server_or_network_is_abnormal":
        MessageLookupByLibrary.simpleMessage(
          "The remote server or network is abnormal, please try again later.",
        ),
    "repayCode": MessageLookupByLibrary.simpleMessage("Repay Code"),
    "resetPwd": MessageLookupByLibrary.simpleMessage("Reset password"),
    "resetPwdSuccess": MessageLookupByLibrary.simpleMessage(
      "Reset password success",
    ),
    "returnForecast": MessageLookupByLibrary.simpleMessage("Return forecast"),
    "returnYesterday": MessageLookupByLibrary.simpleMessage(
      "return of yesterday",
    ),
    "rewardsRecord": MessageLookupByLibrary.simpleMessage("Rewards record"),
    "riil": MessageLookupByLibrary.simpleMessage("Riil"),
    "riskProduct": MessageLookupByLibrary.simpleMessage("Product with Risk"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveEmailDraft": MessageLookupByLibrary.simpleMessage(
      "Saved to draft email",
    ),
    "saveFailure": m14,
    "saveRqSuccess": MessageLookupByLibrary.simpleMessage(
      "QR code saved successfully",
    ),
    "scanQrCode": MessageLookupByLibrary.simpleMessage("扫码"),
    "scanTip": MessageLookupByLibrary.simpleMessage(
      "Hold your card to the upper back of your phone to activate it.Hold the card there until a success popup appears!",
    ),
    "selectBankTip": MessageLookupByLibrary.simpleMessage("Please select bank"),
    "selectCoin": MessageLookupByLibrary.simpleMessage("请选择充币网络"),
    "selectCountry": MessageLookupByLibrary.simpleMessage("选择国家或地区"),
    "selectCrypto": MessageLookupByLibrary.simpleMessage("Select crypto"),
    "selectMessage": MessageLookupByLibrary.simpleMessage("请选择要操作的消息"),
    "selectOperateMsg": MessageLookupByLibrary.simpleMessage(
      "Please select a message to act on",
    ),
    "sell": MessageLookupByLibrary.simpleMessage("Sell"),
    "sellCapital": MessageLookupByLibrary.simpleMessage("SELL"),
    "sellSuccess": MessageLookupByLibrary.simpleMessage("Sold Success !"),
    "send": MessageLookupByLibrary.simpleMessage("Send"),
    "sendCodeSuccess": MessageLookupByLibrary.simpleMessage(
      "Verification code sent",
    ),
    "sendEmail": MessageLookupByLibrary.simpleMessage("Send email"),
    "sendEmailCode": m15,
    "sendEmailSuccess": MessageLookupByLibrary.simpleMessage(
      "Mail sent successfully",
    ),
    "sendPhoneCode": m16,
    "server_is_busy": MessageLookupByLibrary.simpleMessage(
      "The server is busy, please try again later.",
    ),
    "server_upgrade": MessageLookupByLibrary.simpleMessage(
      "The server is being updated, please try again later.",
    ),
    "setMainCard": MessageLookupByLibrary.simpleMessage("Set as main card"),
    "setMainPostCard": MessageLookupByLibrary.simpleMessage("Set as main card"),
    "setPwd": MessageLookupByLibrary.simpleMessage("Set Password"),
    "setPwdSuccess": MessageLookupByLibrary.simpleMessage(
      "Set password successfully",
    ),
    "setting": MessageLookupByLibrary.simpleMessage("Setting"),
    "settings": MessageLookupByLibrary.simpleMessage("Setting"),
    "share": MessageLookupByLibrary.simpleMessage("Share"),
    "shareProfile": MessageLookupByLibrary.simpleMessage(
      "Sharing Personal Profile",
    ),
    "singleMax": m17,
    "spot": MessageLookupByLibrary.simpleMessage("Spot"),
    "statusItem": MessageLookupByLibrary.simpleMessage("Status:"),
    "steadyAsset": MessageLookupByLibrary.simpleMessage(
      "Robust Fixed Income Asset",
    ),
    "submitTimeItem": MessageLookupByLibrary.simpleMessage("Submit time:"),
    "successOCR": MessageLookupByLibrary.simpleMessage(
      "OCR Verification Completed",
    ),
    "switchLogin": MessageLookupByLibrary.simpleMessage("Switch login"),
    "tabHand": MessageLookupByLibrary.simpleMessage("Card in hand"),
    "tabHolder": MessageLookupByLibrary.simpleMessage("Card in holder"),
    "tagRecords": MessageLookupByLibrary.simpleMessage("Tag Records:"),
    "takePhoto": MessageLookupByLibrary.simpleMessage("Take Photo"),
    "tapDownload": MessageLookupByLibrary.simpleMessage("Tap to download"),
    "tapSave": MessageLookupByLibrary.simpleMessage(
      "Tap to download QR code to photos",
    ),
    "task": MessageLookupByLibrary.simpleMessage("Task"),
    "time": MessageLookupByLibrary.simpleMessage("Time"),
    "timerInvestTip": MessageLookupByLibrary.simpleMessage(
      "Investment amount must be integral times of 100",
    ),
    "tip": MessageLookupByLibrary.simpleMessage("Tip"),
    "tips": MessageLookupByLibrary.simpleMessage("Tips"),
    "title": MessageLookupByLibrary.simpleMessage("Job title"),
    "to": MessageLookupByLibrary.simpleMessage("To"),
    "todayProfit": MessageLookupByLibrary.simpleMessage("Today\'s Profit"),
    "token": MessageLookupByLibrary.simpleMessage("Token"),
    "totalBonus": MessageLookupByLibrary.simpleMessage("Total Bonus"),
    "totalExpectReturn": MessageLookupByLibrary.simpleMessage(
      "Total Expected Return",
    ),
    "totalNetAssets": MessageLookupByLibrary.simpleMessage(
      "Total Net Assets Valuation",
    ),
    "totalPayment": MessageLookupByLibrary.simpleMessage("Total Payment"),
    "totalReturn": MessageLookupByLibrary.simpleMessage("Total Return"),
    "tradingAccounts": MessageLookupByLibrary.simpleMessage("Trading accounts"),
    "transactionAccount": MessageLookupByLibrary.simpleMessage(
      "Transaction Account",
    ),
    "transfer": MessageLookupByLibrary.simpleMessage("Transfer"),
    "transferAll": MessageLookupByLibrary.simpleMessage("Transfer all"),
    "transferSuccess": MessageLookupByLibrary.simpleMessage(
      "Transfer successful!！",
    ),
    "transferredIn": MessageLookupByLibrary.simpleMessage("已转入"),
    "transferredOut": MessageLookupByLibrary.simpleMessage("已转出"),
    "tryRefresh": MessageLookupByLibrary.simpleMessage("刷新试试～～"),
    "twicePwd": MessageLookupByLibrary.simpleMessage(
      "The passwords entered repeatedly are inconsistent",
    ),
    "type": MessageLookupByLibrary.simpleMessage("Type"),
    "unSupportRecharge": MessageLookupByLibrary.simpleMessage("此网络暂时不支持充币"),
    "unbindEmail": MessageLookupByLibrary.simpleMessage("未绑定邮箱"),
    "unbindPhone": MessageLookupByLibrary.simpleMessage("未绑定手机号"),
    "unknown_error": MessageLookupByLibrary.simpleMessage("Unknown error"),
    "unknown_mistake": MessageLookupByLibrary.simpleMessage("Unknown error"),
    "unsettlement": MessageLookupByLibrary.simpleMessage("Unsettlement"),
    "unsupporetCard": MessageLookupByLibrary.simpleMessage(
      "The current card type is not yet supported, so stay tuned!",
    ),
    "unsupportActivity": m18,
    "unsupportedAmount": MessageLookupByLibrary.simpleMessage(
      "The current card type does not support reading the balance.",
    ),
    "updateName": MessageLookupByLibrary.simpleMessage("Modify name"),
    "updateNickname": MessageLookupByLibrary.simpleMessage("修改昵称"),
    "updateQRSource": MessageLookupByLibrary.simpleMessage(
      "Modify source of QR code",
    ),
    "updating": MessageLookupByLibrary.simpleMessage("Updating…"),
    "upgradeFail": MessageLookupByLibrary.simpleMessage("Upgrade unsuccessful"),
    "upgradeNow": MessageLookupByLibrary.simpleMessage("Update Now"),
    "upgradeTips": MessageLookupByLibrary.simpleMessage(
      "New Version Available, Update Now ?",
    ),
    "upgrading": MessageLookupByLibrary.simpleMessage("Upgrading..."),
    "usdtAddress": MessageLookupByLibrary.simpleMessage("USDT Address"),
    "userAgreement": MessageLookupByLibrary.simpleMessage("User Agreement"),
    "userInvitedList": MessageLookupByLibrary.simpleMessage(
      "List of invited users",
    ),
    "userLevel": MessageLookupByLibrary.simpleMessage("User Level"),
    "verificationCode": MessageLookupByLibrary.simpleMessage(
      "Verification code",
    ),
    "wallet": MessageLookupByLibrary.simpleMessage("Wallet"),
    "wantBuy": m19,
    "withdraw": MessageLookupByLibrary.simpleMessage("Withdraw"),
    "withdrawAmount": MessageLookupByLibrary.simpleMessage("Withdrawal Amount"),
    "withdrawApprove": MessageLookupByLibrary.simpleMessage(
      "Withdrawal waiting approve",
    ),
    "withdrawRange": m20,
    "withdrawRecords": MessageLookupByLibrary.simpleMessage("Withdraw records"),
    "withdrawSuccessTip": MessageLookupByLibrary.simpleMessage(
      "The withdrawal application is submitted successfully!",
    ),
    "withdrawToCard": MessageLookupByLibrary.simpleMessage(
      "Withdraw Bank Card",
    ),
    "withdrawType": MessageLookupByLibrary.simpleMessage("Withdraw Type"),
    "withdrawVerify": MessageLookupByLibrary.simpleMessage(
      "Identity authentication is required to withdraw cash. Do you want to authenticate now?",
    ),
    "withdrawWaiting": MessageLookupByLibrary.simpleMessage(
      "Withdrawal waiting approve",
    ),
    "writeCard": MessageLookupByLibrary.simpleMessage("Write"),
    "writeSuccess": MessageLookupByLibrary.simpleMessage("Write success"),
    "yesText": MessageLookupByLibrary.simpleMessage("YES"),
    "yourAddress": MessageLookupByLibrary.simpleMessage("Your address"),
    "yourBalane": MessageLookupByLibrary.simpleMessage("Your Balance"),
    "yourCompanyName": MessageLookupByLibrary.simpleMessage(
      "Your company name",
    ),
    "yourDepartment": MessageLookupByLibrary.simpleMessage("Your department"),
    "yourName": MessageLookupByLibrary.simpleMessage("Your name"),
    "yourRemark": MessageLookupByLibrary.simpleMessage("Your remarks"),
    "yourTitle": MessageLookupByLibrary.simpleMessage("Your title"),
  };
}
