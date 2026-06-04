import 'dart:convert';
import 'package:card_coin/bean/coin_balance_info.dart';
import 'package:card_coin/bean/coin_info.dart';
import 'package:card_coin/bean/coin_message_detail.dart';
import 'package:card_coin/bean/investment_config.dart';
import 'package:card_coin/bean/page_field_config.dart';
import 'package:card_coin/card_base/bean/common_info_bean.dart';
import 'package:card_coin/card_base/bean/investment_forecast.dart';
import 'package:card_coin/card_base/bean/investment_info.dart';
import 'package:card_coin/card_base/bean/investment_interval.dart';
import 'package:card_coin/bean/fiat_bean.dart';

import 'blockchain/bit_coin_transaction_info.dart';

class CardInfo {
  late String cardId;
  late String publicKey;
  late String nickName;
  late String version;
  late bool isSelected;
  late bool locked;
  late bool isPasswordSet;
  late bool isNewDevice;

  List<CurrencyInfo> get blockchains =>
      wallets.where((element) => element.type == 'blockchain').toList();

  List<CurrencyInfo> get tokens =>
      wallets.where((element) => element.type == 'token').toList();

  List<CurrencyInfo> wallets = [];

  CardDetail? cardDetail;

  FiatInfo? fiatInfo;

  CardInfo(
      {required this.cardId,
      required this.publicKey,
      required this.wallets,
      this.version = '',
      this.isPasswordSet = false,
      this.isSelected = false,
      this.isNewDevice = false,
      this.nickName = '',
      this.locked = true,
      this.cardDetail,
      this.fiatInfo});

  CardInfo copyWidth(
      {List<CurrencyInfo>? wallets,
      String? nickName,
      bool? isSelected,
      CardDetail? cardDetail,
      FiatInfo? fiatInfo}) {
    return CardInfo(
        cardId: cardId,
        publicKey: publicKey,
        version: version,
        nickName: nickName ?? this.nickName,
        isNewDevice: isNewDevice,
        locked: locked,
        isPasswordSet: isPasswordSet,
        wallets: wallets ?? this.wallets,
        cardDetail: cardDetail ?? this.cardDetail,
        fiatInfo: fiatInfo ?? this.fiatInfo,
        isSelected: isSelected ?? this.isSelected);
  }

