
import 'package:flutter/material.dart';

import '../../../../widget/base_page_loading.dart';
import '../../../bean/link_bean.dart';

class AddDetailState extends LoadPageState<AddDetailState> {
  GlobalKey staticAnchorKey = GlobalKey();
  late TextEditingController valueController;
  late String name;
  String? description;
  String? typeId;
  late String type;
  String? value;
  String? id;
  late String imageUrl;
  LinkTypeDetail? typeDetail;
  late String cardId;
  late String deviceId;

  @override
  AddDetailState clone() {
    return AddDetailState()
      ..valueController = valueController
      ..name = name
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..staticAnchorKey = staticAnchorKey
      ..description = description
      ..imageUrl = imageUrl
      ..value = value
      ..typeDetail = typeDetail
      ..typeId = typeId
      ..id = id
      ..type = type
      ..cardId = cardId
      ..deviceId = deviceId
    ;
  }
}

AddDetailState initState(Map<String, dynamic>? args) {
  LinkDetailItem? linkDetailItem = args!['linkDetailItem'];

  String cardId = args['cardId'];
  String deviceId = args['deviceId'];

  String name;
  String? value;
  String type;
  String? typeId;
  String? id;
  String imageUrl;

  if(linkDetailItem != null){
    id = linkDetailItem.id;
    name = linkDetailItem.name!;
    value = linkDetailItem.value;
    type = linkDetailItem.type!;
    imageUrl = linkDetailItem.imageUrl!;

  }else{
    LinkTypeItem linkTypeItem = args['linktypeItem']!;
    typeId = linkTypeItem.id;
    name = linkTypeItem.name!;
    type = linkTypeItem.type!;
    imageUrl = linkTypeItem.imageUrl!;
  }
  return AddDetailState()
    ..type = type
    ..name = name
    ..id = id
    ..typeId = typeId
    ..value = value
    ..cardId = cardId
    ..deviceId = deviceId
    ..imageUrl = imageUrl
    ..valueController = TextEditingController(text:value ?? '')
  ;
}
