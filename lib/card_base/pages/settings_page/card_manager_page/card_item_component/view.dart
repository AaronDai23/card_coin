
import 'package:card_coin/card_base/extensions/ext_string.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    CardItemState state, Dispatch dispatch, ViewService viewService) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 6.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        onTap: () => dispatch(CardItemActionCreator.onItemClick(state.bean)),
        title: Row(
          children: [
            Text(state.bean.deviceName ?? ''),
            const SizedBox(width: 10.0,),
            Text(state.bean.major??false?S.current.mainCard:'',style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 14.0),),
          ],
        ),
        trailing: !(state.bean.major??false)?GestureDetector(
          onTap: () => dispatch(CardItemActionCreator.onDeleteClick(state.bean)),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.remove_circle_outlined,color: Colors.red,),
          ),
        ):null,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(state.bean.brandInfo?.name??''),
            Text((state.bean.cardNo ?? '').stringSeprate(count:4,separator: ' ')),

          ],
        ),
      ),
    ),
  );
}
