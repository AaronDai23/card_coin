import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import 'wc_connection_model.dart';

class WCConnectionWidgetLoginInfo extends StatelessWidget {
  const WCConnectionWidgetLoginInfo({
    Key? key,
    required this.model,
  }) : super(key: key);

  final WCConnectionModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        StyleConstants.linear8,
      ),
      child: model.elements != null ? _buildList() : _buildText(),
    );
  }

  Widget _buildList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: model.elements!.map((e) {
        return Text(e);
        // String account = model.title?.split('\n')[3].split(': ')[1]??'';

        // var textList = e.split('\n\n');
        // var message = textList[1];
        // var infoList = textList[2];
        // var itemList = infoList.split('\n');
        // String uri = '';

        // String uri = itemList[0].split(': ')[1];
        // if(itemList.length >1){
        //
        // }
        // String version = itemList[1].split(': ')[1];
        // String chainId = itemList[2].split(': ')[1];
        // String chainName = BlockchainUtils.getChainMetadata('eip155:$chainId').name;
        // String nonce = itemList[3].split(': ')[1];
        // String issued = itemList[4].split(': ')[1];
        // TextStyle titleStyle = TextStyle(fontWeight: FontWeight.bold);
        // TextStyle textStyle = TextStyle(fontSize: 14);
        // double heightPadding = 8.0;
        // return Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       '消息',
        //       style: titleStyle,
        //     ),
        //     SizedBox(
        //       height: heightPadding,
        //     ),
        //     Text(
        //       message,
        //       style: textStyle,
        //     ),
        //     SizedBox(
        //       height: heightPadding,
        //     ),
        //     Text(
        //       '账户',
        //       style: titleStyle,
        //     ),
        //     SizedBox(
        //       height: heightPadding,
        //     ),
        //     Text(
        //       account,
        //       style: TextStyle(fontSize: 12),
        //     ),
        //     SizedBox(
        //       height: heightPadding,
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text('URL', style: titleStyle),
        //         Text(
        //           uri,
        //           style: textStyle,
        //         )
        //       ],
        //     ),
        //     SizedBox(
        //       height: heightPadding,
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text('网络', style: titleStyle),
        //         Text(
        //           chainName,
        //           style: textStyle,
        //         )
        //       ],
        //     ),
        //     SizedBox(
        //       height: heightPadding,
        //     ),
        //
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text('版本', style: titleStyle),
        //         Text(
        //           version,
        //           style: textStyle,
        //         )
        //       ],
        //     ),
        //     SizedBox(
        //       height: heightPadding,
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text('链 ID', style: titleStyle),
        //         Text(
        //           chainId,
        //           style: textStyle,
        //         )
        //       ],
        //     ),
        //     SizedBox(
        //       height: heightPadding,
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text('Nonce', style: titleStyle),
        //         Text(
        //           nonce,
        //           style: textStyle,
        //         )
        //       ],
        //     ),
        //     SizedBox(
        //       height: heightPadding,
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text('已签发', style: titleStyle),
        //         Text(
        //           issued,
        //           style: textStyle,
        //         )
        //       ],
        //     ),
        //   ],
        // );
      }).toList(),
    );
  }

  Widget _buildText() {
    return Text(
      model.text!,
      style: StyleConstants.layerTextStyle3,
    );
  }
}
