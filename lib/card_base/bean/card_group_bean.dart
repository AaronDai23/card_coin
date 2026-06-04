import '../../bean/card_info_bean.dart';

class CardGroupListInfo {
  int? total;
  List<CardGroup>? list;

  CardGroupListInfo({this.total, this.list});

  CardGroupListInfo.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      list = <CardGroup>[];
      json['rows'].forEach((v) {
        list!.add(CardGroup.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    if (list != null) {
      data['rows'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CardGroup {
  String? background;
  int? cardCount;
  String? groupId;
  String? groupImage;
  String? groupName;
  String? groupType;

  CardGroup(
      {this.background,
      this.cardCount,
      this.groupId,
      this.groupImage,
      this.groupName,
      this.groupType});

  CardGroup.fromJson(Map<String, dynamic> json) {
    background = json['background'];
    groupId = json['groupId'];
    groupImage = json['groupImage'];
    groupName = json['groupName'];
    groupType = json['groupType'];
    cardCount = json['cardCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['background'] = background;
    data['groupId'] = groupId;
    data['groupImage'] = groupImage;
    data['groupName'] = groupName;
    data['groupType'] = groupType;
    data['cardCount'] = cardCount;
    return data;
  }
}

class SmartCardItem {
  String? groupType;
  String? groupName;
  String? orgId;
  String? smartCardId;
  String? uid;
  String? cardNo;
  String? brandImage;
  String? shapeImage;

  SmartCardItem(
      {this.groupType,
      this.groupName,
      this.orgId,
      this.smartCardId,
      this.uid,
      this.cardNo,
      this.brandImage,
      this.shapeImage});

  SmartCardItem.fromJson(Map<String, dynamic> json) {
    groupType = json['groupType'];
    groupName = json['groupName'];
    orgId = json['orgId'];
    smartCardId = json['smartCardId'];
    uid = json['uid'];
    cardNo = json['cardNo'];
    brandImage = json['brandImage'];
    shapeImage = json['shapeImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['groupType'] = groupType;
    data['groupName'] = groupName;
    data['orgId'] = orgId;
    data['smartCardId'] = smartCardId;
    data['uid'] = uid;
    data['cardNo'] = cardNo;
    data['brandImage'] = brandImage;
    data['shapeImage'] = shapeImage;
    return data;
  }
}

class SmartCardListInfo {
  int? total;
  List<SmartCardDetail>? rows;

  SmartCardListInfo({this.total, this.rows});

  SmartCardListInfo.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      rows = <SmartCardDetail>[];
      json['rows'].forEach((v) {
        rows!.add(SmartCardDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    if (rows != null) {
      data['rows'] = rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