  CardInfo.fromJson(Map<String, dynamic> json) {
    isSelected = json['isSelected'];
    cardId = json['cardId'];
    version = json['version'] ?? '';
    nickName = json['nickName'] ?? '';
    publicKey = json['publicKey'];
    locked = json['locked'] ?? false;
    isPasswordSet = json['isPasswordSet'] ?? false;
    isNewDevice = json['isNewDevice'] ?? false;

    if (json['cardDetail'] != null) {
      cardDetail = CardDetail.fromJson(jsonDecode(json['cardDetail']));
    }

    if (json['fiatInfo'] != null) {
      fiatInfo = FiatInfo.fromJson(jsonDecode(json['fiatInfo']));
    }

    if (json['wallets'] != null) {
      List list = json['wallets'] as List;
      wallets = list.map((e) => CurrencyInfo.fromJson(jsonDecode(e))).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSelected'] = isSelected;
    data['isNewDevice'] = isNewDevice;
    data['locked'] = locked;
    data['isPasswordSet'] = isPasswordSet;
    data['cardId'] = cardId;
    data['version'] = version;
    data['nickName'] = nickName;
    data['publicKey'] = publicKey;
    data['cardDetail'] = cardDetail?.toString();
    data['fiatInfo'] = fiatInfo?.toString();
    data['wallets'] = wallets.map((e) => jsonEncode(e.toJson())).toList();
    return data;
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}

class SmartCardDetail {
  String? address;
  String? background;
  String? brandImage;
  String? brandName;
  String? cardNo;
  String? contact;
  String? description;
  String? email;
  bool? held;
  String? logo;
  String? mobile;
  String? name;
  String? orgId;
  String? shapeImage;
  Shape? shape;
  String? smartCardId;
  String? status;
  String? title;
  String? uid;
  String? groupName;
  String? groupType;
  String? customerSmartCardId;
  bool? available;
  String? category;
  String? usdtBalance;
  MerchantInfo? merchant;
  InvestmentInfo? investment;
  CommonInfo? investmentGuide;
  InvestmentInterval? investmentInterval;
  InvestmentConfig? investmentConfig;
  InvestmentForecast? investmentForecast;
  PageFieldConfig? pageField;
  List<PageFieldConfig>? pageFieldConfig;
  CoinMessageDetail? messageDetail;

  List<Wallect>? wallects;
  List<SumBalanceNewInfo>? walletAddresses;

  SmartCardDetail(
      {this.address,
      this.background,
      this.brandImage,
      this.brandName,
      this.cardNo,
      this.contact,
      this.description,
      this.email,
      this.groupName,
      this.groupType,
      this.available,
      this.held,
      this.logo,
      this.mobile,
      this.name,
      this.orgId,
      this.shapeImage,
      this.smartCardId,
      this.status,
      this.title,
      this.uid,
      this.customerSmartCardId,
      this.category,
      this.investment,
      this.investmentGuide,
      this.investmentInterval,
      this.investmentConfig,
      this.investmentForecast,
      this.usdtBalance,
      this.pageFieldConfig,
      this.merchant,
      this.shape,
      this.pageField,
      this.messageDetail,
      this.wallects,
      this.walletAddresses});

  SmartCardDetail copyWidth({bool? held, String? customerSmartCardId}) {
    return SmartCardDetail(
        address: address,
        background: background,
        cardNo: cardNo,
        contact: contact,
        description: description,
        email: email,
        groupName: groupName,
        groupType: groupType,
        available: available,
        held: held ?? this.held,
        logo: logo,
        mobile: mobile,
        name: name,
        orgId: orgId,
        shapeImage: shapeImage,
        smartCardId: smartCardId,
        status: status,
        title: title,
        uid: uid,
        customerSmartCardId: customerSmartCardId,
        category: category,
        investment: investment,
        investmentGuide: investmentGuide,
        investmentInterval: investmentInterval,
        investmentConfig: investmentConfig,
        investmentForecast: investmentForecast,
        usdtBalance: usdtBalance,
        pageFieldConfig: pageFieldConfig,
        merchant: merchant,
        shape: shape,
        brandName: brandName,
        pageField: pageField,
        messageDetail: messageDetail,
        wallects: wallects,
        walletAddresses: walletAddresses);
  }

  SmartCardDetail.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    background = json['background'];
    brandImage = json['brandImage'];
    cardNo = json['cardNo'];
    contact = json['contact'];
    description = json['description'];
    email = json['email'];
    groupName = json['groupName'];
    groupType = json['groupType'];
    available = json['available'];
    logo = json['logo'];
    mobile = json['mobile'];
    name = json['name'];
    orgId = json['orgId'];
    shapeImage = json['shapeImage'];
    smartCardId = json['smartCardId'];
    status = json['status'];
    title = json['title'];
    uid = json['uid'];
    held = json['held'];
    category = json['category'];
    usdtBalance = json['usdtBalance'];
    merchant = json['merchant'] != null
        ? MerchantInfo.fromJson(json['merchant'])
        : null;
    shape = json['shape'] != null ? Shape.fromJson(json['shape']) : null;
    brandName = json['brandName'];

    customerSmartCardId = json['customerSmartCardId'];
    investment = json['investment'] != null
        ? InvestmentInfo.fromJson(json['investment'])
        : null;
    investmentGuide = json['investmentGuide'] != null
        ? CommonInfo.fromJson(json['investmentGuide'])
        : null;
    investmentInterval = json['investmentParameters'] != null
        ? InvestmentInterval.fromJson(json['investmentParameters'])
        : null;
    investmentConfig = json['investmentConfig'] != null
        ? InvestmentConfig.fromJson(json['investmentConfig'])
        : null;
    investmentForecast = json['investmentForecast'] != null
        ? InvestmentForecast.fromJson(json['investmentForecast'])
        : null;

    if (json['wallets'] != null) {
      wallects = <Wallect>[];
      json['wallets'].forEach((v) {
        wallects!.add(Wallect.fromJson(v));
      });
    }
    if (json['walletAddresses'] != null) {
      walletAddresses = <SumBalanceNewInfo>[];
      json['walletAddresses'].forEach((v) {
        walletAddresses!.add(SumBalanceNewInfo.fromJson(v));
      });
    }
    if (json['pageFieldConfig'] != null) {
      List list = json['pageFieldConfig'] as List;
      pageFieldConfig = list.map((e) => PageFieldConfig.fromJson(e)).toList();
    }
    if (json['pageField'] != null) {
      pageField = PageFieldConfig.fromJson(json['pageField']);
    }
    if (json['chainStampItem'] != null) {
      messageDetail = CoinMessageDetail.fromJson(json['chainStampItem']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['background'] = background;
    data['brandImage'] = brandImage;
    data['cardNo'] = cardNo;
    data['contact'] = contact;
    data['description'] = description;
    data['email'] = email;
    data['groupName'] = groupName;
    data['groupType'] = groupType;
    data['available'] = available;
    data['logo'] = logo;
    data['mobile'] = mobile;
    data['name'] = name;
    data['orgId'] = orgId;
    data['shapeImage'] = shapeImage;
    data['smartCardId'] = smartCardId;
    data['status'] = status;
    data['title'] = title;
    data['uid'] = uid;
    data['held'] = held;
    data['category'] = category;
    data['usdtBalance'] = usdtBalance;
    data['customerSmartCardId'] = customerSmartCardId;
    if (shape != null) {
      data['shape'] = shape!.toJson();
    }
    data['brandName'] = brandName;
    if (merchant != null) {
      data['merchant'] = merchant!.toJson();
    }
    if (investment != null) {
      data['investment'] = investment!.toJson();
    }
    if (investmentGuide != null) {
      data['investmentGuide'] = investmentGuide!.toJson();
    }
    if (investmentInterval != null) {
      data['investmentInterval'] = investmentInterval!.toJson();
    }
    if (investmentConfig != null) {
      data['investmentConfig'] = investmentConfig!.toJson();
    }
    if (investmentForecast != null) {
      data['investmentForecast'] = investmentForecast!.toJson();
    }
    if (messageDetail != null) {
      data['chainStampItem'] = messageDetail!.toJson();
    }

    data['pageFieldConfig'] =
        pageFieldConfig?.map((e) => jsonEncode(e.toJson())).toList();

    data['wallets'] = wallects?.map((e) => jsonEncode(e.toJson())).toList();
    data['walletAddresses'] =
        walletAddresses?.map((e) => jsonEncode(e.toJson())).toList();
    return data;
  }
}

class CardDetail {
  String? uid;
  ChipTwo? chip;
  Shape? shape;
  Vendor? vendor;
  String? description;
  Vendor? merchant;
  Applet? applet;
  String? status;
  String? cardNo;
  String? alias;
  String? lightningNetworkId;

  CardDetail(
      {this.uid,
      this.chip,
      this.shape,
      this.vendor,
      this.description,
      this.merchant,
      this.applet,
      this.status,
      this.cardNo,
      this.alias,
      this.lightningNetworkId});

  CardDetail.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    chip = json['chip'] != null ? ChipTwo.fromJson(json['chip']) : null;
    shape = json['shape'] != null ? Shape.fromJson(json['shape']) : null;
    vendor = json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
    description = json['description'];
    merchant =
        json['merchant'] != null ? Vendor.fromJson(json['merchant']) : null;
    applet = json['applet'] != null ? Applet.fromJson(json['applet']) : null;
    status = json['status'];
    cardNo = json['cardNo'];
    if (json['alias'] != null) {
      alias = json['alias'];
    }
    if (json['lightningNetworkId'] != null) {
      lightningNetworkId = json['lightningNetworkId'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    if (chip != null) {
      data['chip'] = chip!.toJson();
    }
    if (shape != null) {
      data['shape'] = shape!.toJson();
    }
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
    }
    data['description'] = description;
    if (merchant != null) {
      data['merchant'] = merchant!.toJson();
    }
    if (applet != null) {
      data['applet'] = applet!.toJson();
    }
    if (alias != null) {
      data['alias'] = alias;
    }
    if (lightningNetworkId != null) {
      data['lightningNetworkId'] = lightningNetworkId;
    }
    data['status'] = status;
    data['cardNo'] = cardNo;

    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class ChipTwo {
  String? name;
  String? description;
  String? specification;
  String? status;

  ChipTwo({this.name, this.description, this.specification, this.status});

  ChipTwo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    specification = json['specification'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['specification'] = specification;
    data['status'] = status;
    return data;
  }
}

class Shape {
  String? code;
  String? imageUrl;
  String? name;
  String? description;
  String? status;

  Shape({this.code, this.imageUrl, this.name, this.description, this.status});

  Shape.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    return data;
  }
}

class Vendor {
  String? address;
  String? phone;
  String? name;
  String? description;
  String? status;

  Vendor({this.address, this.phone, this.name, this.description, this.status});

  Vendor.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    phone = json['phone'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['phone'] = phone;
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    return data;
  }
}

class Applet {
  String? name;
  String? description;
  String? version;
  String? status;

  Applet({this.name, this.description, this.version, this.status});

  Applet.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    version = json['version'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['version'] = version;
    data['status'] = status;
    return data;
  }
}

class MerchantInfo {
  String? name;
  String? title;
  String? logo;

  MerchantInfo({this.name, this.title, this.logo});
  MerchantInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['title'] = title;
    data['logo'] = logo;
    return data;
  }
}
